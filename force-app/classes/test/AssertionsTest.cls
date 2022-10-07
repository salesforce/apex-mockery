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
    System.assertEquals(
      spy.hasBeenCalled(),
      fakeAsserter.assertEqualsLastActual
    );
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
    System.assertEquals(
      spy.hasBeenCalled(),
      fakeAsserter.assertEqualsLastActual
    );
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
    final Object param = new Account();

    // Act
    sut.hasBeenCalledWith(param);

    // Assert
    System.assertEquals(2, fakeAsserter.assertEqualsCallCount);
    System.assertEquals(true, fakeAsserter.assertEqualsLastExpected);
    System.assertEquals(false, fakeAsserter.assertEqualsLastActual);
  }

  @isTest
  static void givenNull_hasBeenCalledWith_callsAssertEquals() {
    // Arrange
    final MethodSpy spy = new MethodSpy('method');
    final FakeAsserter fakeAsserter = new FakeAsserter();
    final Assertions.MethodSpyAssert sut = new Assertions.MethodSpyAssert(
      spy,
      fakeAsserter
    );

    // Act
    sut.hasBeenCalledWith(null);

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
    final List<Object> param = new List<Object>{ new Account() };

    // Act
    sut.hasBeenCalledWithParams(param);

    // Assert
    System.assertEquals(2, fakeAsserter.assertEqualsCallCount);
    System.assertEquals(true, fakeAsserter.assertEqualsLastExpected);
    System.assertEquals(false, fakeAsserter.assertEqualsLastActual);
  }

  @isTest
  static void givenNullList_hasBeenCalledWithParams_callsAssertEquals() {
    // Arrange
    final MethodSpy spy = new MethodSpy('method');
    final FakeAsserter fakeAsserter = new FakeAsserter();
    final Assertions.MethodSpyAssert sut = new Assertions.MethodSpyAssert(
      spy,
      fakeAsserter
    );
    final List<Object> params = null;

    // Act
    sut.hasBeenCalledWithParams(params);

    // Assert
    System.assertEquals(2, fakeAsserter.assertEqualsCallCount);
    System.assertEquals(true, fakeAsserter.assertEqualsLastExpected);
    System.assertEquals(false, fakeAsserter.assertEqualsLastActual);
  }

  @isTest
  static void givenParametersMatcher_hasBeenCalledWithParams_callsAssertEquals() {
    // Arrange
    final MethodSpy spy = new MethodSpy('method');
    spy.returns('anything');
    final FakeAsserter fakeAsserter = new FakeAsserter();
    final Assertions.MethodSpyAssert sut = new Assertions.MethodSpyAssert(
      spy,
      fakeAsserter
    );
    final List<Object> spyCallParam = new List<Object>{ 'param' };
    spy.call(spyCallParam);
    final ParametersMatcherStub param = new ParametersMatcherStub();
    param.expected = spyCallParam;

    // Act
    sut.hasBeenCalledWithParams(param);

    // Assert
    System.assertEquals(2, fakeAsserter.assertEqualsCallCount);
    System.assertEquals(true, fakeAsserter.assertEqualsLastExpected);
    System.assertEquals(true, fakeAsserter.assertEqualsLastActual);
  }

  @isTest
  static void givenNullParametersMatcher_hasBeenCalledWithParams_callsAssertEquals() {
    // Arrange
    final MethodSpy spy = new MethodSpy('method');
    final FakeAsserter fakeAsserter = new FakeAsserter();
    final Assertions.MethodSpyAssert sut = new Assertions.MethodSpyAssert(
      spy,
      fakeAsserter
    );
    final ParametersMatcher param = null;
    spy.call(new List<Object>());

    // Act
    try {
      sut.hasBeenCalledWithParams((ParametersMatcher) param);

      // Assert
      System.assert(false); // Should not reach this point
    } catch (Exception ex) {
      System.assertEquals(false, fakeAsserter.assertEqualsLastExpected);
      System.assertEquals(
        spy.hasBeenCalled(),
        fakeAsserter.assertEqualsLastActual
      );
      System.assert(ex instanceof NullPointerException);
    }
  }

  @isTest
  static void givenNullParametersMatcher_hasBeenLastCalledWithParams_callsAssertEquals() {
    // Arrange
    final MethodSpy spy = new MethodSpy('method');
    final FakeAsserter fakeAsserter = new FakeAsserter();
    final Assertions.MethodSpyAssert sut = new Assertions.MethodSpyAssert(
      spy,
      fakeAsserter
    );
    final ParametersMatcher param = null;

    // Act
    try {
      sut.hasBeenLastCalledWithParams((ParametersMatcher) param);

      // Assert
      System.assert(false); // Should not reach this point
    } catch (Exception ex) {
      System.assertEquals(false, fakeAsserter.assertEqualsLastExpected);
      System.assertEquals(
        spy.hasBeenCalled(),
        fakeAsserter.assertEqualsLastActual
      );
      System.assert(ex instanceof NullPointerException);
    }
  }

  class ParametersMatcherStub implements ParametersMatcher {
    public List<Object> expected;

    public boolean matches(List<Object> params) {
      return this.expected == params;
    }
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
