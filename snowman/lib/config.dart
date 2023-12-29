import 'dart:async';  // for File
import 'dart:io';     // for File
//import 'dart:math';   // for Random
import 'dart:convert';   // for Json
import 'package:path_provider/path_provider.dart';


class ConfigStorage {
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