/*
 * Copyright (c) 2022, salesforce.com, inc.
 * All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * For full license text, see the LICENSE file in the repo root or https://opensource.org/licenses/BSD-3-Clause
 */
@isTest
public class SystemTypeMatcher implements ArgumentMatcher {
  private System.Type matchingType;

  public SystemTypeMatcher(final System.Type matchingType) {
    this.matchingType = matchingType;
  }

  public boolean matches(final Object callArgument) {
    String typeName = String.valueOf(callArgument).split(':')[0];
    Type actualType = Type.forName(typeName);
    return this.matchingType.isAssignableFrom(actualType);
  }
}
