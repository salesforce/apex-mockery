/*
 * Copyright (c) 2022, salesforce.com, inc.
 * All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * For full license text, see the LICENSE file in the repo root or https://opensource.org/licenses/BSD-3-Clause
 */
@IsTest
private class MethodSpyTest {
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
    final Exception expectedException = new IllegalArgumentException(
      'test exception'
    );
    sut.throwsException(expectedException);

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
    final Exception expectedException = new IllegalArgumentException(
      'test exception'
    );
    sut.whenCalledWith('Expected Param').thenThrow(expectedException);

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
    sut.whenCalledWith('Expected Param').thenReturn('Expected Result');

    // Act
    final Object result = sut.call(new List<Object>{ 'Expected Param' });

    // Assert
    System.assertEquals('Expected Result', result);
  }

  @IsTest
  static void givenSpyConfiguredMultipleTimesToReturnOnMatchingSingleParam_whenCallingTheSpy_itReturnsTheConfiguredValue() {
    // Arrange
    final MethodSpy sut = new MethodSpy('methodName');
    sut.whenCalledWith('Expected Param 1').thenReturn('Expected Result 1');
    sut.whenCalledWith('Expected Param 2').thenReturn('Expected Result 2');

    // Act
    Object result1 = sut.call(new List<Object>{ 'Expected Param 1' });
    Object result2 = sut.call(new List<Object>{ 'Expected Param 2' });

    // Assert
    System.assertEquals('Expected Result 1', result1);
    System.assertEquals('Expected Result 2', result2);
  }

  @IsTest
  static void givenSpyConfiguredOnceToReturnOnMatchingParams_whenCallingTheSpy_itReturnsTheConfiguredValue() {
    // Arrange
    final MethodSpy sut = new MethodSpy('methodName');
    sut.whenCalledWithParams(new List<Object>{ 'Expected First Param', true })
      .thenReturn('Expected Result');

    // Act
    final Object result = sut.call(
      new List<Object>{ 'Expected First Param', true }
    );

    // Assert
    System.assertEquals('Expected Result', result);
  }

  @IsTest
  static void givenSpyConfiguredMultipleTimesToReturnOnMatchingParams_whenCallingTheSpy_itReturnsTheConfiguredValue() {
    // Arrange
    final MethodSpy sut = new MethodSpy('methodName');
    sut.whenCalledWithParams(new List<Object>{ 'Expected First Param 1', true })
      .thenReturn('Expected Result 1');
    sut.whenCalledWithParams(
        new List<Object>{ 'Expected First Param 2', false }
      )
      .thenReturn('Expected Result 2');

    // Act
    Object result1 = sut.call(
      new List<Object>{ 'Expected First Param 1', true }
    );
    Object result2 = sut.call(
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
    object actual = sut.call(new List<Object>{});

    // Assert
    System.assertEquals(null, actual);
  }

  @IsTest
  static void givenSpyConfiguredOnceToReturnOnMatchingParams_whenCallingTheSpyWithOtherParams_itThrowsIllegalArgumentException() {
    // Arrange
    final MethodSpy sut = new MethodSpy('methodName');
    sut.whenCalledWithParams(new List<Object>{ 'Expected First Param', true })
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
    sut.whenCalledWithParams(new List<Object>{ 'Expected First Param', true })
      .thenReturn('Expected Result');
    sut.returns('Default Result');

    // Act
    Object result1 = sut.call(new List<Object>{ 'Expected First Param', true });
    Object result2 = sut.call(new List<Object>{ 'Another Param', false });

    // Assert
    System.assertEquals('Expected Result', result1);
    System.assertEquals('Default Result', result2);
  }

  @IsTest
  static void givenSpyConfiguredToReturnsAndThenToReturnOnMatchingParams_whenCallingTheSpyWithParams_itReturnExpectedValueAndFallbackToDefault() {
    // Arrange
    final MethodSpy sut = new MethodSpy('methodName');
    sut.returns('Default Result');
    sut.whenCalledWithParams(new List<Object>{ 'Expected First Param', true })
      .thenReturn('Expected Result');

    // Act
    Object result1 = sut.call(new List<Object>{ 'Expected First Param', true });
    Object result2 = sut.call(new List<Object>{ 'Another Param', false });

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
    List<Object> first = new List<Object>{ new Opportunity() };
    List<Object> last = new List<Object>{ new Account() };
    final MethodSpy sut = new MethodSpy('methodName');
    sut.call(first);
    sut.call(last);

    // Act && Assert
    System.assert(!sut.hasBeenLastCalledWith(first));
    System.assert(sut.hasBeenLastCalledWith(last));
  }

  @IsTest
  static void givenSpyCalledMultipleTimes_hasBeenCalledWith_returnsTrueForCalledParamsElseFalse() {
    // Arrange
    List<Object> first = new List<Object>{ new Opportunity() };
    List<Object> last = new List<Object>{ new Account() };
    final MethodSpy sut = new MethodSpy('methodName');
    sut.call(first);
    sut.call(last);

    // Act && Assert
    System.assert(sut.hasBeenCalledWith(first));
    System.assert(sut.hasBeenCalledWith(last));
    System.assert(!sut.hasBeenCalledWith(new List<Object>{ new Case() }));
  }

  @IsTest
  static void givenSpyCalledLastWithParams_hasBeenLastCalledWithMatcher_returnsMatches() {
    // Arrange
    List<Object> param = new List<Object>();
    final MethodSpy sut = new MethodSpy('methodName');
    ParametersMatcherStub stub = new ParametersMatcherStub();
    stub.expected = param;

    // Act & Assert
    System.assert(!sut.hasBeenLastCalledWith(stub));
    sut.call(param);
    System.assert(sut.hasBeenLastCalledWith(stub));
  }

  @IsTest
  static void givenSpyCalledLastWithParams_hasBeenCalledWithMatcher_returnsMatches() {
    // Arrange
    List<Object> param = new List<Object>();
    final MethodSpy sut = new MethodSpy('methodName');
    ParametersMatcherStub stub = new ParametersMatcherStub();
    stub.expected = param;

    // Act & Assert
    System.assert(!sut.hasBeenCalledWith(stub));
    sut.call(param);
    System.assert(sut.hasBeenCalledWith(stub));
  }

  @IsTest
  static void givenSpyCalledWithCustomApex_hasBeenCalledWithReturnsTrue() {
    // Arrange
    final CustomApex param = new CustomApex('test');
    final MethodSpy sut = new MethodSpy('methodName');
    final Object expected = new Account();
    sut.whenCalledWith(param).thenReturn(expected);

    // Act
    final Object actual = sut.call(new List<Object>{ param });

    // Assert
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
    sut.whenCalledWithParams(objects).thenReturn(true);

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
    final Object expected = new Account();
    sut.whenCalledWith(param).thenReturn(expected);

    // Act
    final Object actual = sut.call(new List<Object>{ param });

    // Assert
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
    final Object expected = new Account();
    sut.whenCalledWith(param).thenReturn(expected);

    // Act
    final Object actual = sut.call(new List<Object>{ param });

    // Assert
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
    sut.whenCalledWith(1).thenReturn('result 1');
    sut.whenCalledWith(2).thenReturn('result 2');

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
    final Exception expectedException = new IllegalArgumentException(
      'test exception'
    );
    sut.throwsException(expectedException);

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
    final Exception expectedException = new IllegalArgumentException(
      'test exception'
    );
    sut.throwsException(expectedException);
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
    sut.whenCalledWith(1).thenReturn('result 1');
    sut.whenCalledWith(2).thenReturn('result 2');
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
    final Exception expectedException = new IllegalArgumentException(
      'test exception'
    );
    sut.throwsException(expectedException);
    sut.whenCalledWith(1).thenReturn('result 1');
    sut.whenCalledWith(2).thenReturn('result 2');

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
    sut.whenCalledWith(1).thenReturn('result 1');
    sut.whenCalledWith(2).thenReturn('result 2');
    final Exception expectedException = new IllegalArgumentException(
      'test exception'
    );
    sut.throwsException(expectedException);

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

  class ParametersMatcherStub implements ParametersMatcher {
    public List<Object> expected;

    public boolean matches(List<Object> params) {
      return this.expected == params;
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

  /* ************** 
    MethodSpy
    Not Implemented Yet 

    .returns("toto");
    .whenCalledWith(1).thenThrows(E1);
    .whenCalledWith(2).thenThrows(E2);
    .call(1) -> throws E1
    .call(2) -> throws E2
    .call(3) -> "toto"
  */
}
