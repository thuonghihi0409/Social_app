import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/photo.dart';

class PhotoRepository {
  final String baseUrl;
 final int limit=5;
  PhotoRepository({this.baseUrl = "https://jsonplaceholder.typicode.com/photos"});

  // get list images from API
  Future<List<Photo>> fetchPhotos(int start) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl?_start=$start&_limit=$limit'),);

      if (response.statusCode == 200) {
        // Decode JSON and move become List<Photo>
        List<dynamic> jsonList = json.decode(response.body);
        return jsonList.map((json) => Photo.fromJson(json)).toList();
      } else {
        throw Exception("Failed to load photos. Status Code: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error fetching photos: $e");
    }
  }

  // get image by ID
  Future<Photo> fetchPhotoById(int id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/$id'));

      if (response.statusCode == 200) {
        return Photo.fromJson(json.decode(response.body));
      } else {
        throw Exception("Failed to load photo with ID: $id");
      }
    } catch (e) {
      throw Exception("Error fetching photo by ID: $e");
    }
  }

  // add a imageimage (POST)
  Future<Photo> addPhoto(Photo photo) async {
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
