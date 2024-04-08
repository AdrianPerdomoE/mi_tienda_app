import './cart.dart';

class User {
  String id;
  String email;
  String name;
  String address;
  Cart cart;
  String role;
  DateTime creationDate;
  double maxCredit;

  User({
    required this.id,
    required this.email,
    required this.name,
    required this.address,
    required this.role,
    required this.creationDate,
    required this.maxCredit,
    required this.cart,
  });

  User.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        email = json['email'],
        name = json['name'],
        address = json['address'],
        role = json['role'],
        creationDate = DateTime.parse(json['creationDate']),
        maxCredit = json['maxCredit'],
        cart = Cart.fromJson(json['cart']);
}
