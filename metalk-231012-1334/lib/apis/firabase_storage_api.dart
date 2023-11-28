import 'dart:io';
import 'dart:math';

import 'package:firebase_storage/firebase_storage.dart';

class FirebaseStorageApi {
  static final FirebaseStorage _storage = FirebaseStorage.instance;
  static const uploadPathProfile = 'profile/';

  static Future<String?> uploadFile(File file, String uploadPath) async {
    try {
      Reference reference = _storage.ref('$uploadPath${getUploadFileName()}');
      await reference.putFile(file);
      String downloadURL = await reference.getDownloadURL();
      return downloadURL;
    } catch (e) {
      return null;
    }
  }

  static String getUploadFileName() {
    return '${Random().nextInt(900000) + 100000}' // 100000 ~ 999999 (6자리)
        '${DateTime.now().millisecondsSinceEpoch}' // 13자리
        '${Random().nextInt(900000) + 100000}'; // 100000 ~ 999999 (6자리)
  }
}