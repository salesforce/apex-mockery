/*
 * Copyright (c) 2022, salesforce.com, inc.
 * All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * For full license text, see the LICENSE file in the repo root or https://opensource.org/licenses/BSD-3-Clause
 */
@IsTest
private class AssertionsTest {
  // As Assert.* methods throws are not catchable
  // Test are white box (implementation test instead of behavioural test)
  // We implemented a FakeAsserter class for the occasion

  @isTest
  static void givenMethodSpyInstance_assertThatReturnsMethodSpyAssertInstance() {
    // Arrange
    final MethodSpy spy = new MethodSpy('method');

    // Act
    final Assertions.MethodSpyAssertions result = Assertions.assertThat(spy);

    // Assert
    Assert.isNotNull(result);
  }

  @isTest
  static void hasNotBeenCalled_callsAssertEquals() {
    // Arrange
    final MethodSpy spy = new MethodSpy('method');
    final FakeAsserter fakeAsserter = new FakeAsserter();
    final Assertions.MethodSpyAssertions sut = Assertions.assertThat(spy, fakeAsserter);

    // Act
    sut.hasNotBeenCalled();

    // Assert
    Assert.areEqual(1, fakeAsserter.callCount);
    Assert.isFalse(fakeAsserter.failed);
  }

  @isTest
  static void hasBeenCalled_callsAssertEquals() {
    // Arrange
    final MethodSpy spy = new MethodSpy('method');
    final FakeAsserter fakeAsserter = new FakeAsserter();
    final Assertions.MethodSpyAssertions sut = Assertions.assertThat(spy, fakeAsserter);

    // Act
    sut.hasBeenCalled();

    // Assert
    Assert.areEqual(1, fakeAsserter.callCount);
    Assert.isTrue(fakeAsserter.failed);
    Assert.areEqual('Method method was not called', fakeAsserter.errorMessage);
  }

  @isTest
  static void givenObject_hasBeenCalledWith_callsAssertEquals() {
    // Arrange
    final MethodSpy spy = new MethodSpy('method');
    final FakeAsserter fakeAsserter = new FakeAsserter();
    final Assertions.MethodSpyAssertions sut = Assertions.assertThat(spy, fakeAsserter);

    // Act
    sut.hasBeenCalledWith(Params.of(new Account()));

    // Assert
    Assert.areEqual(2, fakeAsserter.callCount);
    Assert.isTrue(fakeAsserter.failed);
    Assert.areEqual('Method method was not called with [(Account:{})]', fakeAsserter.errorMessage);
  }

  @isTest
  static void givenObjectList_hasBeenCalledWithParams_callsAssertEquals() {
    // Arrange
    final MethodSpy spy = new MethodSpy('method');
    final FakeAsserter fakeAsserter = new FakeAsserter();
    final Assertions.MethodSpyAssertions sut = Assertions.assertThat(spy, fakeAsserter);

    // Act
    sut.hasBeenCalledWith(Params.ofList(new List<Object>{ new Account(), new Opportunity() }));

    // Assert
    Assert.areEqual(2, fakeAsserter.callCount);
    Assert.isTrue(fakeAsserter.failed);
    Assert.areEqual('Method method was not called with [(Account:{}, Opportunity:{})]', fakeAsserter.errorMessage);
  }

  @isTest
  static void givenMixList_hasBeenCalledWithParams_callsAssertEquals() {
    // Arrange
    final MethodSpy spy = new MethodSpy('method');
    final FakeAsserter fakeAsserter = new FakeAsserter();
    final Assertions.MethodSpyAssertions sut = Assertions.assertThat(spy, fakeAsserter);

    // Act
    sut.hasBeenCalledWith(Params.of(new Account(), Matcher.equals('test')));

    // Assert
    Assert.areEqual(2, fakeAsserter.callCount);
    Assert.isTrue(fakeAsserter.failed);
    Assert.areEqual('Method method was not called with [(Account:{}, test)]', fakeAsserter.errorMessage);
  }

  @isTest
  static void givenEmptyList_hasBeenCalledWithParams_callsAssertEquals() {
    // Arrange
    final MethodSpy spy = new MethodSpy('method');
    final FakeAsserter fakeAsserter = new FakeAsserter();
    final Assertions.MethodSpyAssertions sut = Assertions.assertThat(spy, fakeAsserter);

    // Act
    sut.hasBeenCalledWith(Params.empty());

    // Assert
    Assert.areEqual(2, fakeAsserter.callCount);
    Assert.isTrue(fakeAsserter.failed);
    Assert.areEqual('Method method was not called with [()]', fakeAsserter.errorMessage);
  }

  @isTest
  static void givenArgumentMatchers_hasBeenCalledWithParams_callsAssertEquals() {
    // Arrange
    final MethodSpy spy = new MethodSpy('method');
    spy.returns('anything');
    final FakeAsserter fakeAsserter = new FakeAsserter();
    final Assertions.MethodSpyAssertions sut = Assertions.assertThat(spy, fakeAsserter);
    spy.call(new List<Object>{ 'param' });

    // Act
    sut.hasBeenCalledWith(Params.of(Matcher.equals('param')));

    // Assert
    Assert.areEqual(2, fakeAsserter.callCount);
    Assert.isFalse(fakeAsserter.failed);
  }

  @isTest
  static void givenNullParam_hasBeenCalledWith_callsAssertEquals() {
    // Arrange
    final MethodSpy spy = new MethodSpy('method');
    final FakeAsserter fakeAsserter = new FakeAsserter();
    final Assertions.MethodSpyAssertions sut = Assertions.assertThat(spy, fakeAsserter);
    spy.call(new List<Object>());

    // Act
    sut.hasBeenCalledWith(Params.of((Object) null));

    Assert.areEqual(2, fakeAsserter.callCount);
    Assert.isTrue(fakeAsserter.failed);
    Assert.areEqual('Method method was not called with [(null)]\nmethod call history:\n\t#1 method([()])\n', fakeAsserter.errorMessage);
  }

  @isTest
  static void givenNullParam_hasBeenLastCalledWith_callsAssertEquals() {
    // Arrange
    final MethodSpy spy = new MethodSpy('method');
    final FakeAsserter fakeAsserter = new FakeAsserter();
    final Assertions.MethodSpyAssertions sut = Assertions.assertThat(spy, fakeAsserter);

    // Act
    sut.hasBeenLastCalledWith(Params.of((Object) null));

    // Assert
    Assert.areEqual(2, fakeAsserter.callCount);
    Assert.isTrue(fakeAsserter.failed);
    Assert.areEqual('Method method was not last called with [(null)]', fakeAsserter.errorMessage);
  }

  @isTest
  static void givenObjectList_hasBeenLastCalledWithParams_callsAssertEquals() {
    // Arrange
    final MethodSpy spy = new MethodSpy('method');
    final FakeAsserter fakeAsserter = new FakeAsserter();
    final Assertions.MethodSpyAssertions sut = Assertions.assertThat(spy, fakeAsserter);

    // Act
    sut.hasBeenLastCalledWith(Params.of(new Account()));

    // Assert
    Assert.areEqual(2, fakeAsserter.callCount);
    Assert.isTrue(fakeAsserter.failed);
    Assert.areEqual('Method method was not last called with [(Account:{})]', fakeAsserter.errorMessage);
  }

  @isTest
  static void givenMixList_hasBeenLastCalledWithParams_callsAssertEquals() {
    // Arrange
    final MethodSpy spy = new MethodSpy('method');
    final FakeAsserter fakeAsserter = new FakeAsserter();
    final Assertions.MethodSpyAssertions sut = Assertions.assertThat(spy, fakeAsserter);

    // Act
    sut.hasBeenLastCalledWith(Params.of(new Account(), Matcher.equals('test')));

    // Assert
    Assert.areEqual(2, fakeAsserter.callCount);
    Assert.isTrue(fakeAsserter.failed);
    Assert.areEqual('Method method was not last called with [(Account:{}, test)]', fakeAsserter.errorMessage);
  }

  @isTest
  static void givenNullList_hasBeenLastCalledWithParams_callsAssertEquals() {
    // Arrange
    final MethodSpy spy = new MethodSpy('method');
    final FakeAsserter fakeAsserter = new FakeAsserter();
    final Assertions.MethodSpyAssertions sut = Assertions.assertThat(spy, fakeAsserter);

    // Act
    sut.hasBeenLastCalledWith(Params.of((Object) null));

    // Assert
    Assert.areEqual(2, fakeAsserter.callCount);
    Assert.isTrue(fakeAsserter.failed);
    Assert.areEqual('Method method was not last called with [(null)]', fakeAsserter.errorMessage);
  }

  @isTest
  static void givenArgumentMatchers_hasBeenLastCalledWithParams_callsAssertEquals() {
    // Arrange
    final MethodSpy spy = new MethodSpy('method');
    spy.returns('anything');
    final FakeAsserter fakeAsserter = new FakeAsserter();
    final Assertions.MethodSpyAssertions sut = Assertions.assertThat(spy, fakeAsserter);
    spy.call(new List<Object>{ 'param' });

    // Act
    sut.hasBeenLastCalledWith(Params.of(Matcher.equals('param')));

    // Assert
    Assert.areEqual(2, fakeAsserter.callCount);
    Assert.isFalse(fakeAsserter.failed);
  }

  @isTest
  static void givenNullArgumentMatchers_hasBeenLastCalledWithParamsOfNull_callsAssertEquals() {
    // Arrange
    final MethodSpy spy = new MethodSpy('method');
    final FakeAsserter fakeAsserter = new FakeAsserter();
    final Assertions.MethodSpyAssertions sut = Assertions.assertThat(spy, fakeAsserter);
    spy.call(new List<Object>());

    // Act
    sut.hasBeenLastCalledWith(Params.of((Object) null));

    Assert.areEqual(2, fakeAsserter.callCount);
    Assert.isTrue(fakeAsserter.failed);
    Assert.areEqual('Method method was not last called with [(null)]\nmethod call history:\n\t#1 method([()])\n', fakeAsserter.errorMessage);
  }

  @isTest
  static void givenCall_hasBeenCalledTimes_returnsCalledTimes() {
    // Arrange
    final MethodSpy spy = new MethodSpy('method');
    final FakeAsserter fakeAsserter = new FakeAsserter();
    final Assertions.MethodSpyAssertions sut = Assertions.assertThat(spy, fakeAsserter);
    spy.call(new List<Object>());

    // Act & Assert
    sut.hasBeenCalledTimes(1);
    Assert.isFalse(fakeAsserter.failed);

    sut.hasBeenCalledTimes(0);
    Assert.isTrue(fakeAsserter.failed);
    Assert.areEqual('Method method was not called 0 times\nmethod call history:\n\t#1 method([()])\n', fakeAsserter.errorMessage);

    sut.hasBeenCalledTimes(2);
    Assert.isTrue(fakeAsserter.failed);
    Assert.areEqual('Method method was not called 2 times\nmethod call history:\n\t#1 method([()])\n', fakeAsserter.errorMessage);
  }

  @isTest
  static void givenExpectedEqualsAssert_MethodSpyAsserter_doNotThrow() {
    // Arrange
    final Assertions.Asserter sut = new Assertions.MethodSpyAsserter();

    // Act
    sut.isTrue(true, new FakeErrorMessage('it works'));
    sut.isFalse(false, new FakeErrorMessage('it works too'));

    // Assert
    Assert.isTrue(true, 'This assertions should be reached');
  }

  class FakeErrorMessage implements Assertions.ErrorMessage {
    private String message;
    FakeErrorMessage(String message) {
      this.message = message;
    }
    public override String toString() {
      return message;
    }
  }

  class FakeAsserter implements Assertions.Asserter {
    public Integer callCount = 0;
    public Boolean failed = false;
    public String errorMessage;

    public void isTrue(Boolean value, Assertions.ErrorMessage message) {
      this.callCount++;
      if (!value) {
        this.failed = true;
        this.errorMessage = message.toString();
      }
    }

    public void isFalse(Boolean value, Assertions.ErrorMessage message) {
      this.callCount++;
      if (value) {
        this.failed = true;
        this.errorMessage = message.toString();
      }
    }
  }
}
