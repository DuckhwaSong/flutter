import 'package:http/http.dart' as http;

class httpCurl {
  Map<String, String> headers = {};
  var responseData;

  Future<String> get(String url) async {
    var uri=Uri.parse(url);
    http.Response response = await http.get(uri, headers: headers);
    updateCookie(response);
    return response.body;
  }

  Future<String> post(String url, dynamic data) async {
    var uri=Uri.parse(url);
    http.Response response = await http.post(uri, body: data, headers: headers);
    updateCookie(response);
    this.responseData=response;
    return response.body;
  }

  void updateCookie(http.Response response) {
    String? rawCookie = response.headers['set-cookie'];
    if (rawCookie != null) {
      int index = rawCookie.indexOf(';');
      headers['cookie'] =
          (index == -1) ? rawCookie : rawCookie.substring(0, index);
    }
  }
}