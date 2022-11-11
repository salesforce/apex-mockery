/*
 * Copyright (c) 2022, salesforce.com, inc.
 * All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * For full license text, see the LICENSE file in the repo root or https://opensource.org/licenses/BSD-3-Clause
 */

/**
 * MethodSpy represents an apex method spy on which you can register some value to be returned
 *
 *  - always return the same value using spy.returns(value)
 *  - return value based on calling arguments list
 *        spy.whenCalledWith(param).thenReturn(value)
 *        spy.whenCalledWith(new List<Object>{param1, param2}).thenReturn(value)
 *        spy.whenCalledWith(new List<Object>{param1, param2}).thenThrow(error)
 *    note: the matching algorithm is currently based on equality (equals method or reference comparison)
 *
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

  public Boolean hasBeenCalledWith(final List<Object> expectedListOfArgs) {
    final List<ArgumentMatcher> expectedMatchers = this.buildMatchers(
      expectedListOfArgs
    );

    final Iterator<MethodCall> it = this.callLog.iterator();
    while (it.hasNext()) {
      final List<Object> actualListOfArgs = it.next().params;

      if (actualListOfArgs.size() == expectedMatchers.size()) {
        Boolean match = true;
        for (Integer i = 0; i < actualListOfArgs.size(); ++i) {
          if (!expectedMatchers[i].matches(actualListOfArgs[i])) {
            match = false;
            break;
          }
        }
        if (match) {
          return true;
        }
      }
    }

    return false;
  }

  public Boolean hasBeenLastCalledWith(List<Object> expectedListOfArgs) {
    if (this.callLog.isEmpty()) {
      return false;
    }

    final List<Object> actualListOfArgs = this.callLog.getLast();
    if (actualListOfArgs.size() != expectedListOfArgs.size()) {
      return false;
    }

    final List<ArgumentMatcher> expectedMatchers = this.buildMatchers(
      expectedListOfArgs
    );

    for (Integer i = 0; i < actualListOfArgs.size(); ++i) {
      if (!expectedMatchers[i].matches(actualListOfArgs[i])) {
        return false;
      }
    }
    return true;
  }

  private List<ArgumentMatcher> buildMatchers(
    final List<Object> expectedListOfArgs
  ) {
    final List<ArgumentMatcher> argumentMatchers = new List<ArgumentMatcher>();
    for (Object callArgument : expectedListOfArgs) {
      if (callArgument != null && callArgument instanceof ArgumentMatcher) {
        argumentMatchers.add((ArgumentMatcher) callArgument);
      } else {
        argumentMatchers.add(new EqualsMatcher(callArgument));
      }
    }
    return argumentMatchers;
  }

  public Boolean hasBeenCalledTimes(final Integer count) {
    return this.callLog.size() == count;
  }

  public Object call(List<Object> params) {
    this.callLog.add(new MethodCall(params));

    if (
      this.parameterizedMethodCalls.isEmpty() &&
      !this.configuredGlobalReturn &&
      this.exceptionToThrow == null
    ) {
      return null;
    }

    for (
      ParameterizedMethodSpyCall parameterizedCall : this.parameterizedMethodCalls
    ) {
      if (parameterizedCall?.matches(params) == true) {
        if (parameterizedCall.shouldThrow() == true) {
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

    throw new IllegalArgumentException(
      this.methodName +
      ': No stub value found for a call with params ' +
      params
    );
  }

  public void returns(Object value) {
    this.configuredGlobalReturn = true;
    this.returnValue = value;
  }

  public void throwsException(Exception exceptionToThrow) {
    this.configuredGlobalReturn = false;
    this.exceptionToThrow = exceptionToThrow;
  }

  public MethodSpyCall whenCalledWith(final List<Object> listOfArgs) {
    final List<ArgumentMatcher> matchers = this.buildMatchers(listOfArgs);
    final ParameterizedMethodSpyCall parameterizedMethodCall = new ParameterizedMethodSpyCall(
      matchers
    );
    this.parameterizedMethodCalls.add(parameterizedMethodCall);
    return parameterizedMethodCall;
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
    private List<ArgumentMatcher> matchers;
    public Object value { get; private set; }
    public Exception error { get; private set; }

    public ParameterizedMethodSpyCall(List<ArgumentMatcher> matchers) {
      this.matchers = matchers;
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
      if (this.matchers.size() != callArguments.size()) {
        return false;
      }

      for (Integer i = 0; i < this.matchers.size(); ++i) {
        if (!this.matchers[i].matches(callArguments[i])) {
          return false;
        }
      }

      return true;
    }
  }

  class MatcherException extends Exception {
  }
}
