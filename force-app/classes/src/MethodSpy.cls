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
  private Integer callCount = 0;
  private List<Object> lastCallParams;
  private List<ParameterizedMethodSpyCall> parameterizedMethodCalls = new List<ParameterizedMethodSpyCall>();
  private Object returnValue;
  private Exception exceptionToThrow;

  public MethodSpy(String methodName) {
    this.methodName = methodName;
  }

  public List<Object> getLastCallParams() {
    return this.lastCallParams;
  }

  public Boolean hasBeenCalled() {
    return this.callCount > 0;
  }

  public Boolean hasBeenCalledTimes(final Integer count) {
    return this.callCount == count;
  }

  public Object call(List<Object> params) {
    this.callCount++;
    this.lastCallParams = params;
    if (this.exceptionToThrow != null) {
      throw this.exceptionToThrow;
    }
    if (this.parameterizedMethodCalls.isEmpty()) {
      return this.returnValue;
    }

    for (
      ParameterizedMethodSpyCall parameterizedCall : this.parameterizedMethodCalls
    ) {
      if (parameterizedCall.matches(params)) {
        return parameterizedCall.value;
      }
    }

    throw new IllegalArgumentException(
      this.methodName +
      ': No stub value found for a call with params ' +
      params
    );
  }

  public void returns(Object value) {
    this.returnValue = value;
  }

  public void throwsException(Exception exceptionToThrow) {
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
