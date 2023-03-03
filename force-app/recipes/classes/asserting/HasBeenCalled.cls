/*
 * Copyright (c) 2022, salesforce.com, inc.
 * All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * For full license text, see the LICENSE file in the repo root or https://opensource.org/licenses/BSD-3-Clause
 */
@isTest
private class HasBeenCalled {
  @isTest
  static void recipe() {
    // Arrange
    mockery.Mock deliveryServiceMock = MockFactory.forType(DeliveryService.class);
    mockery.MethodSpy planDeliverySpy = deliveryServiceMock.spyOn('planDelivery');
    Bakery myBakery = new Bakery((DeliveryService) deliveryServiceMock.stub);

    // Act
    myBakery.order(new Pastry('Chocolatine'));

    // Assert
    mockery.Assertions.assertThat(planDeliverySpy).hasBeenCalled();
  }
}
