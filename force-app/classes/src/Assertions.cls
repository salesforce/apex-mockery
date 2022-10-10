/*
 * Copyright (c) 2022, salesforce.com, inc.
 * All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * For full license text, see the LICENSE file in the repo root or https://opensource.org/licenses/BSD-3-Clause
 */
@IsTest
public class Assertions {
  public virtual class SystemAsserter {
    public virtual void assertEquals(
      Object expected,
      Object actual,
      String message
    ) {
      System.assertEquals(expected, actual, message);
    }
  }

  public class MethodSpyAssert {
    private MethodSpy spy;
    private SystemAsserter asserter;

    private MethodSpyAssert(MethodSpy spy) {
      this.spy = spy;
      this.asserter = new SystemAsserter();
    }

    @TestVisible
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

    public void hasBeenCalledTimes(final Integer count) {
      this.asserter.assertEquals(
        true,
        this.spy.hasBeenCalledTimes(count),
        'Method ' +
        this.spy.methodName +
        ' was not called ' +
        count +
        ' times'
      );
    }

    public void hasBeenCalledWith(Object params) {
      this.hasBeenCalledWithParams(new List<Object>{ params });
    }

    public void hasBeenCalledWithParams(ParametersMatcher matcher) {
      this.asserter.assertEquals(
        false,
        this.spy.hasBeenCalled(),
        'Method ' +
        this.spy.methodName +
        ' was not called'
      );
      this.asserter.assertEquals(
        true,
        this.spy.hasBeenCalledWith(matcher),
        'Method ' +
        this.spy.methodName +
        ' was not called with matcher'
      );
    }

    public void hasBeenCalledWithParams(List<Object> params) {
      this.asserter.assertEquals(
        true,
        this.spy.hasBeenCalled(),
        'Method ' +
        this.spy.methodName +
        ' was not called'
      );
      this.asserter.assertEquals(
        true,
        this.spy.hasBeenCalledWith(params),
        'Method ' +
        this.spy.methodName +
        ' was not called with ' +
        params
      );
    }

    public void hasBeenLastCalledWith(Object params) {
      this.hasBeenLastCalledWithParams(new List<Object>{ params });
    }

    public void hasBeenLastCalledWithParams(ParametersMatcher matcher) {
      this.asserter.assertEquals(
        false,
        this.spy.hasBeenCalled(),
        'Method ' +
        this.spy.methodName +
        ' was not last called'
      );
      this.asserter.assertEquals(
        true,
        this.spy.hasBeenLastCalledWith(matcher),
        'Method ' +
        this.spy.methodName +
        ' was not last called with matcher'
      );
    }

    public void hasBeenLastCalledWithParams(List<Object> params) {
      this.asserter.assertEquals(
        true,
        this.spy.hasBeenCalled(),
        'Method ' +
        this.spy.methodName +
        ' was not called'
      );
      this.asserter.assertEquals(
        true,
        this.spy.hasBeenLastCalledWith(params),
        'Method ' +
        this.spy.methodName +
        ' was not last called with ' +
        params
      );
    }
  }

  public static MethodSpyAssert assertThat(MethodSpy spy) {
    return new MethodSpyAssert(spy);
  }
}
