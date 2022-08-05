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

  public virtual class SystemAsserter {
    public void assertEquals(Object expected, Object actual, String message) {
    }

    public void assertNotEquals(
      Object expected,
      Object actual,
      String message
    ) {
    }
  }

  public class MethodSpyAssert {
    private MethodSpy spy;
    private SystemAsserter asserter;

    private MethodSpyAssert(MethodSpy spy) {
      this.spy = spy;
      this.asserter = new SystemAsserter();
    }

    private MethodSpyAssert(MethodSpy spy, SystemAsserter asserter) {
      this.spy = spy;
      this.asserter = asserter;
    }

    public void hasNotBeenCalled() {
      this.asserter.assertEquals(
        false,
        this.spy.hasBeenCalled(),
        'Method ' +
        this.spy.methodName +
        ' was called'
      );
    }

    public void hasBeenCalled() {
      this.asserter.assertEquals(
        true,
        this.spy.hasBeenCalled(),
        'Method ' +
        this.spy.methodName +
        ' was not called'
      );
    }

    public void hasBeenCalledWith(Object params) {
      this.hasBeenCalledWithParams(new List<Object>{ params });
    }

    public void hasBeenCalledWithParams(ParametersMatcher matcher) {
      this.asserter.assertNotEquals(
        null,
        this.spy.getLastCallParams(),
        'Method ' +
        this.spy.methodName +
        ' was not called'
      );
    }

    public void hasBeenCalledWithParams(List<Object> params) {
      this.asserter.assertNotEquals(
        null,
        this.spy.getLastCallParams(),
        'Method ' +
        this.spy.methodName +
        ' was not called'
      );
      this.asserter.assertEquals(
        params,
        this.spy.getLastCallParams(),
        'Method ' +
        this.spy.methodName +
        ' was not called'
      );
    }
  }

  public static MethodSpyAssert assertThat(MethodSpy spy) {
    return new MethodSpyAssert(spy);
  }
}
