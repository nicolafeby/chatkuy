import 'package:flutter/foundation.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseStorageService {
  static Future<String> uploadImage(Uint8List file, String storagePath) async {
    final metadata = SettableMetadata(
      contentType: 'image/jpeg',
    );
    return await FirebaseStorage.instance
        .ref()
        .child(storagePath)
        .putData(file, metadata)
        .then(
          (task) => task.ref.getDownloadURL(),
        );
  }
}
