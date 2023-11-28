import 'package:flutter/cupertino.dart';

class ChatProvider with ChangeNotifier {
  int receivedChatCnt = 0;

  ChatProvider();

  void receiveChatMessage() {
    receivedChatCnt++;
    debugPrint('receiveChatMessage() - receivedChatCnt: $receivedChatCnt');
    notifyListeners();
  }
}