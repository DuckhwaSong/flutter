import 'httpcurl.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:encrypt/encrypt.dart' as enc;
import 'config.dart';
import 'package:html/parser.dart' as parser;    // html 파싱을 위해


class dataAccess {

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

  var useData={};

  httpCurl _curl = new httpCurl();
  //String body=''; 
  // 로그인 후 데이터 확인
  void getUseData(){
    String url = "https://www.snowman.co.kr/portal/mysnowman/useQntyRetv/rtimeUseQnty";
    print("데이터 불러오기!");    
    _curl.get(url).then((bodyData){
      //print("get 저장된 값:${bodyData}");
      if(bodyData.contains("잔여량")){
        //print("get 저장된 값:${bodyData}");
        //print("로그인성공!");

        var document = parser.parse(bodyData);
        var svcNo = document.querySelectorAll('#svcNo')[0];
        //print("텍스트만 추출 : ${svcNo?.text}");         // 텍스트만 추출  
        //print("innerHtml 반환 : ${svcNo?.innerHtml}");  // html 반환 child만
        //print("outerHtml 반환 : ${svcNo?.outerHtml}");  // html 반환 self 포함
        var options = svcNo.querySelectorAll('option');
        //print(options);
        int i=0;
        for(var option in options){
          print("outerHtml 반환 : ${option?.outerHtml}");
          useData['key'+i.toString()] = option?.attributes['value'];
          useData['val'+i.toString()] = option?.innerHtml;
          i++;
        }
        
        var realtimeContent = document.querySelectorAll('.real-time-box');
        i=0;
        for(var realtime in realtimeContent){
          //print(realtime.text);
          var progressLists = realtime.querySelectorAll('.progress-list > .data');
          for(var progressList in progressLists){
            useData['data'+i.toString()] = progressList.innerHtml.replaceAll(RegExp('\\s'), "");  // 문자열 공백을 제거한다.
            //useData['data'][i.toString()] = progressList.innerHtml.replaceAll(RegExp('\\s'), "");
            i++;
          }
        }
        

        useData['result'] = "로그인성공";
        print("get 저장된 값:${useData}");
      }
      else print("로그인실패!");
    });
  }

  // 로그인 처리
  void processLogin(){
    _config.readConfig().then((value) {
      input = value;
      _idController.text = input['id'];
      _pwController.text = this.decTools(input['pwEnc']); // 비밀번호는 복호화
      _noController.text = input['no'];
      _curl.headers['Referer'] = "https://www.snowman.co.kr/portal/mysnowman/useQntyRetv/rtimeUseQnty";
      var data = { 'loginId' : _idController.text, 'loginPwd' : _pwController.text };

      print("저장된 값:${data}");

      //String url = "http://localhost:21098/?id=1&pw=2";
      String url = "https://www.snowman.co.kr/portal/login/process";
      //String url = 'http://localhost:8880/test.php';
      _curl.post(url,data).then((value) {
        print("로그인처리 시도");
        print("responseHeader 값:${_curl.responseData.headers}");
        //print("responseBody 값:${_curl.responseData.body}");
        if(_curl.responseData.statusCode == 302){
          print("responsestatusCode 값:${_curl.responseData.statusCode}");
          getUseData();   // 데이터 불러오기
        }
      });
    });
  }

  String setLogin(){
    processLogin();
    return "1";
  }

  String getList(){
    _curl.get("https://www.snowman.co.kr/portal/mysnowman/useQntyRetv/rtimeUseQnty").then((value) {
      print("responseBody 값:${_curl.responseData.headers}"); 
    });
    return "getLists";
  }

  void testCall(VoidCallback callback){
    callback.call();
  }
  void testCall2(StringCallback callback){
    String str = 'str';
    callback(str);
  }
}
typedef StringCallback = void Function(String);

