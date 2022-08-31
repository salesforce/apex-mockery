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
    final BusinessService sut = new BusinessService(
      (DMLDelegate) dmlDelegateMock.stub
    );
    Account expected = new Account(NumberOfEmployees = 10);

    // Act
    sut.businessScenario(10);

    // Assert
    Assertions.assertThat(insertSObjectSpy).hasBeenCalledWith(expected);
  }

  // Call multiple time DML Delegate inside the same service
  // Assert it has been called multiple time

  // Call to DMLDelegate without dmlOptions throw an exception
  // Database class definition https://developer.salesforce.com/docs/atlas.en-us.apexref.meta/apexref/apex_methods_system_database.htm#apex_System_Database_insert_5

  // Call to DMLDelegate with dmlOptions partially succeed and we want to evaluate what happen
  // mock Database.SaveResult https://salesforce.stackexchange.com/questions/212144/how-to-mock-a-database-saveresult
  // SaveResult class definition https://developer.salesforce.com/docs/atlas.en-us.apexref.meta/apexref/apex_methods_system_database_saveresult.htm
}
