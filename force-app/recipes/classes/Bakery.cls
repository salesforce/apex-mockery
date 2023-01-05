/*
 * Copyright (c) 2022, salesforce.com, inc.
 * All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * For full license text, see the LICENSE file in the repo root or https://opensource.org/licenses/BSD-3-Clause
 */
public class Bakery {
  private DeliveryService deliveryService;

  public Bakery(DeliveryService deliveryService) {
    this.deliveryService = deliveryService;
  }

  public OrderConfirmation order(Pastry pastry) {
    OrderConfirmation order = new OrderConfirmation();
    order.pastry = pastry;
    order.deliveryDate = this.deliveryService.planDelivery(pastry);
    return order;
  }
}
