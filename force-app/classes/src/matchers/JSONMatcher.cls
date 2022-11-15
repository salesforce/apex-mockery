/*
 * Copyright (c) 2022, salesforce.com, inc.
 * All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * For full license text, see the LICENSE file in the repo root or https://opensource.org/licenses/BSD-3-Clause
 */
@isTest
public class JSONMatcher implements ArgumentMatcher {
  private String expectedJson;

  public JSONMatcher(final Object expectedObject) {
    this.expectedJson = JSON.serialize(expectedObject);
  }

  public boolean matches(final Object callArgument) {
    return this.expectedJson == JSON.serialize(callArgument);
  }
}
