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
    final Params sut = Params.empty();

    // Act
    final Boolean result = sut.matches(new List<Object>());

    // Assert
    Assert.isTrue(result);
  }

  @isTest
  static void given1Object_whenOfIsCalled_matchesTheElement() {
    // Arrange
    final Params sut = Params.of('test');

    // Act
    final Boolean result = sut.matches(new List<Object>{ 'test' });

    // Assert
    Assert.isTrue(result);
  }

  @isTest
  static void given2Objects_whenOfIsCalled_matchesElementsInOrder() {
    // Arrange
    final Params sut = Params.of('test', 10);

    // Act
    final Boolean positive = sut.matches(new List<Object>{ 'test', 10 });
    final Boolean negative = sut.matches(new List<Object>{ 10, 'test' });

    // Assert
    Assert.isTrue(positive);
    Assert.isFalse(negative);
  }

  @isTest
  static void given3Objects_whenOfIsCalled_matchesElementsInOrder() {
    // Arrange
    final Params sut = Params.of('test', 10, new Account());

    // Act
    final Boolean positive = sut.matches(new List<Object>{ 'test', 10, new Account() });
    final Boolean negative = sut.matches(new List<Object>{ 10, 'test', new Account() });

    // Assert
    Assert.isTrue(positive);
    Assert.isFalse(negative);
  }

  @isTest
  static void given4Objects_whenOfIsCalled_matchesElementsInOrder() {
    // Arrange
    final Params sut = Params.of('test', 10, new Account(), new List<Date>());

    // Act
    final Boolean positive = sut.matches(new List<Object>{ 'test', 10, new Account(), new List<Date>() });
    final Boolean negative = sut.matches(new List<Object>{ 10, 'test', new Account(), new List<Date>() });

    // Assert
    Assert.isTrue(positive);
    Assert.isFalse(negative);
  }

  @isTest
  static void given5Objects_whenOfIsCalled_matchesElementsInOrder() {
    // Arrange
    final Params sut = Params.of('test', 10, new Account(), new List<Date>(), new Map<Id, Set<String>>());

    // Act
    final Boolean positive = sut.matches(new List<Object>{ 'test', 10, new Account(), new List<Date>(), new Map<Id, Set<String>>() });
    final Boolean negative = sut.matches(new List<Object>{ 10, 'test', new Account(), new List<Date>(), new Map<Id, Set<String>>() });

    // Assert
    Assert.isTrue(positive);
    Assert.isFalse(negative);
  }

  @isTest
  static void givenListOf10MixType_whenOfListIsCalledWithList_matchesElementsInOrder() {
    // Arrange
    final Params sut = Params.ofList(
      new List<Object>{
        Matcher.equals('test'),
        Matcher.equals(10),
        Matcher.jsonEquals(new Account()),
        Matcher.ofType('List'),
        new Map<Id, Set<String>>(),
        new Set<Date>(),
        new List<Account>(),
        Blob.valueOf('test'),
        new CustomMatcher(),
        Matcher.ofType(CustomType.class)
      }
    );

    // Act
    final Boolean positive = sut.matches(
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
    final Boolean negative = sut.matches(new List<Object>{ 10, 'test', new Account(), new List<Date>(), new Map<Id, Set<String>>() });

    // Assert
    Assert.isTrue(positive);
    Assert.isFalse(negative);
  }

  @isTest
  static void whenOfListIsCalledWithNull_matchesEmptyList() {
    // Act
    final Params sut = Params.ofList(null);

    // Act
    final Boolean result = sut.matches(new List<Object>());

    // Assert
    Assert.isTrue(result);
  }

  class CustomMatcher implements Matcher.ArgumentMatcher {
    public Boolean matches(Object callArgument) {
      return true;
    }
  }

  class CustomType {
  }
}
