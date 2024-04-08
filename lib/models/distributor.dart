import './Category.dart';
import './Comment.dart';

class Distributor {
  String name;
  String imageUrl;
  String number;
  String email;
  String adress;
  List<Category> categories;
  List<Comment> comments;
  String description;
  double rating;
  Distributor({
    required this.name,
    required this.imageUrl,
    required this.number,
    required this.email,
    required this.adress,
    required this.categories,
    required this.comments,
    required this.description,
    required this.rating,
  });
  Distributor.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        imageUrl = json['imageUrl'],
        number = json['number'],
        email = json['email'],
        adress = json['adress'],
        categories = json['categories']
            .map<Category>((category) => Category.fromJson(category))
            .toList(),
        comments = json['comments']
            .map<Comment>((comment) => Comment.fromJson(comment))
            .toList(),
        description = json['description'],
        rating = json['rating'];
}
