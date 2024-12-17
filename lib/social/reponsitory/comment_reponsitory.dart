import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:social_app/social/models/comment.dart';
import '../models/photo.dart';

class CommentRepository {
  final String baseUrl;

  CommentRepository({this.baseUrl = "https://jsonplaceholder.typicode.com/posts"});

  
 

  // get comment by ID Post
  Future<Comment> fetchCommentsByIdPost(int id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/$id/comments'));
      if (response.statusCode == 200) {
        return Comment.fromJson(json.decode(response.body));
      } else {
        throw Exception("Failed to load photo with ID: $id");
      }
    } catch (e) {
      throw Exception("Error fetching photo by ID: $e");
    }
  }

  // add a imageimage (POST)
  Future<Photo> addComment(Photo photo) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(photo.toJson()),
      );

      if (response.statusCode == 201) {
        return Photo.fromJson(json.decode(response.body));
      } else {
        throw Exception("Failed to add photo. Status Code: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error adding photo: $e");
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
