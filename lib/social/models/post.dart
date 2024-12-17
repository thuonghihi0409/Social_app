
import 'package:equatable/equatable.dart';

class Post extends Equatable {
  final int userId;
  final int id;
  final String title;
  final String body;

  // Constructor
  Post({
    required this.userId,
    required this.id,
    required this.title,
    required this.body,
  });
  
  @override
  // TODO: implement props
  List<Object?> get props => [userId, id, title, body];
// create a Post object from JSON
  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      userId: json['userId'] as int,
      id: json['id'] as int,
      title: json['title'] as String,
      body: json['body'] as String,
    );
  }

// move Post object become JSON
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'id': id,
      'title': title,
      'body': body,
    };
  }
  
}
