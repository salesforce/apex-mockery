/*
 * Copyright (c) 2022, salesforce.com, inc.
 * All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * For full license text, see the LICENSE file in the repo root or https://opensource.org/licenses/BSD-3-Clause
 */

@IsTest
private class MethodSpyTestCustomBehavior {
  private class ReturnParam implements MethodSpy.ConfiguredBehavior {
    public Object apply(final List<Object> params) {
      return params;
    }
  }

  @isTest
  static void givenSpyConfiguredWithBehavior_whenCalled_thenExecuteTheBehavior() {
    // Arrange
    MethodSpy sut = new MethodSpy('methodName');
    sut.mockImplementation(new ReturnParam());

    // Act
    final Object result = sut.call(new List<Type>{ String.class }, new List<String>{ 'param' }, new List<Object>{ 'str' });

    // Assert
    Assert.areEqual(new List<Object>{ 'str' }, result);
  }

  @isTest
  static void givenSpyConfiguredWithMatcherWithBehavior_whenCalledWithMatching_thenExecuteTheBehavior() {
    // Arrange
    MethodSpy sut = new MethodSpy('methodName');
    sut.whenCalledWith('str').thenMockImplementation(new ReturnParam());

    // Act
    final Object result = sut.call(new List<Type>{ String.class }, new List<String>{ 'param' }, new List<Object>{ 'str' });

    // Assert
    Assert.areEqual(new List<Object>{ 'str' }, result);
  }

  @isTest
  static void givenSpyConfiguredWithBehaviorOnce_whenCalled_thenExecuteTheBehaviorOnce() {
    // Arrange
    MethodSpy sut = new MethodSpy('methodName');
    sut.mockImplementationOnce(new ReturnParam());

    // Act & Assert
    Object result = sut.call(new List<Type>{ String.class }, new List<String>{ 'param' }, new List<Object>{ 'str' });
    Assert.areEqual(new List<Object>{ 'str' }, result);

    result = sut.call(new List<Type>{ String.class }, new List<String>{ 'param' }, new List<Object>{ 'str' });
    Assert.isNull(result);
  }

  @isTest
  static void givenSpyConfiguredWithMatcherWithBehaviorOnce_whenCalledWithMatching_thenExecuteTheBehaviorOnce() {
    // Arrange
    MethodSpy sut = new MethodSpy('methodName');
    sut.whenCalledWith('str').thenMockImplementationOnce(new ReturnParam());

    // Act & Assert
    Object result = sut.call(new List<Type>{ String.class }, new List<String>{ 'param' }, new List<Object>{ 'str' });
    Assert.areEqual(new List<Object>{ 'str' }, result);

    result = sut.call(new List<Type>{ String.class }, new List<String>{ 'param' }, new List<Object>{ 'str' });
    Assert.isNull(result);
  }

  @isTest
  static void givenSpyConfiguredWithBehaviorTimes_whenCalled_thenExecuteTheBehaviorTimes() {
    // Arrange
    MethodSpy sut = new MethodSpy('methodName');
    sut.mockImplementation(new ReturnParam(), 2);

    // Act & Assert
    Object result = sut.call(new List<Type>{ String.class }, new List<String>{ 'param' }, new List<Object>{ 'str' });
    Assert.areEqual(new List<Object>{ 'str' }, result);

    result = sut.call(new List<Type>{ String.class }, new List<String>{ 'param' }, new List<Object>{ 'str' });
    Assert.areEqual(new List<Object>{ 'str' }, result);

    result = sut.call(new List<Type>{ String.class }, new List<String>{ 'param' }, new List<Object>{ 'str' });
    Assert.isNull(result);
  }

  @isTest
  static void givenSpyConfiguredWithMatcherWithBehaviorTimes_whenCalledWithMatching_thenExecuteTheBehaviorTimes() {
    // Arrange
    MethodSpy sut = new MethodSpy('methodName');
    sut.whenCalledWith('str').thenMockImplementation(new ReturnParam(), 2);

    // Act & Assert
    Object result = sut.call(new List<Type>{ String.class }, new List<String>{ 'param' }, new List<Object>{ 'str' });
    Assert.areEqual(new List<Object>{ 'str' }, result);

    result = sut.call(new List<Type>{ String.class }, new List<String>{ 'param' }, new List<Object>{ 'str' });
    Assert.areEqual(new List<Object>{ 'str' }, result);

    result = sut.call(new List<Type>{ String.class }, new List<String>{ 'param' }, new List<Object>{ 'str' });
    Assert.isNull(result);
  }
}
