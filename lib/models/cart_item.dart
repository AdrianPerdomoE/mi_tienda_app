class CartItem {
  String productId;
  String productName;
  double price;
  int quantity;
  String imageUrl;
  double discount;
  CartItem({
    required this.productId,
    required this.productName,
    required this.price,
    required this.quantity,
    required this.imageUrl,
    required this.discount,
  });

  CartItem.fromJson(Map<String, dynamic> json)
      : productId = json['productId'],
        productName = json['productName'],
        price = json['price'],
        quantity = json['quantity'],
        imageUrl = json['imageUrl'],
        discount = json['discount'];

  toJson() {
    return {
      "productId": productId,
      "productName": productName,
      "price": price,
      "quantity": quantity,
      "imageUrl": imageUrl,
      "discount": discount,
    };
  }
}