import 'httpcurl.dart';

import 'package:http/http.dart' as http;



class dataAccess {

  httpCurl _curl = new httpCurl();
  String body='';

  String setLogin(){
    //_curl.get("https://www.snowman.co.kr/portal/login/process").then((value) {
    var data = { 'loginId' : 'goorm80', 'loginPwd' : 'Kf80sdh123' };
    
    _curl.post("http://dev4.tsherpamall.co.kr/sdhtest/apiTest",data).then((value) {
    //_curl.post("https://www.snowman.co.kr/portal/login/process",data).then((value) {
      print("responseHeader 값:${_curl.responseData.headers}");
      //body=getList();
    });

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
