/*
 * Copyright (c) 2022, salesforce.com, inc.
 * All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * For full license text, see the LICENSE file in the repo root or https://opensource.org/licenses/BSD-3-Clause
 */

@IsTest
private class MethodSpyTest {
  @IsTest
  static void givenSpyConfiguredWithNull_callWithLegitInput_itThrowsNPE() {
    // Arrange
    final MethodSpy sut = new MethodSpy('methodName');
    sut.whenCalledWith(null);

    try {
      // Act
      sut.call(new List<Object>());

      // Assert
      System.assert(false, 'it should not reach this line');
    } catch (Exception ex) {
      System.assert(ex instanceof NullPointerException);
    }
  }

  @IsTest
  static void givenSpy_hasBeenCalledWithNull_itThrowsNPE() {
    // Arrange
    final MethodSpy sut = new MethodSpy('methodName');

    try {
      // Act
      sut.hasBeenCalledWith(null);

      // Assert
      System.assert(false, 'it should not reach this line');
    } catch (Exception ex) {
      System.assert(ex instanceof NullPointerException);
    }
  }

  @IsTest
  static void givenSpyConfiguredWithoutArguments_whenCalledWithoutArgument_spyIsCalled() {
    // Arrange
    final MethodSpy sut = new MethodSpy('methodName');
    sut.whenCalledWith(Params.empty()).thenReturn('test');

    // Act
    final Object result = sut.call(new List<Object>());

    // Assert
    System.assertEquals('test', result);
    System.assertEquals(true, sut.hasBeenCalledWith(Params.empty()));
    System.assertEquals(true, sut.hasBeenLastCalledWith(Params.empty()));
  }

  @IsTest
  static void givenSpyConfiguredWithAMixOfObjectAndParamMatcher_whenCalledWithAllMatching_spyIsCalled() {
    // Arrange
    final MethodSpy sut = new MethodSpy('methodName');
    sut.whenCalledWith(
        Params.of('param', new Account(Name = 'Test'), Matcher.any())
      )
      .thenReturn('Expected Result');

    // Act
    final Object result = sut.call(
      new List<Object>{ 'param', new Account(Name = 'Test'), true }
    );

    // Assert
    final Params expectedArgs = Params.of(
      'param',
      new Account(Name = 'Test'),
      Matcher.any()
    );
    System.assertEquals('Expected Result', result);
    System.assertEquals(true, sut.hasBeenCalledWith(expectedArgs));
    System.assertEquals(false, sut.hasBeenLastCalledWith(Params.empty()));
    System.assertEquals(true, sut.hasBeenLastCalledWith(expectedArgs));
  }

  @IsTest
  static void givenSpyConfiguredWithAMixOfObjectAndParamMatcher_whenCalledWithPartialMatching_spyThrows() {
    // Arrange
    final MethodSpy sut = new MethodSpy('methodName');
    sut.whenCalledWith(
        Params.of('param', new Account(Name = 'Test'), Matcher.any())
      )
      .thenReturn('Expected Result');

    // Act
    try {
      final Object result = sut.call(new List<Object>{ 'param' });

      // Assert
      System.assert(false, 'we shoud not reach this line');
    } catch (IllegalArgumentException iaex) {
      final Params expectedArgs = Params.of(
        'param',
        new Account(Name = 'Test'),
        Matcher.any()
      );
      System.assertEquals(false, sut.hasBeenCalledWith(expectedArgs));
    }
  }

  @IsTest
  static void givenSpyConfiguredWithAMixOfObjectAndParamMatcher_whenCalledWithNonMatching_spyThrows() {
    // Arrange
    final MethodSpy sut = new MethodSpy('methodName');
    sut.whenCalledWith(Params.of('param', new Account(Name = 'Test')))
      .thenReturn('Expected Result');

    // Act
    try {
      final Object result = sut.call(new List<Object>{ new Opportunity() });

      // Assert
      System.assert(false, 'we shoud not reach this line');
    } catch (IllegalArgumentException iaex) {
      Params expectedArgs = Params.of('param', new Account(Name = 'Test'));
      System.assertEquals(false, sut.hasBeenCalledWith(expectedArgs));
    }
  }

  @IsTest
  static void givenSpyConfiguredWithListOfParamMatcher_whenCalledWithAllMatching_spyIsCalled() {
    // Arrange
    final MethodSpy sut = new MethodSpy('methodName');
    sut.whenCalledWith(
        Params.of(
          Matcher.jsonEquals(new List<String>{ 'test' }),
          Matcher.ofType(Account.getSObjectType()),
          Matcher.any()
        )
      )
      .thenReturn('Expected Result');

    // Act
    final Object result = sut.call(
      new List<Object>{
        new List<String>{ 'test' },
        new Account(Name = 'random'),
        true
      }
    );

    // Assert
    final Params expectedArgs = Params.of(
      Matcher.jsonEquals(new List<String>{ 'test' }),
      Matcher.ofType(Account.getSObjectType()),
      Matcher.any()
    );
    System.assertEquals('Expected Result', result);
    System.assertEquals(true, sut.hasBeenCalledWith(expectedArgs));
    System.assertEquals(false, sut.hasBeenLastCalledWith(Params.empty()));
    System.assertEquals(true, sut.hasBeenLastCalledWith(expectedArgs));
  }

  @IsTest
  static void givenSpyConfiguredForMultipleOverload_whenCalledWithDifferentArgumentType_itCallsTheSameSpy() {
    // Arrange
    final MethodSpy sut = new MethodSpy('overLoaded');
    sut.whenCalledWith(Params.of(new Account())).thenReturn('Account result');
    sut.whenCalledWith(Params.of(new Opportunity()))
      .thenReturn('Opportunity result');

    // Act && Assert
    final Object firstCallResult = sut.call(new List<Object>{ new Account() });
    System.assertEquals('Account result', firstCallResult);
    final Object secondCallResult = sut.call(
      new List<Object>{ new Opportunity() }
    );
    System.assertEquals('Opportunity result', secondCallResult);
  }

  static void givenSpy_whenCalledWithDifferentArgumentType_itCallsTheSameSpy() {
    // Arrange
    final MethodSpy sut = new MethodSpy('methodName');
    sut.returns('String result');

    // Act && Assert
    final Object result = sut.call(new List<Object>{ new Account() });
    System.assertEquals('String result', result);
    result = sut.call(new List<Object>{ new Opportunity() });
    System.assertEquals('String result', result);
  }

  @IsTest
  static void givenSpyConfiguredOnceToReturnSomething_whenCallingTheSpy_itReturnsTheConfiguredValue() {
    // Arrange
    final MethodSpy sut = new MethodSpy('methodName');
    sut.returns('String result');

    // Act
    final Object result = sut.call(new List<Object>{});

    // Assert
    System.assertEquals('String result', result);
  }

  @IsTest
  static void givenSpyConfiguredMultipleTimesToReturnSomething_whenCallingTheSpy_itReturnsTheConfiguredValue() {
    // Arrange
    final MethodSpy sut = new MethodSpy('methodName');
    sut.returns('First Configuration');
    sut.returns('Second Configuration');
    sut.returns('Last Configuration');

    // Act
    final Object result = sut.call(new List<Object>{});

    // Assert
    System.assertEquals('Last Configuration', result);
  }

  @IsTest
  static void givenSpyConfiguredToThrowException_whenCallingTheSpy_itThrowsTheException() {
    // Arrange
    final MethodSpy sut = new MethodSpy('methodName');
    sut.throwsException(new IllegalArgumentException('test exception'));

    try {
      // Act
      sut.call(new List<Object>{});
      System.assert(false, 'test should have throw an exception');
    } catch (Exception e) {
      // Assert
      System.assertEquals('test exception', e.getMessage());
    }
  }

  @IsTest
  static void givenSpyConfiguredToThrowExceptionMultipleTimes_whenCallingTheSpy_itThrowsTheLastConfiguredException() {
    // Arrange
    final MethodSpy sut = new MethodSpy('methodName');
    final Exception exception1 = new IllegalArgumentException(
      'test exception 1'
    );
    final Exception exception2 = new IllegalArgumentException(
      'test exception 2'
    );
    final Exception exception3 = new IllegalArgumentException(
      'test exception 3'
    );
    sut.throwsException(exception1);
    sut.throwsException(exception2);
    sut.throwsException(exception3);

    try {
      // Act
      sut.call(new List<Object>{});
      System.assert(false, 'test should have throw an exception');
    } catch (Exception e) {
      // Assert
      System.assertEquals(exception3.getMessage(), e.getMessage());
    }
  }

  @IsTest
  static void givenSpyConfiguredToThenThrowException_whenCallingTheSpyWithMatchingParams_itThrowsTheException() {
    // Arrange
    final MethodSpy sut = new MethodSpy('methodName');
    sut.whenCalledWith(Params.of('Expected Param'))
      .thenThrow(new IllegalArgumentException('test exception'));

    try {
      // Act
      sut.call(new List<Object>{ 'Expected Param' });
      System.assert(false, 'test should have throw an exception');
    } catch (Exception e) {
      // Assert
      System.assertEquals('test exception', e.getMessage());
    }
  }

  @IsTest
  static void givenSpyConfiguredOnceToReturnOnMatchingSingleParam_whenCallingTheSpy_itReturnsTheConfiguredValue() {
    // Arrange
    final MethodSpy sut = new MethodSpy('methodName');
    sut.whenCalledWith(Params.of('Expected Param'))
      .thenReturn('Expected Result');

    // Act
    final Object result = sut.call(new List<Object>{ 'Expected Param' });

    // Assert
    System.assertEquals('Expected Result', result);
  }

  @IsTest
  static void givenSpyConfiguredMultipleTimesToReturnOnMatchingSingleParam_whenCallingTheSpy_itReturnsTheConfiguredValue() {
    // Arrange
    final MethodSpy sut = new MethodSpy('methodName');
    sut.whenCalledWith(Params.of('Expected Param 1'))
      .thenReturn('Expected Result 1');
    sut.whenCalledWith(Params.of('Expected Param 2'))
      .thenReturn('Expected Result 2');

    // Act
    final Object result1 = sut.call(new List<Object>{ 'Expected Param 1' });
    final Object result2 = sut.call(new List<Object>{ 'Expected Param 2' });

    // Assert
    System.assertEquals('Expected Result 1', result1);
    System.assertEquals('Expected Result 2', result2);
  }

  @IsTest
  static void givenSpyConfiguredOnceToReturnOnMatchingParams_whenCallingTheSpy_itReturnsTheConfiguredValue() {
    // Arrange
    final MethodSpy sut = new MethodSpy('methodName');
    sut.whenCalledWith(Params.of('Expected First Param', true))
      .thenReturn('Expected Result');

    // Act
    final Object result = sut.call(
      new List<Object>{ 'Expected First Param', true }
    );

    // Assert
    System.assertEquals('Expected Result', result);
  }

  @IsTest
  static void givenSpyConfiguredOnceToReturnOnMatchingTypeMatcherAndBooleanTrue_whenCallingTheSpyWithRightType_itReturnsTheConfiguredValue() {
    // Arrange
    final MethodSpy sut = new MethodSpy('methodName');
    sut.whenCalledWith(
        Params.of(Matcher.ofType(Account.getSObjectType()), true)
      )
      .thenReturn('Expected Result');

    // Act
    final Object result = sut.call(new List<Object>{ new Account(), true });

    // Assert
    System.assertEquals('Expected Result', result);
  }

  @IsTest
  static void givenSpyConfiguredOnceToReturnOnMatchingTypeMatcher_whenCallingTheSpyWithWWrong_itShouldThrowIllegalArgumentException() {
    // Arrange
    final MethodSpy sut = new MethodSpy('methodName');
    sut.whenCalledWith(Params.of(Matcher.ofType(Account.getSObjectType())))
      .thenReturn('Expected Result');

    // Act
    try {
      final Object result = sut.call(
        new List<Object>{ new Opportunity(), true }
      );
      // Assert
      System.assert(false, 'test should have throw an exception');
    } catch (Exception ex) {
      System.assert(
        ex instanceof IllegalArgumentException,
        'Exception should be IllegalArgumentException'
      );
    }
  }

  @IsTest
  static void givenSpyConfiguredMultipleTimesToReturnOnMatchingParams_whenCallingTheSpy_itReturnsTheConfiguredValue() {
    // Arrange
    final MethodSpy sut = new MethodSpy('methodName');
    sut.whenCalledWith(Params.of('Expected First Param 1', true))
      .thenReturn('Expected Result 1');
    sut.whenCalledWith(Params.of('Expected First Param 2', false))
      .thenReturn('Expected Result 2');

    // Act
    final Object result1 = sut.call(
      new List<Object>{ 'Expected First Param 1', true }
    );
    final Object result2 = sut.call(
      new List<Object>{ 'Expected First Param 2', false }
    );

    // Assert
    System.assertEquals('Expected Result 1', result1);
    System.assertEquals('Expected Result 2', result2);
  }

  @IsTest
  static void givenSpyOnMethodWithoutParameterReturningVoid_whenCallingTheSpy_itReturnsNull() {
    // Arrange
    final MethodSpy sut = new MethodSpy('methodName');

    // Act
    final object actual = sut.call(new List<Object>{});

    // Assert
    System.assertEquals(null, actual);
  }

  @IsTest
  static void givenSpyConfiguredOnceToReturnOnMatchingParams_whenCallingTheSpyWithOtherParams_itThrowsIllegalArgumentException() {
    // Arrange
    final MethodSpy sut = new MethodSpy('methodName');
    sut.whenCalledWith(Params.of('Expected First Param', true))
      .thenReturn('Expected Result');
    try {
      // Act
      sut.call(new List<Object>{ 'Another Param', false });
      System.assert(false, 'test should have throw an exception');
    } catch (IllegalArgumentException e) {
      // Assert
      System.assertEquals(
        'methodName: No stub value found for a call with params (Another Param, false)',
        e.getMessage()
      );
    }
  }

  @IsTest
  static void givenSpyConfiguredToReturnOnMatchingParamsAndThenToReturns_whenCallingTheSpyWithParams_itReturnExpectedValueAndFallbackToDefault() {
    // Arrange
    final MethodSpy sut = new MethodSpy('methodName');
    sut.whenCalledWith(Params.of('Expected First Param', true))
      .thenReturn('Expected Result');
    sut.returns('Default Result');

    // Act
    final Object result1 = sut.call(
      new List<Object>{ 'Expected First Param', true }
    );
    final Object result2 = sut.call(new List<Object>{ 'Another Param', false });

    // Assert
    System.assertEquals('Expected Result', result1);
    System.assertEquals('Default Result', result2);
  }

  @IsTest
  static void givenSpyConfiguredToReturnsAndThenToReturnOnMatchingParams_whenCallingTheSpyWithParams_itReturnExpectedValueAndFallbackToDefault() {
    // Arrange
    final MethodSpy sut = new MethodSpy('methodName');
    sut.returns('Default Result');
    sut.whenCalledWith(Params.of('Expected First Param', true))
      .thenReturn('Expected Result');

    // Act
    final Object result1 = sut.call(
      new List<Object>{ 'Expected First Param', true }
    );
    final Object result2 = sut.call(new List<Object>{ 'Another Param', false });

    // Assert
    System.assertEquals('Expected Result', result1);
    System.assertEquals('Default Result', result2);
  }

  @IsTest
  static void givenSpyNotCalled_hasBeenCalled_itReturnsFalse() {
    // Arrange
    final MethodSpy sut = new MethodSpy('methodName');
    sut.returns('any result');

    // Act
    final Boolean hasBeenCalled = sut.hasBeenCalled();

    // Assert
    System.assert(!hasBeenCalled);
  }

  @IsTest
  static void givenSpyCalled_hasBeenCalled_itReturnsTrue() {
    // Arrange
    final MethodSpy sut = new MethodSpy('methodName');
    sut.returns('any result');
    sut.call(new List<Object>{});

    // Act
    final Boolean hasBeenCalled = sut.hasBeenCalled();

    // Assert
    System.assert(hasBeenCalled);
  }

  @IsTest
  static void givenSpyNotCalled_hasBeenCalledTimes_itReturnsTrueForZero() {
    // Arrange
    final MethodSpy sut = new MethodSpy('methodName');
    sut.returns('any result');

    // Act && Assert
    System.assert(!sut.hasBeenCalledTimes(-1));
    System.assert(sut.hasBeenCalledTimes(0));
    System.assert(!sut.hasBeenCalledTimes(1));
    System.assert(!sut.hasBeenCalledTimes(5));
  }

  @IsTest
  static void givenSpyCalledOnce_hasBeenCalledTimes_itReturnsTrueForOne() {
    // Arrange
    final MethodSpy sut = new MethodSpy('methodName');
    sut.returns('any result');
    sut.call(new List<Object>{});

    // Act && Assert
    System.assert(!sut.hasBeenCalledTimes(-1));
    System.assert(!sut.hasBeenCalledTimes(0));
    System.assert(sut.hasBeenCalledTimes(1));
    System.assert(!sut.hasBeenCalledTimes(5));
  }

  @IsTest
  static void givenSpyCalledFiveTimes_hasBeenCalledTimes_itReturnsTrueForFive() {
    // Arrange
    final MethodSpy sut = new MethodSpy('methodName');
    sut.returns('any result');
    sut.call(new List<Object>{});
    sut.call(new List<Object>{});
    sut.call(new List<Object>{});
    sut.call(new List<Object>{});
    sut.call(new List<Object>{});

    // Act && Assert
    System.assert(!sut.hasBeenCalledTimes(-1));
    System.assert(!sut.hasBeenCalledTimes(0));
    System.assert(!sut.hasBeenCalledTimes(1));
    System.assert(sut.hasBeenCalledTimes(5));
    System.assert(!sut.hasBeenCalledTimes(6));
  }

  @IsTest
  static void givenSpyCalledLastWithParams_hasBeenLastCalledWithParams_returnsTrueForLastAndFalseElse() {
    // Arrange
    final List<Object> first = new List<Object>{ new Opportunity() };
    final List<Object> last = new List<Object>{ new Account() };
    final MethodSpy sut = new MethodSpy('methodName');
    sut.call(first);
    sut.call(last);

    // Act && Assert
    System.assert(!sut.hasBeenLastCalledWith(Params.of(new Opportunity())));
    System.assert(sut.hasBeenLastCalledWith(Params.of(new Account())));
  }

  @IsTest
  static void givenSpyCalledLastWithParams_hasBeenLastCalledWithEmptyArgs_returnsMatches() {
    // Arrange
    final List<Object> param = new List<Object>();
    final MethodSpy sut = new MethodSpy('methodName');

    // Act & Assert
    System.assert(!sut.hasBeenLastCalledWith(Params.empty()));
    sut.call(param);
    System.assert(sut.hasBeenLastCalledWith(Params.empty()));
  }

  @IsTest
  static void givenSpyCalledLastWithParams_hasBeenLastCalledWithMatchers_returnsMatches() {
    // Arrange
    final Object param = new Account();
    final MethodSpy sut = new MethodSpy('methodName');

    // Act & Assert
    System.assert(!sut.hasBeenLastCalledWith(Params.of(Matcher.any())));
    sut.call(new List<Object>{ param });
    System.assert(sut.hasBeenLastCalledWith(Params.of(Matcher.any())));
  }

  @IsTest
  static void givenSpyCalledMultipleTimes_hasBeenCalledWith_returnsTrueForCalledParamsElseFalse() {
    // Arrange
    final List<Object> first = new List<Object>{ new Opportunity() };
    final List<Object> last = new List<Object>{ new Account() };
    final MethodSpy sut = new MethodSpy('methodName');
    sut.call(first);
    sut.call(last);

    // Act && Assert

    System.assert(sut.hasBeenCalledWith(Params.of(new Opportunity())));
    System.assert(sut.hasBeenCalledWith(Params.of(new Account())));
    System.assert(!sut.hasBeenCalledWith(Params.of(new Case())));
  }

  @IsTest
  static void givenSpyCalledWithParams_hasBeenCalledEmptyArgs_returnsMatches() {
    // Arrange
    final List<Object> param = new List<Object>();
    final MethodSpy sut = new MethodSpy('methodName');

    // Act & Assert
    System.assert(!sut.hasBeenCalledWith(Params.empty()));
    sut.call(param);
    System.assert(sut.hasBeenCalledWith(Params.empty()));
  }

  @IsTest
  static void givenSpyCalledWithParams_hasBeenCalledWithMatcher_returnsMatches() {
    // Arrange
    final Object param = new Account(Name = 'test');
    final MethodSpy sut = new MethodSpy('methodName');

    // Act & Assert
    System.assert(!sut.hasBeenCalledWith(Params.of(Matcher.any())));
    sut.call(new List<Object>{ param });
    System.assert(sut.hasBeenCalledWith(Params.of(Matcher.any())));
  }

  @IsTest
  static void givenSpyCalledWithParam_hasBeenCalledWithJSONMatcher() {
    // Arrange
    final Object param = new Account(Name = 'test');
    final MethodSpy sut = new MethodSpy('methodName');

    // Act & Assert
    System.assert(!sut.hasBeenCalledWith(Params.of(Matcher.jsonEquals(param))));
    sut.call(new List<Object>{ param });
    System.assert(sut.hasBeenCalledWith(Params.of(Matcher.jsonEquals(param))));
  }

  @IsTest
  static void givenSpyCalledWithCustomApex_hasBeenCalledWithReturnsTrue() {
    // Arrange
    final CustomApex param = new CustomApex('test');
    final MethodSpy sut = new MethodSpy('methodName');
    sut.whenCalledWith(Params.of(param)).thenReturn(new Account());

    // Act
    final Object actual = sut.call(new List<Object>{ param });

    // Assert
    final Object expected = new Account();
    System.assertEquals(
      expected,
      actual,
      'custom apex identical list should match'
    );
  }

  @IsTest
  static void givenSpyCalledWithListOf2_hasBeenCalledWithListOf1ReturnsFalse() {
    // Arrange
    final List<Object> objects = new List<Object>{
      new Account(),
      new Account()
    };
    final MethodSpy sut = new MethodSpy('methodName');
    sut.whenCalledWith(Params.of(new Account(), new Account()))
      .thenReturn(true);

    // Act
    try {
      final Object actual = sut.call(new List<Object>{ new Account() });

      // Assert
      System.assert(false); // Should not reach this point
    } catch (IllegalArgumentException ex) {
      System.assertNotEquals(null, ex, 'exception should be thrown');
    }
  }

  @IsTest
  static void givenSpyCalledWithCustomApexWithEquals_hasBeenCalledWithReturnsTrue() {
    // Arrange
    final CustomApexWithEquals param = new CustomApexWithEquals('test');
    final MethodSpy sut = new MethodSpy('methodName');
    sut.whenCalledWith(Params.of(param)).thenReturn(new Account());

    // Act
    final Object actual = sut.call(new List<Object>{ param });

    // Assert
    final Object expected = new Account();
    System.assertEquals(
      expected,
      actual,
      'custom apex with equals identical list should match'
    );
  }

  @IsTest
  static void givenSpyCalledWithNotSerializableCustomApex_hasBeenCalledWithReturnsTrue() {
    // Arrange
    final NotSerializableCustomApex param = new NotSerializableCustomApex();
    final MethodSpy sut = new MethodSpy('methodName');
    sut.whenCalledWith(Params.of(param)).thenReturn(new Account());

    // Act
    final Object actual = sut.call(new List<Object>{ param });

    // Assert
    final Object expected = new Account();
    System.assertEquals(
      expected,
      actual,
      'Not serializable custom apex identical list should match'
    );
  }

  @IsTest
  static void e2e_returns_then_whenCalledWith() {
    // Arrange
    final MethodSpy sut = new MethodSpy('methodName');
    sut.returns('result default');
    sut.whenCalledWith(Params.of(1)).thenReturn('result 1');
    sut.whenCalledWith(Params.of(2)).thenReturn('result 2');

    // Act & Assert
    final Object result1 = sut.call(new List<Object>{ 1 });
    System.assertEquals('result 1', result1);

    // Act & Assert
    final Object result2 = sut.call(new List<Object>{ 2 });
    System.assertEquals('result 2', result2);

    // Act & Assert
    final Object resultDefault = sut.call(new List<Object>{ 3 });
    System.assertEquals('result default', resultDefault);
  }

  @IsTest
  static void e2e_returns_then_throwsException() {
    // Arrange
    final MethodSpy sut = new MethodSpy('methodName');
    sut.returns('result');
    sut.throwsException(new IllegalArgumentException('test exception'));

    // Act & Assert
    try {
      sut.call(new List<Object>{ 1 });
      System.assert(false, 'test should have throw an exception');
    } catch (Exception e) {
      System.assertEquals('test exception', e.getMessage());
    }
  }

  @IsTest
  static void e2e_throwsException_then_returns() {
    // Arrange
    final MethodSpy sut = new MethodSpy('methodName');
    sut.throwsException(new IllegalArgumentException('test exception'));
    sut.returns('result');

    // Act
    final Object result = sut.call(new List<Object>{ 1 });

    // Assert
    System.assertEquals('result', result);
  }

  @IsTest
  static void e2e_whenCalledWith_then_returns() {
    // Arrange
    final MethodSpy sut = new MethodSpy('methodName');
    sut.whenCalledWith(Params.of(1)).thenReturn('result 1');
    sut.whenCalledWith(Params.of(2)).thenReturn('result 2');
    sut.returns('result default');

    // Act & Assert
    final Object result1 = sut.call(new List<Object>{ 1 });
    System.assertEquals('result 1', result1);

    // Act & Assert
    final Object result2 = sut.call(new List<Object>{ 2 });
    System.assertEquals('result 2', result2);

    // Act & Assert
    final Object resultDefault = sut.call(new List<Object>{ 3 });
    System.assertEquals('result default', resultDefault);
  }

  @IsTest
  static void e2e_throwsException_then_whenCalledWith() {
    // Arrange
    final MethodSpy sut = new MethodSpy('methodName');
    sut.throwsException(new IllegalArgumentException('test exception'));
    sut.whenCalledWith(Params.of(1)).thenReturn('result 1');
    sut.whenCalledWith(Params.of(2)).thenReturn('result 2');

    // Act & Assert
    final Object result1 = sut.call(new List<Object>{ 1 });
    System.assertEquals('result 1', result1);

    // Act & Assert
    final Object result2 = sut.call(new List<Object>{ 2 });
    System.assertEquals('result 2', result2);

    // Act & Assert
    try {
      sut.call(new List<Object>{ 3 });
      System.assert(false, 'test should have throw an exception');
    } catch (Exception e) {
      System.assertEquals('test exception', e.getMessage());
    }
  }

  @IsTest
  static void e2e_whenCalledWith_then_throwsException() {
    // Arrange
    final MethodSpy sut = new MethodSpy('methodName');
    sut.whenCalledWith(Params.of(1)).thenReturn('result 1');
    sut.whenCalledWith(Params.of(2)).thenReturn('result 2');
    sut.throwsException(new IllegalArgumentException('test exception'));

    // Act & Assert
    final Object result1 = sut.call(new List<Object>{ 1 });
    System.assertEquals('result 1', result1);

    // Act & Assert
    final Object result2 = sut.call(new List<Object>{ 2 });
    System.assertEquals('result 2', result2);

    // Act & Assert
    try {
      sut.call(new List<Object>{ 3 });
      System.assert(false, 'test should have throw an exception');
    } catch (Exception e) {
      System.assertEquals('test exception', e.getMessage());
    }
  }

  class CustomApex {
    private String attribut;

    public CustomApex(final String attribut) {
      this.attribut = attribut;
    }
  }

  class CustomApexWithEquals {
    private String attribut;

    public CustomApexWithEquals(final String attribut) {
      this.attribut = attribut;
    }

    public Boolean equals(Object o) {
      if ((o == null) || !(o instanceof CustomApexWithEquals)) {
        return false;
      }
      final CustomApexWithEquals subject = (CustomApexWithEquals) o;
      return this.attribut == subject.attribut;
    }

    public Integer hashCode() {
      return this.attribut != null ? this.attribut.hashCode() : -1;
    }
  }

  class NotSerializableCustomApex {
    private Http notSerializableAttribut;

    public NotSerializableCustomApex() {
      this.notSerializableAttribut = new Http();
    }
  }
}
