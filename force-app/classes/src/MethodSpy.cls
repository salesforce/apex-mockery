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
  private List<List<Object>> callParams;
  private List<ParameterizedMethodSpyCall> parameterizedMethodCalls = new List<ParameterizedMethodSpyCall>();
  private Object returnValue;
  private Boolean configuredGlobalReturn = false;
  private Exception exceptionToThrow;

  public MethodSpy(String methodName) {
    this.methodName = methodName;
    this.callParams = new List<List<Object>>();
  }

  public List<List<Object>> getCallParams() {
    return this.callParams;
  }

  public List<Object> getLastCallParams() {
    return this.hasBeenCalled()
      ? this.callParams[this.callParams.size() - 1]
      : null;
  }

  public Boolean hasBeenCalled() {
    return !this.callParams.isEmpty();
  }

  public Boolean hasBeenCalledWith(List<Object> params) {
    for (List<Object> callParam : this.callParams) {
      if (callParam == params) {
        return true;
      }
    }

    return false;
  }

  public Boolean hasBeenLastCalledWith(List<Object> params) {
    return this.getLastCallParams() == params;
  }

  public Boolean hasBeenCalledTimes(final Integer count) {
    return this.callParams.size() == count;
  }

  public Object call(List<Object> params) {
    this.callParams.add(params);

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
}
