import 'dart:io';

import 'package:firebase_proje/services/storagebase.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FireStorageService implements StorageBase {
  FirebaseStorage _storage = FirebaseStorage.instance;

  @override
  Future<String?> uploadFile(
      String userID, String fileType, File uploadFile) async {
    final uploadTask =
        await _storage.ref().child(userID).child(fileType).putFile(uploadFile);

    String downloadURL =
        await _storage.ref().child(userID).child(fileType).getDownloadURL();

    return downloadURL;
  }


}
