/*
 * Copyright (c) 2022, salesforce.com, inc.
 * All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * For full license text, see the LICENSE file in the repo root or https://opensource.org/licenses/BSD-3-Clause
 */
@isTest
global class Mock implements System.StubProvider {
  global Object stub { get; set; }
  private Map<String, MethodSpy> spies = new Map<String, MethodSpy>();

  private Mock(final Type aType) {
    this.stub = Test.createStub(aType, this);
  }

  @SuppressWarnings('PMD.EmptyStatementBlock')
  global Mock() {
  }

  global Object handleMethodCall(
    Object stubbedObject,
    String stubbedMethodName,
    Type returnType,
    List<Type> listOfParamTypes,
    List<String> listOfParamNames,
    List<Object> listOfArgs
  ) {
    Object result;
    if (this.spies.containsKey(stubbedMethodName)) {
      MethodSpy spy = this.getSpy(stubbedMethodName);
      result = spy.call(listOfArgs);
    }

    return result;
  }

  global MethodSpy spyOn(final String methodName) {
    if (!this.spies.containsKey(methodName)) {
      this.spies.put(methodName, new MethodSpy(methodName));
    }
    return this.getSpy(methodName);
  }

  global MethodSpy getSpy(final String methodName) {
    return this.spies.get(methodName);
  }

  global static Mock forType(final Type aType) {
    return new Mock(aType);
  }
}
