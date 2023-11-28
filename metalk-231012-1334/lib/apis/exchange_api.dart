import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_metalk/model/exchange_vo.dart';

class ExchangeApi {
  static final CollectionReference _ref = FirebaseFirestore.instance.collection('exchanges');

  static Future<List<ExchangeVo>> getExchanges(String userId) async {
    QuerySnapshot querySnapshot = await _ref
        .where('userId', isEqualTo: userId)
        .get();
    return List<ExchangeVo>.from(querySnapshot.docs.map((e) => ExchangeVo.fromQueryDocumentSnapshot(e)));
  }

  static Future<ExchangeVo> createExchange(ExchangeVo vo) async {
    DocumentReference res = await _ref.add(vo.toMap());
    return ExchangeVo.fromQueryDocumentSnapshot(await res.get());
  }
}