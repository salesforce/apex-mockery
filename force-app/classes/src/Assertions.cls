/*
 * Copyright (c) 2022, salesforce.com, inc.
 * All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * For full license text, see the LICENSE file in the repo root or https://opensource.org/licenses/BSD-3-Clause
 */
@IsTest
public class Assertions {
  public interface ParametersMatcher {
    void assertMatches(List<Object> actualParams);
  }

  public class MockAssert {
    private Mock mock;

    private MockAssert(Mock mock) {
      this.mock = mock;
    }

    public MethodSpyAssert method(final String methodName) {
      final MethodSpy aSpy = this.mock.getSpy(methodName);
      if (aSpy == null) {
        System.assert(false, 'No spy declared for method ' + methodName);
      }
      return new MethodSpyAssert(aSpy);
    }
  }

  public class MethodSpyAssert {
    private MethodSpy spy;

    private MethodSpyAssert(MethodSpy spy) {
      this.spy = spy;
    }

    public void hasNotBeenCalled() {
      System.assertEquals(
        false,
        spy.hasBeenCalled(),
        'Method ' +
        spy.methodName +
        ' was called'
      );
    }

    public void hasBeenCalled() {
      System.assertEquals(
        true,
        spy.hasBeenCalled(),
        'Method ' +
        spy.methodName +
        ' was not called'
      );
    }

    public void hasBeenCalledWith(Object params) {
      this.hasBeenCalledWith(new List<Object>{ params });
    }

    public void hasBeenCalledWith(ParametersMatcher matcher) {
      System.assertNotEquals(
        null,
        spy.getLastCallParams(),
        'Method ' +
        spy.methodName +
        ' was not called'
      );
      matcher.assertMatches(spy.getLastCallParams());
    }

    public void hasBeenCalledWith(List<Object> params) {
      System.assertNotEquals(
        null,
        spy.getLastCallParams(),
        'Method ' +
        spy.methodName +
        ' was not called'
      );
      System.assertEquals(params, spy.getLastCallParams());
    }
  }

  public class SObjectAssert {
    private SObject value;

    private SObjectAssert(SObject value) {
      this.value = value;
    }

    public void is(SObject otherValue) {
      if (otherValue == null) {
        System.assertEquals(null, value);
        return;
      }
      System.assertEquals(
        otherValue.getSObjectType(),
        value.getSObjectType(),
        'sobjects should have the same type'
      );
      System.assertEquals(
        otherValue.getPopulatedFieldsAsMap(),
        value.getPopulatedFieldsAsMap(),
        'sobjects should have same field values'
      );
    }
  }

  public static SObjectAssert assertThat(SObject value) {
    return new SObjectAssert(value);
  }

  public static MethodSpyAssert assertThat(MethodSpy spy) {
    return new MethodSpyAssert(spy);
  }

  public static MockAssert assertThat(Mock mock) {
    return new MockAssert(mock);
  }
}
