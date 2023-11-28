import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_metalk/model/character_vo.dart';

class CharacterApi {
  static final CollectionReference _charactersRef = FirebaseFirestore.instance.collection('characters');

  static Future<CharacterVo?> getCharacter(String id) async {
    DocumentSnapshot documentSnapshot = await _charactersRef.doc(id).get();
    if (documentSnapshot.exists) {
      CharacterVo characterVo = CharacterVo.fromQueryDocumentSnapshot(documentSnapshot);
      return characterVo;
    } else {
      return null;
    }
  }

  static Future<List<CharacterVo>> getCharacters() async {
    QuerySnapshot querySnapshot = await _charactersRef.get();
    List<CharacterVo> results = List<CharacterVo>.from(querySnapshot.docs.map((e) => CharacterVo.fromQueryDocumentSnapshot(e)));
    if (results.isEmpty) {
      results = await initCharacters();
    }
    return results;
  }

  static Future<CharacterVo> createCharacter({
    required String title,
    required DateTime createDt,
  }) async {
    DocumentReference res = await _charactersRef.add({
      'title': title,
      'createDt': createDt,
    });
    return CharacterVo.fromQueryDocumentSnapshot(await res.get());
  }

  static Future<List<CharacterVo>> initCharacters() async {
    for (int i = 0; i < 9; i++) {
      await createCharacter(
        title: '성격',
        createDt: DateTime.now(),
      );
    }

    return await getCharacters();
  }
}