import 'dart:async';  // for File
import 'dart:io';     // for File
import 'dart:math';   // for Random
import 'dart:convert';   // for Json

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class CounterStorage {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/counter.txt');
  }

  Future<int> readCounter() async {
    try {
      final file = await _localFile;

      // Read the file
      final contents = await file.readAsString();

      return int.parse(contents);
    } catch (e) {
      // If encountering an error, return 0
      return 0;
    }
  }

  Future<File> writeCounter(int counter) async {
    final file = await _localFile;

    // Write the file
    return file.writeAsString('$counter');
  }
}

class ConfigStorage {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/counter.txt');
  }

  /*Future<int> readConfig() async {
    try {
      final file = await _localFile;

      // Read the file
      final contents = await file.readAsString();

      return String.parse(contents);
    } catch (e) {
      // If encountering an error, return 0
      return 0;
  }*/

  Future<File> writeConfig(Map<String, dynamic> input) async {
    final file = await _localFile;

    // Write the file
    return file.writeAsString(jsonEncode(input));
  }
}

class SettingPage extends StatelessWidget {

  //final CounterStorage storage;
  CounterStorage storage=new CounterStorage();
  ConfigStorage _config = new ConfigStorage();

  final TextEditingController _idController = TextEditingController(text:'tets');
  final TextEditingController _pwController = TextEditingController(text:'pwd');
  final TextEditingController _noController = TextEditingController(text:'nono');

  int testConter=0;
  String JsonString = '{"name":"red"}';
  Map<String, dynamic> color = jsonDecode('{"name":"red"}');
  Map<String, dynamic> input = Map<String, dynamic>();

  //print("$JsonString");
  //input['no1']='111';

  @override
  Widget build(BuildContext context) {
    // 초기값 세팅
    input['no2']='222';
    input['no2']='333';

    return ScaffoldMessenger(
      child: Scaffold(
        appBar: AppBar(
          title: Text('설정'),
        ),
        body: Builder( // 빌더를 통해서 context를 받아야 해.
          builder: (context){
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'snowMan 홈페이지 계정 설정',
                  style: TextStyle(fontSize: 20.0, color: Colors.redAccent),
                ),
                Padding(
                  padding: const EdgeInsets.only(top:20),
                ),
                SizedBox(
                  width: 300,
                  child: TextField(
                    controller: _idController,
                    //obscureText: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'ID',
                    ),
                    onChanged:(text){
                      input['id']=text;
                    }
                  ),
                ),                  
                Padding(
                  padding: const EdgeInsets.only(top:20),
                ),
                SizedBox(
                  width: 300,
                  child: TextField(
                    controller: _noController,
                    obscureText: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: '비밀번호',
                    ),
                    onChanged:(text){
                      input['pw']=text;
                    }
                  ),
                ),  
                Padding(
                  padding: const EdgeInsets.only(top:20),
                ),
                SizedBox(
                  width: 300,
                  child: TextField(
                    controller: TextEditingController(text:'nono'),   // 초기값 설정
                    //obscureText: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: '전화번호(-제거)',
                    ),
                    onChanged:(text){
                      input['no']=text;
                    }
                  ),
                ),                  
                Padding(
                  padding: const EdgeInsets.only(top:20),
                ),                
                ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar( // 스캐폴드 메신저가 스낵바 들고 있음!!
                      // 이렇게 하면 화면을 빠져나가서 context가 사라지면 스낵바가 사라져서 UI개선
                      content: Text("설정이 저장되었습니다."),
                      duration: Duration(seconds: 3),
                    ));
                    print(input);   // 입력값 확인
                    JsonString = jsonEncode(input);
                    print(JsonString);   // 입력값 확인
                    _config.writeConfig(input);

                    testConter=Random().nextInt(6)+1;
                    storage.writeCounter(testConter);
                    print("저장하는 값:$testConter");
                    storage.readCounter().then((value) {
                      testConter = value;
                      print("저장된 값:$testConter");
                    });
                  },
                  child: Text('저장'),
                ),
              ],
            ),
          );}

        ),
      ),
    );
  }
}