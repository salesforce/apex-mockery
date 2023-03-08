/*
 * Copyright (c) 2022, salesforce.com, inc.
 * All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * For full license text, see the LICENSE file in the repo root or https://opensource.org/licenses/BSD-3-Clause
 */
@JsonAccess(serializable='always')
public class Pastry {
  public String name;

  public Pastry(String name) {
    this.name = name;
  }

  public Boolean equals(Object other) {
    if (other instanceof Pastry) {
      Pastry p = (Pastry) other;
      return (p.name == this.name);
    }
    return false;
  }

  public Integer hashCode() {
    return this.name?.hashCode();
  }
}
