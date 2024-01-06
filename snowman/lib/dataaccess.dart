import 'httpcurl.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:encrypt/encrypt.dart' as enc;
import 'config.dart';


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

  httpCurl _curl = new httpCurl();
  //String body='';

  Future<String> getPageCall(String url) async {
    var responseBody = await _curl.get(url);
    //print("responseBody 값:${_curl.responseData.body}");
    return "getPageCall";
  }

  void getUseData(){
    String url = "https://www.snowman.co.kr/portal/mysnowman/useQntyRetv/rtimeUseQnty";
    _curl.get(url).then((bodyData){
      //print("get 저장된 값:${bodyData}");      
    });
  }

  void processLogin(){
    _config.readConfig().then((value) {
      input = value;
      _idController.text = input['id'];
      _pwController.text = this.decTools(input['pwEnc']); // 비밀번호는 복호화
      _noController.text = input['no'];
      print("_pwController 저장된 값:${_pwController.text}");
      _curl.headers['Referer'] = "https://www.snowman.co.kr/portal/mysnowman/useQntyRetv/rtimeUseQnty";
      var data = { 'loginId' : _idController.text, 'loginPwd' : _pwController.text };
      //String url = "http://localhost:21098/?id=1&pw=2";
      String url = "https://www.snowman.co.kr/portal/login/process";
      _curl.post(url,data).then((value) {
        print("로그인처리");
        print("responseHeader 값:${_curl.responseData.headers}");
        //print("responseBody 값:${_curl.responseData.body}");
        if(_curl.responseData.statusCode == 302){
          //print("responsestatusCode 값:${_curl.responseData.statusCode}");
          getUseData();   // 데이터 불러오기
        }
      });
    });
  }

  String setLogin(){
    String url = "https://www.snowman.co.kr/portal/login";
    getPageCall(url).then((value) {
      //print("responseBody 값:${_curl.responseData.body}");
      processLogin();
    });
    return "1";

     
    
    
    //_curl.post("http://localhost:21098/?id=1&pw=2",data).then((value) {
    //_curl.post("http://dev4.tsherpamall.co.kr/sdhtest/apiTest",data).then((value) {
    //_curl.post("https://www.snowman.co.kr/portal/login/process",data).then((value) {
      //body=getList();
    //});

    /*var url = Uri.https('www.snowman.co.kr', 'portal/login/process');
    var response = http.post(url, body: { 'loginId' : 'goorm80', 'loginPwd' : 'Kf80sdh123' });
    response.then((resp) {
      print("resp 값:$resp"); 
    });
    print('Response: ${response}');*/
    
    //print('Response status: ${response.statusCode}');
    //print('Response body: ${response.body}');



    /*var data = { 'loginId' : 'goorm80', 'loginPwd' : 'Kf80sdh123' };
    http.postFormData('https://www.snowman.co.kr/portal/login/process', data).then((HttpRequest resp) {
      print("data 값:$data"); 
      print("resp 값:$resp"); 
      // Do something with the response.
    });*/
    return "121";
  }

  String getList(){
    _curl.get("https://www.snowman.co.kr/portal/mysnowman/useQntyRetv/rtimeUseQnty").then((value) {
      print("responseBody 값:${_curl.responseData.headers}"); 
    });
    return "getLists";
  }  
}
