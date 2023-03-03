/*
 * Copyright (c) 2022, salesforce.com, inc.
 * All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * For full license text, see the LICENSE file in the repo root or https://opensource.org/licenses/BSD-3-Clause
 */
@isTest
private class HasNotBeenCalled {
  @isTest
  static void recipe() {
    // Arrange
    mockery.Mock deliveryServiceMock = mockery.Mock.forType(DeliveryService.class);
    mockery.MethodSpy planDeliverySpy = deliveryServiceMock.spyOn('planDelivery');

    // Act

    // Assert
    mockery.Assertions.assertThat(planDeliverySpy).hasNotBeenCalled();
  }
}
