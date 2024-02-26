import 'dart:async';  // for File
import 'dart:io';     // for File
//import 'dart:math';   // for Random
import 'dart:convert';   // for Json
import 'package:path_provider/path_provider.dart';
import 'package:encrypt/encrypt.dart' as enc;


class ConfigStorage {
  // 암복호화 툴
  String encKey = 'SNOWMAN79SNOWMAN';
  String encIV = '1A23B456C7890DFE';  
  String encTools(String text){
    if(text == null || text == "") return "";
    final encrypter=enc.Encrypter(enc.AES(enc.Key.fromUtf8(this.encKey)));
    return encrypter.encrypt(text,iv: enc.IV.fromUtf8(this.encIV)).base64;
  }  
  String decTools(String encString){
    if(encString == null || encString == "") return "";
    final encrypter=enc.Encrypter(enc.AES(enc.Key.fromUtf8(this.encKey)));
    return encrypter.decrypt64(encString,iv: enc.IV.fromUtf8(this.encIV));
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/config.json');
  }

  Future<Map<String, dynamic>> readConfig() async {
    try {
      final file = await _localFile;

      // Read the file
      final contents = await file.readAsString();
      return jsonDecode(contents);
    } catch (e) {
      // If encountering an error, return map
      return Map<String, dynamic>();
    }
  }

  Future<File> writeConfig(Map<String, dynamic> input) async {
    final file = await _localFile;

    // Write the file
    return file.writeAsString(jsonEncode(input));
  }
}