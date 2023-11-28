import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_metalk/model/interest_vo.dart';

class InterestApi {
  static final CollectionReference _interestsRef = FirebaseFirestore.instance.collection('interests');

  static Future<InterestVo?> getInterest(String id) async {
    DocumentSnapshot documentSnapshot = await _interestsRef.doc(id).get();
    if (documentSnapshot.exists) {
      InterestVo interestVo = InterestVo.fromQueryDocumentSnapshot(documentSnapshot);
      return interestVo;
    } else {
      return null;
    }
  }

  static Future<List<InterestVo>> getInterests() async {
    QuerySnapshot querySnapshot = await _interestsRef.get();
    List<InterestVo> results = List<InterestVo>.from(querySnapshot.docs.map((e) => InterestVo.fromQueryDocumentSnapshot(e)));
    if (results.isEmpty) {
      results = await initInterests();
    }
    return results;
  }

  static Future<InterestVo> createInterest({
    required String iconUrl,
    required String title,
    required DateTime createDt,
  }) async {
    DocumentReference res = await _interestsRef.add({
      'iconUrl': iconUrl,
      'title': title,
      'createDt': createDt,
    });
    return InterestVo.fromQueryDocumentSnapshot(await res.get());
  }

  static Future<List<InterestVo>> initInterests() async {
    await createInterest(
      iconUrl: 'https://firebasestorage.googleapis.com/v0/b/metalk-95884.appspot.com/o/common%2Fcamara.png?alt=media&token=47de5f6b-63e7-4122-bce2-920b676480af',
      title: '사진찍기',
      createDt: DateTime.now(),
    );
    await createInterest(
      iconUrl: 'https://firebasestorage.googleapis.com/v0/b/metalk-95884.appspot.com/o/common%2Fplaseddd.png?alt=media&token=4ed561a8-bc9e-43c3-a4d2-f5594a859042',
      title: '해외여행',
      createDt: DateTime.now(),
    );
    await createInterest(
      iconUrl: 'https://firebasestorage.googleapis.com/v0/b/metalk-95884.appspot.com/o/common%2Fmovic.png?alt=media&token=5318b48d-3506-47b7-aef1-2e2caa21635d',
      title: '영화감상',
      createDt: DateTime.now(),
    );
    await createInterest(
      iconUrl: 'https://firebasestorage.googleapis.com/v0/b/metalk-95884.appspot.com/o/common%2Fmovic.png?alt=media&token=5318b48d-3506-47b7-aef1-2e2caa21635d',
      title: '문화생활',
      createDt: DateTime.now(),
    );
    await createInterest(
      iconUrl: 'https://firebasestorage.googleapis.com/v0/b/metalk-95884.appspot.com/o/common%2Fheart.png?alt=media&token=70390643-484f-4d02-ab44-102059eb1f4c',
      title: '운동',
      createDt: DateTime.now(),
    );
    await createInterest(
      iconUrl: 'https://firebasestorage.googleapis.com/v0/b/metalk-95884.appspot.com/o/common%2Fmovic.png?alt=media&token=5318b48d-3506-47b7-aef1-2e2caa21635d',
      title: '영화감상',
      createDt: DateTime.now(),
    );

    return await getInterests();
  }
}