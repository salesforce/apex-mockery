/*
 * Copyright (c) 2024, salesforce.com, inc.
 * All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * For full license text, see the LICENSE file in the repo root or https://opensource.org/licenses/BSD-3-Clause
 */

@IsTest
private class MethodSpyOnceTest {
  @IsTest
  static void givenSpyConfiguredConfiguredOncesGlobalOnceConfiguredNormalAndGlobalNormal_whenCalledWithMatchingMultipleTimes_spyOnceThenGlobalOnceThenMathThenGlobalInOrderOfConfiguration() {
    // Arrange
    MethodSpy sut = new MethodSpy('methodName');
    sut.returnsOnce('global once');
    sut.throwsExceptionOnce(new IllegalArgumentException('global once'));
    sut.returns('global');
    sut.throwsException(new IllegalArgumentException('global')); // It overrides returns (last global configuration overrides)
    sut.whenCalledWith('str')
      .thenReturn('match')
      .thenThrow(new IllegalArgumentException('match')) // It overrides thenReturn (last matching configuration overrides)
      .thenReturnOnce('match once')
      .thenThrowOnce(new IllegalArgumentException('match once'));

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
  static void givenSpyConfiguredWithReturnOnceThrowOnce_whenCalledMultipleTImes_spyThrowsOnceReturnsOnceThenGlobalReturnsOnceThenGlobalReturns() {
    // Arrange
    MethodSpy sut = new MethodSpy('methodName');
    sut.returnsOnce('once');
    sut.returns('every');
    sut.whenCalledWith('str').thenReturnOnce('match').thenThrowOnce(new IllegalArgumentException('match'));

    // Act & Assert
    Object resultMatcher = sut.call(new List<Type>{ String.class }, new List<String>{ 'param' }, new List<Object>{ 'str' });
    Assert.areEqual('match', resultMatcher);
    try {
      sut.call(new List<Type>{ String.class }, new List<String>{ 'param' }, new List<Object>{ 'str' });
      Assert.fail('it shoud not reach this line');
    } catch (Exception e) {
      Assert.areEqual('match', e.getMessage());
    }
    Object resultOnce = sut.call(new List<Type>{ String.class }, new List<String>{ 'param' }, new List<Object>{ 'str' });
    Assert.areEqual('once', resultOnce);

    Object resultNoMatcher = sut.call(new List<Type>{ String.class }, new List<String>{ 'param' }, new List<Object>{ 'str' });
    Assert.areEqual('every', resultNoMatcher);
  }

  @IsTest
  static void givenSpyConfiguredWithReturnOnce_whenCalledMultipleTImes_spyReturnsOnce() {
    // Arrange
    MethodSpy sut = new MethodSpy('methodName');
    sut.returnsOnce('once');
    sut.returns('every');
    sut.whenCalledWith('str').thenReturn('match');

    // Act
    Object resultOnce = sut.call(new List<Type>{ String.class }, new List<String>{ 'param' }, new List<Object>{ null });
    Object resultNoMatcher = sut.call(new List<Type>{ String.class }, new List<String>{ 'param' }, new List<Object>{ null });
    Object resultMatcher = sut.call(new List<Type>{ String.class }, new List<String>{ 'param' }, new List<Object>{ 'str' });

    // Assert
    Assert.areEqual('once', resultOnce);
    Assert.areEqual('every', resultNoMatcher);
    Assert.areEqual('match', resultMatcher);
  }

  @IsTest
  static void givenSpyConfiguredWithThrowOnce_whenCalledMultipleTimes_spyThrowsOnce() {
    // Arrange
    MethodSpy sut = new MethodSpy('methodName');
    sut.throwsExceptionOnce(new IllegalArgumentException('once'));
    sut.throwsException(new IllegalArgumentException('every'));
    sut.whenCalledWith('str').thenThrow(new IllegalArgumentException('match'));

    // Act & Assert
    try {
      sut.call(new List<Type>{ String.class }, new List<String>{ 'param' }, new List<Object>{ null });
      Assert.fail('it shoud not reach this line');
    } catch (Exception e) {
      Assert.areEqual('once', e.getMessage());
    }

    try {
      sut.call(new List<Type>{ String.class }, new List<String>{ 'param' }, new List<Object>{ null });
      Assert.fail('it shoud not reach this line');
    } catch (Exception e) {
      Assert.areEqual('every', e.getMessage());
    }

    try {
      sut.call(new List<Type>{ String.class }, new List<String>{ 'param' }, new List<Object>{ 'str' });
      Assert.fail('it shoud not reach this line');
    } catch (Exception e) {
      Assert.areEqual('match', e.getMessage());
    }
  }

  @IsTest
  static void givenSpyConfiguredWithMatcherReturnOnce_whenCalledWithMatchingMultipleTimes_spyReturnsOnce() {
    // Arrange
    MethodSpy sut = new MethodSpy('methodName');
    sut.returnsOnce('once');
    sut.returns('every');
    sut.whenCalledWith('str').thenReturnOnce('match once').thenReturn('match');

    // Act
    Object resultOnce = sut.call(new List<Type>{ String.class }, new List<String>{ 'param' }, new List<Object>{ null });
    Object resultNoMatcher = sut.call(new List<Type>{ String.class }, new List<String>{ 'param' }, new List<Object>{ null });
    Object resultMatcherOnce = sut.call(new List<Type>{ String.class }, new List<String>{ 'param' }, new List<Object>{ 'str' });
    Object resultMatcher = sut.call(new List<Type>{ String.class }, new List<String>{ 'param' }, new List<Object>{ 'str' });

    // Assert
    Assert.areEqual('once', resultOnce);
    Assert.areEqual('every', resultNoMatcher);
    Assert.areEqual('match once', resultMatcherOnce);
    Assert.areEqual('match', resultMatcher);
  }

  @IsTest
  static void givenSpyConfiguredWithMatcherThrowOnce_whenCalledWithMatchingMultipleTimes_spyThrowsOnce() {
    // Arrange
    MethodSpy sut = new MethodSpy('methodName');
    sut.throwsExceptionOnce(new IllegalArgumentException('once'));
    sut.throwsException(new IllegalArgumentException('every'));
    sut.whenCalledWith('str').thenThrowOnce(new IllegalArgumentException('match once')).thenThrow(new IllegalArgumentException('match'));

    // Act & Assert
    try {
      sut.call(new List<Type>{ String.class }, new List<String>{ 'param' }, new List<Object>{ null });
      Assert.fail('it shoud not reach this line');
    } catch (Exception e) {
      Assert.areEqual('once', e.getMessage());
    }

    try {
      sut.call(new List<Type>{ String.class }, new List<String>{ 'param' }, new List<Object>{ null });
      Assert.fail('it shoud not reach this line');
    } catch (Exception e) {
      Assert.areEqual('every', e.getMessage());
    }

    sut.throwsExceptionOnce(new IllegalArgumentException('once'));

    try {
      sut.call(new List<Type>{ String.class }, new List<String>{ 'param' }, new List<Object>{ 'str' });
      Assert.fail('it shoud not reach this line');
    } catch (Exception e) {
      Assert.areEqual('match once', e.getMessage());
    }

    try {
      sut.call(new List<Type>{ String.class }, new List<String>{ 'param' }, new List<Object>{ 'str' });
      Assert.fail('it shoud not reach this line');
    } catch (Exception e) {
      Assert.areEqual('once', e.getMessage());
    }

    try {
      sut.call(new List<Type>{ String.class }, new List<String>{ 'param' }, new List<Object>{ 'str' });
      Assert.fail('it shoud not reach this line');
    } catch (Exception e) {
      Assert.areEqual('match', e.getMessage());
    }
  }

  @IsTest
  static void givenSpyConfiguredWithMatcherThrowThrowOnceReturnReturnOnce_whenCalledWithMatchingMultipleTimes_spyThrowsOnceFirstThenThrowsAndNeverReturns() {
    // Arrange
    MethodSpy sut = new MethodSpy('methodName');
    sut.whenCalledWith('str')
      .thenReturn('match')
      .thenThrow(new IllegalArgumentException('match throw'))
      .thenReturnOnce('match once')
      .thenThrowOnce(new IllegalArgumentException('match once'));

    // Act & Assert
    Object resultMatchOnce = sut.call(new List<Type>{ String.class }, new List<String>{ 'param' }, new List<Object>{ 'str' });
    Assert.areEqual('match once', resultMatchOnce);

    try {
      sut.call(new List<Type>{ String.class }, new List<String>{ 'param' }, new List<Object>{ 'str' });
      Assert.fail('it shoud not reach this line');
    } catch (Exception e) {
      Assert.areEqual('match once', e.getMessage());
    }

    try {
      sut.call(new List<Type>{ String.class }, new List<String>{ 'param' }, new List<Object>{ 'str' });
      Assert.fail('it shoud not reach this line');
    } catch (Exception e) {
      Assert.areEqual('match throw', e.getMessage());
    }

    // As it is configured to throw it should not return
    try {
      sut.call(new List<Type>{ String.class }, new List<String>{ 'param' }, new List<Object>{ 'str' });
      Assert.fail('it shoud not reach this line');
    } catch (Exception e) {
      Assert.areEqual('match throw', e.getMessage());
    }
  }

  @IsTest
  static void givenSpyConfiguredWithMatcherThrowOnceReturnOnceReturn_whenCalledWithMatchingMultipleTimes_spyThrowsOnceFirstThenReturnsOnceThenReturns() {
    // Arrange
    MethodSpy sut = new MethodSpy('methodName');
    sut.whenCalledWith('str').thenReturn('match').thenReturnOnce('match once').thenThrowOnce(new IllegalArgumentException('match once'));

    // Act & Assert
    Object resultMatcherOnce = sut.call(new List<Type>{ String.class }, new List<String>{ 'param' }, new List<Object>{ 'str' });
    Assert.areEqual('match once', resultMatcherOnce);

    try {
      sut.call(new List<Type>{ String.class }, new List<String>{ 'param' }, new List<Object>{ 'str' });
      Assert.fail('it shoud not reach this line');
    } catch (Exception e) {
      Assert.areEqual('match once', e.getMessage());
    }

    Object resultMatcher = sut.call(new List<Type>{ String.class }, new List<String>{ 'param' }, new List<Object>{ 'str' });
    Assert.areEqual('match', resultMatcher);
  }
}
