import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["quantity", "totalPrice", "cartLink"];
  static values = {
    pricePerDay: Number,
    rentalDuration: Number,
    maxQuantity: Number,
  };

  connect() {
    this.updateTotalPrice();
    this.updateLinks();
  }

  decrease() {
    const currentQuantity = parseInt(this.quantityTarget.value);
    if (currentQuantity > 1) {
      this.quantityTarget.value = currentQuantity - 1;
      this.updateTotalPrice();
      this.updateLinks();
    }
  }

  increase() {
    const currentQuantity = parseInt(this.quantityTarget.value);
    if (currentQuantity < this.maxQuantityValue) {
      this.quantityTarget.value = currentQuantity + 1;
      this.updateTotalPrice();
      this.updateLinks();
    }
  }

  updateTotalPrice() {
    const quantity = parseInt(this.quantityTarget.value);
    const totalPrice =
      quantity * this.pricePerDayValue * this.rentalDurationValue;
    const formattedTotalPrice = totalPrice
      .toLocaleString("en", { maximumFractionDigits: 0 })
      .replace(/,/g, ".");
    this.totalPriceTarget.textContent = "₫" + formattedTotalPrice;
  }

  updateLinks() {
    const quantity = this.quantityTarget.value;

    // Update rent now button
    const rentNowBtn = document.getElementById("rent-now-btn");
    if (rentNowBtn) {
      const rentUrl = new URL(rentNowBtn.href);
      rentUrl.searchParams.set("quantity", quantity);
      rentNowBtn.href = rentUrl.toString();
    }

    // Update add to cart button
    const cartLink = this.cartLinkTarget;
    if (cartLink) {
      const cartUrl = new URL(cartLink.href);
      cartUrl.searchParams.set("cart_item[quantity]", quantity);
      cartLink.href = cartUrl.toString();
    }
  }
}
