
import 'package:equatable/equatable.dart';

class Comment extends Equatable {
  final int postId;
  final int id;
  final String name;
  final String email;
  final String body;

  // Constructor
  Comment({
    required this.postId,
    required this.id,
    required this.name,
    required this.email,
    required this.body,
  });

  // Create Comment object from JSON
  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      postId: json['postId'] as int,
      id: json['id'] as int,
      name: json['name'] as String,
      email: json['email'] as String,
      body: json['body'] as String,
    );
  }

  // move Comment object become JSON
  Map<String, dynamic> toJson() {
    return {
      'postId': postId,
      'id': id,
      'name': name,
      'email': email,
      'body': body,
    };
  }
  
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}
