/*
 * Copyright (c) 2022, salesforce.com, inc.
 * All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * For full license text, see the LICENSE file in the repo root or https://opensource.org/licenses/BSD-3-Clause
 */
@IsTest
public class ParameterizedMethodSpyCall {
  private List<Object> params;
  public Object value;

  public ParameterizedMethodSpyCall(List<Object> params) {
    this.params = params;
  }

  public void thenReturn(Object value) {
    this.value = value;
  }

  public boolean matches(List<Object> params) {
    if (this.params == params) {
      return true;
    }
    if (this.params?.size() != params?.size()) {
      return false;
    }
    for (Integer i = 0; i < params.size(); i++) {
      Object expectedParam = this.params.get(i);
      Object actualParam = params.get(i);
      if (actualParam != expectedParam) {
        return false;
      }
    }
    return true;
  }
}
