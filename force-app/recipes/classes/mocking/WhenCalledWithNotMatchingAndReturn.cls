/*
 * Copyright (c) 2022, salesforce.com, inc.
 * All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * For full license text, see the LICENSE file in the repo root or https://opensource.org/licenses/BSD-3-Clause
 */
@isTest
private class WhenCalledWithNotMatchingAndReturn {
  @isTest
  static void recipe() {
    // Arrange
    final Mock deliveryServiceMock = Mock.forType(DeliveryService.class);
    final MethodSpy planDeliverySpy = deliveryServiceMock.spyOn('planDelivery');
    final Bakery sut = new Bakery((DeliveryService) deliveryServiceMock.stub);
    planDeliverySpy.returns(Date.today().addDays(4));
    planDeliverySpy.whenCalledWith(Params.of(new Pastry('Croissant'))).thenReturn(Date.today().addDays(3));
    planDeliverySpy.whenCalledWith(Params.of(new Pastry('Chocolatine'))).thenThrow(new RecipeException());

    // Act
    final OrderConfirmation order = sut.order(new Pastry('Opera'));

    // Assert
    Assert.areEqual(Date.today().addDays(4), order.deliveryDate);
  }
}