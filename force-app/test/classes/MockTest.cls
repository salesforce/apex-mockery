/*
 * Copyright (c) 2022, salesforce.com, inc.
 * All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * For full license text, see the LICENSE file in the repo root or https://opensource.org/licenses/BSD-3-Clause
 */
@IsTest
private class MockTest {
  // Integration test
  @IsTest
  static void givenAType_whenSpyinOnWithReturn_callingTheMethodReturnsTheConfiguredOutput() {
    // Arrange
    String expected = 'expected';
    Mock mock = Mock.forType(DummyInterface.class);
    MethodSpy dummyMethod = mock.spyOn('dummyMethod');
    dummyMethod.returns(expected);
    DummyInterface sut = (DummyInterface) mock.stub;

    // Act
    String result = sut.dummyMethod();

    // Assert
    Assert.areEqual(expected, result);
  }

  @IsTest
  static void givenAType_whenSpyinOnWithoutReturn_callingTheMethodReturnsNull() {
    // Arrange
    Mock mock = Mock.forType(DummyInterface.class);
    MethodSpy dummyMethod = mock.spyOn('dummyMethod');
    dummyMethod.returns(null);

    DummyInterface sut = (DummyInterface) mock.stub;

    // Act
    Object result = sut.dummyMethod();

    // Assert
    Assert.areEqual(null, result);
  }

  // Unit test
  @IsTest
  static void givenAMethodName_thenSpyOnReturnsMethodSpy() {
    // Arrange
    String expected = 'methodName';
    Mock sut = Mock.forType(DummyInterface.class);

    // Act
    MethodSpy result = sut.spyOn(expected);

    // Assert
    Assert.areEqual(expected, result.methodName);
  }

  @IsTest
  static void givenAMethodName_whenCallingSpyOnMultipleTimes_thenReturnsSameMethodSpy() {
    // Arrange
    String methodName = 'methodName';
    Mock sut = Mock.forType(DummyInterface.class);
    MethodSpy expected = sut.spyOn(methodName);

    // Act
    MethodSpy result = sut.spyOn(methodName);

    // Assert
    Assert.areEqual(expected, result);
  }

  @IsTest
  static void givenAMethodName_whenNotSpiedOn_thenGetSpyReturnsNull() {
    // Arrange
    String methodName = 'methodName';
    Mock sut = Mock.forType(DummyInterface.class);

    // Act
    MethodSpy result = sut.getSpy(methodName);

    // Assert
    Assert.areEqual(null, result);
  }

  @IsTest
  static void givenAMethodName_whenSpiedOn_thenGetSpyReturnsMethodSpy() {
    // Arrange
    String methodName = 'methodName';
    Mock sut = Mock.forType(DummyInterface.class);
    MethodSpy expected = sut.spyOn(methodName);

    // Act
    MethodSpy result = sut.getSpy(methodName);

    // Assert
    Assert.areEqual(expected, result);
  }

  @IsTest
  static void givenAType_forTypeReturnsMock() {
    // Arrange
    Type param = DummyInterface.class;

    // Act
    Mock result = Mock.forType(param);

    // Assert
    Assert.areNotEqual(null, result);
  }

  @IsTest
  static void givenNull_forTypeThrows() {
    // Arrange
    Type param = null;

    // Act
    try {
      Mock result = Mock.forType(param);
      // Assert
      Assert.fail('Expected exception was not thrown');
    } catch (Exception ex) {
      Assert.areNotEqual(null, ex);
    }
  }
}
