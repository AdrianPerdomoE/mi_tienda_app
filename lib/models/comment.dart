class Comment {
  String creator;
  String content;
  DateTime creationDate;

  Comment({
    required this.creator,
    required this.content,
    required this.creationDate,
  });

  Comment.fromJson(Map<String, dynamic> json)
      : creator = json['creator'],
        content = json['content'],
        creationDate = DateTime.parse(json['creationDate']);

  Map<String, dynamic> toJson() {
    return {
      'creator': creator,
      'content': content,
      'creationDate': creationDate.toString(),
    };
  }
}
