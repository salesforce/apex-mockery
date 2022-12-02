public class Bakery {
  private DeliveryService deliveryService;

  public Bakery(final DeliveryService deliveryService) {
    this.deliveryService = deliveryService;
  }

  public OrderConfirmation order(final Pastry pastry) {
    final OrderConfirmation order = new OrderConfirmation();
    order.pastry = pastry;
    order.deliveryDate = this.deliveryService.planDelivery(pastry);
    return order;
  }
}
