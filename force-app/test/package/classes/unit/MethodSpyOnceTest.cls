/*
 * Copyright (c) 2024, salesforce.com, inc.
 * All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * For full license text, see the LICENSE file in the repo root or https://opensource.org/licenses/BSD-3-Clause
 */

@IsTest
private class MethodSpyOnceTest {
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
}
