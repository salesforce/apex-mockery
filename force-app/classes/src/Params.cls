/*
 * Copyright (c) 2022, salesforce.com, inc.
 * All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * For full license text, see the LICENSE file in the repo root or https://opensource.org/licenses/BSD-3-Clause
 */
@IsTest
public class Params {
  public List<ArgumentMatcher> listOfArgs { get; private set; }

  private Params() {
    this.listOfArgs = new List<ArgumentMatcher>();
  }

  private Params(List<Object> callArguments) {
    final List<ArgumentMatcher> listOfArgs = new List<ArgumentMatcher>();
    for (Object callArgument : callArguments) {
      if (callArgument instanceof ArgumentMatcher) {
        listOfArgs.add((ArgumentMatcher) callArgument);
      } else {
        listOfArgs.add(Matcher.equals(callArgument));
      }
    }
    this.listOfArgs = listOfArgs;
  }

  override public String toString() {
    return '[' + listOfArgs + ']';
  }

  public static Params empty() {
    return new Params();
  }

  public static Params of(final Object arg) {
    return new Params(new List<Object>{ arg });
  }

  public static Params of(final Object arg1, final Object arg2) {
    return new Params(new List<Object>{ arg1, arg2 });
  }

  public static Params of(
    final Object arg1,
    final Object arg2,
    final Object arg3
  ) {
    return new Params(new List<Object>{ arg1, arg2, arg3 });
  }

  public static Params of(
    final Object arg1,
    final Object arg2,
    final Object arg3,
    final Object arg4
  ) {
    return new Params(new List<Object>{ arg1, arg2, arg3, arg4 });
  }

  public static Params of(
    final Object arg1,
    final Object arg2,
    final Object arg3,
    final Object arg4,
    final Object arg5
  ) {
    return new Params(new List<Object>{ arg1, arg2, arg3, arg4, arg5 });
  }

  public static Params ofList(final List<Object> listOfArgs) {
    if (listOfArgs == null) {
      return Params.empty();
    }
    return new Params(listOfArgs);
  }
}
