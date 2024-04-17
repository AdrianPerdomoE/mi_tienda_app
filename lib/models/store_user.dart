import 'package:cloud_firestore/cloud_firestore.dart';

import './cart.dart';

const customer = "Customer";
const admin = "Admin";

class IUser {
  String id;
  String email;
  String name;
  String role;
  Timestamp creationDate;
  String imageUrl;
  IUser({
    required this.id,
    required this.email,
    required this.name,
    required this.role,
    required this.creationDate,
    required this.imageUrl,
  });
  IUser.fromJson(Map<String, dynamic> json)
      : id = json['id'] ?? '',
        email = json['email'] ?? '',
        name = json['name'] ?? '',
        role = json['role'] ?? '',
        imageUrl = json['image'] ?? '',
        creationDate = json['creationDate'] ?? Timestamp.now();
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'role': role,
      'image': imageUrl,
      'creationDate': creationDate,
    };
  }
}

class Admin extends IUser {
  Admin({
    required super.id,
    required super.email,
    required super.name,
    required super.creationDate,
    required super.imageUrl,
  }) : super(
          role: admin,
        );

  Admin.fromJson(super.json) : super.fromJson();
}

class Customer extends IUser {
  String address;
  Cart cart;

  double maxCredit;

  Customer({
    required super.id,
    required super.email,
    required super.name,
    required super.creationDate,
    required this.address,
    required this.cart,
    required this.maxCredit,
    required super.imageUrl,
  }) : super(
          role: customer,
        );

  Customer.fromJson(super.json)
      : address = json['address'] ?? '',
        maxCredit = json['maxCredit'] ?? 0.0,
        cart = Cart.fromJson(json['cart'] ?? {}),
        super.fromJson();
  @override
  toJson() {
    return {
      'cart': cart.toJson(),
      'maxCredit': maxCredit,
      'address': address,
      ...super.toJson()
    };
  }
}
