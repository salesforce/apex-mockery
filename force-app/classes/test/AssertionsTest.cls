/*
 * Copyright (c) 2022, salesforce.com, inc.
 * All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * For full license text, see the LICENSE file in the repo root or https://opensource.org/licenses/BSD-3-Clause
 */
@IsTest
private class AssertionsTest {
  // As System.Assert* methods throws are not catchable
  // Test are white box (implementation test instead of behavioural test)
  // We implemented a FakeAsserter class for the occasion

  @isTest
  static void givenMethodSpyInstance_assertThatReturnsMethodSpyAssertInstance() {
    // Arrange
    final MethodSpy spy = new MethodSpy('method');

    // Act
    final Assertions.MethodSpyAssertions result = Assertions.assertThat(spy);

    // Assert
    System.assertNotEquals(null, result);
  }

  @isTest
  static void hasNotBeenCalled_callsAssertEquals() {
    // Arrange
    final MethodSpy spy = new MethodSpy('method');
    final FakeAsserter fakeAsserter = new FakeAsserter();
    final Assertions.MethodSpyAssertions sut = Assertions.assertThat(
      spy,
      fakeAsserter
    );

    // Act
    sut.hasNotBeenCalled();

    // Assert
    System.assertEquals(1, fakeAsserter.assertEqualsCallCount);
    System.assertEquals(false, fakeAsserter.assertEqualsLastExpected);
    System.assertEquals(false, fakeAsserter.assertEqualsLastActual);
    System.assertEquals(
      'Method method was called',
      fakeAsserter.assertEqualsLastMessage
    );
  }

  @isTest
  static void hasBeenCalled_callsAssertEquals() {
    // Arrange
    final MethodSpy spy = new MethodSpy('method');
    final FakeAsserter fakeAsserter = new FakeAsserter();
    final Assertions.MethodSpyAssertions sut = Assertions.assertThat(
      spy,
      fakeAsserter
    );

    // Act
    sut.hasBeenCalled();

    // Assert
    System.assertEquals(1, fakeAsserter.assertEqualsCallCount);
    System.assertEquals(true, fakeAsserter.assertEqualsLastExpected);
    System.assertEquals(false, fakeAsserter.assertEqualsLastActual);
    System.assertEquals(
      'Method method was not called',
      fakeAsserter.assertEqualsLastMessage
    );
  }

  @isTest
  static void givenObject_hasBeenCalledWith_callsAssertEquals() {
    // Arrange
    final MethodSpy spy = new MethodSpy('method');
    final FakeAsserter fakeAsserter = new FakeAsserter();
    final Assertions.MethodSpyAssertions sut = Assertions.assertThat(
      spy,
      fakeAsserter
    );

    // Act
    sut.hasBeenCalledWith(Params.of(new Account()));

    // Assert
    System.assertEquals(2, fakeAsserter.assertEqualsCallCount);
    System.assertEquals(true, fakeAsserter.assertEqualsLastExpected);
    System.assertEquals(false, fakeAsserter.assertEqualsLastActual);
    System.assertEquals(
      'Method method was not called with [(Account:{})]',
      fakeAsserter.assertEqualsLastMessage
    );
  }

  @isTest
  static void givenObjectList_hasBeenCalledWithParams_callsAssertEquals() {
    // Arrange
    final MethodSpy spy = new MethodSpy('method');
    final FakeAsserter fakeAsserter = new FakeAsserter();
    final Assertions.MethodSpyAssertions sut = Assertions.assertThat(
      spy,
      fakeAsserter
    );

    // Act
    sut.hasBeenCalledWith(
      Params.ofList(new List<Object>{ new Account(), new Opportunity() })
    );

    // Assert
    System.assertEquals(2, fakeAsserter.assertEqualsCallCount);
    System.assertEquals(true, fakeAsserter.assertEqualsLastExpected);
    System.assertEquals(false, fakeAsserter.assertEqualsLastActual);
    System.assertEquals(
      'Method method was not called with [(Account:{}, Opportunity:{})]',
      fakeAsserter.assertEqualsLastMessage
    );
  }

  @isTest
  static void givenMixList_hasBeenCalledWithParams_callsAssertEquals() {
    // Arrange
    final MethodSpy spy = new MethodSpy('method');
    final FakeAsserter fakeAsserter = new FakeAsserter();
    final Assertions.MethodSpyAssertions sut = Assertions.assertThat(
      spy,
      fakeAsserter
    );

    // Act
    sut.hasBeenCalledWith(Params.of(new Account(), Matcher.equals('test')));

    // Assert
    System.assertEquals(2, fakeAsserter.assertEqualsCallCount);
    System.assertEquals(true, fakeAsserter.assertEqualsLastExpected);
    System.assertEquals(false, fakeAsserter.assertEqualsLastActual);
    System.assertEquals(
      'Method method was not called with [(Account:{}, test)]',
      fakeAsserter.assertEqualsLastMessage
    );
  }

  @isTest
  static void givenEmptyList_hasBeenCalledWithParams_callsAssertEquals() {
    // Arrange
    final MethodSpy spy = new MethodSpy('method');
    final FakeAsserter fakeAsserter = new FakeAsserter();
    final Assertions.MethodSpyAssertions sut = Assertions.assertThat(
      spy,
      fakeAsserter
    );

    // Act
    sut.hasBeenCalledWith(Params.empty());

    // Assert
    System.assertEquals(2, fakeAsserter.assertEqualsCallCount);
    System.assertEquals(true, fakeAsserter.assertEqualsLastExpected);
    System.assertEquals(false, fakeAsserter.assertEqualsLastActual);
    System.assertEquals(
      'Method method was not called with [()]',
      fakeAsserter.assertEqualsLastMessage
    );
  }

  @isTest
  static void givenArgumentMatchers_hasBeenCalledWithParams_callsAssertEquals() {
    // Arrange
    final MethodSpy spy = new MethodSpy('method');
    spy.returns('anything');
    final FakeAsserter fakeAsserter = new FakeAsserter();
    final Assertions.MethodSpyAssertions sut = Assertions.assertThat(
      spy,
      fakeAsserter
    );
    spy.call(new List<Object>{ 'param' });

    // Act
    sut.hasBeenCalledWith(Params.of(Matcher.equals('param')));

    // Assert
    System.assertEquals(2, fakeAsserter.assertEqualsCallCount);
    System.assertEquals(true, fakeAsserter.assertEqualsLastExpected);
    System.assertEquals(true, fakeAsserter.assertEqualsLastActual);
  }

  @isTest
  static void givenNullArgumentMatchers_hasBeenCalledWithEmptyParams_callsAssertEquals() {
    // Arrange
    final MethodSpy spy = new MethodSpy('method');
    final FakeAsserter fakeAsserter = new FakeAsserter();
    final Assertions.MethodSpyAssertions sut = Assertions.assertThat(
      spy,
      fakeAsserter
    );
    ArgumentMatcher expected = null;
    spy.call(new List<Object>());

    // Act
    sut.hasBeenCalledWith(Params.of((Object) null));

    System.assertEquals(true, fakeAsserter.assertEqualsLastExpected);
    System.assertEquals(false, fakeAsserter.assertEqualsLastActual);
  }

  @isTest
  static void givenNull_hasBeenLastCalledWith_callsAssertEquals() {
    // Arrange
    final MethodSpy spy = new MethodSpy('method');
    final FakeAsserter fakeAsserter = new FakeAsserter();
    final Assertions.MethodSpyAssertions sut = Assertions.assertThat(
      spy,
      fakeAsserter
    );

    // Act
    sut.hasBeenLastCalledWith(null);

    // Assert
    System.assertEquals(2, fakeAsserter.assertEqualsCallCount);
    System.assertEquals(true, fakeAsserter.assertEqualsLastExpected);
    System.assertEquals(false, fakeAsserter.assertEqualsLastActual);
    System.assertEquals(
      'Method method was not last called with null',
      fakeAsserter.assertEqualsLastMessage
    );
  }

  @isTest
  static void givenObjectList_hasBeenLastCalledWithParams_callsAssertEquals() {
    // Arrange
    final MethodSpy spy = new MethodSpy('method');
    final FakeAsserter fakeAsserter = new FakeAsserter();
    final Assertions.MethodSpyAssertions sut = Assertions.assertThat(
      spy,
      fakeAsserter
    );

    // Act
    sut.hasBeenLastCalledWith(Params.of(new Account()));

    // Assert
    System.assertEquals(2, fakeAsserter.assertEqualsCallCount);
    System.assertEquals(true, fakeAsserter.assertEqualsLastExpected);
    System.assertEquals(false, fakeAsserter.assertEqualsLastActual);
    System.assertEquals(
      'Method method was not last called with [(Account:{})]',
      fakeAsserter.assertEqualsLastMessage
    );
  }

  @isTest
  static void givenMixList_hasBeenLastCalledWithParams_callsAssertEquals() {
    // Arrange
    final MethodSpy spy = new MethodSpy('method');
    final FakeAsserter fakeAsserter = new FakeAsserter();
    final Assertions.MethodSpyAssertions sut = Assertions.assertThat(
      spy,
      fakeAsserter
    );

    // Act
    sut.hasBeenLastCalledWith(Params.of(new Account(), Matcher.equals('test')));

    // Assert
    System.assertEquals(2, fakeAsserter.assertEqualsCallCount);
    System.assertEquals(true, fakeAsserter.assertEqualsLastExpected);
    System.assertEquals(false, fakeAsserter.assertEqualsLastActual);
    System.assertEquals(
      'Method method was not last called with [(Account:{}, test)]',
      fakeAsserter.assertEqualsLastMessage
    );
  }

  @isTest
  static void givenNullList_hasBeenLastCalledWithParams_callsAssertEquals() {
    // Arrange
    final MethodSpy spy = new MethodSpy('method');
    final FakeAsserter fakeAsserter = new FakeAsserter();
    final Assertions.MethodSpyAssertions sut = Assertions.assertThat(
      spy,
      fakeAsserter
    );

    // Act
    sut.hasBeenLastCalledWith(Params.of((Object) null));

    // Assert
    System.assertEquals(2, fakeAsserter.assertEqualsCallCount);
    System.assertEquals(true, fakeAsserter.assertEqualsLastExpected);
    System.assertEquals(false, fakeAsserter.assertEqualsLastActual);
    System.assertEquals(
      'Method method was not last called with [(null)]',
      fakeAsserter.assertEqualsLastMessage
    );
  }

  @isTest
  static void givenArgumentMatchers_hasBeenLastCalledWithParams_callsAssertEquals() {
    // Arrange
    final MethodSpy spy = new MethodSpy('method');
    spy.returns('anything');
    final FakeAsserter fakeAsserter = new FakeAsserter();
    final Assertions.MethodSpyAssertions sut = Assertions.assertThat(
      spy,
      fakeAsserter
    );
    spy.call(new List<Object>{ 'param' });

    // Act
    sut.hasBeenLastCalledWith(Params.of(Matcher.equals('param')));

    // Assert
    System.assertEquals(2, fakeAsserter.assertEqualsCallCount);
    System.assertEquals(true, fakeAsserter.assertEqualsLastExpected);
    System.assertEquals(true, fakeAsserter.assertEqualsLastActual);
  }

  @isTest
  static void givenNullArgumentMatchers_hasBeenLastCalledWithParams_callsAssertEquals() {
    // Arrange
    final MethodSpy spy = new MethodSpy('method');
    final FakeAsserter fakeAsserter = new FakeAsserter();
    final Assertions.MethodSpyAssertions sut = Assertions.assertThat(
      spy,
      fakeAsserter
    );
    spy.call(null);

    // Act
    try {
      sut.hasBeenLastCalledWith(Params.of((Object) null));

      // Assert
      System.assert(false); // Should not reach this point
    } catch (Exception ex) {
      System.assertEquals(true, fakeAsserter.assertEqualsLastExpected);
      System.assertEquals(true, fakeAsserter.assertEqualsLastActual);
      System.assert(ex instanceof NullPointerException);
    }
  }

  @isTest
  static void givenCall_hasBeenCalledTimes_returnsCalledTimes() {
    // Arrange
    final MethodSpy spy = new MethodSpy('method');
    final FakeAsserter fakeAsserter = new FakeAsserter();
    final Assertions.MethodSpyAssertions sut = Assertions.assertThat(
      spy,
      fakeAsserter
    );
    spy.call(null);

    // Act & Assert
    sut.hasBeenCalledTimes(1);
    System.assertEquals(true, fakeAsserter.assertEqualsLastExpected);
    System.assertEquals(true, fakeAsserter.assertEqualsLastActual);

    sut.hasBeenCalledTimes(0);
    System.assertEquals(true, fakeAsserter.assertEqualsLastExpected);
    System.assertEquals(false, fakeAsserter.assertEqualsLastActual);
    System.assertEquals(
      'Method method was not called 0 times\nmethod call history:\n\t#1 method([()])\n',
      fakeAsserter.assertEqualsLastMessage
    );

    sut.hasBeenCalledTimes(2);
    System.assertEquals(true, fakeAsserter.assertEqualsLastExpected);
    System.assertEquals(false, fakeAsserter.assertEqualsLastActual);
    System.assertEquals(
      'Method method was not called 2 times\nmethod call history:\n\t#1 method([()])\n',
      fakeAsserter.assertEqualsLastMessage
    );
  }

  @isTest
  static void givenExpectedEqualsAssert_systemAsserter_doNotThrow() {
    // Arrange
    final Assertions.SystemAsserter systemAsserter = new Assertions.SystemAsserter();

    // Act
    systemAsserter.isTrue(true, 'it works');
    systemAsserter.isFalse(false, 'it works too');

    // Assert
    System.assert(true, 'This assertions should be reached');
  }

  class FakeAsserter implements Assertions.Asserter {
    public Integer assertEqualsCallCount = 0;
    public Object assertEqualsLastExpected;
    public Object assertEqualsLastActual;
    public String assertEqualsLastMessage;

    public void isTrue(Boolean value, String message) {
      this.assertEqualsCallCount++;
      this.assertEqualsLastExpected = true;
      this.assertEqualsLastActual = value;
      this.assertEqualsLastMessage = message;
    }

    public void isFalse(Boolean value, String message) {
      this.assertEqualsCallCount++;
      this.assertEqualsLastExpected = false;
      this.assertEqualsLastActual = value;
      this.assertEqualsLastMessage = message;
    }
  }
}
