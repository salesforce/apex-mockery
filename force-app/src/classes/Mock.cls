/*
 * Copyright (c) 2022, salesforce.com, inc.
 * All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * For full license text, see the LICENSE file in the repo root or https://opensource.org/licenses/BSD-3-Clause
 */
@IsTest
global class Mock implements System.StubProvider {
  global Object stub { get; set; }
  private Map<String, MethodSpy> spies = new Map<String, MethodSpy>();

  private Mock(final Type aType, final StubBuilder stubBuilder) {
    this.stub = stubBuilder.build(aType, this);
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
    final String key = this.getSpyKey(stubbedMethodName);
    if (this.spies.containsKey(key)) {
      MethodSpy spy = this.getSpy(key);
      result = spy.call(listOfParamTypes, listOfParamNames, listOfArgs);
    }

    return result;
  }

  global MethodSpy spyOn(final String methodName) {
    final String key = this.getSpyKey(methodName);
    if (!this.spies.containsKey(key)) {
      this.spies.put(key, new MethodSpy(methodName));
    }
    return this.getSpy(key);
  }

  global MethodSpy getSpy(final String methodName) {
    return this.spies.get(this.getSpyKey(methodName));
  }

  global static Mock forType(final Type aType) {
    return Mock.forType(aType, new DefaultStubBuilder());
  }

  global static Mock forType(final Type aType, final StubBuilder stubBuilder) {
    return new Mock(aType, stubBuilder);
  }

  global interface StubBuilder {
    Object build(final Type aType, System.StubProvider stubProvider);
  }

  private String getSpyKey(final String methodName) {
    return methodName.toLowerCase();
  }

  private class DefaultStubBuilder implements StubBuilder {
    public Object build(final Type aType, System.StubProvider stubProvider) {
      return Test.createStub(aType, stubProvider);
    }
  }
}
