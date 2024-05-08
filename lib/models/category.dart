import 'package:cloud_firestore/cloud_firestore.dart';

class Category {
  String id;
  String name;
  bool hidden;
  int order;
  Timestamp creationDate;

  Category({
    required this.id,
    required this.name,
    required this.hidden,
    required this.order,
    required this.creationDate,
  });

  Category.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        hidden = json['hidden'],
        order = json['order'],
        creationDate = json['creationDate'];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'hidden': hidden,
      'order': order,
      'creationDate': creationDate,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Category &&
        other.id == id &&
        other.name == name &&
        other.order == order;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ order.hashCode;
}
