/*
 * Copyright (c) 2024, salesforce.com, inc.
 * All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * For full license text, see the LICENSE file in the repo root or https://opensource.org/licenses/BSD-3-Clause
 */

@IsTest
private class MethodSpyTimesTest {
  @isTest
  static void givenConfiguredSpy_whenCalled_respectTheOrderOfMatching() {
    // Arrange
    MethodSpy sut = new MethodSpy('methodName');
    sut.returns('global');
    sut.throwsException(new IllegalArgumentException('global')); // It overrides returns (last global configuration overrides)
    sut.returnsOnce('global once');
    sut.throwsExceptionOnce(new IllegalArgumentException('global once'));
    sut.whenCalledWith('str')
      .thenReturn('match')
      .thenThrow(new IllegalArgumentException('match')) // It overrides thenReturn (last matching configuration overrides)
      .thenReturnOnce('match once')
      .thenThrowOnce(new IllegalArgumentException('match once'))
      .thenReturnTimes(2, 'match times')
      .thenThrowTimes(2, new IllegalArgumentException('match times'));

    // Act & Assert
    // whenCalledWith('str').thenReturnOnce('match once')
    Object resultMatcherOnce = sut.call(new List<Type>{ String.class }, new List<String>{ 'param' }, new List<Object>{ 'str' });
    Assert.areEqual('match once', resultMatcherOnce);

    // whenCalledWith('str').thenThrowOnce(new IllegalArgumentException('match once'))
    try {
      sut.call(new List<Type>{ String.class }, new List<String>{ 'param' }, new List<Object>{ 'str' });
      Assert.fail('it shoud not reach this line');
    } catch (Exception e) {
      Assert.areEqual('match once', e.getMessage());
    }

    // whenCalledWith('str').thenReturnTimes(2, 'match times')
    for (Integer i = 0; i < 2; ++i) {
      Object resultMatcherTimes = sut.call(new List<Type>{ String.class }, new List<String>{ 'param' }, new List<Object>{ 'str' });
      Assert.areEqual('match times', resultMatcherTimes);
    }

    // whenCalledWith('str').thenThrowTimes(2, new IllegalArgumentException('match times'))
    for (Integer i = 0; i < 2; ++i) {
      try {
        Object result = sut.call(new List<Type>{ String.class }, new List<String>{ 'param' }, new List<Object>{ 'str' });
        Assert.fail('it shoud not reach this line: ' + result);
      } catch (Exception e) {
        Assert.areEqual('match times', e.getMessage());
      }
    }

    // .returnsOnce('global once')
    Object resultGlobalOnce = sut.call(new List<Type>{ String.class }, new List<String>{ 'param' }, new List<Object>{ 'str' });
    Assert.areEqual('global once', resultGlobalOnce);

    // .throwsExceptionOnce(new IllegalArgumentException('global once'))
    try {
      sut.call(new List<Type>{ String.class }, new List<String>{ 'param' }, new List<Object>{ 'str' });
      Assert.fail('it shoud not reach this line');
    } catch (Exception e) {
      Assert.areEqual('global once', e.getMessage());
    }

    // whenCalledWith('str').thenThrow(new IllegalArgumentException('match')) => Override thenReturn('match')
    try {
      sut.call(new List<Type>{ String.class }, new List<String>{ 'param' }, new List<Object>{ 'str' });
      Assert.fail('it shoud not reach this line');
    } catch (Exception e) {
      Assert.areEqual('match', e.getMessage());
    }

    // .throwsException(new IllegalArgumentException('global')) => Override returns('global')
    try {
      sut.call(new List<Type>{ String.class }, new List<String>{ 'param' }, new List<Object>{ null });
      Assert.fail('it shoud not reach this line');
    } catch (Exception e) {
      Assert.areEqual('global', e.getMessage());
    }
  }

  @IsTest
  static void givenSpyConfigured_whenCallingTheSpyWithOtherArguments_itThrowsMethodSpyConfigurationException() {
    // Arrange
    MethodSpy sut = new MethodSpy('methodName');
    sut.whenCalledWith('Another Param', true).thenReturn('Expected Result');
    sut.whenCalledWith('Expected First Param', false)
      .thenReturn('Another expected Result')
      .thenReturnOnce('Another expected Result Once')
      .thenReturnTimes(2, 'Another expected Result Times');
    sut.whenCalledWith('Expected First Param', true)
      .thenThrow(new IllegalArgumentException('Yet another expected Result'))
      .thenThrowOnce(new IllegalArgumentException('Yet another expected Result Once'))
      .thenThrowTimes(2, new IllegalArgumentException('Yet another expected Result Times'));
    try {
      // Act
      sut.call(new List<Type>{ String.class, Boolean.class }, new List<String>{ 'param', 'bool' }, new List<Object>{ 'Another Param', false });
      Assert.fail('it shoud not reach this line');
    } catch (MethodSpy.ConfigurationException cex) {
      // Assert
      Assert.areEqual(
        'No stub value found for a call of methodName(String param[Another Param], Boolean bool[false])\nHere are the configured stubs:\n\twhenCalledWith(Another Param, true).thenReturn(Expected Result)\n\twhenCalledWith(Expected First Param, false).thenReturnOnce(Another expected Result Once).thenReturnOnce(Another expected Result Times).thenReturnOnce(Another expected Result Times).thenReturn(Another expected Result)\n\twhenCalledWith(Expected First Param, true).thenThrowOnce(IllegalArgumentException:[]: Yet another expected Result Once).thenThrowOnce(IllegalArgumentException:[]: Yet another expected Result Times).thenThrowOnce(IllegalArgumentException:[]: Yet another expected Result Times).thenThrow(IllegalArgumentException:[]: Yet another expected Result)',
        cex.getMessage()
      );
    }
  }

  @isTest
  static void givenSpyConfiguredToGloballyReturnsNTimes_whenCalledN1Times_returnsConfiguration() {
    // Arrange
    MethodSpy sut = new MethodSpy('methodName');
    sut.returnsTimes(3, 'global');

    // Act
    for (Integer i = 0; i < 3; ++i) {
      Object resultMatcher = sut.call(new List<Type>{ String.class }, new List<String>{ 'param' }, new List<Object>{ 'str' });
      Assert.areEqual('global', resultMatcher);
    }

    // Assert
    Object result = sut.call(new List<Type>{ String.class }, new List<String>{ 'param' }, new List<Object>{ 'str' });
    Assert.isNull(result);
  }

  @isTest
  static void givenSpyConfiguredToGloballyThrowsNTimes_whenCalledN1Times_throwsConfiguration() {
    // Arrange
    MethodSpy sut = new MethodSpy('methodName');
    sut.throwsExceptionTimes(3, new IllegalArgumentException('global'));

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
    Object result = sut.call(new List<Type>{ String.class }, new List<String>{ 'param' }, new List<Object>{ 'str' });
    Assert.isNull(result);
  }

  @isTest
  static void givenSpyConfiguredToMatchReturnsNTimes_whenCalledN1Times_returnsConfiguration() {
    // Arrange
    MethodSpy sut = new MethodSpy('methodName');
    sut.whenCalledWith('str').thenReturnTimes(3, 'match');

    // Act
    for (Integer i = 0; i < 3; ++i) {
      Object resultMatcher = sut.call(new List<Type>{ String.class }, new List<String>{ 'param' }, new List<Object>{ 'str' });
      Assert.areEqual('match', resultMatcher);
    }

    // Assert
    Object result = sut.call(new List<Type>{ String.class }, new List<String>{ 'param' }, new List<Object>{ 'str' });
    Assert.isNull(result);
  }

  @isTest
  static void givenSpyConfiguredToMatchThrowsNTimes_whenCalledN1Times_throwsConfiguration() {
    // Arrange
    MethodSpy sut = new MethodSpy('methodName');
    sut.whenCalledWith('str').thenThrowTimes(3, new IllegalArgumentException('match'));

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
    Object result = sut.call(new List<Type>{ String.class }, new List<String>{ 'param' }, new List<Object>{ 'str' });
    Assert.isNull(result);
  }
}
