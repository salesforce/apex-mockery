/*
 * Copyright (c) 2022, salesforce.com, inc.
 * All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * For full license text, see the LICENSE file in the repo root or https://opensource.org/licenses/BSD-3-Clause
 */

/**
 * MethodSpy represents an apex method spy on which you can register some value to be returned
 *
 *  - always return the same value using spy.returns(value)
 *  - return value based on calling arguments list
 *        spy.whenCalledWith(param).thenReturn(value)
 *        spy.whenCalledWith(new List<Object>{param1, param2}).thenReturn(value)
 *    note: the matching algorithm is currently based on equality (equals method or reference comparison)
 *
 */
@IsTest
private class MethodSpyTest {
}
