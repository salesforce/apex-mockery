/*
 * Copyright (c) 2022, salesforce.com, inc.
 * All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * For full license text, see the LICENSE file in the repo root or https://opensource.org/licenses/BSD-3-Clause
 */
@IsTest
private class ParameterizedMethodSpyCallTest {
  @IsTest
  static void givenTwoIdenticalListByRef_matchesReturnsTrue() {
    // Arrange
    final List<String> objects = new List<String>{ 'test' };
    final ParameterizedMethodSpyCall sut = new ParameterizedMethodSpyCall(
      objects
    );

    // Act
    final boolean result = sut.matches(objects);

    // Assert
    System.assertEquals(
      true,
      result,
      'identical list by reference should match'
    );
  }

  @IsTest
  static void givenTwoIdenticalListByValue_matchesReturnsTrue() {
    // Arrange
    final List<String> objects = new List<String>{ 'test' };
    final ParameterizedMethodSpyCall sut = new ParameterizedMethodSpyCall(
      objects
    );

    // Act
    final boolean result = sut.matches(new List<String>{ 'test' });

    // Assert
    System.assertEquals(true, result, 'identical list by content should match');
  }

  @IsTest
  static void givenTwoDifferentList_matchesReturnsFalse() {
    // Arrange
    final List<String> objects = new List<String>{ 'test' };
    final ParameterizedMethodSpyCall sut = new ParameterizedMethodSpyCall(
      objects
    );

    // Act
    final boolean result = sut.matches(new List<String>{ 'anothertest' });

    // Assert
    System.assertEquals(false, result, 'different list should not match');
  }

  @IsTest
  static void givenTwoListWithOneDifferentElement_matchesReturnsFalse() {
    // Arrange
    final List<String> objects = new List<String>{
      'test',
      'another test',
      'yet another test'
    };
    final ParameterizedMethodSpyCall sut = new ParameterizedMethodSpyCall(
      objects
    );

    // Act
    final boolean result = sut.matches(
      new List<String>{ 'test', 'anothertest', 'yet another test' }
    );

    // Assert
    System.assertEquals(false, result, 'different list should not match');
  }

  @IsTest
  static void givenTwoIdenticalCustomApexList_matchesReturnsTrue() {
    // Arrange
    final List<CustomApex> objects = new List<CustomApex>{
      new CustomApex('test')
    };
    final ParameterizedMethodSpyCall sut = new ParameterizedMethodSpyCall(
      objects
    );

    // Act
    final boolean result = sut.matches(objects);

    // Assert
    System.assertEquals(
      true,
      result,
      'custom apex identical list should match'
    );
  }

  @IsTest
  static void givenTwoIdenticalCustomApexListWithEquals_matchesReturnsTrue() {
    // Arrange
    final ParameterizedMethodSpyCall sut = new ParameterizedMethodSpyCall(
      new List<CustomApexWithEquals>{ new CustomApexWithEquals('test') }
    );

    // Act
    final boolean result = sut.matches(
      new List<CustomApexWithEquals>{ new CustomApexWithEquals('test') }
    );

    // Assert
    System.assertEquals(
      true,
      result,
      'custom apex identical list should match'
    );
  }

  @IsTest
  static void givenTwoIdenticalCustomApexListWithoutEquals_matchesReturnsFalse() {
    // Arrange
    final List<CustomApex> objects = new List<CustomApex>{
      new CustomApex('test')
    };
    final ParameterizedMethodSpyCall sut = new ParameterizedMethodSpyCall(
      objects
    );

    // Act
    final boolean result = sut.matches(
      new List<CustomApex>{ new CustomApex('test') }
    );

    // Assert
    System.assertEquals(
      false,
      result,
      'custom apex identical list should match'
    );
  }

  @IsTest
  static void givenTwoDifferentCustomApexList_matchesReturnsFalse() {
    // Arrange
    final List<CustomApex> objects = new List<CustomApex>{
      new CustomApex('test')
    };
    final ParameterizedMethodSpyCall sut = new ParameterizedMethodSpyCall(
      objects
    );

    // Act
    final boolean result = sut.matches(
      new List<CustomApex>{ new CustomApex('anothertest') }
    );

    // Assert
    System.assertEquals(
      false,
      result,
      'custom apex different list should not match'
    );
  }

  @IsTest
  static void givenTwoIdenticalNotSerializableTypeList_matchesReturnsTrue() {
    // Arrange
    final List<NotSerializableCustomApex> objects = new List<NotSerializableCustomApex>{
      new NotSerializableCustomApex()
    };
    final ParameterizedMethodSpyCall sut = new ParameterizedMethodSpyCall(
      objects
    );

    // Act
    final boolean result = sut.matches(objects);

    // Assert
    System.assertEquals(
      true,
      result,
      'not serializable identical list should match'
    );
  }

  @IsTest
  static void givenTwoDifferentNotSerializableTypeList_matchesReturnsFalse() {
    // Arrange
    final List<NotSerializableCustomApex> objects = new List<NotSerializableCustomApex>{
      new NotSerializableCustomApex()
    };
    final ParameterizedMethodSpyCall sut = new ParameterizedMethodSpyCall(
      objects
    );

    // Act
    final boolean result = sut.matches(
      new List<NotSerializableCustomApex>{ new NotSerializableCustomApex() }
    );

    // Assert
    System.assertEquals(
      false,
      result,
      'not serializable different list should not match'
    );
  }

  @IsTest
  static void givenAnObject_thenReturnSetsValueAttributeWithIt() {
    // Arrange
    final String value = 'test';
    final ParameterizedMethodSpyCall sut = new ParameterizedMethodSpyCall(null);

    // Act
    sut.thenReturn(value);

    // Assert
    System.assertEquals(
      value,
      sut.value,
      'value attribute should be set by thenReturn method call'
    );
  }

  @IsTest
  static void givenAnObject_thenThrowSetsErrorAttributeWithIt() {
    // Arrange
    final ParameterizedMethodSpyCall sut = new ParameterizedMethodSpyCall(null);
    final Exception expectedException = new IllegalArgumentException(
      'test exception'
    );

    // Act
    sut.thenThrow(expectedException);

    // Assert
    System.assertEquals(
      expectedException.getMessage(),
      sut.error.getMessage(),
      'error attribute should be set by thenThrow method call'
    );
  }

  @IsTest
  static void givenAnObject_thenThrowSetShouldThrow() {
    // Arrange
    final ParameterizedMethodSpyCall sut = new ParameterizedMethodSpyCall(null);
    final Exception expectedException = new IllegalArgumentException(
      'test exception'
    );
    sut.thenThrow(expectedException);

    // Act
    final Boolean shouldThrow = sut.shouldThrow();

    // Assert
    System.assert(
      shouldThrow,
      'shouldThrow should be true because an error is configured'
    );
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
}
