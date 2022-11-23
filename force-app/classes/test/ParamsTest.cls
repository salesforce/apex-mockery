/*
 * Copyright (c) 2022, salesforce.com, inc.
 * All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * For full license text, see the LICENSE file in the repo root or https://opensource.org/licenses/BSD-3-Clause
 */
@IsTest
private class ParamsTest {
  @isTest
  static void givenNothing_whenOfIsCalled_listOfArgsContains0Element() {
    // Arrange
    Params sut;

    // Act
    sut = Params.empty();

    // Assert
    System.assertEquals(0, sut.listOfArgs.size());
  }

  @isTest
  static void given1Object_whenOfIsCalled_listOfArgsContains1Element() {
    // Arrange
    Params sut;

    // Act
    sut = Params.of('test');

    // Assert
    System.assertEquals(1, sut.listOfArgs.size());
    assertListOfArgsElementsAreArgumentMatcher(sut);
  }

  @isTest
  static void given2Objects_whenOfIsCalled_listOfArgsContains2Elements() {
    // Arrange
    Params sut;

    // Act
    sut = Params.of('test', 10);

    // Assert
    System.assertEquals(2, sut.listOfArgs.size());
    assertListOfArgsElementsAreArgumentMatcher(sut);
  }

  @isTest
  static void given3Objects_whenOfIsCalled_listOfArgsContains3Elements() {
    // Arrange
    Params sut;

    // Act
    sut = Params.of('test', 10, new Account());

    // Assert
    System.assertEquals(3, sut.listOfArgs.size());
    assertListOfArgsElementsAreArgumentMatcher(sut);
  }

  @isTest
  static void given4Objects_whenOfIsCalled_listOfArgsContains4Elements() {
    // Arrange
    Params sut;

    // Act
    sut = Params.of('test', 10, new Account(), new List<Date>());

    // Assert
    System.assertEquals(4, sut.listOfArgs.size());
    assertListOfArgsElementsAreArgumentMatcher(sut);
  }

  @isTest
  static void given5Objects_whenOfIsCalled_listOfArgsContains5Elements() {
    // Arrange
    Params sut;

    // Act
    sut = Params.of(
      'test',
      10,
      new Account(),
      new List<Date>(),
      new Map<Id, Set<String>>()
    );

    // Assert
    System.assertEquals(5, sut.listOfArgs.size());
    assertListOfArgsElementsAreArgumentMatcher(sut);
  }

  @isTest
  static void givenListOf10MixType_whenOfIsCalledWithList_listOfArgsContains10Elements() {
    // Arrange
    Params sut;

    // Act
    sut = Params.ofList(
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

    // Assert
    System.assertEquals(10, sut.listOfArgs.size());
    assertListOfArgsElementsAreArgumentMatcher(sut);
  }

  @isTest
  static void givenAParam_whenAddIsCalled_listOfArgsContains1ElementMore() {
    // Arrange
    Params sut = Params.empty();

    // Act
    System.assertEquals(0, sut.listOfArgs.size());
    sut.add(Matcher.equals('test'));

    // Assert
    System.assertEquals(1, sut.listOfArgs.size());
    assertListOfArgsElementsAreArgumentMatcher(sut);
  }

  static void assertListOfArgsElementsAreArgumentMatcher(final Params params) {
    for (Object argument : params.listOfArgs) {
      System.assert(argument instanceof ArgumentMatcher);
    }
  }

  class CustomMatcher implements ArgumentMatcher {
    public Boolean matches(Object callArgument) {
      return true;
    }
  }

  class CustomType {
  }
}
