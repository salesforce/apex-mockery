/*
 * Copyright (c) 2022, salesforce.com, inc.
 * All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * For full license text, see the LICENSE file in the repo root or https://opensource.org/licenses/BSD-3-Clause
 */
@IsTest
public class Params {
  private List<Matcher.ArgumentMatcher> listOfArgs;

  private Params() {
    this.listOfArgs = new List<Matcher.ArgumentMatcher>();
  }

  private Params(final List<Object> callArguments) {
    this();
    for (Object callArgument : callArguments) {
      if (callArgument instanceof Matcher.ArgumentMatcher) {
        this.listOfArgs.add((Matcher.ArgumentMatcher) callArgument);
      } else {
        this.listOfArgs.add(Matcher.equals(callArgument));
      }
    }
  }

  public boolean matches(final List<Object> callArguments) {
    if (this.listOfArgs.size() != callArguments?.size()) {
      return false;
    }

    for (Integer i = 0; i < this.listOfArgs.size(); ++i) {
      if (!this.listOfArgs[i].matches(callArguments[i])) {
        return false;
      }
    }

    return true;
  }

  public override String toString() {
    return this.listOfArgs + '';
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

  public static Params of(final Object arg1, final Object arg2, final Object arg3) {
    return new Params(new List<Object>{ arg1, arg2, arg3 });
  }

  public static Params of(final Object arg1, final Object arg2, final Object arg3, final Object arg4) {
    return new Params(new List<Object>{ arg1, arg2, arg3, arg4 });
  }

  public static Params of(final Object arg1, final Object arg2, final Object arg3, final Object arg4, final Object arg5) {
    return new Params(new List<Object>{ arg1, arg2, arg3, arg4, arg5 });
  }

  public static Params ofList(final List<Object> listOfArgs) {
    if (listOfArgs == null) {
      return Params.empty();
    }
    return new Params(listOfArgs);
  }
}
