/*
 * Copyright (c) 2022, salesforce.com, inc.
 * All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * For full license text, see the LICENSE file in the repo root or https://opensource.org/licenses/BSD-3-Clause
 */
@IsTest
private class ParamsTest {
  @isTest
  static void givenNothing_whenOfIsCalled_matchesEmptyList() {
    // Arrange
    Params sut = Params.empty();

    // Act
    Boolean result = sut.matches(new List<Object>());

    // Assert
    Assert.isTrue(result);
  }

  @isTest
  static void given1Object_whenOfIsCalled_matchesTheElement() {
    // Arrange
    Params sut = Params.of('test');

    // Act
    Boolean result = sut.matches(new List<Object>{ 'test' });

    // Assert
    Assert.isTrue(result);
  }

  @isTest
  static void given2Objects_whenOfIsCalled_matchesElementsInOrder() {
    // Arrange
    Params sut = Params.of('test', 10);

    // Act
    Boolean positive = sut.matches(new List<Object>{ 'test', 10 });
    Boolean negative = sut.matches(new List<Object>{ 10, 'test' });

    // Assert
    Assert.isTrue(positive);
    Assert.isFalse(negative);
  }

  @isTest
  static void given3Objects_whenOfIsCalled_matchesElementsInOrder() {
    // Arrange
    Params sut = Params.of('test', 10, new Account());

    // Act
    Boolean positive = sut.matches(new List<Object>{ 'test', 10, new Account() });
    Boolean negative = sut.matches(new List<Object>{ 10, 'test', new Account() });

    // Assert
    Assert.isTrue(positive);
    Assert.isFalse(negative);
  }

  @isTest
  static void given4Objects_whenOfIsCalled_matchesElementsInOrder() {
    // Arrange
    Params sut = Params.of('test', 10, new Account(), new List<Date>());

    // Act
    Boolean positive = sut.matches(new List<Object>{ 'test', 10, new Account(), new List<Date>() });
    Boolean negative = sut.matches(new List<Object>{ 10, 'test', new Account(), new List<Date>() });

    // Assert
    Assert.isTrue(positive);
    Assert.isFalse(negative);
  }

  @isTest
  static void given5Objects_whenOfIsCalled_matchesElementsInOrder() {
    // Arrange
    Params sut = Params.of('test', 10, new Account(), new List<Date>(), new Map<Id, Set<String>>());

    // Act
    Boolean positive = sut.matches(new List<Object>{ 'test', 10, new Account(), new List<Date>(), new Map<Id, Set<String>>() });
    Boolean negative = sut.matches(new List<Object>{ 10, 'test', new Account(), new List<Date>(), new Map<Id, Set<String>>() });

    // Assert
    Assert.isTrue(positive);
    Assert.isFalse(negative);
  }

  @isTest
  static void givenListOf10MixType_whenOfListIsCalledWithList_matchesElementsInOrder() {
    // Arrange
    Params sut = Params.ofList(
      new List<Object>{
        AMatcher.equals('test'),
        AMatcher.equals(10),
        AMatcher.jsonEquals(new Account()),
        AMatcher.ofType('List'),
        new Map<Id, Set<String>>(),
        new Set<Date>(),
        new List<Account>(),
        Blob.valueOf('test'),
        new CustomMatcher(),
        AMatcher.ofType(CustomType.class)
      }
    );

    // Act
    Boolean positive = sut.matches(
      new List<Object>{
        'test',
        10,
        new Account(),
        new List<Date>(),
        new Map<Id, Set<String>>(),
        new Set<Date>(),
        new List<Account>(),
        Blob.valueOf('test'),
        'test',
        new CustomType()
      }
    );
    Boolean negative = sut.matches(new List<Object>{ 10, 'test', new Account(), new List<Date>(), new Map<Id, Set<String>>() });

    // Assert
    Assert.isTrue(positive);
    Assert.isFalse(negative);
  }

  @isTest
  static void whenOfListIsCalledWithNull_matchesEmptyList() {
    // Act
    Params sut = Params.ofList(null);

    // Act
    Boolean result = sut.matches(new List<Object>());

    // Assert
    Assert.isTrue(result);
  }

  class CustomMatcher implements AMatcher.ArgumentMatcher {
    public Boolean matches(Object callArgument) {
      return true;
    }
  }

  class CustomType {
  }
}
