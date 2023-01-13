/*
 * Copyright (c) 2022, salesforce.com, inc.
 * All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * For full license text, see the LICENSE file in the repo root or https://opensource.org/licenses/BSD-3-Clause
 */
@isTest
private class WhenCalledWithMatchingThrowsAndReturns {
  @isTest
  static void recipe() {
    // Arrange
    Mock deliveryServiceMock = Mock.forType(DeliveryService.class);
    MethodSpy planDeliverySpy = deliveryServiceMock.spyOn('planDelivery');
    Bakery myBakery = new Bakery((DeliveryService) deliveryServiceMock.stub);
    planDeliverySpy.returns(Date.today().addDays(2));
    planDeliverySpy.throwsException(new RecipeException());
    planDeliverySpy.whenCalledWith(new Pastry('Croissant')).thenReturn(Date.today().addDays(3));
    planDeliverySpy.whenCalledWith(new Pastry('Pain au Chocolat')).thenThrow(new RecipeException());

    // Act
    try {
      OrderConfirmation order = myBakery.order(new Pastry('Pain au Chocolat'));

      // Assert
      Assert.fail('Expected exception was not thrown');
    } catch (Exception ex) {
      Assert.isInstanceOfType(ex, RecipeException.class);
    }
  }
}
