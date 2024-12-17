import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/post.dart';

class PostRepository {
  final String baseUrl;
  final int limit=5;
  PostRepository({this.baseUrl = "https://jsonplaceholder.typicode.com/posts"});

  // Fetch posts with pagination
  Future<List<Post>> fetchPosts(int start) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl?_start=$start&_limit=$limit'),
      );

      if (response.statusCode == 200) {
        // Decode JSON into List<Post>
        List<dynamic> jsonList = json.decode(response.body);
        return jsonList.map((json) => Post.fromJson(json)).toList();
      } else {
        throw Exception("Failed to load posts. Status Code: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error fetching posts: $e");
    }
  }
}
