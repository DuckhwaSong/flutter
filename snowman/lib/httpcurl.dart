import 'package:http/http.dart' as http;

class httpCurl {
  Map<String, String> headers = {
    'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36',
    'Accept': '*/*',
    'Accept-Encoding': 'gzip, deflate, br',
    'Connection': 'keep-alive',
    'Accept-Language': 'ko-KR,ko;q=0.9',
    'Cache-Control': 'max-age=0',
    'Content-Length': '35',
    'Content-Type': 'application/x-www-form-urlencoded',
    'Host': 'www.snowman.co.kr',
    'Origin': 'https://www.snowman.co.kr',
    'Referer': 'https: //www.snowman.co.kr/portal/login'
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