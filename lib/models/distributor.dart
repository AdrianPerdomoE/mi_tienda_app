import './comment.dart';

class Distributor {
  String id;
  String name;
  String imageUrl;
  String number;
  String email;
  String address;
  List<Comment> comments;
  String description;
  int rating;
  Distributor({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.number,
    required this.email,
    required this.address,
    required this.comments,
    required this.description,
    required this.rating,
  });
  Distributor.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        id = json['id'],
        imageUrl = json['imageUrl'],
        number = json['number'],
        email = json['email'],
        address = json['address'],
        comments = json['comments']
            .map<Comment>((comment) => Comment.fromJson(comment))
            .toList(),
        description = json['description'],
        rating = json['rating'];

  toJson() {
    return {
      'name': name,
      'id': id,
      'imageUrl': imageUrl,
      'number': number,
      'email': email,
      'address': address,
      'comments': comments.map((comment) => comment.toJson()).toList(),
      'description': description,
      'rating': rating,
    };
  }
}
