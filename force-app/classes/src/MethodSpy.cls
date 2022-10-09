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
 *    note: the matching algorithm is currently based on equality (equals method or reference comparison)
 *
 */
@IsTest
public class MethodSpy {
  public String methodName;
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

  public Boolean hasBeenCalledWith(List<Object> params) {
    Iterator<CallParameter> it = this.callLog.iterator();
    while (it.hasNext()) {
      if (params == it.next().params) {
        return true;
      }
    }

    return false;
  }

  public Boolean hasBeenCalledWith(ParametersMatcher matcher) {
    Iterator<CallParameter> it = this.callLog.iterator();
    while (it.hasNext()) {
      if (matcher.matches(it.next().params)) {
        return true;
      }
    }

    return false;
  }

  public Boolean hasBeenLastCalledWith(List<Object> params) {
    if (this.callLog.isEmpty()) {
      return false;
    }
    return this.callLog.getLast() == params;
  }

  public Boolean hasBeenLastCalledWith(ParametersMatcher matcher) {
    if (this.callLog.isEmpty()) {
      return false;
    }
    return matcher.matches(this.callLog.getLast());
  }

  public Boolean hasBeenCalledTimes(final Integer count) {
    return this.callLog.size() == count;
  }

  public Object call(List<Object> params) {
    this.callLog.add(new CallParameter(params));

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
      if (parameterizedCall.matches(params)) {
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

  public ParameterizedMethodSpyCall whenCalledWith(Object param) {
    return whenCalledWithParams(new List<Object>{ param });
  }

  public ParameterizedMethodSpyCall whenCalledWithParams(List<Object> params) {
    final ParameterizedMethodSpyCall parameterizedMethodCall = new ParameterizedMethodSpyCall(
      params
    );
    this.parameterizedMethodCalls.add(parameterizedMethodCall);
    return parameterizedMethodCall;
  }

  private class CallLog implements Iterable<CallParameter> {
    private List<CallParameter> callParams = new List<CallParameter>();

    public void add(CallParameter callParam) {
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
      return this.callParams[this.size() - 1].params;
    }

    public Iterator<CallParameter> iterator() {
      return this.callParams.iterator();
    }
  }

  private class CallParameter {
    public List<Object> params { get; private set; }

    public CallParameter(final List<Object> params) {
      this.params = params;
    }
  }
}
