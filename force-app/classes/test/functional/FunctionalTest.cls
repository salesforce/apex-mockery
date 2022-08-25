/*
 * Copyright (c) 2022, salesforce.com, inc.
 * All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * For full license text, see the LICENSE file in the repo root or https://opensource.org/licenses/BSD-3-Clause
 */
@IsTest
private class FunctionalTest {
  @isTest
  static void givenASpy_andAMethodWithOneParameterReturningVoid_itShouldStub() {
    // Arrange
    final Mock dmlDelegateMock = Mock.forType(DMLDelegate.class);
    final MethodSpy insertSObjectSpy = dmlDelegateMock.spyOn('insertSObject');
    final AccountService sut = new AccountService(
      (DMLDelegate) dmlDelegateMock.stub
    );
    Account expected = new Account();

    // Act
    sut.insertAccount(expected);

    // Assert
    Assertions.assertThat(insertSObjectSpy).hasBeenCalledWith(expected);
  }
}
