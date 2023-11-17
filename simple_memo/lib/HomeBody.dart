import 'package:flutter/material.dart';
import 'package:simple_memo/SecondPage.dart';


class HomeBody extends StatelessWidget {
  const HomeBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center( // 센터임!! 주
      child: ElevatedButton( // 엘레베이티드 버튼
        child: Text('Go to the second page'),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => SecondPage())); // 두번쨰 페이지로 전환
        },
      ),
    );
  }
}