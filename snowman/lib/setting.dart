import 'package:flutter/material.dart';
import 'package:encrypt/encrypt.dart' as enc;

import 'config.dart';

class SettingPage extends StatelessWidget {

  // 설정 변수
  ConfigStorage _config = new ConfigStorage();

  // 인풋컨트롤러
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();
  final TextEditingController _noController = TextEditingController();

  Map<String, dynamic> input = Map<String, dynamic>();

  // 암복호화 툴
  String encKey = 'SNOWMAN79SNOWMAN';
  String encIV = '1A23B456C7890DFE';  
  String encTools(String text){
    final encrypter=enc.Encrypter(enc.AES(enc.Key.fromUtf8(this.encKey)));
    return encrypter.encrypt(text,iv: enc.IV.fromUtf8(this.encIV)).base64;
  }  
  String decTools(String encString){
    final encrypter=enc.Encrypter(enc.AES(enc.Key.fromUtf8(this.encKey)));
    return encrypter.decrypt64(encString,iv: enc.IV.fromUtf8(this.encIV));
  }
  // [로그인]
  // https://www.snowman.co.kr/portal/login/process
  // goorm80/Kf80sdh123
  
  // [조회]
  // https://www.snowman.co.kr/portal/mysnowman/myInfo/submain
  // svcNo: K0QUhaLUsm+7o1UY+aWQBQ==

  // [조회]
  // https://www.snowman.co.kr/portal/mysnowman/useQntyRetv/rtimeUseQnty
  // svcNo: /o7YzZ/LALiqpWEsEsXVzw==
  // svcNo: K0QUhaLUsm+7o1UY+aWQBQ==

  @override
  Widget build(BuildContext context) {
    // 초기 저장 설정값 세팅
    _config.readConfig().then((value) {
      input = value;
      //print("저장된 값:$input");
      _idController.text = input['id'];
      //_pwController.text = input['pw'];
      _pwController.text = this.decTools(input['pwEnc']); // 비밀번호는 복호화
      _noController.text = input['no'];
    }); 

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
                      input['pwEnc']=this.encTools(text);  // 비밀번호는 암호화
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