/*
 * Copyright (c) 2022, salesforce.com, inc.
 * All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * For full license text, see the LICENSE file in the repo root or https://opensource.org/licenses/BSD-3-Clause
 */
@isTest
public class OperaPastryMatcher implements Argument.Matcher {
  public Boolean matches(Object callArgument) {
    Pastry p = (Pastry) callArgument;
    return p.name == 'Opera';
  }
}
