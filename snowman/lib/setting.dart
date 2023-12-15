import 'package:flutter/material.dart';

class SettingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      child: Scaffold(
        appBar: AppBar(
          title: Text('설정'),
        ),
        body: Builder( // 빌더를 통해서 context를 받아야 해.
          builder: (context){
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'snowMan 홈페이지 계정 설정',
                  style: TextStyle(fontSize: 20.0, color: Colors.redAccent),
                ),
                Padding(
                  padding: const EdgeInsets.only(top:20),
                ),
                SizedBox(
                  width: 300,
                  child: TextField(
                    //obscureText: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'ID',
                    ),
                  ),
                ),                  
                Padding(
                  padding: const EdgeInsets.only(top:20),
                ),
                SizedBox(
                  width: 300,
                  child: TextField(
                    obscureText: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: '비밀번호',
                    ),
                  ),
                ),  
                Padding(
                  padding: const EdgeInsets.only(top:20),
                ),
                SizedBox(
                  width: 300,
                  child: TextField(
                    //obscureText: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: '전화번호(-제거)',
                    ),
                  ),
                ),                  
                Padding(
                  padding: const EdgeInsets.only(top:20),
                ),                
                ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar( // 스캐폴드 메신저가 스낵바 들고 있음!!
                      // 이렇게 하면 화면을 빠져나가서 context가 사라지면 스낵바가 사라져서 UI개선
                      content: Text("설정이 저장되었습니다."),
                      duration: Duration(seconds: 3),
                    ));
                  },
                  child: Text('저장'),
                ),
              ],
            ),
          );}

        ),
      ),
    );
  }
}