import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_metalk/model/language_vo.dart';

class LanguageApi {
  static final CollectionReference _languagesRef = FirebaseFirestore.instance.collection('languages');

  static Future<LanguageVo?> getLanguage(String id) async {
    DocumentSnapshot documentSnapshot = await _languagesRef.doc(id).get();
    if (documentSnapshot.exists) {
      LanguageVo languageVo = LanguageVo.fromQueryDocumentSnapshot(documentSnapshot);
      return languageVo;
    } else {
      return null;
    }
  }

  static Future<List<LanguageVo>> getLanguages() async {
    QuerySnapshot querySnapshot = await _languagesRef.get();
    List<LanguageVo> results = List<LanguageVo>.from(querySnapshot.docs.map((e) => LanguageVo.fromQueryDocumentSnapshot(e)));
    if (results.isEmpty) {
      results = await initLanguages();
    }
    return results;
  }

  static Future<LanguageVo> createLanguage({
    required String iconUrl,
    required String title,
    required DateTime createDt,
  }) async {
    DocumentReference res = await _languagesRef.add({
      'iconUrl': iconUrl,
      'title': title,
      'createDt': createDt,
    });
    return LanguageVo.fromQueryDocumentSnapshot(await res.get());
  }

  static Future<List<LanguageVo>> initLanguages() async {
    await createLanguage(
      iconUrl: 'https://firebasestorage.googleapis.com/v0/b/metalk-95884.appspot.com/o/common%2Fkoreaa.png?alt=media&token=e84413c2-d734-4cd7-b81b-30a561bb3416',
      title: '한국어',
      createDt: DateTime.now(),
    );
    await createLanguage(
      iconUrl: 'https://firebasestorage.googleapis.com/v0/b/metalk-95884.appspot.com/o/common%2Fjapan.png?alt=media&token=f77c9ce7-65d8-491d-93c6-76d9f189a468',
      title: '일본어',
      createDt: DateTime.now(),
    );
    await createLanguage(
      iconUrl: 'https://firebasestorage.googleapis.com/v0/b/metalk-95884.appspot.com/o/common%2Fusa.png?alt=media&token=15b978f2-c51d-454b-a0df-0c02bee69844',
      title: '영어',
      createDt: DateTime.now(),
    );
    await createLanguage(
      iconUrl: 'https://firebasestorage.googleapis.com/v0/b/metalk-95884.appspot.com/o/common%2Fpari.png?alt=media&token=e9a5eeec-fd91-4fb8-aab0-cafd81f0925f',
      title: '불어',
      createDt: DateTime.now(),
    );
    await createLanguage(
      iconUrl: 'https://firebasestorage.googleapis.com/v0/b/metalk-95884.appspot.com/o/common%2Fchain.png?alt=media&token=df5f90d5-a598-4464-9391-acaecb82bdac',
      title: '중국어',
      createDt: DateTime.now(),
    );

    return await getLanguages();
  }
}