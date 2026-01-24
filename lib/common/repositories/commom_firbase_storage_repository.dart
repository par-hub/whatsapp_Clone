import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final CommomFirbaseStorageRepositoryProvider = Provider((ref) =>
    CommomFirbaseStorageRepository(firebaseStorage: FirebaseStorage.instance));

class CommomFirbaseStorageRepository {
  final FirebaseStorage firebaseStorage;

  CommomFirbaseStorageRepository({required this.firebaseStorage});

  Future<String> storeFileToFirebase(String ref, File file) async {
    UploadTask uploadTask = firebaseStorage.ref().child(ref).putFile(file);
    TaskSnapshot snap = await uploadTask;
    String downloadUrl = await snap.ref.getDownloadURL();
    return downloadUrl;
  }
}
