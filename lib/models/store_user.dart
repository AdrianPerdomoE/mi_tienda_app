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
      : id = json['id'],
        email = json['email'],
        name = json['name'],
        role = json['role'],
        imageUrl = json['image'],
        creationDate = json['creationDate'];
}

class Admin extends IUser {
  Admin({
    required String id,
    required String email,
    required String name,
    required Timestamp creationDate,
    required String imageUrl,
  }) : super(
          id: id,
          email: email,
          name: name,
          role: admin,
          creationDate: creationDate,
          imageUrl: imageUrl,
        );

  Admin.fromJson(Map<String, dynamic> json) : super.fromJson(json);
}

class Customer extends IUser {
  String address;
  Cart cart;

  double maxCredit;

  Customer({
    required String id,
    required String email,
    required String name,
    required Timestamp creationDate,
    required this.address,
    required this.cart,
    required this.maxCredit,
    required String imageUrl,
  }) : super(
          id: id,
          email: email,
          name: name,
          role: customer,
          creationDate: creationDate,
          imageUrl: imageUrl,
        );

  Customer.fromJson(Map<String, dynamic> json)
      : address = json['address'],
        maxCredit = json['maxCredit'],
        cart = Cart.fromJson(json['cart']),
        super.fromJson(json);
}
