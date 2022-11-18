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
    final Assertions.MethodSpyAssert result = Assertions.assertThat(spy);

    // Assert
    System.assertNotEquals(null, result);
  }

  @isTest
  static void hasNotBeenCalled_callsAssertEquals() {
    // Arrange
    final MethodSpy spy = new MethodSpy('method');
    final FakeAsserter fakeAsserter = new FakeAsserter();
    final Assertions.MethodSpyAssert sut = new Assertions.MethodSpyAssert(
      spy,
      fakeAsserter
    );

    // Act
    sut.hasNotBeenCalled();

    // Assert
    System.assertEquals(1, fakeAsserter.assertEqualsCallCount);
    System.assertEquals(false, fakeAsserter.assertEqualsLastExpected);
    System.assertEquals(false, fakeAsserter.assertEqualsLastActual);
  }

  @isTest
  static void hasBeenCalled_callsAssertEquals() {
    // Arrange
    final MethodSpy spy = new MethodSpy('method');
    final FakeAsserter fakeAsserter = new FakeAsserter();
    final Assertions.MethodSpyAssert sut = new Assertions.MethodSpyAssert(
      spy,
      fakeAsserter
    );

    // Act
    sut.hasBeenCalled();

    // Assert
    System.assertEquals(1, fakeAsserter.assertEqualsCallCount);
    System.assertEquals(true, fakeAsserter.assertEqualsLastExpected);
    System.assertEquals(false, fakeAsserter.assertEqualsLastActual);
  }

  @isTest
  static void givenObject_hasBeenCalledWith_callsAssertEquals() {
    // Arrange
    final MethodSpy spy = new MethodSpy('method');
    final FakeAsserter fakeAsserter = new FakeAsserter();
    final Assertions.MethodSpyAssert sut = new Assertions.MethodSpyAssert(
      spy,
      fakeAsserter
    );

    // Act
    sut.hasBeenCalledWith(Params.args(new Account()));

    // Assert
    System.assertEquals(2, fakeAsserter.assertEqualsCallCount);
    System.assertEquals(true, fakeAsserter.assertEqualsLastExpected);
    System.assertEquals(false, fakeAsserter.assertEqualsLastActual);
  }

  @isTest
  static void givenObjectList_hasBeenCalledWithParams_callsAssertEquals() {
    // Arrange
    final MethodSpy spy = new MethodSpy('method');
    final FakeAsserter fakeAsserter = new FakeAsserter();
    final Assertions.MethodSpyAssert sut = new Assertions.MethodSpyAssert(
      spy,
      fakeAsserter
    );

    // Act
    sut.hasBeenCalledWith(Params.args(new List<Object>{ new Account() }));

    // Assert
    System.assertEquals(2, fakeAsserter.assertEqualsCallCount);
    System.assertEquals(true, fakeAsserter.assertEqualsLastExpected);
    System.assertEquals(false, fakeAsserter.assertEqualsLastActual);
  }

  @isTest
  static void givenMixList_hasBeenCalledWithParams_callsAssertEquals() {
    // Arrange
    final MethodSpy spy = new MethodSpy('method');
    final FakeAsserter fakeAsserter = new FakeAsserter();
    final Assertions.MethodSpyAssert sut = new Assertions.MethodSpyAssert(
      spy,
      fakeAsserter
    );

    // Act
    sut.hasBeenCalledWith(Params.args(new Account(), Matcher.equals('test')));

    // Assert
    System.assertEquals(2, fakeAsserter.assertEqualsCallCount);
    System.assertEquals(true, fakeAsserter.assertEqualsLastExpected);
    System.assertEquals(false, fakeAsserter.assertEqualsLastActual);
  }

  @isTest
  static void givenEmptyList_hasBeenCalledWithParams_callsAssertEquals() {
    // Arrange
    final MethodSpy spy = new MethodSpy('method');
    final FakeAsserter fakeAsserter = new FakeAsserter();
    final Assertions.MethodSpyAssert sut = new Assertions.MethodSpyAssert(
      spy,
      fakeAsserter
    );

    // Act
    sut.hasBeenCalledWith(Params.args());

    // Assert
    System.assertEquals(2, fakeAsserter.assertEqualsCallCount);
    System.assertEquals(true, fakeAsserter.assertEqualsLastExpected);
    System.assertEquals(false, fakeAsserter.assertEqualsLastActual);
  }

  @isTest
  static void givenArgumentMatchers_hasBeenCalledWithParams_callsAssertEquals() {
    // Arrange
    final MethodSpy spy = new MethodSpy('method');
    spy.returns('anything');
    final FakeAsserter fakeAsserter = new FakeAsserter();
    final Assertions.MethodSpyAssert sut = new Assertions.MethodSpyAssert(
      spy,
      fakeAsserter
    );
    spy.call(new List<Object>{ 'param' });

    // Act
    sut.hasBeenCalledWith(Params.args(Matcher.equals('param')));

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
    final Assertions.MethodSpyAssert sut = new Assertions.MethodSpyAssert(
      spy,
      fakeAsserter
    );
    ArgumentMatcher expected = null;
    spy.call(new List<Object>());

    // Act
    sut.hasBeenCalledWith(Params.args(null));

    System.assertEquals(true, fakeAsserter.assertEqualsLastExpected);
    System.assertEquals(false, fakeAsserter.assertEqualsLastActual);
  }

  @isTest
  static void givenNull_hasBeenLastCalledWith_callsAssertEquals() {
    // Arrange
    final MethodSpy spy = new MethodSpy('method');
    final FakeAsserter fakeAsserter = new FakeAsserter();
    final Assertions.MethodSpyAssert sut = new Assertions.MethodSpyAssert(
      spy,
      fakeAsserter
    );

    // Act
    sut.hasBeenLastCalledWith(null);

    // Assert
    System.assertEquals(2, fakeAsserter.assertEqualsCallCount);
    System.assertEquals(true, fakeAsserter.assertEqualsLastExpected);
    System.assertEquals(false, fakeAsserter.assertEqualsLastActual);
  }

  @isTest
  static void givenObjectList_hasBeenLastCalledWithParams_callsAssertEquals() {
    // Arrange
    final MethodSpy spy = new MethodSpy('method');
    final FakeAsserter fakeAsserter = new FakeAsserter();
    final Assertions.MethodSpyAssert sut = new Assertions.MethodSpyAssert(
      spy,
      fakeAsserter
    );

    // Act
    sut.hasBeenLastCalledWith(Params.args(new Account()));

    // Assert
    System.assertEquals(2, fakeAsserter.assertEqualsCallCount);
    System.assertEquals(true, fakeAsserter.assertEqualsLastExpected);
    System.assertEquals(false, fakeAsserter.assertEqualsLastActual);
  }

  @isTest
  static void givenMixList_hasBeenLastCalledWithParams_callsAssertEquals() {
    // Arrange
    final MethodSpy spy = new MethodSpy('method');
    final FakeAsserter fakeAsserter = new FakeAsserter();
    final Assertions.MethodSpyAssert sut = new Assertions.MethodSpyAssert(
      spy,
      fakeAsserter
    );

    // Act
    sut.hasBeenLastCalledWith(
      Params.args(new Account(), Matcher.equals('test'))
    );

    // Assert
    System.assertEquals(2, fakeAsserter.assertEqualsCallCount);
    System.assertEquals(true, fakeAsserter.assertEqualsLastExpected);
    System.assertEquals(false, fakeAsserter.assertEqualsLastActual);
  }

  @isTest
  static void givenNullList_hasBeenLastCalledWithParams_callsAssertEquals() {
    // Arrange
    final MethodSpy spy = new MethodSpy('method');
    final FakeAsserter fakeAsserter = new FakeAsserter();
    final Assertions.MethodSpyAssert sut = new Assertions.MethodSpyAssert(
      spy,
      fakeAsserter
    );

    // Act
    sut.hasBeenLastCalledWith(Params.args(null));

    // Assert
    System.assertEquals(2, fakeAsserter.assertEqualsCallCount);
    System.assertEquals(true, fakeAsserter.assertEqualsLastExpected);
    System.assertEquals(false, fakeAsserter.assertEqualsLastActual);
  }

  @isTest
  static void givenArgumentMatchers_hasBeenLastCalledWithParams_callsAssertEquals() {
    // Arrange
    final MethodSpy spy = new MethodSpy('method');
    spy.returns('anything');
    final FakeAsserter fakeAsserter = new FakeAsserter();
    final Assertions.MethodSpyAssert sut = new Assertions.MethodSpyAssert(
      spy,
      fakeAsserter
    );
    spy.call(new List<Object>{ 'param' });

    // Act
    sut.hasBeenLastCalledWith(Params.args(Matcher.equals('param')));

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
    final Assertions.MethodSpyAssert sut = new Assertions.MethodSpyAssert(
      spy,
      fakeAsserter
    );
    spy.call(null);

    // Act
    try {
      sut.hasBeenLastCalledWith(Params.args(null));

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
    final Assertions.MethodSpyAssert sut = new Assertions.MethodSpyAssert(
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

    sut.hasBeenCalledTimes(2);
    System.assertEquals(true, fakeAsserter.assertEqualsLastExpected);
    System.assertEquals(false, fakeAsserter.assertEqualsLastActual);
  }

  @isTest
  static void givenExpectedEqualsAssert_systemAsserter_doNotThrow() {
    // Arrange
    Assertions.SystemAsserter systemAsserter = new Assertions.SystemAsserter();

    // Act
    systemAsserter.assertEquals(true, true, 'it works');

    // Assert
    System.assert(true, 'This assertions should be reached');
  }

  class FakeAsserter extends Assertions.SystemAsserter {
    public Integer assertEqualsCallCount = 0;
    public Object assertEqualsLastExpected;
    public Object assertEqualsLastActual;

    public override void assertEquals(
      Object expected,
      Object actual,
      String message
    ) {
      this.assertEqualsCallCount++;
      this.assertEqualsLastExpected = expected;
      this.assertEqualsLastActual = actual;
    }
  }
}
