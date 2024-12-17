/*
 * Copyright (c) 2022, salesforce.com, inc.
 * All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * For full license text, see the LICENSE file in the repo root or https://opensource.org/licenses/BSD-3-Clause
 */

@IsTest
private class MethodSpyTestCustomBehavior {
  class ReturnParam implements MethodSpy.ConfiguredBehavior {
    public Object apply(final List<Object> params) {
      return params;
    }
  }

  @isTest
  static void givenSpyConfiguredWithBehavior_whenCalled_thenExecuteTheBehavior() {
    // Arrange
    MethodSpy sut = new MethodSpy('methodName');
    sut.mockImplementation(new ReturnParam());
    final String valueParameter = 'str';

    // Act
    final List<Object> result = (List<Object>) sut.call(new List<Type>{ String.class }, new List<String>{ 'param' }, new List<Object>{ valueParameter });

    // Assert
    Assert.areEqual(new List<Object>{ valueParameter }, result);
    Assert.isTrue(valueParameter === result[0]);
  }

  @isTest
  static void givenSpyConfiguredWithMatcherWithBehavior_whenCalledWithMatching_thenExecuteTheBehavior() {
    // Arrange
    MethodSpy sut = new MethodSpy('methodName');
    sut.whenCalledWith('str').thenMockImplementation(new ReturnParam());
    final String valueParameter = 'str';

    // Act
    final List<Object> result = (List<Object>) sut.call(new List<Type>{ String.class }, new List<String>{ 'param' }, new List<Object>{ valueParameter });

    // Assert
    Assert.areEqual(new List<Object>{ valueParameter }, result);
    Assert.isTrue(valueParameter === result[0]);
  }

  @isTest
  static void givenSpyConfiguredWithBehaviorOnce_whenCalled_thenExecuteTheBehaviorOnce() {
    // Arrange
    MethodSpy sut = new MethodSpy('methodName');
    sut.mockImplementationOnce(new ReturnParam());
    final String valueParameter = 'str';

    // Act
    final List<Object> result = (List<Object>) sut.call(new List<Type>{ String.class }, new List<String>{ 'param' }, new List<Object>{ valueParameter });
    Assert.areEqual(new List<Object>{ valueParameter }, result);
    Assert.isTrue(valueParameter === result[0]);

    final Object secondResult = sut.call(new List<Type>{ String.class }, new List<String>{ 'param' }, new List<Object>{ 'str' });
    Assert.isNull(secondResult);
  }

  @isTest
  static void givenSpyConfiguredWithMatcherWithBehaviorOnce_whenCalledWithMatching_thenExecuteTheBehaviorOnce() {
    // Arrange
    MethodSpy sut = new MethodSpy('methodName');
    sut.whenCalledWith('str').thenMockImplementationOnce(new ReturnParam());
    final String valueParameter = 'str';

    // Act
    final List<Object> result = (List<Object>) sut.call(new List<Type>{ String.class }, new List<String>{ 'param' }, new List<Object>{ valueParameter });
    Assert.areEqual(new List<Object>{ valueParameter }, result);
    Assert.isTrue(valueParameter === result[0]);

    final Object secondResult = sut.call(new List<Type>{ String.class }, new List<String>{ 'param' }, new List<Object>{ 'str' });
    Assert.isNull(secondResult);
  }

  @isTest
  static void givenSpyConfiguredWithBehaviorTimes_whenCalled_thenExecuteTheBehaviorTimes() {
    // Arrange
    MethodSpy sut = new MethodSpy('methodName');
    sut.mockImplementation(new ReturnParam(), 2);
    final String valueParameter = 'str';

    // Act
    final List<Object> result = (List<Object>) sut.call(new List<Type>{ String.class }, new List<String>{ 'param' }, new List<Object>{ valueParameter });
    Assert.areEqual(new List<Object>{ valueParameter }, result);
    Assert.isTrue(valueParameter === result[0]);

    Object secondResult = sut.call(new List<Type>{ String.class }, new List<String>{ 'param' }, new List<Object>{ 'str' });
    Assert.areEqual(new List<Object>{ valueParameter }, secondResult);

    secondResult = sut.call(new List<Type>{ String.class }, new List<String>{ 'param' }, new List<Object>{ 'str' });
    Assert.isNull(secondResult);
  }

  @isTest
  static void givenSpyConfiguredWithMatcherWithBehaviorTimes_whenCalledWithMatching_thenExecuteTheBehaviorTimes() {
    // Arrange
    MethodSpy sut = new MethodSpy('methodName');
    sut.whenCalledWith('str').thenMockImplementation(new ReturnParam(), 2);
    final String valueParameter = 'str';

    // Act
    final List<Object> result = (List<Object>) sut.call(new List<Type>{ String.class }, new List<String>{ 'param' }, new List<Object>{ valueParameter });
    Assert.areEqual(new List<Object>{ valueParameter }, result);
    Assert.isTrue(valueParameter === result[0]);

    Object secondResult = sut.call(new List<Type>{ String.class }, new List<String>{ 'param' }, new List<Object>{ 'str' });

    secondResult = sut.call(new List<Type>{ String.class }, new List<String>{ 'param' }, new List<Object>{ 'str' });
    Assert.isNull(secondResult);
  }

  @isTest
  static void givenSpyConfiguredWithMutatingBehavior_whenCalledWithObjectAndUpdateAttribute_thenObjectAttributeIsMutated() {
    // Arrange
    MethodSpy sut = new MethodSpy('methodName');
    final Person aPerson = new Person('Name');
    sut.mockImplementation(new MutateParam());

    // Act
    sut.call(new List<Type>{ String.class }, new List<String>{ 'param' }, new List<Object>{ aPerson });

    // Assert
    Assert.areEqual('Mutated Name', aPerson.name);
  }

  class MutateParam implements MethodSpy.ConfiguredBehavior {
    public Object apply(final List<Object> params) {
      final Person aPerson = (Person) params[0];
      aPerson.name = 'Mutated ' + aPerson.name;
      return null;
    }
  }

  class Person {
    public String name { get; set; }
    public Person(final String name) {
      this.name = name;
    }
  }
}
