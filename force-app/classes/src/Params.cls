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

  public void add(final Object callArgument) {
    if (callArgument instanceof ArgumentMatcher) {
      this.listOfArgs.add((ArgumentMatcher) callArgument);
    } else {
      this.listOfArgs.add(Matcher.equals(callArgument));
    }
  }

  public static Params args() {
    return new Params();
  }

  public static Params args(final Object arg) {
    final Params params = args();
    params.add(arg);
    return params;
  }

  public static Params args(final Object arg1, final Object arg2) {
    final Params params = args(arg1);
    params.add(arg2);
    return params;
  }

  public static Params args(
    final Object arg1,
    final Object arg2,
    final Object arg3
  ) {
    final Params params = args(arg1, arg2);
    params.add(arg3);
    return params;
  }

  public static Params args(
    final Object arg1,
    final Object arg2,
    final Object arg3,
    final Object arg4
  ) {
    final Params params = args(arg1, arg2, arg3);
    params.add(arg4);
    return params;
  }

  public static Params args(
    final Object arg1,
    final Object arg2,
    final Object arg3,
    final Object arg4,
    final Object arg5
  ) {
    final Params params = args(arg1, arg2, arg3, arg4);
    params.add(arg5);
    return params;
  }

  public static Params fromList(final List<Object> listOfArgs) {
    final Params params = args();
    for (Object callArgument : listOfArgs) {
      params.add(callArgument);
    }
    return params;
  }
}