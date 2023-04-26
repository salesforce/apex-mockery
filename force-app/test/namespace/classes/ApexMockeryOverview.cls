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
    mockery.Mock deliveryServiceMock = mockery.Mock.forType(DeliveryService.class, new StubBuilderImpl());
    mockery.MethodSpy planDeliverySpy = deliveryServiceMock.spyOn('planDelivery');
    Bakery myBakery = new Bakery((DeliveryService) deliveryServiceMock.stub);
    planDeliverySpy.whenCalledWith(new Pastry('Chocolatine')).thenReturn(Date.today().addDays(3));
    planDeliverySpy.whenCalledWith(new OperaPastryMatcher()).thenThrow(new RecipeException());
    planDeliverySpy.returns(Date.today().addDays(4));

    mockery.Assertions.assertThat(planDeliverySpy).hasNotBeenCalled();
    mockery.Assertions.assertThat(planDeliverySpy).hasBeenCalledTimes(0);

    // Act & Assert
    OrderConfirmation order = myBakery.order(new Pastry('Chocolatine'));
    mockery.Assertions.assertThat(planDeliverySpy).hasBeenCalled();
    mockery.Assertions.assertThat(planDeliverySpy).hasBeenCalledWith(new Pastry('Chocolatine'));
    mockery.Assertions.assertThat(planDeliverySpy).hasBeenLastCalledWith(new Pastry('Chocolatine'));
    mockery.Assertions.assertThat(planDeliverySpy).hasBeenCalledTimes(1);
    Assert.areEqual(Date.today().addDays(3), order.deliveryDate);

    order = myBakery.order(new Pastry('Croissant'));
    mockery.Assertions.assertThat(planDeliverySpy).hasBeenCalled();
    mockery.Assertions.assertThat(planDeliverySpy).hasBeenCalledWith(mockery.AMatcher.jsonEquals(new Pastry('Chocolatine')));
    mockery.Assertions.assertThat(planDeliverySpy).hasBeenCalledWith(new Pastry('Croissant'));
    mockery.Assertions.assertThat(planDeliverySpy).hasBeenLastCalledWith(new Pastry('Croissant'));
    mockery.Assertions.assertThat(planDeliverySpy).hasBeenCalledTimes(2);
    Assert.areEqual(Date.today().addDays(4), order.deliveryDate);

    try {
      order = myBakery.order(new Pastry('Opera'));
      Assert.fail('Expected exception was not thrown');
    } catch (Exception ex) {
      Assert.isInstanceOfType(ex, RecipeException.class);
    }
  }

  private class OperaPastryMatcher implements mockery.AMatcher.ArgumentMatcher {
    public Boolean matches(Object callArgument) {
      Pastry p = (Pastry) callArgument;
      return p.name == 'Opera';
    }
  }
}
