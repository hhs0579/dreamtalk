import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_metalk/model/ideal_vo.dart';

class IdealApi {
  static final CollectionReference _idealsRef = FirebaseFirestore.instance.collection('ideals');

  static Future<IdealVo?> getIdeal(String id) async {
    DocumentSnapshot documentSnapshot = await _idealsRef.doc(id).get();
    if (documentSnapshot.exists) {
      IdealVo idealVo = IdealVo.fromQueryDocumentSnapshot(documentSnapshot);
      return idealVo;
    } else {
      return null;
    }
  }

  static Future<List<IdealVo>> getIdeals() async {
    QuerySnapshot querySnapshot = await _idealsRef.get();
    List<IdealVo> results = List<IdealVo>.from(querySnapshot.docs.map((e) => IdealVo.fromQueryDocumentSnapshot(e)));
    if (results.isEmpty) {
      results = await initIdeals();
    }
    return results;
  }

  static Future<IdealVo> createIdeal({
    required String title,
    required DateTime createDt,
  }) async {
    DocumentReference res = await _idealsRef.add({
      'title': title,
      'createDt': createDt,
    });
    return IdealVo.fromQueryDocumentSnapshot(await res.get());
  }

  static Future<List<IdealVo>> initIdeals() async {
    for (int i = 0; i < 7; i++) {
      await createIdeal(
        title: '이상형',
        createDt: DateTime.now(),
      );
    }

    return await getIdeals();
  }
}