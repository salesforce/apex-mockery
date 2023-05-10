/*
 * Copyright (c) 2022, salesforce.com, inc.
 * All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * For full license text, see the LICENSE file in the repo root or https://opensource.org/licenses/BSD-3-Clause
 */

/**
 * MethodSpy represents an apex method spy on which you can register some value to be returned
 *  - spy.returns(value): always return the same value using spy.returns(value)
 *  - spy.whenCalledWith(Arguments args).thenReturn(value)
 *  - spy.whenCalledWith(Arguments args).thenThrow(error)
 *  note: the matching algorithm is based on Matchable specified in the Arguments instanciation (defaulting to equals)
 *  @see Arguments
 *  @see Matchable
 */
@IsTest
global class MethodSpy {
  global String methodName { get; private set; }
  global CallLog callLog { get; private set; }
  private List<ParameterizedMethodSpyCall> parameterizedMethodCalls = new List<ParameterizedMethodSpyCall>();
  private Object returnValue;
  private Boolean configuredGlobalReturn = false;
  private Boolean configuredGlobalThrow = false;
  private Exception exceptionToThrow;

  global MethodSpy(String methodName) {
    this.methodName = methodName;
    this.callLog = new CallLog();
  }

  public Object call(List<Object> args) {
    this.callLog.add(new MethodCall(args));

    if (this.parameterizedMethodCalls.isEmpty() && !this.configuredGlobalReturn && !this.configuredGlobalThrow) {
      return null;
    }

    for (ParameterizedMethodSpyCall parameterizedCall : this.parameterizedMethodCalls) {
      if (parameterizedCall.matches(args)) {
        if (parameterizedCall.shouldThrow()) {
          throw parameterizedCall.error;
        }
        return parameterizedCall.value;
      }
    }

    if (this.configuredGlobalReturn) {
      return this.returnValue;
    }

    if (this.configuredGlobalThrow) {
      throw this.exceptionToThrow;
    }

    throw new ConfigurationExceptionBuilder().withMethodSpy(this).withCallArguments(args).build();
  }

  global void returns(Object value) {
    this.configuredGlobalReturn = true;
    this.configuredGlobalThrow = false;
    this.returnValue = value;
  }

  global void throwsException(Exception exceptionToThrow) {
    this.configuredGlobalThrow = true;
    this.configuredGlobalReturn = false;
    this.exceptionToThrow = exceptionToThrow;
  }

  global MethodSpyCall whenCalledWith() {
    return this.whenCalledWithArguments(Argument.empty());
  }

  global MethodSpyCall whenCalledWith(final Object arg) {
    return this.whenCalledWithArguments((arg instanceof List<Argument.Matchable>) ? (List<Argument.Matchable>) arg : Argument.of(arg));
  }

  global MethodSpyCall whenCalledWith(final Object arg1, final Object arg2) {
    return this.whenCalledWithArguments(Argument.of(arg1, arg2));
  }

  global MethodSpyCall whenCalledWith(final Object arg1, final Object arg2, final Object arg3) {
    return this.whenCalledWithArguments(Argument.of(arg1, arg2, arg3));
  }

  global MethodSpyCall whenCalledWith(final Object arg1, final Object arg2, final Object arg3, final Object arg4) {
    return this.whenCalledWithArguments(Argument.of(arg1, arg2, arg3, arg4));
  }

  global MethodSpyCall whenCalledWith(final Object arg1, final Object arg2, final Object arg3, final Object arg4, final Object arg5) {
    return this.whenCalledWithArguments(Argument.of(arg1, arg2, arg3, arg4, arg5));
  }

  private MethodSpyCall whenCalledWithArguments(final List<Argument.Matchable> args) {
    final ParameterizedMethodSpyCall parameterizedMethodCall = new ParameterizedMethodSpyCall(args);
    this.parameterizedMethodCalls.add(parameterizedMethodCall);
    return parameterizedMethodCall;
  }

  public class CallLog {
    private List<MethodCall> callArguments = new List<MethodCall>();

    private void add(MethodCall callParam) {
      this.callArguments.add(callParam);
    }

    public Boolean isEmpty() {
      return this.callArguments.isEmpty();
    }

    public Integer size() {
      return this.callArguments.size();
    }

    public List<Object> get(final Integer index) {
      return this.callArguments[index].args;
    }

    public List<Object> getLast() {
      return this.size() > 0 ? this.get(this.size() - 1) : null;
    }
  }

  private class MethodCall {
    public List<Object> args { get; private set; }

    public MethodCall(final List<Object> args) {
      this.args = args;
    }
  }

  global interface MethodSpyCall {
    void thenReturn(Object value);
    void thenThrow(Exception error);
  }

  private class ParameterizedMethodSpyCall implements MethodSpyCall {
    private final List<Argument.Matchable> argsMatchable;
    public Object value { get; private set; }
    public Exception error { get; private set; }

    public ParameterizedMethodSpyCall(final List<Argument.Matchable> argsMatchable) {
      this.argsMatchable = argsMatchable;
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
      return Argument.matches(this.argsMatchable, callArguments);
    }

    public override String toString() {
      return 'whenCalledWith' + this.argsMatchable + '' + (this.shouldThrow() ? '.thenThrow(' + this.error + ')' : '.thenReturn(' + this.value + ')');
    }
  }

  private class ConfigurationExceptionBuilder {
    private MethodSpy spy;
    private List<Object> callArguments;

    public ConfigurationExceptionBuilder withMethodSpy(final MethodSpy spy) {
      this.spy = spy;
      return this;
    }

    public ConfigurationExceptionBuilder withCallArguments(final List<Object> callArguments) {
      this.callArguments = callArguments;
      return this;
    }

    public ConfigurationException build() {
      List<String> errorMessages = new List<String>();
      for (ParameterizedMethodSpyCall parameterizedCall : this.spy.parameterizedMethodCalls) {
        errorMessages.add(parameterizedCall.toString());
      }
      return new ConfigurationException(
        this.spy.methodName +
          ': No stub value found for a call with args ' +
          this.callArguments +
          '\nHere are the configured stubs:\n\t' +
          String.join(errorMessages, '\n\t')
      );
    }
  }

  global class ConfigurationException extends Exception {
  }
}
