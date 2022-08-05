/*
 * Copyright (c) 2022, salesforce.com, inc.
 * All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * For full license text, see the LICENSE file in the repo root or https://opensource.org/licenses/BSD-3-Clause
 */
@IsTest
private class MethodSpyTest {
  // Integration Test
  // **************** */
  // when calling`returns`, then `call`, assert return value
  // when calling `returns` multiple time, `call` return the last one

  // when calling `throwsException`, then `call`, assert what is throwed
  // when calling `throwsException` multiple time, `call` throws the last one

  // when calling `whenCalledWith`, then `call`, assert matcher has been used
  // when calling `whenCalledWith` multiple time, `call` assert matchers has been used

  // when calling `whenCalledWithParams`, then `call`, assert matcher has been used
  // when calling `whenCalledWithParams` multiple time, `call` assert matchers has been used

  // when calling `call`, without stub, it should throw IllegalArgumentException
  // when calling `call`, with a non matching ParameterizedMethodSpyCall, it should throw IllegalArgumentException
  // when calling `call`, with ParameterizedMethodSpyCall and then a Return value, it should return return Value
  // when calling `call`, with a Return Value and then ParameterizedMethodSpyCall, it should return ParameterizedMethodSpyCall matching value

  // Unit Test
  // ************** */
  // when calling `call` with params, getlastCallParams should return those params
  // when calling `call` with null params, getlastCallParams should return null
  // when calling `getlastCallParams` without calling `call` it should return null

  // when calling `call`, hasBeenCalled returns true and hasBeenCalledTimes(1) returns true (0) returns false (2) returns false
  // when calling `call` n times, hasBeenCalled returns true and hasBeenCalledTimes(n) returns true (n-1) returns false (n+1) returns false
  // when not calling `call` n times, hasBeenCalled returns false and hasBeenCalledTimes(0) returns true (1) returns false (-1) returns false

  // Test E2E
  /* ************** 
 MethodSpy

    .returns("toto");
    .throwsException(E); // Or throw configuration error ?
    .call(1) -> "toto"
    .call(n) -> "toto"

    .returns("toto");
    .whenCalledWith(1).thenReturn("titi");
    .whenCalledWith(2).thenReturn("tutu");
    .call(1) -> "titi"
    .call(2) -> "tutu"
    .call(3) -> "toto"


    .whenCalledWith(1).thenReturn("titi");
    .whenCalledWith(2).thenReturn("tutu");
    .returns("toto");
    .call(1) -> "titi"
    .call(2) -> "tutu"
    .call(3) -> "toto"

    .throwsException(E);
    .whenCalledWith(1).thenReturn("titi");
    .whenCalledWith(2).thenReturn("tutu");
    .call(1) -> "titi"
    .call(2) -> "tutu"
    .call(3) -> throws E

    .whenCalledWith(1).thenReturn("titi");
    .whenCalledWith(2).thenReturn("tutu");
    .throwsException(E);
    .call(1) -> "titi"
    .call(2) -> "tutu"
    .call(3) -> throws E

    
    .returns("toto");
    .whenCalledWith(1).thenThrows(E1);
    .whenCalledWith(2).thenThrows(E2);
    .call(1) -> throws E1
    .call(2) -> throws E2
    .call(3) -> "toto"
    */
}
