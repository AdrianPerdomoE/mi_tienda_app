Map<String, double> discountValues(double price, double discount) {
  double discountAmount = price * discount;
  double finalPrice = price - discountAmount;
  return {
    'price': price,
    'discount': discount,
    'discountAmount': discountAmount,
    'finalPrice': finalPrice,
  };
}
