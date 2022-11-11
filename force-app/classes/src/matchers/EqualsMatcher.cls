/*
 * Copyright (c) 2022, salesforce.com, inc.
 * All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * For full license text, see the LICENSE file in the repo root or https://opensource.org/licenses/BSD-3-Clause
 */
@isTest
public class EqualsMatcher implements ArgumentMatcher {
  private Object callArgumentToMatch;

  public EqualsMatcher(final Object callArgumentToMatch) {
    this.callArgumentToMatch = callArgumentToMatch;
  }

  public Boolean matches(final Object callArgument) {
    return callArgument == this.callArgumentToMatch;
  }
}
