@isTest
private class ApexMockeryRecipe {
  @isTest
  static void assertionRecipe_hasNotBeenCalled() {
    // Arrange
    final Mock deliveryServiceMock = Mock.forType(DeliveryService.class);
    final MethodSpy planDeliverySpy = deliveryServiceMock.spyOn('planDelivery');

    // Act

    // Assert
    Assertions.assertThat(planDeliverySpy).hasNotBeenCalled();
  }

  @isTest
  static void assertionRecipe_hasBeenCalled() {
    // Arrange
    final Mock deliveryServiceMock = Mock.forType(DeliveryService.class);
    final MethodSpy planDeliverySpy = deliveryServiceMock.spyOn('planDelivery');
    final Bakery sut = new Bakery((DeliveryService) deliveryServiceMock.stub);

    // Act
    sut.order(new Pastry('Chocolatine'));

    // Assert
    Assertions.assertThat(planDeliverySpy).hasBeenCalled();
  }

  @isTest
  static void assertionRecipe_hasBeenCalledWith() {
    // Arrange
    final Mock deliveryServiceMock = Mock.forType(DeliveryService.class);
    final MethodSpy planDeliverySpy = deliveryServiceMock.spyOn('planDelivery');
    final Bakery sut = new Bakery((DeliveryService) deliveryServiceMock.stub);

    // Act
    sut.order(new Pastry('Chocolatine'));
    sut.order(new Pastry('Croissant'));

    // Assert
    Assertions.assertThat(planDeliverySpy).hasBeenCalledWith(Params.of(new Pastry('Chocolatine')));
    Assertions.assertThat(planDeliverySpy).hasBeenCalledWith(Params.of(new Pastry('Croissant')));
    //Assertions.assertThat(planDeliverySpy).hasBeenCalledWith(Params.of(new Pastry('Pain au chocolat'))); // Throws
  }

  @isTest
  static void assertionRecipe_hasBeenCalledWithTypeMatcher() {
    // Arrange
    final Mock deliveryServiceMock = Mock.forType(DeliveryService.class);
    final MethodSpy planDeliverySpy = deliveryServiceMock.spyOn('planDelivery');
    final Bakery sut = new Bakery((DeliveryService) deliveryServiceMock.stub);

    // Act
    sut.order(new Pastry('Chocolatine'));
    sut.order(new Pastry('Croissant'));

    // Assert
    Assertions.assertThat(planDeliverySpy).hasBeenCalledWith(Params.of(Matcher.ofType(Pastry.class)));
    Assertions.assertThat(planDeliverySpy).hasBeenCalledWith(Params.of(new Pastry('Croissant')));
    //Assertions.assertThat(planDeliverySpy).hasBeenCalledWith(Params.of(new Pastry('Pain au chocolat'))); // Throws
  }

  @isTest
  static void assertionRecipe_hasBeenCalledWithJSONMatcher() {
    // Arrange
    final Mock deliveryServiceMock = Mock.forType(DeliveryService.class);
    final MethodSpy planDeliverySpy = deliveryServiceMock.spyOn('planDelivery');
    final Bakery sut = new Bakery((DeliveryService) deliveryServiceMock.stub);

    // Act
    sut.order(new Pastry('Chocolatine'));
    sut.order(new Pastry('Croissant'));

    // Assert
    Assertions.assertThat(planDeliverySpy).hasBeenCalledWith(Params.of(Matcher.jsonEquals(new Pastry('Chocolatine')))); // Match not serializable types
    Assertions.assertThat(planDeliverySpy).hasBeenCalledWith(Params.of(new Pastry('Croissant')));
    //Assertions.assertThat(planDeliverySpy).hasBeenCalledWith(Params.of(new Pastry('Pain au chocolat'))); // Throws
  }

  @isTest
  static void assertionRecipe_hasBeenCalledWithCustomMatcher() {
    // Arrange
    final Mock deliveryServiceMock = Mock.forType(DeliveryService.class);
    final MethodSpy planDeliverySpy = deliveryServiceMock.spyOn('planDelivery');
    final Bakery sut = new Bakery((DeliveryService) deliveryServiceMock.stub);

    // Act
    sut.order(new Pastry('Opera'));
    sut.order(new Pastry('Croissant'));

    // Assert
    Assertions.assertThat(planDeliverySpy).hasBeenCalledWith(Params.of(new OperaPastryMatcher())); // Match not serializable types
    Assertions.assertThat(planDeliverySpy).hasBeenCalledWith(Params.of(new Pastry('Croissant')));
    //Assertions.assertThat(planDeliverySpy).hasBeenCalledWith(Params.of(new Pastry('Pain au chocolat'))); // Throws
  }

  @isTest
  static void assertionRecipe_hasBeenLastCalledWith() {
    // Arrange
    final Mock deliveryServiceMock = Mock.forType(DeliveryService.class);
    final MethodSpy planDeliverySpy = deliveryServiceMock.spyOn('planDelivery');
    final Bakery sut = new Bakery((DeliveryService) deliveryServiceMock.stub);

    // Act
    sut.order(new Pastry('Chocolatine'));
    sut.order(new Pastry('Croissant'));

    // Assert
    Assertions.assertThat(planDeliverySpy).hasBeenLastCalledWith(Params.of(new Pastry('Croissant')));
    //Assertions.assertThat(planDeliverySpy).hasBeenLastCalledWith(Params.of(new Pastry('Chocolatine'))); // Throws
  }

  @isTest
  static void assertionRecipe_hasBeenCalledTimes() {
    // Arrange
    final Mock deliveryServiceMock = Mock.forType(DeliveryService.class);
    final MethodSpy planDeliverySpy = deliveryServiceMock.spyOn('planDelivery');
    final Bakery sut = new Bakery((DeliveryService) deliveryServiceMock.stub);

    // Act
    sut.order(new Pastry('Chocolatine'));
    sut.order(new Pastry('Croissant'));

    // Assert
    Assertions.assertThat(planDeliverySpy).hasBeenCalledTimes(2);
  }

  @isTest
  static void assertionRecipe_AllAtOnce() {
    // Arrange
    final Mock deliveryServiceMock = Mock.forType(DeliveryService.class);
    final MethodSpy planDeliverySpy = deliveryServiceMock.spyOn('planDelivery');
    final Bakery sut = new Bakery((DeliveryService) deliveryServiceMock.stub);

    Assertions.assertThat(planDeliverySpy).hasNotBeenCalled(); // Ok
    Assertions.assertThat(planDeliverySpy).hasBeenCalledTimes(0);

    // Act & Assert
    sut.order(new Pastry('Chocolatine'));
    Assertions.assertThat(planDeliverySpy).hasBeenCalled();
    Assertions.assertThat(planDeliverySpy).hasBeenCalledWith(Params.of(new Pastry('Chocolatine')));
    Assertions.assertThat(planDeliverySpy).hasBeenLastCalledWith(Params.of(new Pastry('Chocolatine')));
    Assertions.assertThat(planDeliverySpy).hasBeenCalledTimes(1);

    sut.order(new Pastry('Croissant'));
    Assertions.assertThat(planDeliverySpy).hasBeenCalled();
    Assertions.assertThat(planDeliverySpy).hasBeenCalledWith(Params.of(new Pastry('Chocolatine')));
    Assertions.assertThat(planDeliverySpy).hasBeenCalledWith(Params.of(new Pastry('Croissant')));
    Assertions.assertThat(planDeliverySpy).hasBeenLastCalledWith(Params.of(new Pastry('Croissant')));
    Assertions.assertThat(planDeliverySpy).hasBeenCalledTimes(2);
    //Assertions.assertThat(planDeliverySpy).hasBeenLastCalledWith(Params.of(new Pastry('Chocolatine'))); // Throws
    //Assertions.assertThat(planDeliverySpy).hasBeenCalledWith(Params.of(new Pastry('Pain au chocolat'))); // Throws
    //Assertions.assertThat(planDeliverySpy).hasBeenLastCalledWith(Params.of(new Pastry('Pain au chocolat'))); // Throws
    //Assertions.assertThat(planDeliverySpy).hasBeenCalledTimes(1); // Throws
    //Assertions.assertThat(planDeliverySpy).hasNotBeenCalled(); // Throws
  }

  @isTest
  static void mockingRecipe_returns() {
    // Arrange
    final Mock deliveryServiceMock = Mock.forType(DeliveryService.class);
    final MethodSpy planDeliverySpy = deliveryServiceMock.spyOn('planDelivery');
    final Bakery sut = new Bakery((DeliveryService) deliveryServiceMock.stub);
    planDeliverySpy.returns(Date.today().addDays(3));

    // Act
    final OrderConfirmation order = sut.order(new Pastry('Opera'));

    // Assert
    Assert.areEqual(Date.today().addDays(3), order.deliveryDate);
  }

  @isTest
  static void mockingRecipe_throws() {
    // Arrange
    final Mock deliveryServiceMock = Mock.forType(DeliveryService.class);
    final MethodSpy planDeliverySpy = deliveryServiceMock.spyOn('planDelivery');
    final Bakery sut = new Bakery((DeliveryService) deliveryServiceMock.stub);
    planDeliverySpy.throwsException(new RecipeException());

    // Act
    try {
      final OrderConfirmation order = sut.order(new Pastry('Opera'));

      // Assert
      Assert.fail('Expected exception was not thrown');
    } catch (Exception ex) {
      Assert.isInstanceOfType(ex, RecipeException.class);
    }
  }

  @isTest
  static void mockingRecipe_returnsThenThrows() {
    // Arrange
    final Mock deliveryServiceMock = Mock.forType(DeliveryService.class);
    final MethodSpy planDeliverySpy = deliveryServiceMock.spyOn('planDelivery');
    final Bakery sut = new Bakery((DeliveryService) deliveryServiceMock.stub);
    planDeliverySpy.returns(Date.today().addDays(3));
    planDeliverySpy.throwsException(new RecipeException());

    // Act
    try {
      final OrderConfirmation order = sut.order(new Pastry('Opera'));

      // Assert
      Assert.fail('Expected exception was not thrown');
    } catch (Exception ex) {
      Assert.isInstanceOfType(ex, RecipeException.class);
    }
  }

  @isTest
  static void mockingRecipe_throwThenReturns() {
    // Arrange
    final Mock deliveryServiceMock = Mock.forType(DeliveryService.class);
    final MethodSpy planDeliverySpy = deliveryServiceMock.spyOn('planDelivery');
    final Bakery sut = new Bakery((DeliveryService) deliveryServiceMock.stub);
    planDeliverySpy.throwsException(new RecipeException());
    planDeliverySpy.returns(Date.today().addDays(3));

    // Act
    final OrderConfirmation order = sut.order(new Pastry('Opera'));

    // Assert
    Assert.areEqual(Date.today().addDays(3), order.deliveryDate);
  }

  @isTest
  static void mockingRecipe_whenCalledWithTypeMatching_thenReturn() {
    // Arrange
    final Mock deliveryServiceMock = Mock.forType(DeliveryService.class);
    final MethodSpy planDeliverySpy = deliveryServiceMock.spyOn('planDelivery');
    final Bakery sut = new Bakery((DeliveryService) deliveryServiceMock.stub);
    planDeliverySpy.whenCalledWith(Params.of(Matcher.ofType(Pastry.class))).thenReturn(Date.today().addDays(4)); // Order matter
    planDeliverySpy.whenCalledWith(Params.of(new Pastry('Croissant'))).thenReturn(Date.today().addDays(3));
    planDeliverySpy.whenCalledWith(Params.of(new Pastry('Opera'))).thenReturn(Date.today().addDays(2));

    // Act
    final OrderConfirmation order = sut.order(new Pastry('Opera'));

    // Assert
    Assert.areEqual(Date.today().addDays(4), order.deliveryDate);
  }

  @isTest
  static void mockingRecipe_whenCalledWithJSONMatching_thenReturn() {
    // Arrange
    final Mock deliveryServiceMock = Mock.forType(DeliveryService.class);
    final MethodSpy planDeliverySpy = deliveryServiceMock.spyOn('planDelivery');
    final Bakery sut = new Bakery((DeliveryService) deliveryServiceMock.stub);
    planDeliverySpy.whenCalledWith(Params.of(Matcher.jsonEquals(new Pastry('Opera')))).thenReturn(Date.today().addDays(4)); // Order matter
    planDeliverySpy.whenCalledWith(Params.of(new Pastry('Croissant'))).thenReturn(Date.today().addDays(3));
    planDeliverySpy.whenCalledWith(Params.of(new Pastry('Opera'))).thenReturn(Date.today().addDays(2));

    // Act
    final OrderConfirmation order = sut.order(new Pastry('Opera'));

    // Assert
    Assert.areEqual(Date.today().addDays(4), order.deliveryDate);
  }

  @isTest
  static void mockingRecipe_whenCalledWithEqualMatching_thenReturn() {
    // Arrange
    final Mock deliveryServiceMock = Mock.forType(DeliveryService.class);
    final MethodSpy planDeliverySpy = deliveryServiceMock.spyOn('planDelivery');
    final Bakery sut = new Bakery((DeliveryService) deliveryServiceMock.stub);
    planDeliverySpy.whenCalledWith(Params.of(new Pastry('Croissant'))).thenReturn(Date.today().addDays(3));
    planDeliverySpy.whenCalledWith(Params.of(new Pastry('Opera'))).thenReturn(Date.today().addDays(2));
    planDeliverySpy.whenCalledWith(Params.of(Matcher.ofType(Pastry.class))).thenReturn(Date.today().addDays(4)); // Order matter

    // Act
    final OrderConfirmation order = sut.order(new Pastry('Opera'));

    // Assert
    Assert.areEqual(Date.today().addDays(2), order.deliveryDate);
  }

  @isTest
  static void mockingRecipe_whenCalledWithNotMatchingAndNoReturnAndNoThrowConfiguration_thenThrow() {
    // Arrange
    final Mock deliveryServiceMock = Mock.forType(DeliveryService.class);
    final MethodSpy planDeliverySpy = deliveryServiceMock.spyOn('planDelivery');
    final Bakery sut = new Bakery((DeliveryService) deliveryServiceMock.stub);
    planDeliverySpy.whenCalledWith(Params.of(new Pastry('Croissant'))).thenReturn(Date.today().addDays(3));
    planDeliverySpy.whenCalledWith(Params.of(new Pastry('Chocolatine'))).thenReturn(Date.today().addDays(2));

    // Act
    try {
      final OrderConfirmation order = sut.order(new Pastry('Opera'));

      // Assert
      Assert.fail('Expected exception was not thrown');
    } catch (Exception ex) {
      Assert.isInstanceOfType(ex, MethodSpy.ConfigurationException.class);
    }
  }

  @isTest
  static void mockingRecipe_whenCalledWithNotMatchingAndReturn_thenReturns() {
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

  @isTest
  static void mockingRecipe_whenCalledWith_thenThrow() {
    // Arrange
    final Mock deliveryServiceMock = Mock.forType(DeliveryService.class);
    final MethodSpy planDeliverySpy = deliveryServiceMock.spyOn('planDelivery');
    final Bakery sut = new Bakery((DeliveryService) deliveryServiceMock.stub);
    planDeliverySpy.whenCalledWith(Params.of(new Pastry('Croissant'))).thenReturn(Date.today().addDays(3));
    planDeliverySpy.whenCalledWith(Params.of(new Pastry('Opera'))).thenThrow(new RecipeException());

    // Act
    try {
      final OrderConfirmation order = sut.order(new Pastry('Opera'));

      // Assert
      Assert.fail('Expected exception was not thrown');
    } catch (Exception ex) {
      Assert.isInstanceOfType(ex, RecipeException.class);
    }
  }

  @isTest
  static void mockingRecipe_whenCalledWithMatchingThrowsAndReturns_thenThrow() {
    // Arrange
    final Mock deliveryServiceMock = Mock.forType(DeliveryService.class);
    final MethodSpy planDeliverySpy = deliveryServiceMock.spyOn('planDelivery');
    final Bakery sut = new Bakery((DeliveryService) deliveryServiceMock.stub);
    planDeliverySpy.returns(Date.today().addDays(2));
    planDeliverySpy.throwsException(new RecipeException());
    planDeliverySpy.whenCalledWith(Params.of(new Pastry('Croissant'))).thenReturn(Date.today().addDays(3));
    planDeliverySpy.whenCalledWith(Params.of(new Pastry('Opera'))).thenThrow(new RecipeException());

    // Act
    try {
      final OrderConfirmation order = sut.order(new Pastry('Opera'));

      // Assert
      Assert.fail('Expected exception was not thrown');
    } catch (Exception ex) {
      Assert.isInstanceOfType(ex, RecipeException.class);
    }
  }

  @isTest
  static void mockingRecipe_whenCalledWithCustomMatcher_thenReturns() {
    // Arrange
    final Mock deliveryServiceMock = Mock.forType(DeliveryService.class);
    final MethodSpy planDeliverySpy = deliveryServiceMock.spyOn('planDelivery');
    final Bakery sut = new Bakery((DeliveryService) deliveryServiceMock.stub);
    planDeliverySpy.whenCalledWith(Params.of(new OperaPastryMatcher())).thenReturn(Date.today().addDays(3));

    // Act
    final OrderConfirmation order = sut.order(new Pastry('Opera'));

    // Assert
    Assert.areEqual(Date.today().addDays(3), order.deliveryDate);
  }

  @isTest
  static void allRecipe_AllAtOnce() {
    // Arrange
    final Mock deliveryServiceMock = Mock.forType(DeliveryService.class);
    final MethodSpy planDeliverySpy = deliveryServiceMock.spyOn('planDelivery');
    final Bakery sut = new Bakery((DeliveryService) deliveryServiceMock.stub);
    planDeliverySpy.whenCalledWith(Params.of(new Pastry('Chocolatine'))).thenReturn(Date.today().addDays(3));
    planDeliverySpy.whenCalledWith(Params.of(new OperaPastryMatcher())).thenThrow(new RecipeException());
    planDeliverySpy.returns(Date.today().addDays(4));

    Assertions.assertThat(planDeliverySpy).hasNotBeenCalled(); // Ok
    Assertions.assertThat(planDeliverySpy).hasBeenCalledTimes(0);

    // Act & Assert
    OrderConfirmation order = sut.order(new Pastry('Chocolatine'));
    Assertions.assertThat(planDeliverySpy).hasBeenCalled();
    Assertions.assertThat(planDeliverySpy).hasBeenCalledWith(Params.of(new Pastry('Chocolatine')));
    Assertions.assertThat(planDeliverySpy).hasBeenLastCalledWith(Params.of(new Pastry('Chocolatine')));
    Assertions.assertThat(planDeliverySpy).hasBeenCalledTimes(1);
    Assert.areEqual(Date.today().addDays(3), order.deliveryDate);

    order = sut.order(new Pastry('Croissant'));
    Assertions.assertThat(planDeliverySpy).hasBeenCalled();
    Assertions.assertThat(planDeliverySpy).hasBeenCalledWith(Params.of(new Pastry('Chocolatine')));
    Assertions.assertThat(planDeliverySpy).hasBeenCalledWith(Params.of(new Pastry('Croissant')));
    Assertions.assertThat(planDeliverySpy).hasBeenLastCalledWith(Params.of(new Pastry('Croissant')));
    Assertions.assertThat(planDeliverySpy).hasBeenCalledTimes(2);
    Assert.areEqual(Date.today().addDays(4), order.deliveryDate);
    //Assertions.assertThat(planDeliverySpy).hasBeenLastCalledWith(Params.of(new Pastry('Chocolatine'))); // Throws
    //Assertions.assertThat(planDeliverySpy).hasBeenCalledWith(Params.of(new Pastry('Pain au chocolat'))); // Throws
    //Assertions.assertThat(planDeliverySpy).hasBeenLastCalledWith(Params.of(new Pastry('Pain au chocolat'))); // Throws
    //Assertions.assertThat(planDeliverySpy).hasBeenCalledTimes(1); // Throws

    try {
      order = sut.order(new Pastry('Opera'));
      Assert.fail('Expected exception was not thrown');
    } catch (Exception ex) {
      Assert.isInstanceOfType(ex, RecipeException.class);
    }
  }

  class OperaPastryMatcher implements Matcher.ArgumentMatcher {
    public Boolean matches(final Object callArgument) {
      Pastry p = (Pastry) callArgument;
      return p.name == 'Opera';
    }
  }

  class RecipeException extends Exception {
  }
}
