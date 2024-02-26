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
  String keyStr = "";   // 조회키

  Map<String, dynamic> useData={};

  httpCurl _curl = new httpCurl();
  //String body=''; 
  // 로그인 후 데이터 확인
  Future<void> getUseData() async{
    String url = "https://www.snowman.co.kr/portal/mysnowman/useQntyRetv/rtimeUseQnty";
    print("데이터 불러오기!");  
    //var bodyData = await _curl.get(url);    
    if(keyStr == "") {
      String bodyData = await _curl.get(url);
      await parseUseData(bodyData);
    } 
    else 
    {
      String bodyData = await _curl.post(url,{'svcNo': keyStr});
      await parseUseData(bodyData);
    }
  }
  Future<void>  parseUseData(String bodyData) async{
    if(bodyData.contains("잔여량")){
      var document = parser.parse(bodyData);
      var svcNo = document.querySelectorAll('#svcNo')[0];
      var options = svcNo.querySelectorAll('option');
      int i=0;
      if(keyStr == ""){   // 조회키가 없는 경우
        String regPhoneNo = _noController.text.substring(0,5) + "***" + _noController.text.substring(8);
        for(var option in options){
          print("outerHtml 반환 : ${option?.outerHtml}");
          useData['key'+i.toString()] = option?.attributes['value'];
          useData['val'+i.toString()] = option?.innerHtml;
          if(regPhoneNo == useData['val'+i.toString()].toString().substring(0,13).replaceAll('-','')) keyStr=useData['key'+i.toString()].toString();
          i++;            
        }
        print("전화번호 keyStr : ${keyStr}");
        await getUseData();
      }
      else {    // 조회키로 조회된 값 처리!
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
        //print("get 저장된 값:${useData}");
      }      
    }
    else print("로그인실패!");
  }

  // 로그인 처리
  Future<void> processLogin() async{
    var input = await _config.readConfig();
    _idController.text = input['id'];
    _pwController.text = this.decTools(input['pwEnc']); // 비밀번호는 복호화
    _noController.text = input['no'];
    _curl.headers['Referer'] = "https://www.snowman.co.kr/portal/mysnowman/useQntyRetv/rtimeUseQnty";
    var data = { 'loginId' : _idController.text, 'loginPwd' : _pwController.text };
    //print("data 값:${data}");
    String url = "https://www.snowman.co.kr/portal/login/process";
    String responseBody =  await _curl.post(url,data);
    if(_curl.responseData.statusCode == 302){
        //print("responsestatusCode 값:${_curl.responseData.statusCode}");
        await getUseData();   // 데이터 불러오기
    }
  }  


  Future<Map<String, dynamic>> setLogin() async{
    await processLogin();
    return useData;
  }

  /*
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
  void testCall3(ObjectCallback callback){
    var str = {};
    str[0] = 0;
    str[1] = 1;
    callback(str);
  }*/
}
//typedef StringCallback = void Function(String);
//typedef ObjectCallback = void Function(Object);

