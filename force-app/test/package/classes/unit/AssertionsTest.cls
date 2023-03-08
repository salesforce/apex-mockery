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
    MethodSpy spy = new MethodSpy('method');

    // Act
    Assertions.MethodSpyAssertions result = Assertions.assertThat(spy);

    // Assert
    Assert.isNotNull(result);
  }

  @isTest
  static void hasNotBeenCalled_callsAssertEquals() {
    // Arrange
    MethodSpy spy = new MethodSpy('method');
    FakeAsserter fakeAsserter = new FakeAsserter();
    Assertions.MethodSpyAssertions sut = Assertions.assertThat(spy, fakeAsserter);

    // Act
    sut.hasNotBeenCalled();

    // Assert
    Assert.areEqual(1, fakeAsserter.callCount);
    Assert.isFalse(fakeAsserter.failed);
  }

  @isTest
  static void hasBeenCalled_callsAssertEquals() {
    // Arrange
    MethodSpy spy = new MethodSpy('method');
    FakeAsserter fakeAsserter = new FakeAsserter();
    Assertions.MethodSpyAssertions sut = Assertions.assertThat(spy, fakeAsserter);

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
    MethodSpy spy = new MethodSpy('method');
    FakeAsserter fakeAsserter = new FakeAsserter();
    Assertions.MethodSpyAssertions sut = Assertions.assertThat(spy, fakeAsserter);

    // Act
    sut.hasBeenCalledWith(new Account());

    // Assert
    Assert.areEqual(2, fakeAsserter.callCount);
    Assert.isTrue(fakeAsserter.failed);
    Assert.areEqual('Method method was not called with (Account:{})', fakeAsserter.errorMessage);
  }

  @isTest
  static void givenObjectList_hasBeenCalledWith_callsAssertEquals() {
    // Arrange
    MethodSpy spy = new MethodSpy('method');
    FakeAsserter fakeAsserter = new FakeAsserter();
    Assertions.MethodSpyAssertions sut = Assertions.assertThat(spy, fakeAsserter);

    // Act
    sut.hasBeenCalledWith(Params.ofList(new List<Object>{ new Account(), new Opportunity() }));

    // Assert
    Assert.areEqual(2, fakeAsserter.callCount);
    Assert.isTrue(fakeAsserter.failed);
    Assert.areEqual('Method method was not called with (Account:{}, Opportunity:{})', fakeAsserter.errorMessage);
  }

  @isTest
  static void givenMixList_hasBeenCalledWith_callsAssertEquals() {
    // Arrange
    MethodSpy spy = new MethodSpy('method');
    FakeAsserter fakeAsserter = new FakeAsserter();
    Assertions.MethodSpyAssertions sut = Assertions.assertThat(spy, fakeAsserter);

    // Act
    sut.hasBeenCalledWith(new Account(), Matcher.equals('test'));

    // Assert
    Assert.areEqual(2, fakeAsserter.callCount);
    Assert.isTrue(fakeAsserter.failed);
    Assert.areEqual('Method method was not called with (Account:{}, test)', fakeAsserter.errorMessage);
  }

  @isTest
  static void givenParamsEmpty_hasBeenCalledWith_callsAssertEquals() {
    // Arrange
    MethodSpy spy = new MethodSpy('method');
    FakeAsserter fakeAsserter = new FakeAsserter();
    Assertions.MethodSpyAssertions sut = Assertions.assertThat(spy, fakeAsserter);

    // Act
    sut.hasBeenCalledWith(Params.empty());

    // Assert
    Assert.areEqual(2, fakeAsserter.callCount);
    Assert.isTrue(fakeAsserter.failed);
    Assert.areEqual('Method method was not called with ()', fakeAsserter.errorMessage);
  }

  @isTest
  static void givenNoParameter_hasBeenCalledWith_callsAssertEquals() {
    // Arrange
    MethodSpy spy = new MethodSpy('method');
    FakeAsserter fakeAsserter = new FakeAsserter();
    Assertions.MethodSpyAssertions sut = Assertions.assertThat(spy, fakeAsserter);

    // Act
    sut.hasBeenCalledWith();

    // Assert
    Assert.areEqual(2, fakeAsserter.callCount);
    Assert.isTrue(fakeAsserter.failed);
    Assert.areEqual('Method method was not called with ()', fakeAsserter.errorMessage);
  }

  @isTest
  static void given1Params_hasBeenCalledWith_callsAssertEquals() {
    // Arrange
    MethodSpy spy = new MethodSpy('method');
    spy.returns('anything');
    FakeAsserter fakeAsserter = new FakeAsserter();
    Assertions.MethodSpyAssertions sut = Assertions.assertThat(spy, fakeAsserter);
    spy.call(new List<Object>{ 'param' });

    // Act
    sut.hasBeenCalledWith(Params.of('param'));

    // Assert
    Assert.areEqual(2, fakeAsserter.callCount);
    Assert.isFalse(fakeAsserter.failed);
  }

  @isTest
  static void given2Params_hasBeenCalledWith_callsAssertEquals() {
    // Arrange
    MethodSpy spy = new MethodSpy('method');
    spy.returns('anything');
    FakeAsserter fakeAsserter = new FakeAsserter();
    Assertions.MethodSpyAssertions sut = Assertions.assertThat(spy, fakeAsserter);
    spy.call(new List<Object>{ '2', 'param' });

    // Act
    sut.hasBeenCalledWith('2', 'param');

    // Assert
    Assert.areEqual(2, fakeAsserter.callCount);
    Assert.isFalse(fakeAsserter.failed);
  }

  @isTest
  static void given3Params_hasBeenCalledWith_callsAssertEquals() {
    // Arrange
    MethodSpy spy = new MethodSpy('method');
    spy.returns('anything');
    FakeAsserter fakeAsserter = new FakeAsserter();
    Assertions.MethodSpyAssertions sut = Assertions.assertThat(spy, fakeAsserter);
    spy.call(new List<Object>{ '3', 'param', 'test' });

    // Act
    sut.hasBeenCalledWith('3', 'param', 'test');

    // Assert
    Assert.areEqual(2, fakeAsserter.callCount);
    Assert.isFalse(fakeAsserter.failed);
  }

  @isTest
  static void given4Params_hasBeenCalledWith_callsAssertEquals() {
    // Arrange
    MethodSpy spy = new MethodSpy('method');
    spy.returns('anything');
    FakeAsserter fakeAsserter = new FakeAsserter();
    Assertions.MethodSpyAssertions sut = Assertions.assertThat(spy, fakeAsserter);
    spy.call(new List<Object>{ '4', 'param', 'unit', 'test' });

    // Act
    sut.hasBeenCalledWith('4', 'param', 'unit', 'test');

    // Assert
    Assert.areEqual(2, fakeAsserter.callCount);
    Assert.isFalse(fakeAsserter.failed);
  }

  @isTest
  static void given5Params_hasBeenCalledWith_callsAssertEquals() {
    // Arrange
    MethodSpy spy = new MethodSpy('method');
    spy.returns('anything');
    FakeAsserter fakeAsserter = new FakeAsserter();
    Assertions.MethodSpyAssertions sut = Assertions.assertThat(spy, fakeAsserter);
    spy.call(new List<Object>{ '5', 'param', 'unit', 'test', 'scenario' });

    // Act
    sut.hasBeenCalledWith('5', 'param', 'unit', 'test', 'scenario');

    // Assert
    Assert.areEqual(2, fakeAsserter.callCount);
    Assert.isFalse(fakeAsserter.failed);
  }

  @isTest
  static void givenArgumentMatchers_hasBeenCalledWith_callsAssertEquals() {
    // Arrange
    MethodSpy spy = new MethodSpy('method');
    spy.returns('anything');
    FakeAsserter fakeAsserter = new FakeAsserter();
    Assertions.MethodSpyAssertions sut = Assertions.assertThat(spy, fakeAsserter);
    spy.call(new List<Object>{ 'param' });

    // Act
    sut.hasBeenCalledWith(Matcher.equals('param'));

    // Assert
    Assert.areEqual(2, fakeAsserter.callCount);
    Assert.isFalse(fakeAsserter.failed);
  }

  @isTest
  static void givenNullParam_hasBeenCalledWith_callsAssertEquals() {
    // Arrange
    MethodSpy spy = new MethodSpy('method');
    FakeAsserter fakeAsserter = new FakeAsserter();
    Assertions.MethodSpyAssertions sut = Assertions.assertThat(spy, fakeAsserter);
    spy.call(new List<Object>());

    // Act
    sut.hasBeenCalledWith(null);

    Assert.areEqual(2, fakeAsserter.callCount);
    Assert.isTrue(fakeAsserter.failed);
    Assert.areEqual('Method method was not called with (null)\nmethod call history:\n\t#1 method(())\n', fakeAsserter.errorMessage);
  }

  @isTest
  static void givenNullParam_hasBeenLastCalledWith_callsAssertEquals() {
    // Arrange
    MethodSpy spy = new MethodSpy('method');
    FakeAsserter fakeAsserter = new FakeAsserter();
    Assertions.MethodSpyAssertions sut = Assertions.assertThat(spy, fakeAsserter);

    // Act
    sut.hasBeenLastCalledWith(null);

    // Assert
    Assert.areEqual(2, fakeAsserter.callCount);
    Assert.isTrue(fakeAsserter.failed);
    Assert.areEqual('Method method was not last called with (null)', fakeAsserter.errorMessage);
  }

  @isTest
  static void givenObject_hasBeenLastCalledWith_callsAssertEquals() {
    // Arrange
    MethodSpy spy = new MethodSpy('method');
    FakeAsserter fakeAsserter = new FakeAsserter();
    Assertions.MethodSpyAssertions sut = Assertions.assertThat(spy, fakeAsserter);

    // Act
    sut.hasBeenLastCalledWith(new Account());

    // Assert
    Assert.areEqual(2, fakeAsserter.callCount);
    Assert.isTrue(fakeAsserter.failed);
    Assert.areEqual('Method method was not last called with (Account:{})', fakeAsserter.errorMessage);
  }

  @isTest
  static void givenMixList_hasBeenLastCalledWith_callsAssertEquals() {
    // Arrange
    MethodSpy spy = new MethodSpy('method');
    FakeAsserter fakeAsserter = new FakeAsserter();
    Assertions.MethodSpyAssertions sut = Assertions.assertThat(spy, fakeAsserter);

    // Act
    sut.hasBeenLastCalledWith(new Account(), Matcher.equals('test'));

    // Assert
    Assert.areEqual(2, fakeAsserter.callCount);
    Assert.isTrue(fakeAsserter.failed);
    Assert.areEqual('Method method was not last called with (Account:{}, test)', fakeAsserter.errorMessage);
  }

  @isTest
  static void givenNoParameter_hasBeenLastCalledWith_callsAssertEquals() {
    // Arrange
    MethodSpy spy = new MethodSpy('method');
    FakeAsserter fakeAsserter = new FakeAsserter();
    Assertions.MethodSpyAssertions sut = Assertions.assertThat(spy, fakeAsserter);

    // Act
    sut.hasBeenLastCalledWith();

    // Assert
    Assert.areEqual(2, fakeAsserter.callCount);
    Assert.isTrue(fakeAsserter.failed);
    Assert.areEqual('Method method was not last called with ()', fakeAsserter.errorMessage);
  }

  @isTest
  static void given1Params_hasBeenLastCalledWith_callsAssertEquals() {
    // Arrange
    MethodSpy spy = new MethodSpy('method');
    spy.returns('anything');
    FakeAsserter fakeAsserter = new FakeAsserter();
    Assertions.MethodSpyAssertions sut = Assertions.assertThat(spy, fakeAsserter);
    spy.call(new List<Object>{ 'param' });

    // Act
    sut.hasBeenLastCalledWith(Params.of('param'));

    // Assert
    Assert.areEqual(2, fakeAsserter.callCount);
    Assert.isFalse(fakeAsserter.failed);
  }

  @isTest
  static void given2Params_hasBeenLastCalledWith_callsAssertEquals() {
    // Arrange
    MethodSpy spy = new MethodSpy('method');
    spy.returns('anything');
    FakeAsserter fakeAsserter = new FakeAsserter();
    Assertions.MethodSpyAssertions sut = Assertions.assertThat(spy, fakeAsserter);
    spy.call(new List<Object>{ '2', 'param' });

    // Act
    sut.hasBeenLastCalledWith('2', 'param');

    // Assert
    Assert.areEqual(2, fakeAsserter.callCount);
    Assert.isFalse(fakeAsserter.failed);
  }

  @isTest
  static void given3Params_hasBeenLastCalledWith_callsAssertEquals() {
    // Arrange
    MethodSpy spy = new MethodSpy('method');
    spy.returns('anything');
    FakeAsserter fakeAsserter = new FakeAsserter();
    Assertions.MethodSpyAssertions sut = Assertions.assertThat(spy, fakeAsserter);
    spy.call(new List<Object>{ '3', 'param', 'test' });

    // Act
    sut.hasBeenLastCalledWith('3', 'param', 'test');

    // Assert
    Assert.areEqual(2, fakeAsserter.callCount);
    Assert.isFalse(fakeAsserter.failed);
  }

  @isTest
  static void given4Params_hasBeenLastCalledWith_callsAssertEquals() {
    // Arrange
    MethodSpy spy = new MethodSpy('method');
    spy.returns('anything');
    FakeAsserter fakeAsserter = new FakeAsserter();
    Assertions.MethodSpyAssertions sut = Assertions.assertThat(spy, fakeAsserter);
    spy.call(new List<Object>{ '4', 'param', 'unit', 'test' });

    // Act
    sut.hasBeenLastCalledWith('4', 'param', 'unit', 'test');

    // Assert
    Assert.areEqual(2, fakeAsserter.callCount);
    Assert.isFalse(fakeAsserter.failed);
  }

  @isTest
  static void given5Params_hasBeenLastCalledWith_callsAssertEquals() {
    // Arrange
    MethodSpy spy = new MethodSpy('method');
    spy.returns('anything');
    FakeAsserter fakeAsserter = new FakeAsserter();
    Assertions.MethodSpyAssertions sut = Assertions.assertThat(spy, fakeAsserter);
    spy.call(new List<Object>{ '5', 'param', 'unit', 'test', 'scenario' });

    // Act
    sut.hasBeenLastCalledWith('5', 'param', 'unit', 'test', 'scenario');

    // Assert
    Assert.areEqual(2, fakeAsserter.callCount);
    Assert.isFalse(fakeAsserter.failed);
  }

  @isTest
  static void givenArgumentMatchers_hasBeenLastCalledWith_callsAssertEquals() {
    // Arrange
    MethodSpy spy = new MethodSpy('method');
    spy.returns('anything');
    FakeAsserter fakeAsserter = new FakeAsserter();
    Assertions.MethodSpyAssertions sut = Assertions.assertThat(spy, fakeAsserter);
    spy.call(new List<Object>{ 'param' });

    // Act
    sut.hasBeenLastCalledWith(Matcher.equals('param'));

    // Assert
    Assert.areEqual(2, fakeAsserter.callCount);
    Assert.isFalse(fakeAsserter.failed);
  }

  @isTest
  static void givenNullArgumentMatchers_hasBeenLastCalledWithNull_callsAssertEquals() {
    // Arrange
    MethodSpy spy = new MethodSpy('method');
    FakeAsserter fakeAsserter = new FakeAsserter();
    Assertions.MethodSpyAssertions sut = Assertions.assertThat(spy, fakeAsserter);
    spy.call(new List<Object>());

    // Act
    sut.hasBeenLastCalledWith(null);

    Assert.areEqual(2, fakeAsserter.callCount);
    Assert.isTrue(fakeAsserter.failed);
    Assert.areEqual('Method method was not last called with (null)\nmethod call history:\n\t#1 method(())\n', fakeAsserter.errorMessage);
  }

  @isTest
  static void givenCall_hasBeenCalledTimes_returnsCalledTimes() {
    // Arrange
    MethodSpy spy = new MethodSpy('method');
    FakeAsserter fakeAsserter = new FakeAsserter();
    Assertions.MethodSpyAssertions sut = Assertions.assertThat(spy, fakeAsserter);
    spy.call(new List<Object>());

    // Act & Assert
    sut.hasBeenCalledTimes(1);
    Assert.isFalse(fakeAsserter.failed);

    sut.hasBeenCalledTimes(0);
    Assert.isTrue(fakeAsserter.failed);
    Assert.areEqual('Method method was not called 0 times\nmethod call history:\n\t#1 method(())\n', fakeAsserter.errorMessage);

    sut.hasBeenCalledTimes(2);
    Assert.isTrue(fakeAsserter.failed);
    Assert.areEqual('Method method was not called 2 times\nmethod call history:\n\t#1 method(())\n', fakeAsserter.errorMessage);
  }

  @isTest
  static void givenExpectedEqualsAssert_MethodSpyAsserter_doNotThrow() {
    // Arrange
    Assertions.Asserter sut = new Assertions.MethodSpyAsserter();

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
