/*
 * Copyright (c) 2024, salesforce.com, inc.
 * All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * For full license text, see the LICENSE file in the repo root or https://opensource.org/licenses/BSD-3-Clause
 */

@IsTest
private class MethodSpyOnceTest {
  @isTest
  static void givenSpyConfiguredToGloballyReturnsOnce_whenCalledOnce_returnsConfiguration() {
    // Arrange
    MethodSpy sut = new MethodSpy('methodName');
    sut.returnsOnce('global');

    // Act
    Object resultMatcher = sut.call(new List<Type>{ String.class }, new List<String>{ 'param' }, new List<Object>{ 'str' });
    Assert.areEqual('global', resultMatcher);

    // Assert
    Object result = sut.call(new List<Type>{ String.class }, new List<String>{ 'param' }, new List<Object>{ 'str' });
    Assert.isNull(result);
  }

  @isTest
  static void givenSpyConfiguredToGloballyThrowsOnce_whenCalledOnce_throwsConfiguration() {
    // Arrange
    MethodSpy sut = new MethodSpy('methodName');
    sut.throwsExceptionOnce(new IllegalArgumentException('global'));

    // Act
    try {
      sut.call(new List<Type>{ String.class }, new List<String>{ 'param' }, new List<Object>{ 'str' });
      Assert.fail('it shoud not reach this line');
    } catch (Exception e) {
      Assert.areEqual('global', e.getMessage());
    }

    // Assert
    Object result = sut.call(new List<Type>{ String.class }, new List<String>{ 'param' }, new List<Object>{ 'str' });
    Assert.isNull(result);
  }

  @isTest
  static void givenSpyConfiguredToMatchReturnsOnce_whenCalledOnce_returnsConfiguration() {
    // Arrange
    MethodSpy sut = new MethodSpy('methodName');
    sut.whenCalledWith('str').thenReturnOnce('match');

    // Act
    Object resultMatcher = sut.call(new List<Type>{ String.class }, new List<String>{ 'param' }, new List<Object>{ 'str' });
    Assert.areEqual('match', resultMatcher);

    // Assert
    Object result = sut.call(new List<Type>{ String.class }, new List<String>{ 'param' }, new List<Object>{ 'str' });
    Assert.isNull(result);
  }

  @isTest
  static void givenSpyConfiguredToMatchThrowsOnce_whenCalledOnce_throwsConfiguration() {
    // Arrange
    MethodSpy sut = new MethodSpy('methodName');
    sut.whenCalledWith('str').thenThrowOnce(new IllegalArgumentException('match'));

    // Act
    try {
      sut.call(new List<Type>{ String.class }, new List<String>{ 'param' }, new List<Object>{ 'str' });
      Assert.fail('it shoud not reach this line');
    } catch (Exception e) {
      Assert.areEqual('match', e.getMessage());
    }

    // Assert
    Object result = sut.call(new List<Type>{ String.class }, new List<String>{ 'param' }, new List<Object>{ 'str' });
    Assert.isNull(result);
  }
}
