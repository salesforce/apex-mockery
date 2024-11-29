/*
 * Copyright (c) 2022, salesforce.com, inc.
 * All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * For full license text, see the LICENSE file in the repo root or https://opensource.org/licenses/BSD-3-Clause
 */

@IsTest
private class MethodSpyTest {
  @IsTest
  static void givenSpyConfiguredWithArguments_whenConfiguredWithSameArgument_thenReturnSameConfiguration() {
    // Arrange
    MethodSpy sut = new MethodSpy('methodName');

    // Act
    MethodSpy.MethodSpyCall spyCallNull = sut.whenCalledWith(null);
    MethodSpy.MethodSpyCall spyCallString = sut.whenCalledWith('str');
    MethodSpy.MethodSpyCall otherSpyCallNull = sut.whenCalledWith(null);
    MethodSpy.MethodSpyCall otherSpyCallString = sut.whenCalledWith('str');

    // Assert
    Assert.areNotEqual(spyCallNull, spyCallString);
    Assert.areNotEqual(otherSpyCallNull, spyCallString);
    Assert.areNotEqual(spyCallNull, otherSpyCallString);
    Assert.areNotEqual(otherSpyCallNull, otherSpyCallString);

    Assert.areEqual(spyCallNull, otherSpyCallNull);
    Assert.isTrue(spyCallNull === otherSpyCallNull);
    Assert.areEqual(spyCallString, otherSpyCallString);
    Assert.isTrue(spyCallString === otherSpyCallString);
  }

  @IsTest
  static void givenSpyConfiguredWithNullArguments_whenCalledWithMatching_spyIsCalled() {
    // Arrange
    MethodSpy sut = new MethodSpy('methodName');
    sut.whenCalledWith(null).thenReturn('test');

    // Act
    Object result = sut.call(new List<Type>{ String.class }, new List<String>{ 'param' }, new List<Object>{ null });

    // Assert
    Assert.areEqual('test', result);
    Assert.areEqual(new List<Object>{ null }, sut.callLog.getLast());
  }

  @IsTest
  static void givenSpyConfiguredWithArguments_whenCalledWithMatching_spyIsCalled() {
    // Arrange
    MethodSpy sut = new MethodSpy('methodName');
    sut.whenCalledWith(Argument.of('value')).thenReturn('test');

    // Act
    Object result = sut.call(new List<Type>{ String.class }, new List<String>{ 'param' }, new List<Object>{ 'value' });

    // Assert
    Assert.areEqual('test', result);
    Assert.areEqual(new List<Object>{ 'value' }, sut.callLog.getLast());
  }

  @IsTest
  static void givenSpyConfiguredWithoutArguments_whenCalledWithoutArgument_spyIsCalled() {
    // Arrange
    MethodSpy sut = new MethodSpy('methodName');
    sut.whenCalledWith().thenReturn('test');

    // Act
    Object result = sut.call(new List<Type>(), new List<String>(), new List<Object>());

    // Assert
    Assert.areEqual('test', result);
    Assert.areEqual(new List<Object>(), sut.callLog.getLast());
  }

  @IsTest
  static void givenSpyConfiguredWithEmptyArguments_whenCalledWithoutArgument_spyIsCalled() {
    // Arrange
    MethodSpy sut = new MethodSpy('methodName');
    sut.whenCalledWith(Argument.empty()).thenReturn('test');

    // Act
    Object result = sut.call(new List<Type>(), new List<String>(), new List<Object>());

    // Assert
    Assert.areEqual('test', result);
    Assert.areEqual(new List<Object>(), sut.callLog.getLast());
  }

  @IsTest
  static void givenSpyConfiguredWith2Arguments_whenCalledWithMatchingArgument_spyIsCalled() {
    // Arrange
    MethodSpy sut = new MethodSpy('methodName');
    sut.whenCalledWith('2', 'args').thenReturn('test');

    // Act
    Object result = sut.call(new List<Type>{ Integer.class, String.class }, new List<String>{ 'count', 'name' }, new List<Object>{ '2', 'args' });

    // Assert
    Assert.areEqual('test', result);
    Assert.areEqual(new List<Object>{ '2', 'args' }, sut.callLog.getLast());
  }

  @IsTest
  static void givenSpyConfiguredWith3Arguments_whenCalledWithMatchingArgument_spyIsCalled() {
    // Arrange
    MethodSpy sut = new MethodSpy('methodName');
    sut.whenCalledWith('3', 'args', 'test').thenReturn('test');

    // Act
    Object result = sut.call(
      new List<Type>{ Integer.class, String.class, String.class },
      new List<String>{ 'count', 'name', 'othername' },
      new List<Object>{ '3', 'args', 'test' }
    );

    // Assert
    Assert.areEqual('test', result);
    Assert.areEqual(new List<Object>{ '3', 'args', 'test' }, sut.callLog.getLast());
  }

  @IsTest
  static void givenSpyConfiguredWith4Arguments_whenCalledWithMatchingArgument_spyIsCalled() {
    // Arrange
    MethodSpy sut = new MethodSpy('methodName');
    sut.whenCalledWith('test', 'with', '4', 'args').thenReturn('test');

    // Act
    Object result = sut.call(
      new List<Type>{ String.class, String.class, Integer.class, String.class },
      new List<String>{ 'param', 'otherParam', 'count', 'yetanothername' },
      new List<Object>{ 'test', 'with', '4', 'args' }
    );

    // Assert
    Assert.areEqual('test', result);
    Assert.areEqual(new List<Object>{ 'test', 'with', '4', 'args' }, sut.callLog.getLast());
  }

  @IsTest
  static void givenSpyConfiguredWith5Arguments_whenCalledWithMatchingArgument_spyIsCalled() {
    // Arrange
    MethodSpy sut = new MethodSpy('methodName');
    sut.whenCalledWith('another', 'test', 'with', '5', 'args').thenReturn('test');

    // Act
    Object result = sut.call(
      new List<Type>{ String.class, String.class, String.class, Integer.class, String.class },
      new List<String>{ 'param', 'otherParam', 'anotherParam', 'count', 'yetanothername' },
      new List<Object>{ 'another', 'test', 'with', '5', 'args' }
    );

    // Assert
    Assert.areEqual('test', result);
    Assert.areEqual(new List<Object>{ 'another', 'test', 'with', '5', 'args' }, sut.callLog.getLast());
  }

  @IsTest
  static void givenSpyConfiguredWithAMixOfObjectAndArgument_whenCalledWithAllMatching_spyIsCalled() {
    // Arrange
    MethodSpy sut = new MethodSpy('methodName');
    sut.whenCalledWith('param', new Account(Name = 'Test'), Argument.any()).thenReturn('Expected Result');

    // Act
    Object result = sut.call(
      new List<Type>{ String.class, Account.class, Boolean.class },
      new List<String>{ 'param', 'account', 'bool' },
      new List<Object>{ 'param', new Account(Name = 'Test'), true }
    );

    // Assert
    Assert.areEqual(new List<Object>{ 'param', new Account(Name = 'Test'), true }, sut.callLog.getLast());
  }

  @IsTest
  static void givenSpyConfiguredWithAMixOfObjectAndArgument_whenCalledWithPartialMatching_spyThrows() {
    // Arrange
    MethodSpy sut = new MethodSpy('methodName');
    sut.whenCalledWith('param', Argument.equals('otherParam'), Argument.jsonEquals(new Account(Name = 'Test')), Argument.any(), Argument.ofType('Integer'))
      .thenReturn('Expected Result');

    // Act
    try {
      Object result = sut.call(new List<Type>{ String.class }, new List<String>{ 'param' }, new List<Object>{ 'param' });

      // Assert
      Assert.fail('it shoud not reach this line');
    } catch (Exception ex) {
      Assert.isInstanceOfType(ex, MethodSpy.ConfigurationException.class);
      Assert.areNotEqual(
        new List<Object>{ 'param', Argument.equals('otherParam'), Argument.jsonEquals(new Account(Name = 'Test')), Argument.any(), Argument.ofType('Integer') },
        sut.callLog.getLast()
      );
      Assert.areEqual(new List<Object>{ 'param' }, sut.callLog.getLast());
    }
  }

  @IsTest
  static void givenSpyConfiguredWithAMixOfObjectAndArgument_whenCalledWithNonMatching_spyThrows() {
    // Arrange
    MethodSpy sut = new MethodSpy('methodName');
    sut.whenCalledWith('param', new Account(Name = 'Test')).thenReturn('Expected Result');

    // Act
    try {
      Object result = sut.call(new List<Type>{ Opportunity.class }, new List<String>{ 'oppy' }, new List<Object>{ new Opportunity() });

      // Assert
      Assert.fail('it shoud not reach this line');
    } catch (Exception ex) {
      Assert.isInstanceOfType(ex, MethodSpy.ConfigurationException.class);
      Assert.areNotEqual(new List<Object>{ 'param', new Account(Name = 'Test') }, sut.callLog.getLast());
      Assert.areEqual(new List<Object>{ new Opportunity() }, sut.callLog.getLast());
    }
  }

  @IsTest
  static void givenSpyConfiguredWithListOfArgument_whenCalledWithAllMatching_spyIsCalled() {
    // Arrange
    MethodSpy sut = new MethodSpy('methodName');
    sut.whenCalledWith(Argument.jsonEquals(new List<String>{ 'test' }), Argument.ofType(Account.getSObjectType()), Argument.any())
      .thenReturn('Expected Result');

    // Act
    Object result = sut.call(
      new List<Type>{ List<String>.class, Account.class, Boolean.class },
      new List<String>{ 'params', 'account', 'bool' },
      new List<Object>{ new List<String>{ 'test' }, new Account(Name = 'random'), true }
    );

    // Assert
    Assert.areEqual('Expected Result', result);
    Assert.areEqual(new List<Object>{ new List<String>{ 'test' }, new Account(Name = 'random'), true }, sut.callLog.getLast());
  }

  @IsTest
  static void givenSpyConfiguredForMultipleOverload_whenCalledWithDifferentArgumentType_itCallsTheSameSpy() {
    // Arrange
    MethodSpy sut = new MethodSpy('overLoaded');
    sut.whenCalledWith(new Account()).thenReturn('Account result');
    sut.whenCalledWith(new Opportunity()).thenReturn('Opportunity result');

    // Act
    Object firstCallResult = sut.call(new List<Type>{ Account.class }, new List<String>{ 'account' }, new List<Object>{ new Account() });

    // Assert
    Assert.areEqual('Account result', firstCallResult);
    Assert.areEqual(new List<Object>{ new Account() }, sut.callLog.getLast());
    Object secondCallResult = sut.call(new List<Type>{ Opportunity.class }, new List<String>{ 'oppy' }, new List<Object>{ new Opportunity() });
    Assert.areEqual(new List<Object>{ new Account() }, sut.callLog.get(0));
    Assert.areEqual(new List<Object>{ new Opportunity() }, sut.callLog.getLast());
    Assert.areEqual('Opportunity result', secondCallResult);
  }

  static void givenSpy_whenCalledWithDifferentArgumentType_itCallsTheSameSpy() {
    // Arrange
    MethodSpy sut = new MethodSpy('methodName');
    sut.returns('String result');

    // Act
    Object result = sut.call(new List<Type>{ Account.class }, new List<String>{ 'account' }, new List<Object>{ new Account() });

    // Assert
    Assert.areEqual('String result', result);
    result = sut.call(new List<Type>{ Opportunity.class }, new List<String>{ 'oppy' }, new List<Object>{ new Opportunity() });
    Assert.areEqual('String result', result);
  }

  @IsTest
  static void givenSpyConfiguredOnceToReturnSomething_whenCallingTheSpy_itReturnsTheConfiguredValue() {
    // Arrange
    MethodSpy sut = new MethodSpy('methodName');
    sut.returns('String result');

    // Act
    Object result = sut.call(new List<Type>{}, new List<String>{}, new List<Object>{});

    // Assert
    Assert.areEqual('String result', result);
  }

  @IsTest
  static void givenSpyConfiguredMultipleTimesToReturnSomething_whenCallingTheSpy_itReturnsTheConfiguredValue() {
    // Arrange
    MethodSpy sut = new MethodSpy('methodName');
    sut.returns('First Configuration');
    sut.returns('Second Configuration');
    sut.returns('Last Configuration');

    // Act
    Object result = sut.call(new List<Type>{}, new List<String>{}, new List<Object>{});

    // Assert
    Assert.areEqual('Last Configuration', result);
  }

  @IsTest
  static void givenSpyConfiguredToThrowException_whenCallingTheSpy_itThrowsTheException() {
    // Arrange
    MethodSpy sut = new MethodSpy('methodName');
    sut.throwsException(new IllegalArgumentException('test exception'));

    try {
      // Act
      sut.call(new List<Type>{}, new List<String>{}, new List<Object>{});
      Assert.fail('it shoud not reach this line');
    } catch (Exception e) {
      // Assert
      Assert.areEqual('test exception', e.getMessage());
    }
  }

  @IsTest
  static void givenSpyConfiguredToThrowExceptionMultipleTimes_whenCallingTheSpy_itThrowsTheLastConfiguredException() {
    // Arrange
    MethodSpy sut = new MethodSpy('methodName');
    Exception exception1 = new IllegalArgumentException('test exception 1');
    Exception exception2 = new IllegalArgumentException('test exception 2');
    Exception exception3 = new IllegalArgumentException('test exception 3');
    sut.throwsException(exception1);
    sut.throwsException(exception2);
    sut.throwsException(exception3);

    try {
      // Act
      sut.call(new List<Type>{}, new List<String>{}, new List<Object>{});
      Assert.fail('it shoud not reach this line');
    } catch (Exception e) {
      // Assert
      Assert.areEqual(exception3.getMessage(), e.getMessage());
    }
  }

  @IsTest
  static void givenSpyConfiguredToThenThrowException_whenCallingTheSpyWithMatchingArguments_itThrowsTheException() {
    // Arrange
    MethodSpy sut = new MethodSpy('methodName');
    sut.whenCalledWith('Expected Param').thenThrow(new IllegalArgumentException('test exception'));

    try {
      // Act
      sut.call(new List<Type>{ String.class }, new List<String>{ 'param' }, new List<Object>{ 'Expected Param' });
      Assert.fail('it shoud not reach this line');
    } catch (Exception e) {
      // Assert
      Assert.areEqual('test exception', e.getMessage());
    }
  }

  @IsTest
  static void givenSpyConfiguredOnceToReturnOnMatchingSingleParam_whenCallingTheSpy_itReturnsTheConfiguredValue() {
    // Arrange
    MethodSpy sut = new MethodSpy('methodName');
    sut.whenCalledWith('Expected Param').thenReturn('Expected Result');

    // Act
    Object result = sut.call(new List<Type>{ String.class }, new List<String>{ 'param' }, new List<Object>{ 'Expected Param' });

    // Assert
    Assert.areEqual('Expected Result', result);
  }

  @IsTest
  static void givenSpyConfiguredMultipleTimesToReturnOnMatchingSingleParam_whenCallingTheSpy_itReturnsTheConfiguredValue() {
    // Arrange
    MethodSpy sut = new MethodSpy('methodName');
    sut.whenCalledWith('Expected Param 1').thenReturn('Expected Result 1');
    sut.whenCalledWith('Expected Param 2').thenReturn('Expected Result 2');

    // Act
    Object result1 = sut.call(new List<Type>{ String.class }, new List<String>{ 'param' }, new List<Object>{ 'Expected Param 1' });
    Object result2 = sut.call(new List<Type>{ String.class }, new List<String>{ 'param' }, new List<Object>{ 'Expected Param 2' });

    // Assert
    Assert.areEqual('Expected Result 1', result1);
    Assert.areEqual('Expected Result 2', result2);
  }

  @IsTest
  static void givenSpyConfiguredOnceToReturnOnMatchingArguments_whenCallingTheSpy_itReturnsTheConfiguredValue() {
    // Arrange
    MethodSpy sut = new MethodSpy('methodName');
    sut.whenCalledWith('Expected First Param', true).thenReturn('Expected Result');

    // Act
    Object result = sut.call(
      new List<Type>{ String.class, Boolean.class },
      new List<String>{ 'param', 'bool' },
      new List<Object>{ 'Expected First Param', true }
    );

    // Assert
    Assert.areEqual('Expected Result', result);
  }

  @IsTest
  static void givenSpyConfiguredOnceToReturnOnMatchingTypeMatchableAndBooleanTrue_whenCallingTheSpyWithRightType_itReturnsTheConfiguredValue() {
    // Arrange
    MethodSpy sut = new MethodSpy('methodName');
    sut.whenCalledWith(Argument.ofType(Account.getSObjectType()), true).thenReturn('Expected Result');

    // Act
    Object result = sut.call(new List<Type>{ Account.class, Boolean.class }, new List<String>{ 'account', 'bool' }, new List<Object>{ new Account(), true });

    // Assert
    Assert.areEqual('Expected Result', result);
  }

  @IsTest
  static void givenSpyConfiguredOnceToReturnOnMatchingTypeMatchable_whenCallingTheSpyWithWWrong_itShouldThrowMethodSpyConfigurationException() {
    // Arrange
    MethodSpy sut = new MethodSpy('methodName');
    sut.whenCalledWith(Argument.ofType(Account.getSObjectType())).thenReturn('Expected Result');

    // Act
    try {
      Object result = sut.call(
        new List<Type>{ Opportunity.class, Boolean.class },
        new List<String>{ 'oppy', 'bool' },
        new List<Object>{ new Opportunity(), true }
      );
      // Assert
      Assert.fail('it shoud not reach this line');
    } catch (Exception ex) {
      Assert.isInstanceOfType(ex, MethodSpy.ConfigurationException.class, 'Exception should be MethodSpy.ConfigurationException');
    }
  }

  @IsTest
  static void givenSpyConfiguredMultipleTimesToReturnOnMatchingArguments_whenCallingTheSpy_itReturnsTheConfiguredValue() {
    // Arrange
    MethodSpy sut = new MethodSpy('methodName');
    sut.whenCalledWith('Expected First Param 1', true).thenReturn('Expected Result 1');
    sut.whenCalledWith('Expected First Param 2', false).thenReturn('Expected Result 2');

    // Act
    Object result1 = sut.call(
      new List<Type>{ String.class, Boolean.class },
      new List<String>{ 'param', 'bool' },
      new List<Object>{ 'Expected First Param 1', true }
    );
    Object result2 = sut.call(
      new List<Type>{ String.class, Boolean.class },
      new List<String>{ 'param', 'bool' },
      new List<Object>{ 'Expected First Param 2', false }
    );

    // Assert
    Assert.areEqual('Expected Result 1', result1);
    Assert.areEqual('Expected Result 2', result2);
  }

  @IsTest
  static void givenSpyOnMethodWithoutParameterReturningVoid_whenCallingTheSpy_itReturnsNull() {
    // Arrange
    MethodSpy sut = new MethodSpy('methodName');

    // Act
    object actual = sut.call(new List<Type>{}, new List<String>{}, new List<Object>{});

    // Assert
    Assert.areEqual(null, actual);
  }

  @IsTest
  static void givenSpyConfiguredToReturnOnMatchingArgumentsAndThenToReturns_whenCallingTheSpyWithArguments_itReturnExpectedValueAndFallbackToDefault() {
    // Arrange
    MethodSpy sut = new MethodSpy('methodName');
    sut.whenCalledWith('Expected First Param', true).thenReturn('Expected Result');
    sut.returns('Default Result');

    // Act
    Object result1 = sut.call(
      new List<Type>{ String.class, Boolean.class },
      new List<String>{ 'param', 'bool' },
      new List<Object>{ 'Expected First Param', true }
    );
    Object result2 = sut.call(new List<Type>{ String.class, Boolean.class }, new List<String>{ 'param', 'bool' }, new List<Object>{ 'Another Param', false });

    // Assert
    Assert.areEqual('Expected Result', result1);
    Assert.areEqual('Default Result', result2);
  }

  @IsTest
  static void givenSpyConfiguredToReturnsAndThenToReturnOnMatchingArguments_whenCallingTheSpyWithArguments_itReturnExpectedValueAndFallbackToDefault() {
    // Arrange
    MethodSpy sut = new MethodSpy('methodName');
    sut.returns('Default Result');
    sut.whenCalledWith('Expected First Param', true).thenReturn('Expected Result');

    // Act
    Object result1 = sut.call(
      new List<Type>{ String.class, Boolean.class },
      new List<String>{ 'param', 'bool' },
      new List<Object>{ 'Expected First Param', true }
    );
    Object result2 = sut.call(new List<Type>{ String.class, Boolean.class }, new List<String>{ 'param', 'bool' }, new List<Object>{ 'Another Param', false });

    // Assert
    Assert.areEqual('Expected Result', result1);
    Assert.areEqual('Default Result', result2);
  }

  @IsTest
  static void givenSpyConfiguredWithCustomApex_whenCalledWith_returnsConfiguredValue() {
    // Arrange
    CustomApex param = new CustomApex('test');
    MethodSpy sut = new MethodSpy('methodName');
    sut.whenCalledWith(param).thenReturn(new Account());

    // Act
    Object actual = sut.call(new List<Type>{ CustomApex.class }, new List<String>{ 'customType' }, new List<Object>{ param });

    // Assert
    Object expected = new Account();
    Assert.areEqual(expected, actual, 'custom apex identical list should match');
  }

  @IsTest
  static void givenSpyConfiguredWithListOf2_whenCalledWithSomethingElses_throwsConfigurationException() {
    // Arrange
    List<Object> objects = new List<Object>{ new Account(), new Account() };
    MethodSpy sut = new MethodSpy('methodName');
    sut.whenCalledWith(new Account(), new Account()).thenReturn(true);

    // Act
    try {
      Object actual = sut.call(new List<Type>{ Account.class }, new List<String>{ 'account' }, new List<Object>{ new Account() });

      // Assert
      Assert.fail('Expected exception was not thrown');
    } catch (MethodSpy.ConfigurationException cex) {
      Assert.isNotNull(cex, 'exception should be thrown');
    }
  }

  @IsTest
  static void givenSpyConfiguredWithCustomApexWithEquals_whenCalledWith_returnsConfiguredValue() {
    // Arrange
    CustomApexWithEquals param = new CustomApexWithEquals('test');
    MethodSpy sut = new MethodSpy('methodName');
    sut.whenCalledWith(param).thenReturn(new Account());

    // Act
    Object actual = sut.call(new List<Type>{ CustomApexWithEquals.class }, new List<String>{ 'customType' }, new List<Object>{ param });

    // Assert
    Object expected = new Account();
    Assert.areEqual(expected, actual, 'custom apex with equals identical list should match');
  }

  @IsTest
  static void givenSpyCalledWithNotSerializableCustomApex_hasBeenCalledWithReturnsTrue() {
    // Arrange
    NotSerializableCustomApex param = new NotSerializableCustomApex();
    MethodSpy sut = new MethodSpy('methodName');
    sut.whenCalledWith(param).thenReturn(new Account());

    // Act
    Object actual = sut.call(new List<Type>{ NotSerializableCustomApex.class }, new List<String>{ 'customType' }, new List<Object>{ param });

    // Assert
    Object expected = new Account();
    Assert.areEqual(expected, actual, 'Not serializable custom apex identical list should match');
  }

  @IsTest
  static void e2e_returns_then_whenCalledWith() {
    // Arrange
    MethodSpy sut = new MethodSpy('methodName');
    sut.returns('result default');
    sut.whenCalledWith(1).thenReturn('result 1');
    sut.whenCalledWith(2).thenReturn('result 2');

    // Act & Assert
    Object result1 = sut.call(new List<Type>{ Integer.class }, new List<String>{ 'count' }, new List<Object>{ 1 });
    Assert.areEqual('result 1', result1);

    // Act & Assert
    Object result2 = sut.call(new List<Type>{ Integer.class }, new List<String>{ 'count' }, new List<Object>{ 2 });
    Assert.areEqual('result 2', result2);

    // Act & Assert
    Object resultDefault = sut.call(new List<Type>{ Integer.class }, new List<String>{ 'count' }, new List<Object>{ 3 });
    Assert.areEqual('result default', resultDefault);
  }

  @IsTest
  static void e2e_returns_then_throwsException() {
    // Arrange
    MethodSpy sut = new MethodSpy('methodName');
    sut.returns('result');
    sut.throwsException(new IllegalArgumentException('test exception'));

    // Act & Assert
    try {
      sut.call(new List<Type>{ Integer.class }, new List<String>{ 'count' }, new List<Object>{ 1 });
      Assert.fail('Expected exception was not thrown');
    } catch (Exception e) {
      Assert.areEqual('test exception', e.getMessage());
    }
  }

  @IsTest
  static void e2e_throwsException_then_returns() {
    // Arrange
    MethodSpy sut = new MethodSpy('methodName');
    sut.throwsException(new IllegalArgumentException('test exception'));
    sut.returns('result');

    // Act
    Object result = sut.call(new List<Type>{ Integer.class }, new List<String>{ 'count' }, new List<Object>{ 1 });

    // Assert
    Assert.areEqual('result', result);
  }

  @IsTest
  static void e2e_whenCalledWith_then_returns() {
    // Arrange
    MethodSpy sut = new MethodSpy('methodName');
    sut.whenCalledWith(1).thenReturn('result 1');
    sut.whenCalledWith(2).thenReturn('result 2');
    sut.returns('result default');

    // Act & Assert
    Object result1 = sut.call(new List<Type>{ Integer.class }, new List<String>{ 'count' }, new List<Object>{ 1 });
    Assert.areEqual('result 1', result1);

    // Act & Assert
    Object result2 = sut.call(new List<Type>{ Integer.class }, new List<String>{ 'count' }, new List<Object>{ 2 });
    Assert.areEqual('result 2', result2);

    // Act & Assert
    Object resultDefault = sut.call(new List<Type>{ Integer.class }, new List<String>{ 'count' }, new List<Object>{ 3 });
    Assert.areEqual('result default', resultDefault);
  }

  @IsTest
  static void e2e_throwsException_then_whenCalledWith() {
    // Arrange
    MethodSpy sut = new MethodSpy('methodName');
    sut.throwsException(new IllegalArgumentException('test exception'));
    sut.whenCalledWith(1).thenReturn('result 1');
    sut.whenCalledWith(2).thenReturn('result 2');

    // Act & Assert
    Object result1 = sut.call(new List<Type>{ Integer.class }, new List<String>{ 'count' }, new List<Object>{ 1 });
    Assert.areEqual('result 1', result1);

    // Act & Assert
    Object result2 = sut.call(new List<Type>{ Integer.class }, new List<String>{ 'count' }, new List<Object>{ 2 });
    Assert.areEqual('result 2', result2);

    // Act & Assert
    try {
      sut.call(new List<Type>{ Integer.class }, new List<String>{ 'count' }, new List<Object>{ 3 });
      Assert.fail('Expected exception was not thrown');
    } catch (Exception e) {
      Assert.areEqual('test exception', e.getMessage());
    }
  }

  @IsTest
  static void e2e_whenCalledWith_then_throwsException() {
    // Arrange
    MethodSpy sut = new MethodSpy('methodName');
    sut.whenCalledWith(1).thenReturn('result 1');
    sut.whenCalledWith(2).thenReturn('result 2');
    sut.throwsException(new IllegalArgumentException('test exception'));

    // Act & Assert
    Object result1 = sut.call(new List<Type>{ Integer.class }, new List<String>{ 'count' }, new List<Object>{ 1 });
    Assert.areEqual('result 1', result1);

    // Act & Assert
    Object result2 = sut.call(new List<Type>{ Integer.class }, new List<String>{ 'count' }, new List<Object>{ 2 });
    Assert.areEqual('result 2', result2);

    // Act & Assert
    try {
      sut.call(new List<Type>{ Integer.class }, new List<String>{ 'count' }, new List<Object>{ 3 });
      Assert.fail('Expected exception was not thrown');
    } catch (Exception e) {
      Assert.areEqual('test exception', e.getMessage());
    }
  }

  class CustomApex {
    private String attribute;

    public CustomApex(String attribute) {
      this.attribute = attribute;
    }
  }

  class CustomApexWithEquals {
    private String attribute;

    public CustomApexWithEquals(String attribute) {
      this.attribute = attribute;
    }

    public Boolean equals(Object o) {
      if ((o == null) || !(o instanceof CustomApexWithEquals)) {
        return false;
      }
      CustomApexWithEquals subject = (CustomApexWithEquals) o;
      return this.attribute == subject.attribute;
    }

    public Integer hashCode() {
      return this.attribute != null ? this.attribute.hashCode() : -1;
    }
  }

  class NotSerializableCustomApex {
    private Http notSerializableAttribute;

    public NotSerializableCustomApex() {
      this.notSerializableAttribute = new Http();
    }
  }
}
