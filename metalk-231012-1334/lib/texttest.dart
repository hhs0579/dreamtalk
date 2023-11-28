import 'package:flutter/material.dart';

class Texttest extends StatefulWidget {
  @override
  _TexttestState createState() => _TexttestState();
}

class _TexttestState extends State<Texttest> {
  final FocusNode _focusNode = FocusNode();
  TextEditingController _textEditingController = TextEditingController();

  @override
  void dispose() {
    _focusNode.dispose();
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Text Field Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _textEditingController,
              focusNode: _focusNode,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // 텍스트 필드의 포커스 해제
                _focusNode.unfocus();
              },
              child: Text('+ 버튼'),
            ),
          ],
        ),
      ),
    );
  }
}
