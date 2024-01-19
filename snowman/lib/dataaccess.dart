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

  void postData() async {
    _idController.text = input['id'];
    _pwController.text = this.decTools(input['pwEnc']); // 비밀번호는 복호화
    _noController.text = input['no'];

    var url = 'https://www.snowman.co.kr/portal/login/process';
    var headers = {
      'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36',
      'Accept': '*/*',
      'Accept-Encoding': 'gzip, deflate, br',
      'Connection': 'keep-alive',
      'Accept-Language': 'ko-KR,ko;q=0.9',
      'Cache-Control': 'max-age=0',
      'Content-Type': 'application/x-www-form-urlencoded',
      'Host': 'www.snowman.co.kr',
      'Origin': 'https://www.snowman.co.kr',
      'Referer': 'https: //www.snowman.co.kr/portal/login'
    };
    var body = { 'loginId' : _idController.text, 'loginPwd' : _pwController.text };

    var response = await http.post(Uri.parse(url), headers: headers, body: body);

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    String? rawCookie = response.headers['set-cookie'];
    if (rawCookie != null) {
      int index = rawCookie.indexOf(';');
      headers['cookie'] =
          (index == -1) ? rawCookie : rawCookie.substring(0, index);
    }
    String tmpCookie = headers['cookie'].toString();
    if(!tmpCookie.contains("popupDispYn")) headers['cookie'] = "${headers['cookie']};popupDispYn=N;";
    print("rawCookie 값:${headers['cookie']}");  
    print("response headers 값:${response.headers}");  
    
    var response2 = await http.get(Uri.parse('https://www.snowman.co.kr/portal/mysnowman/useQntyRetv/rtimeUseQnty'), headers: headers);

    print('Response status: ${response2.statusCode}');

    if(response2.body.contains("잔여량")) print("로그인 : 성공!");
    if(!response2.body.contains("잔여량")) print("로그인실패!");
  }

  void getUseData(){
    String url = "https://www.snowman.co.kr/portal/mysnowman/useQntyRetv/rtimeUseQnty";
    _curl.get(url).then((bodyData){
      //print("get 저장된 값:${bodyData}");
      if(bodyData.contains("잔여량")){
        print("get 저장된 값:${bodyData}");
      }
      else print("로그인실패!");
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
        print("로그인처리 시도");
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
    postData();
    //String url = "https://www.snowman.co.kr/portal/login";
    /*getPageCall(url).then((value) {
      //print("responseBody 값:${_curl.responseData.body}");
      processLogin();
    });*/
    //processLogin();
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
