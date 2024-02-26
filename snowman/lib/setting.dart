import 'package:flutter/material.dart';
import 'package:encrypt/encrypt.dart' as enc;
import 'package:snowman/main.dart';
import 'dataaccess.dart';

import 'config.dart';

class SettingPage extends StatelessWidget {

  // 설정 변수
  ConfigStorage _config = new ConfigStorage();

  // 인풋컨트롤러
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();
  final TextEditingController _noController = TextEditingController();

  Map<String, dynamic> input = Map<String, dynamic>();
  dataAccess _dtAcc = new dataAccess();

  @override
  Widget build(BuildContext context) {
    // 초기 저장 설정값 세팅
    _config.readConfig().then((value) {
      input = value;
      //print("저장된 값:$input");
      _idController.text = input['id'];
      //_pwController.text = input['pw'];
      _pwController.text = _config.decTools(input['pwEnc']); // 비밀번호는 복호화      
      _noController.text = input['no'];
    }); 

    return ScaffoldMessenger(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(icon: Icon(Icons.arrow_back_ios), onPressed: (){
            //Navigator.pop(context);
            //Navigator.of(context).pop('result');
            //Navigator.pop(context,MaterialPageRoute(builder: (context) => MyApp()));
            print("리프레쉬가 되어야함:1");
            _dtAcc.setLogin().then((responseData) {
              print("setLogin 값:${responseData}");

              // 값이 없는 경우 설정으로 전환
              if(responseData['result'].toString()!='로그인성공'){
                print("tmp 값:${responseData['result']}");
                Navigator.push(context, MaterialPageRoute(builder: (context) => SettingPage())); // 설정페이지로 이동
              }
              else {    //값이 있는 경우 값을 변수에 매칭

              }
              Navigator.pop(context,MaterialPageRoute(builder: (context) => MyApp()));
            });
          }),
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
                  width: 320,
                  child: TextField(
                    controller: _idController,
                    //obscureText: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'ID',
                    ),
                    onChanged:(text){
                      input['id']=text;
                    }
                  ),
                ),                  
                Padding(
                  padding: const EdgeInsets.only(top:20),
                ),
                SizedBox(
                  width: 320,
                  child: TextField(
                    controller: _pwController,
                    obscureText: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: '비밀번호',
                    ),
                    onChanged:(text){
                      //input['pw']=text;
                      input['pwEnc']=_config.encTools(text);  // 비밀번호는 암호화                      
                    }
                  ),
                ),  
                Padding(
                  padding: const EdgeInsets.only(top:20),
                ),
                SizedBox(
                  width: 320,
                  child: TextField(
                    controller: _noController,
                    //obscureText: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: '전화번호(-제거)',
                    ),
                    onChanged:(text){
                      input['no']=text;
                    }
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
                    print("저장된 값:1");
                    //print("저장된 값:$input");         // 입력값 확인
                    _config.writeConfig(input);
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