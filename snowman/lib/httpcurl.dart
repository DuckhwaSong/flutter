import 'package:http/http.dart' as http;

class httpCurl {
  Map<String, String> headers = {
    //'Content-Type': 'application/json',
    'User-Agent': 'swonmanApp',
    'Accept': '*/*',
    'Accept-Encoding': 'gzip, deflate, br',
    'Connection': 'keep-alive'
  };
  var responseData;

  Future<String> get(String url) async {
    var uri=Uri.parse(url);
    http.Response response = await http.get(uri, headers: headers);
    updateCookie(response);
    return response.body;
  }

  Future<String> post(String url, dynamic data) async {
    var uri=Uri.parse(url);
    print("cookie 값:${headers['cookie']}");
    http.Response response = await http.post(uri, body: data, headers: headers);
    print('Response status: ${response.statusCode}');
    updateCookie(response);
    this.responseData=response;
    return response.body;
  }

  void updateCookie(http.Response response) {
    //print("headers 값:${headers}");
    String? rawCookie = response.headers['set-cookie'];
    if (rawCookie != null) {
      int index = rawCookie.indexOf(';');
      headers['cookie'] =
          (index == -1) ? rawCookie : rawCookie.substring(0, index);
    }
    String tmpCookie = headers['cookie'].toString();
    if(!tmpCookie.contains("popupDispYn")) headers['cookie'] = "${headers['cookie']};popupDispYn=N;";
    print("rawCookie 값:${headers['cookie']}");
    //print("headers 값:${headers}");
  }
}