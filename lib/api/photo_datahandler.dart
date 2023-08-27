import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:opslagstavlen/api/photo_local_datahandler.dart';
import 'package:opslagstavlen/model/photo.dart';

class PhotoDataHandler {
  final baseUrl = 'http://10.0.2.2:27016/api/GalleryEntry';

  Future<Photo> getPhotoById(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/$id'));

    if (response.statusCode != 200) {
      throw Exception(
          '[ERROR] Failed to get - response code: ${response.statusCode}');
    }

    return Photo.fromJson(jsonDecode(response.body));
  }

  Future<List<Photo>> getPhotoCollection() async {
    final response = await http.get(Uri.parse(baseUrl));
    List<Photo> tempCollection = [];
    final local = PhotoLocalDataHandler();

    // If request doesn't succeed, return collection from local storage instead
    if (response.statusCode != 200) {
      return await local.getPhotoLocalCollection();
    }

    for (var item in json.decode(response.body)) {
      Photo photo = Photo.fromJson(item);
      tempCollection.add(photo);
    }

    return tempCollection;
  }

  Future<Photo> createPhoto(Photo photo) async {
    final response = await http.post(Uri.parse(baseUrl),
        headers: <String, String>{'Content-Type': 'application/json'},
        body: photo.toJson());

    final local = PhotoLocalDataHandler();

    // If request fails, it saves to local db with a temporary id instead
    if (response.statusCode != 201) {
      return local.createPhotoLocal(photo, null);
    }

    // Saves a local copy with the id from the created object
    local.createPhotoLocal(photo, Photo.fromJson(jsonDecode(response.body)).id);

    return Photo.fromJson(jsonDecode(response.body));
  }

  Future<Photo> updatePhoto(Photo photo) async {
    final response = await http.put(Uri.parse(baseUrl),
        headers: <String, String>{'Content-Type': 'application/json'},
        body: photo.toJson());

    if (response.statusCode != 204) {
      throw Exception(
          '[ERROR] Failed to put - response code: ${response.statusCode}');
    }

    return Photo.fromJson(jsonDecode(response.body));
  }

  Future<void> deletePhotoById(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));

    if (response.statusCode != 204) {
      throw Exception(
          '[ERROR] Failed to delete - response code: ${response.statusCode}');
    }
  }
}
