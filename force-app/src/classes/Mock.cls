/*
 * Copyright (c) 2022, salesforce.com, inc.
 * All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * For full license text, see the LICENSE file in the repo root or https://opensource.org/licenses/BSD-3-Clause
 */
@isTest
public class Mock implements System.StubProvider {
  public Object stub { get; set; }
  private Map<String, MethodSpy> spies = new Map<String, MethodSpy>();

  private Mock(final Type aType, final StubBuilder stubBuilder) {
    this.stub = stubBuilder.build(aType, this);
  }

  public Object handleMethodCall(
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

  public MethodSpy spyOn(final String methodName) {
    if (!this.spies.containsKey(methodName)) {
      this.spies.put(methodName, new MethodSpy(methodName));
    }
    return this.getSpy(methodName);
  }

  public MethodSpy getSpy(final String methodName) {
    return this.spies.get(methodName);
  }

  public static Mock forType(final Type aType) {
    return Mock.forType(aType, new DefaultStubBuilder());
  }

  public static Mock forType(final Type aType, final StubBuilder stubBuilder) {
    return new Mock(aType, stubBuilder);
  }

  public interface StubBuilder {
    Object build(final Type aType, System.StubProvider stubProvider);
  }

  private class DefaultStubBuilder implements StubBuilder {
    public Object build(final Type aType, System.StubProvider stubProvider) {
      return Test.createStub(aType, stubProvider);
    }
  }
}
