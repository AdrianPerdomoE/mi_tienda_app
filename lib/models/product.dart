class Product {
  String id;
  String name;
  String description;
  String imageUrl;
  double price;
  String categoryId;
  DateTime creationDate;
  bool hidden;
  int stock;
  double discount;

  Product({
    required this.id,
    required this.name,
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
      : id = json['id'],
        name = json['name'],
        description = json['description'],
        imageUrl = json['imageUrl'],
        price = json['price'],
        categoryId = json['categoryId'],
        creationDate = DateTime.parse(json['creationDate']),
        hidden = json['hidden'],
        stock = json['stock'],
        discount = json['discount'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'imageUrl': imageUrl,
        'price': price,
        'categoryId': categoryId,
        'creationDate': creationDate.toString(),
        'hidden': hidden,
        'stock': stock,
        'discount': discount,
      };
}
