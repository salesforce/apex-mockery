/*
 * Copyright (c) 2022, salesforce.com, inc.
 * All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * For full license text, see the LICENSE file in the repo root or https://opensource.org/licenses/BSD-3-Clause
 */
@isTest
private class ApexMockeryOverview {
  @isTest
  static void recipe() {
    // Arrange
    Mock deliveryServiceMock = Mock.forType(DeliveryService.class);
    MethodSpy planDeliverySpy = deliveryServiceMock.spyOn('planDelivery');
    Bakery myBakery = new Bakery((DeliveryService) deliveryServiceMock.stub);
    planDeliverySpy.whenCalledWith(new Pastry('Chocolatine')).thenReturn(Date.today().addDays(3));
    planDeliverySpy.whenCalledWith(new OperaPastryMatcher()).thenThrow(new RecipeException());
    planDeliverySpy.returns(Date.today().addDays(4));

    Assertions.assertThat(planDeliverySpy).hasNotBeenCalled();
    Assertions.assertThat(planDeliverySpy).hasBeenCalledTimes(0);

    // Act & Assert
    OrderConfirmation order = myBakery.order(new Pastry('Chocolatine'));
    Assertions.assertThat(planDeliverySpy).hasBeenCalled();
    Assertions.assertThat(planDeliverySpy).hasBeenCalledWith(new Pastry('Chocolatine'));
    Assertions.assertThat(planDeliverySpy).hasBeenLastCalledWith(new Pastry('Chocolatine'));
    Assertions.assertThat(planDeliverySpy).hasBeenCalledTimes(1);
    Assert.areEqual(Date.today().addDays(3), order.deliveryDate);

    order = myBakery.order(new Pastry('Croissant'));
    Assertions.assertThat(planDeliverySpy).hasBeenCalled();
    Assertions.assertThat(planDeliverySpy).hasBeenCalledWith(new Pastry('Chocolatine'));
    Assertions.assertThat(planDeliverySpy).hasBeenCalledWith(new Pastry('Croissant'));
    Assertions.assertThat(planDeliverySpy).hasBeenLastCalledWith(new Pastry('Croissant'));
    Assertions.assertThat(planDeliverySpy).hasBeenCalledTimes(2);
    Assert.areEqual(Date.today().addDays(4), order.deliveryDate);

    try {
      order = myBakery.order(new Pastry('Opera'));
      Assert.fail('Expected exception was not thrown');
    } catch (Exception ex) {
      Assert.isInstanceOfType(ex, RecipeException.class);
    }
  }
}
