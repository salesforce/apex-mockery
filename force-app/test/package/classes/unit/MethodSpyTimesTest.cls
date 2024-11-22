/*
 * Copyright (c) 2024, salesforce.com, inc.
 * All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * For full license text, see the LICENSE file in the repo root or https://opensource.org/licenses/BSD-3-Clause
 */

@IsTest
private class MethodSpyTimesTest {
  @isTest
  static void givenSpyConfiguredToGloballyReturnsNTimes_whenCalledN1Times_returnsConfiguration() {
    // Arrange
    MethodSpy sut = new MethodSpy('methodName');
    sut.returns('global', 3);

    // Act
    for (Integer i = 0; i < 3; ++i) {
      Object resultMatcher = sut.call(new List<Type>{ String.class }, new List<String>{ 'param' }, new List<Object>{ 'str' });
      Assert.areEqual('global', resultMatcher);
    }

    // Assert
    Object resultMatcher = sut.call(new List<Type>{ String.class }, new List<String>{ 'param' }, new List<Object>{ 'str' });
    ASsert.isNull(resultMatcher);
  }

  @isTest
  static void givenSpyConfiguredToGloballyThrowsNTimes_whenCalledN1Times_throwssConfiguration() {
    // Arrange
    MethodSpy sut = new MethodSpy('methodName');
    sut.throwsException(new IllegalArgumentException('global'), 3);

    // Act
    for (Integer i = 0; i < 3; ++i) {
      try {
        sut.call(new List<Type>{ String.class }, new List<String>{ 'param' }, new List<Object>{ 'str' });
        Assert.fail('it shoud not reach this line');
      } catch (Exception e) {
        Assert.areEqual('global', e.getMessage());
      }
    }

    // Assert
    Object resultMatcher = sut.call(new List<Type>{ String.class }, new List<String>{ 'param' }, new List<Object>{ 'str' });
    ASsert.isNull(resultMatcher);
  }

  @isTest
  static void givenSpyConfiguredToMatchReturnsNTimes_whenCalledN1Times_returnsConfiguration() {
    // Arrange
    MethodSpy sut = new MethodSpy('methodName');
    sut.whenCalledWith('str').thenReturn('match', 3);

    // Act
    for (Integer i = 0; i < 3; ++i) {
      Object resultMatcher = sut.call(new List<Type>{ String.class }, new List<String>{ 'param' }, new List<Object>{ 'str' });
      Assert.areEqual('match', resultMatcher);
    }

    // Assert
    /*Object resultMatcher = sut.call(new List<Type>{ String.class }, new List<String>{ 'param' }, new List<Object>{ 'str' });
     ASsert.isNull(resultMatcher);*/
  }

  @isTest
  static void givenSpyConfiguredToMatchThrowsNTimes_whenCalledN1Times_throwssConfiguration() {
    // Arrange
    MethodSpy sut = new MethodSpy('methodName');
    sut.whenCalledWith('str').thenThrow(new IllegalArgumentException('match'), 3);

    // Act
    for (Integer i = 0; i < 3; ++i) {
      try {
        sut.call(new List<Type>{ String.class }, new List<String>{ 'param' }, new List<Object>{ 'str' });
        Assert.fail('it shoud not reach this line');
      } catch (Exception e) {
        Assert.areEqual('match', e.getMessage());
      }
    }

    // Assert
    /*Object resultMatcher = sut.call(new List<Type>{ String.class }, new List<String>{ 'param' }, new List<Object>{ 'str' });
     ASsert.isNull(resultMatcher);*/
  }
}
