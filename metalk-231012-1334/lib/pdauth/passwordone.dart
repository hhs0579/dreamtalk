import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_metalk/colors/colors.dart';
import 'package:flutter_metalk/pdauth/passwordtwo.dart';

class PassWordOnePage extends StatefulWidget {
  const PassWordOnePage({super.key});

  @override
  State<PassWordOnePage> createState() => _PassWordOnePageState();
}

class _PassWordOnePageState extends State<PassWordOnePage> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        leading: const Icon(
          Icons.arrow_back_ios_rounded,
          color: Colors.grey,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 15.0, top: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text(
                      '보내드린',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    Text(
                      '인증번호 6자리',
                      style: TextStyle(
                        color: ColorList.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                      const Text(
                      '를',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
                  const Text(
                  '입력해주세요',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            const Text(
              '인증번호',
              style: TextStyle(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              width: width / 1.1,
              child: TextFormField(
                // controller: _controlleremail,
                decoration: const InputDecoration(
                  //누를떄 컨테이너 모양
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                    borderSide: BorderSide(
                      color: Colors.black,
                    ),
                  ),
                  //누르기 전 컨테이너 모양
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                    borderSide: BorderSide(
                      color: Colors.black,
                    ),
                  ),
                  hintText: '인증번호 6자리',

                  hintStyle: TextStyle(
                    fontSize: 13.0,
                  ),
                ),
                onChanged: ((value) {
                  setState(
                    () {
                      // userId = value;
                    },
                  );
                }),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushReplacement<void, void>(
                  context,
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) => const PassWordTwoPage(),
                  ),
                );
              },
              child: Container(
                width: width / 1.1,
                height: 50,
                decoration: BoxDecoration(
                  color: ColorList.primary,
                  borderRadius: BorderRadius.circular(
                    15,
                  ),
                ),
                child: const Center(
                  child: Text(
                    '확인',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 17.0,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.question_mark,
                  size: 13,
                ),
                const Text(
                  '인증문자를 받지 못하셨나요?',
                  style: TextStyle(
                    fontSize: 13.0,
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Column(
                  children: [
                    const Text(
                      '인증문자 재발송',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 13.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Container(
                      color: Colors.grey,
                      width: width / 4.7,
                      height: 1,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
