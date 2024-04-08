class Cart {
  List<CartItem> items;
  Cart({required this.items});
  Cart.fromJson(Map<String, dynamic> json)
      : items = json['items']
            .map<CartItem>((item) => CartItem.fromJson(item))
            .toList();

  double get total =>
      items.fold(0, (total, item) => total + item.price * item.quantity);
  deleteItem(String productId) {
    items.removeWhere((element) => element.productId == productId);
  }

  _updateItem(CartItem item) {
    items.removeWhere((element) => element.productId == item.productId);
    items.add(item);
  }

  addItem(CartItem item) {
    if (items.any((element) => element.productId == item.productId)) {
      _updateItem(item);
    } else {
      items.add(item);
    }
  }

  void emptyCart() {
    items = [];
  }
}

class CartItem {
  String productId;
  String productName;
  double price;
  int quantity;
  String imageUrl;
  double descount;
  CartItem({
    required this.productId,
    required this.productName,
    required this.price,
    required this.quantity,
    required this.imageUrl,
    required this.descount,
  });

  CartItem.fromJson(Map<String, dynamic> json)
      : productId = json['productId'],
        productName = json['productName'],
        price = json['price'],
        quantity = json['quantity'],
        imageUrl = json['imageUrl'],
        descount = json['descount'];
}
