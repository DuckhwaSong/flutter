import 'package:flutter/material.dart';
import 'package:simple_memo/ThirdPage.dart';

class FloatButton1 extends StatelessWidget {
  const FloatButton1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 150.0,
        height: 60.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            FloatingActionButton(
              onPressed: (){
                Navigator.push(context, // 네비게이션 형식으로 push형식으로 전환
                  MaterialPageRoute(builder: (context) => ThirdPage())
                ); // 화면전환 코드  
              },
              tooltip: 'Increment',
              child: const Icon(Icons.thumb_up),
            ),
            FloatingActionButton(
              onPressed: (){
                // 버튼을 눌렀을 때
                print("search is clicked");
              },
              tooltip: 'Increment',
              child: const Icon(Icons.thumb_up),
            ),            
          ],
        ),
      );
  }
}

