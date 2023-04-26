/*
 * Copyright (c) 2022, salesforce.com, inc.
 * All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * For full license text, see the LICENSE file in the repo root or https://opensource.org/licenses/BSD-3-Clause
 */
@IsTest
global class Params {
  private List<ParamMatcher.ArgumentMatcher> listOfArgs;

  private Params() {
    this.listOfArgs = new List<ParamMatcher.ArgumentMatcher>();
  }

  private Params(final List<Object> callArguments) {
    this();
    for (Object callArgument : callArguments) {
      if (callArgument instanceof ParamMatcher.ArgumentMatcher) {
        this.listOfArgs.add((ParamMatcher.ArgumentMatcher) callArgument);
      } else {
        this.listOfArgs.add(ParamMatcher.equals(callArgument));
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

  global override String toString() {
    return this.listOfArgs + '';
  }

  global static Params empty() {
    return new Params();
  }

  global static Params of(final Object arg) {
    return new Params(new List<Object>{ arg });
  }

  global static Params of(final Object arg1, final Object arg2) {
    return new Params(new List<Object>{ arg1, arg2 });
  }

  global static Params of(final Object arg1, final Object arg2, final Object arg3) {
    return new Params(new List<Object>{ arg1, arg2, arg3 });
  }

  global static Params of(final Object arg1, final Object arg2, final Object arg3, final Object arg4) {
    return new Params(new List<Object>{ arg1, arg2, arg3, arg4 });
  }

  global static Params of(final Object arg1, final Object arg2, final Object arg3, final Object arg4, final Object arg5) {
    return new Params(new List<Object>{ arg1, arg2, arg3, arg4, arg5 });
  }

  global static Params ofList(final List<Object> listOfArgs) {
    if (listOfArgs == null) {
      return Params.empty();
    }
    return new Params(listOfArgs);
  }
}
