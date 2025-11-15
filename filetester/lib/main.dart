import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import 'package:downloadsfolder/downloadsfolder.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:external_path/external_path.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
      builder: EasyLoading.init(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  //다운로드 폴더 경로 받아오기
  Future<String> _getPublicDownloadPath() async {
    String? downloadDirPath = null;

      // 만약 다운로드 폴더가 존재하지 않는다면 앱내 파일 패스를 대신 주도록한다.
      if (Platform.isAndroid) {
        downloadDirPath = await ExternalPath.getExternalStoragePublicDirectory(ExternalPath.DIRECTORY_DOWNLOADS);
        Directory dir = Directory(downloadDirPath);

        if (!dir.existsSync()) {
          downloadDirPath = (await getExternalStorageDirectory())!.path;
        }
      } else if (Platform.isIOS) {
        // downloadDirPath = (await getApplicationSupportDirectory())!.path;
        downloadDirPath = (await getApplicationDocumentsDirectory())!.path;
      }

    return downloadDirPath!;
  }

  // 파일 읽기 쓰기 권한 처리
  Future<bool> _requestPermissions() async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }

    if (await Permission.storage.isGranted) return true;
    else return false;
  }

  // 파일로 로그를 남긴다.
  Future<void> _writeLog(String message) async {
    bool storageAccess = await _requestPermissions();
    if(!storageAccess) return null;
    // 타임스템프
    //final timestamp = DateTime.now().toIso8601String();
    //String date = timestamp.substring(0,13);
    //final Directory directory = await getDownloadsDirectory()??await getApplicationDocumentsDirectory();
    //final DocumentDIR = await getApplicationDocumentsDirectory();
    //EasyLoading.showToast("${directory.path}"); // 문자열만 출력
    //EasyLoading.showToast("${DocumentDIR.path}"); // 문자열만 출력
    String directory_path = await _getPublicDownloadPath();
    EasyLoading.showToast("${directory_path}"); // 문자열만 출력
    final path = '${directory_path}/filetester.txt';
    final file = File(path);

    // 로그 메시지에 타임스탬프 추가
    final logMessage = '$message\n';

    // 로그 메시지를 파일에 작성
    await file.writeAsString(logMessage, mode: FileMode.append).then((value) {
      print("==============================");
      print(message);
      print(value);
      print("==============================");

    });
    //await file.writeAsString(logMessage);

    //print("==============================");
    //print(message);
    //print("==============================");
  }

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed:() { _writeLog("_counter : ${_counter}");},
            tooltip: 'save_file',
            child: const Icon(Icons.save_as),
          ),
          SizedBox(width: 10, height: 10,), // 여백을 만들기 위해서 넣음.
          FloatingActionButton(
            onPressed: _incrementCounter,
            tooltip: 'Increment',
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}
