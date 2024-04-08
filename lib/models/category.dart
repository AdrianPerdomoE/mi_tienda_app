class Category {
  String id;
  String name;
  bool hidden;
  DateTime creationDate;

  Category({
    required this.id,
    required this.name,
    required this.hidden,
    required this.creationDate,
  });

  Category.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        hidden = json['hidden'],
        creationDate = DateTime.parse(json['creationDate']);
}
