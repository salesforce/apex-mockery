/*
 * Copyright (c) 2022, salesforce.com, inc.
 * All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * For full license text, see the LICENSE file in the repo root or https://opensource.org/licenses/BSD-3-Clause
 */

/**
 * MethodSpy represents an apex method spy on which you can register some value to be returned
 *  - spy.returns(value): always return the same value using spy.returns(value)
 *  - spy.whenCalledWith(Params params).thenReturn(value)
 *  - spy.whenCalledWith(Params params).thenThrow(error)
 *  note: the matching algorithm is based on Matcher specified in the Params instanciation (defaulting to equals)
 *  @see Params
 *  @see Matcher
 */
@IsTest
public class MethodSpy {
  public String methodName { get; private set; }
  private CallLog callLog;
  private List<ParameterizedMethodSpyCall> parameterizedMethodCalls = new List<ParameterizedMethodSpyCall>();
  private Object returnValue;
  private Boolean configuredGlobalReturn = false;
  private Exception exceptionToThrow;

  public MethodSpy(String methodName) {
    this.methodName = methodName;
    this.callLog = new CallLog();
  }

  public Boolean hasBeenCalled() {
    return !this.callLog.isEmpty();
  }

  public Boolean hasBeenCalledWith(final Params params) {
    if (params == null) {
      throw new Matcher.MatcherException('Params cannot be null');
    }
    final Iterator<MethodCall> it = this.callLog.iterator();
    while (it.hasNext()) {
      if (params.matches(it.next().params)) {
        return true;
      }
    }

    return false;
  }

  public Boolean hasBeenLastCalledWith(final Params params) {
    if (params == null) {
      throw new Matcher.MatcherException('Params cannot be null');
    }
    if (this.callLog.isEmpty()) {
      return false;
    }

    final List<Object> actualListOfArgs = this.callLog.getLast();
    return params.matches(actualListOfArgs);
  }

  public Boolean hasBeenCalledTimes(final Integer count) {
    return this.callLog.size() == count;
  }

  public Object call(List<Object> params) {
    this.callLog.add(new MethodCall(params));

    if (this.parameterizedMethodCalls.isEmpty() && !this.configuredGlobalReturn && this.exceptionToThrow == null) {
      return null;
    }

    for (ParameterizedMethodSpyCall parameterizedCall : this.parameterizedMethodCalls) {
      if (parameterizedCall.matches(params)) {
        if (parameterizedCall.shouldThrow()) {
          throw parameterizedCall.error;
        }
        return parameterizedCall.value;
      }
    }

    if (this.configuredGlobalReturn) {
      return this.returnValue;
    }

    if (this.exceptionToThrow != null) {
      throw this.exceptionToThrow;
    }

    throw new ConfigurationExceptionBuilder().withMethodSpy(this).withCallParams(params).build();
  }

  public void returns(Object value) {
    this.configuredGlobalReturn = true;
    this.returnValue = value;
  }

  public void throwsException(Exception exceptionToThrow) {
    this.configuredGlobalReturn = false;
    this.exceptionToThrow = exceptionToThrow;
  }

  public MethodSpyCall whenCalledWith(final Params params) {
    if (params == null) {
      throw new Matcher.MatcherException('Params cannot be null');
    }
    final ParameterizedMethodSpyCall parameterizedMethodCall = new ParameterizedMethodSpyCall(params);
    this.parameterizedMethodCalls.add(parameterizedMethodCall);
    return parameterizedMethodCall;
  }

  @TestVisible
  private List<Params> getCallLogParams() {
    final List<Params> reversedCallsTrace = new List<Params>();
    final List<MethodCall> calls = this.callLog.callParams;
    for (Integer i = calls.size() - 1; i >= 0; i--) {
      final MethodCall call = calls[i];
      reversedCallsTrace.add(Params.ofList(call.params));
    }
    return reversedCallsTrace;
  }

  private class CallLog implements Iterable<MethodCall> {
    private List<MethodCall> callParams = new List<MethodCall>();

    public void add(MethodCall callParam) {
      this.callParams.add(callParam);
    }

    public Boolean isEmpty() {
      return this.callParams.isEmpty();
    }

    public Integer size() {
      return this.callParams.size();
    }

    public List<Object> get(final Integer index) {
      return this.callParams[index].params;
    }

    public List<Object> getLast() {
      return this.get(this.size() - 1);
    }

    public Iterator<MethodCall> iterator() {
      return this.callParams.iterator();
    }
  }

  private class MethodCall {
    public List<Object> params { get; private set; }

    public MethodCall(final List<Object> params) {
      this.params = params;
    }
  }

  public interface MethodSpyCall {
    void thenReturn(Object value);
    void thenThrow(Exception error);
  }

  private class ParameterizedMethodSpyCall implements MethodSpyCall {
    private Params paramsMatcher;
    public Object value { get; private set; }
    public Exception error { get; private set; }

    public ParameterizedMethodSpyCall(final Params paramsMatcher) {
      this.paramsMatcher = paramsMatcher;
    }

    public void thenReturn(Object value) {
      this.value = value;
    }

    public void thenThrow(Exception error) {
      this.error = error;
    }

    public boolean shouldThrow() {
      return this.error != null;
    }

    public boolean matches(final List<Object> callArguments) {
      return this.paramsMatcher.matches(callArguments);
    }

    public override String toString() {
      return 'whenCalledWith' + this.paramsMatcher + '' + (this.shouldThrow() ? '.thenThrow(' + this.error + ')' : '.thenReturn(' + this.value + ')');
    }
  }

  private class ConfigurationExceptionBuilder {
    private MethodSpy spy;
    private List<Object> callParams;

    public ConfigurationExceptionBuilder withMethodSpy(final MethodSpy spy) {
      this.spy = spy;
      return this;
    }

    public ConfigurationExceptionBuilder withCallParams(final List<Object> callParams) {
      this.callParams = callParams;
      return this;
    }

    public ConfigurationException build() {
      List<String> errorMessages = new List<String>();
      for (ParameterizedMethodSpyCall parameterizedCall : this.spy.parameterizedMethodCalls) {
        errorMessages.add(parameterizedCall.toString());
      }
      return new ConfigurationException(
        this.spy.methodName +
          ': No stub value found for a call with params ' +
          this.callParams +
          '\nHere are the configured stubs:\n\t' +
          String.join(errorMessages, '\n\t')
      );
    }
  }

  public class ConfigurationException extends Exception {
  }
}
