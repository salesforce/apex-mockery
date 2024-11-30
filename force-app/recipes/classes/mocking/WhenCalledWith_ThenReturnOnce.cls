/*
 * Copyright (c) 2022, salesforce.com, inc.
 * All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * For full license text, see the LICENSE file in the repo root or https://opensource.org/licenses/BSD-3-Clause
 */
@isTest
private class WhenCalledWith_ThenReturnOnce {
  @isTest
  static void recipe() {
    // Arrange
    Mock deliveryServiceMock = Mock.forType(DeliveryService.class);
    MethodSpy planDeliverySpy = deliveryServiceMock.spyOn('planDelivery');
    Bakery myBakery = new Bakery((DeliveryService) deliveryServiceMock.stub);
    planDeliverySpy.whenCalledWith(new Pastry('Croissant')).thenThrow(new RecipeException());
    planDeliverySpy.whenCalledWith(new Pastry('Croissant')).thenReturnOnce(Date.today().addDays(3));

    // Act
    OrderConfirmation order = myBakery.order(new Pastry('Croissant'));

    // Assert
    Assert.areEqual(Date.today().addDays(3), order.deliveryDate);

    // Act
    try {
      myBakery.order(new Pastry('Croissant'));

      // Assert
      Assert.fail('Expected exception was not thrown');
    } catch (Exception ex) {
      Assert.isInstanceOfType(ex, RecipeException.class);
    }
  }
}
