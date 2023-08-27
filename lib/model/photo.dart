import 'dart:typed_data';
import 'dart:convert';

class Photo {
  final String? id;
  final Uint8List image;
  final String description;
  final String fileType;
  final String fileName;

  Photo({
    this.id,
    required this.image,
    required this.description,
    required this.fileType,
    required this.fileName,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
    result.addAll({'id': id});
    result.addAll({'base64Image': base64.encode(image)});
    result.addAll({'description': description});
    result.addAll({'fileName': fileName});
    result.addAll({'filetype': fileType});

    return result;
  }

  factory Photo.fromJson(Map<String, dynamic> json) {
    String id = json['id'];
    Uint8List image = base64.decode(json['base64Image']);
    String description = json['description'];
    String fileName = json['fileName'];
    String fileType = json['filetype'];

    return Photo(
        id: id,
        image: image,
        description: description,
        fileName: fileName,
        fileType: fileType);
  }

  String toJson() => json.encode(toMap());
}
