import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:social_app/social/models/comment.dart';
import '../models/photo.dart';

class CommentRepository {
  final String baseUrl;
  final int limit = 5;
  CommentRepository(
      {this.baseUrl = "https://jsonplaceholder.typicode.com/posts"});
  // get comment by ID Post
  Future<List<Comment>> fetchCommentsByIdPost(int start, int id) async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/$id/comments?_start=$start&_limit=$limit'));
      if (response.statusCode == 200) {
        List<dynamic> jsonList = json.decode(response.body);
        return jsonList.map((json) => Comment.fromJson(json)).toList();
      } else {
        throw Exception("Failed to load photo with ID: $id");
      }
    } catch (e) {
      throw Exception("Error fetching photo by ID: $e");
    }
  }

  // add a imageimage (POST)
  Future<Comment> addComment(Comment comment, int id) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/$id/comments'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(comment.toJson()),
      );

      if (response.statusCode == 201) {
        return Comment.fromJson(json.decode(response.body));
      } else {
        throw Exception(
            "Failed to add comment. Status Code: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error adding comment: $e");
    }
  }

  // update a image (PUT)
  Future<Photo> updatePhoto(int id, Photo photo) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/$id'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(photo.toJson()),
      );

      if (response.statusCode == 200) {
        return Photo.fromJson(json.decode(response.body));
      } else {
        throw Exception("Failed to update photo with ID: $id");
      }
    } catch (e) {
      throw Exception("Error updating photo: $e");
    }
  }

  // deleted a image (DELETE)
  Future<void> deletePhoto(int id) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/$id'));

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception("Failed to delete photo with ID: $id");
      }
    } catch (e) {
      throw Exception("Error deleting photo: $e");
    }
  }
}
