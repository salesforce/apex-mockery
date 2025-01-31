/*
 * Copyright (c) 2022, salesforce.com, inc.
 * All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * For full license text, see the LICENSE file in the repo root or https://opensource.org/licenses/BSD-3-Clause
 */
@IsTest
private class WhenCalledWith_ThenBehave {
  class MockImpl implements MethodSpy.SpyBehavior {
    public Object execute(final List<Object> params) {
      return Date.today().addDays(10);
    }
  }

  @IsTest
  static void recipe() {
    // Arrange
    Mock deliveryServiceMock = Mock.forType(DeliveryService.class);
    MethodSpy planDeliverySpy = deliveryServiceMock.spyOn('planDelivery');
    Bakery myBakery = new Bakery((DeliveryService) deliveryServiceMock.stub);
    planDeliverySpy.whenCalledWith(new Pastry('Croissant')).thenBehave(new MockImpl());

    // Act
    OrderConfirmation order = myBakery.order(new Pastry('Croissant'));

    // Assert
    Assert.areEqual(Date.today().addDays(10), order.deliveryDate);

    // Act
    order = myBakery.order(new Pastry('Croissant'));

    // Assert
    Assert.areEqual(Date.today().addDays(10), order.deliveryDate);
  }
}
