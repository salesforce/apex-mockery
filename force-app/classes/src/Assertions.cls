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
        buildErrorMessage(this.spy, ErrorMessageType.CALLED)
      );
    }

    public void hasBeenCalled() {
      this.asserter.assertEquals(
        true,
        this.spy.hasBeenCalled(),
        buildErrorMessage(this.spy, ErrorMessageType.NEVER_CALLED)
      );
    }

    public void hasBeenCalledTimes(final Integer count) {
      this.asserter.assertEquals(
        true,
        this.spy.hasBeenCalledTimes(count),
        buildErrorMessage(this.spy, ErrorMessageType.NOT_CALLED_TIMES, count)
      );
    }

    public void hasBeenCalledWith(final Params params) {
      this.asserter.assertEquals(
        true,
        this.spy.hasBeenCalled(),
        buildErrorMessage(this.spy, ErrorMessageType.NEVER_CALLED)
      );
      this.asserter.assertEquals(
        true,
        this.spy.hasBeenCalledWith(params),
        buildErrorMessage(this.spy, ErrorMessageType.NOT_CALLED_WITH, params)
      );
    }

    public void hasBeenLastCalledWith(final Params params) {
      this.asserter.assertEquals(
        true,
        this.spy.hasBeenCalled(),
        buildErrorMessage(this.spy, ErrorMessageType.NEVER_CALLED)
      );
      this.asserter.assertEquals(
        true,
        this.spy.hasBeenLastCalledWith(params),
        buildErrorMessage(
          this.spy,
          ErrorMessageType.NOT_LAST_CALLED_WITH,
          params
        )
      );
    }
  }

  public static MethodSpyAssert assertThat(MethodSpy spy) {
    return new MethodSpyAssert(spy);
  }

  private enum ErrorMessageType {
    CALLED,
    NEVER_CALLED,
    NOT_CALLED_WITH,
    NOT_LAST_CALLED_WITH,
    NOT_CALLED_TIMES
  }

  private class ErrorMessageRow {
    protected String message;
    protected Boolean tabbed;

    ErrorMessageRow(String message) {
      this(message, false);
    }
    ErrorMessageRow(String message, Boolean tabbed) {
      this.message = message;
      this.tabbed = tabbed;
    }
  }

  private class ErrorMessage {
    private String headline;
    private List<ErrorMessageRow> callTraces;
    ErrorMessage(MethodSpy spy, ErrorMessageType error) {
      this(spy, error, null);
    }
    ErrorMessage(MethodSpy spy, ErrorMessageType error, Object argument) {
      this.headline = this.buildHeadline(spy, error, argument);
      this.callTraces = this.buildCallTraces(spy);
    }

    private String buildHeadline(
      MethodSpy spy,
      ErrorMessageType error,
      Object argument
    ) {
      final Map<ErrorMessageType, String> messages = new Map<ErrorMessageType, String>{
        ErrorMessageType.CALLED => 'Method {0} was called',
        ErrorMessageType.NEVER_CALLED => 'Method {0} was not called',
        ErrorMessageType.NOT_CALLED_WITH => 'Method {0} was not called with {1}',
        ErrorMessageType.NOT_LAST_CALLED_WITH => 'Method {0} was not last called with {1}',
        ErrorMessageType.NOT_CALLED_TIMES => 'Method {0} was not called {1} times'
      };
      return String.format(
        messages.get(error),
        new List<String>{ spy.methodName, argument + '' }
      );
    }

    private List<ErrorMessageRow> buildCallTraces(MethodSpy spy) {
      final List<Params> callLogParams = spy.getCallLogParams();
      if (callLogParams.isEmpty()) {
        return new List<ErrorMessageRow>();
      }

      final List<ErrorMessageRow> rows = new List<ErrorMessageRow>();
      rows.add(new ErrorMessageRow('method call history:'));
      final String template = '#{0} {1}({2})';
      for (Integer i = 0; i < callLogParams.size(); i++) {
        final Params params = callLogParams[i];
        final Integer count = callLogParams.size() - i;
        rows.add(
          new ErrorMessageRow(
            String.format(
              template,
              new List<Object>{ count, spy.methodName, params }
            ),
            true
          )
        );
      }
      return rows;
    }

    override public String toString() {
      final List<String> lines = new List<String>();
      lines.add(this.headline);
      if (!callTraces.isEmpty()) {
        for (ErrorMessageRow row : callTraces) {
          final String prefix = row.tabbed ? '\t' : '';
          final String line = prefix + row.message;
          lines.add(line);
        }
        lines.add('');
      }
      return String.join(lines, '\n');
    }
  }

  private static String buildErrorMessage(
    MethodSpy spy,
    ErrorMessageType error
  ) {
    return new ErrorMessage(spy, error, null).toString();
  }

  private static String buildErrorMessage(
    MethodSpy spy,
    ErrorMessageType error,
    Object argument
  ) {
    return new ErrorMessage(spy, error, argument).toString();
  }
}
