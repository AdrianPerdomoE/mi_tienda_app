class Product {
  String name;
  String id;
  String description;
  String imageUrl;
  double price;
  String categoryId;
  DateTime creationDate;
  bool hidden;
  int stock;
  double discount;

  Product({
    required this.name,
    required this.id,
    required this.description,
    required this.imageUrl,
    required this.price,
    required this.categoryId,
    required this.creationDate,
    required this.hidden,
    required this.stock,
    required this.discount,
  });

  Product.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        id = json['id'],
        description = json['description'],
        imageUrl = json['imageUrl'],
        price = json['price'],
        categoryId = json['categoryId'],
        creationDate = DateTime.parse(json['creationDate']),
        hidden = json['hidden'],
        stock = json['stock'],
        discount = json['discount'];
}
