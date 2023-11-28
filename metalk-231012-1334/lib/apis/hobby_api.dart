import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_metalk/model/hobby_vo.dart';

class HobbyApi {
  static final CollectionReference _hobbysRef = FirebaseFirestore.instance.collection('hobbys');

  static Future<HobbyVo?> getHobby(String id) async {
    DocumentSnapshot documentSnapshot = await _hobbysRef.doc(id).get();
    if (documentSnapshot.exists) {
      HobbyVo hobbyVo = HobbyVo.fromQueryDocumentSnapshot(documentSnapshot);
      return hobbyVo;
    } else {
      return null;
    }
  }

  static Future<List<HobbyVo>> getHobbys() async {
    QuerySnapshot querySnapshot = await _hobbysRef.get();
    List<HobbyVo> results = List<HobbyVo>.from(querySnapshot.docs.map((e) => HobbyVo.fromQueryDocumentSnapshot(e)));
    if (results.isEmpty) {
      results = await initHobbys();
    }
    return results;
  }

  static Future<HobbyVo> createHobby({
    required String title,
    required DateTime createDt,
  }) async {
    DocumentReference res = await _hobbysRef.add({
      'title': title,
      'createDt': createDt,
    });
    return HobbyVo.fromQueryDocumentSnapshot(await res.get());
  }

  static Future<List<HobbyVo>> initHobbys() async {
    for (int i = 0; i < 9; i++) {
      await createHobby(
        title: '취미',
        createDt: DateTime.now(),
      );
    }

    return await getHobbys();
  }
}