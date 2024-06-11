import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mi_tienda_app/models/cart.dart';
import 'package:mi_tienda_app/models/cart_item.dart';
import 'package:mi_tienda_app/models/product.dart';

class CartDatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String _usersCollections = "Users";
  String _uid;

  setUid(String uid) {
    _uid = uid;
  }

  CartDatabaseService(this._uid);

  Stream<Cart> getCart() {
    return _db
        .collection(_usersCollections)
        .doc(_uid)
        .snapshots()
        .map((doc) => Cart.fromJson(doc.data()!['cart']));
  }

  Stream<int> getCartItemsCount() {
    return _db
        .collection(_usersCollections)
        .doc(_uid)
        .snapshots()
        .map((doc) => Cart.fromJson(doc.data()!['cart']).totalItems);
  }

  Stream<double> getCartTotalPrice() {
    return _db
        .collection(_usersCollections)
        .doc(_uid)
        .snapshots()
        .map((doc) => Cart.fromJson(doc.data()!['cart']).totalPrice);
  }

  Stream<CartItem> getCartItem(String productId) {
    return _db.collection(_usersCollections).doc(_uid).snapshots().map((doc) =>
        Cart.fromJson(doc.data()!['cart'])
            .items
            .firstWhere((item) => item.productId == productId));
  }

  Future<Cart> _getCart() async {
    final DocumentSnapshot<Map<String, dynamic>> userDoc =
        await _db.collection(_usersCollections).doc(_uid).get();
    return Cart.fromJson(userDoc.data()!['cart']);
  }

  Future<void> _updateCart(Cart cart) async {
    await _db.collection(_usersCollections).doc(_uid).update({
      'cart': cart.toJson(),
    });
  }

  Future<bool> isProductInCart(String productId) async {
    final Cart cart = await _getCart();
    return cart.items.any((item) => item.productId == productId);
  }

  Future<bool> isThereStock(String productId, int productStock) async {
    final Cart cart = await _getCart();
    final int index =
        cart.items.indexWhere((item) => item.productId == productId);
    return index == -1 || cart.items[index].quantity < productStock;
  }

  Future<void> addItemToCart(Product product) async {
    final Cart cart = await _getCart();
    if (!cart.items.any((item) => item.productId == product.id)) {
      final CartItem item = CartItem(
        productId: product.id,
        productName: product.name,
        price: product.price,
        imageUrl: product.imageUrl,
        discount: product.discount,
        quantity: 1,
      );
      cart.items.add(item);
      await _updateCart(cart);
    }
  }

  Future<void> removeItemFromCart(String productId) async {
    final Cart cart = await _getCart();
    cart.items.removeWhere((item) => item.productId == productId);
    await _updateCart(cart);
  }

  Future<void> intOrDecItemQuantity(String productId, int quantity) async {
    final Cart cart = await _getCart();
    final int index =
        cart.items.indexWhere((item) => item.productId == productId);
    cart.items[index].quantity += quantity;
    await _updateCart(cart);
  }

  Future<void> clearCart() async {
    await _updateCart(Cart(items: []));
  }
}
