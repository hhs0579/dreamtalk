import 'package:flutter_metalk/utils/utils.dart';
import 'package:intl/intl.dart';


class ChattingVo {
  String? id;
  String senderId;
  String receiverId;
  String message;
  DateTime createDt;
  bool isRead;

  ChattingVo({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.message,
    required this.createDt,
    required this.isRead,
  });

  factory ChattingVo.fromQueryDocumentSnapshot(dynamic snapshot) {
    Map<String, dynamic> json = snapshot.data() as Map<String, dynamic>;
    return ChattingVo(
      id: snapshot.id,
      senderId: json['senderId'],
      receiverId: json['receiverId'],
      message: json['message'],
      createDt: json['createDt'].toDate(),
      isRead: json['isRead'],
    );
  }

  Map<String, dynamic> toMap() => {
    'senderId': senderId,
    'receiverId': receiverId,
    'message': message,
    'createDt': createDt,
    'isRead': isRead,
  };

  factory ChattingVo.fromJSON(Map<String, dynamic> json) => ChattingVo(
    id: json['id'],
    senderId: json['senderId'],
    receiverId: json['receiverId'],
    message: json['message'],
    createDt: DateTime.parse(json['createDt']),
    isRead: json['isRead'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'senderId': senderId,
    'receiverId': receiverId,
    'message': message,
    'createDt': createDt.toString(),
    'isRead': isRead,
  };

  String get createDtStr => Utils.isSameDay(DateTime.now(), createDt)
      ? DateFormat('HH:mm').format(createDt)
      : DateFormat('MM-dd HH:mm').format(createDt);
}