import 'dart:convert';

import 'package:localstore/localstore.dart';
import 'package:opslagstavlen/model/photo.dart';

class PhotoLocalDataHandler {
  Future<List<Photo>> getPhotoLocalCollection() async {
    List<Photo> tempCollection = [];
    final db = Localstore.instance;

    final items = await db.collection('Photos').get();
    if (items != null) {
      for (var i = 0; i < items.length; i++) {
        tempCollection.add(Photo.fromJson(items[i]));
      }
    }
    return tempCollection;
  }

  Future<Photo> createPhotoLocal(Photo photo, String? id) async {
    final db = Localstore.instance;

    // Null check on id value, gets a new id if none was supplied
    id = photo.id ?? db.collection('Photos').doc().id;

    // Saves a local copy with the id from the created object
    db.collection('Photos').doc(id).set({
      'id': id,
      'base64Image': const Base64Encoder().convert(photo.image),
      'description': photo.description,
      'fileName': photo.fileName,
      'filetype': photo.fileType
    });

    final data = await db.collection('Photos').doc(id).get();

    if (data != null) {
      return Photo.fromJson(data);
    }
    return photo;
  }

    Future<void> deletePhotoLocalCollection() async {
    final db = Localstore.instance;
    db.collection("Photos").delete();
  }

  Future<void> deletePhotoLocalById(String id) async {
    final db = Localstore.instance;
    db.collection("Photos").doc(id).delete();
  }
}
