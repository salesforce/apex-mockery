/*
 * Copyright (c) 2022, salesforce.com, inc.
 * All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * For full license text, see the LICENSE file in the repo root or https://opensource.org/licenses/BSD-3-Clause
 */
@isTest
private class HasBeenCalledTimes {
  @isTest
  static void recipe() {
    // Arrange
    Mock deliveryServiceMock = Mock.forType(DeliveryService.class);
    MethodSpy planDeliverySpy = deliveryServiceMock.spyOn('planDelivery');
    Bakery sut = new Bakery((DeliveryService) deliveryServiceMock.stub);

    // Act
    sut.order(new Pastry('Chocolatine'));
    sut.order(new Pastry('Croissant'));

    // Assert
    Assertions.assertThat(planDeliverySpy).hasBeenCalledTimes(2);
  }
}
