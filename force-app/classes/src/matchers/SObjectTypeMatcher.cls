/*
 * Copyright (c) 2022, salesforce.com, inc.
 * All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * For full license text, see the LICENSE file in the repo root or https://opensource.org/licenses/BSD-3-Clause
 */
@isTest
public class SObjectTypeMatcher implements ArgumentMatcher {
  private SObjectType matchingType;

  public SObjectTypeMatcher(final SObjectType matchingType) {
    this.matchingType = matchingType;
  }

  public boolean matches(final Object callArgument) {
    SObject sob = (SObject) callArgument;
    return this.matchingType == sob.getsObjectType();
  }
}
