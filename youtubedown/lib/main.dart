import 'package:flutter/material.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';  // 유튜브 라이브러리
import 'dart:io'; //파일 입출력을 위한 라이브러리
import 'package:path_provider/path_provider.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'YouTube Video Download',
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
      home: const MyHomePage(title: 'YouTube Video Download'),
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

  final TextEditingController _idController = TextEditingController();
  //Map<String, dynamic> input = Map<String, dynamic>();
  String _youtube_url = "";

  // 유튜브 다운로드 함수 구현 - youtube_explode_dart.dart 필요
  void _downloadVideo(String url) async {
    var ytExplode = YoutubeExplode();
    var video = await ytExplode.videos.get(url);
    print("==============================");
    print("${video}");
    print("==============================");
    var manifest = await ytExplode.videos.streamsClient.getManifest(video.id);
    print("==============================");
    print("${manifest}");
    print("==============================");
    
    /*var streamInfo = manifest.muxed.withHighestBitrate();
    print("==============================");
    print("streamInfo : ${streamInfo}");
    print("==============================");
    */

    for (final stream in manifest.streams) {
      //final quality = stream.quality; // 해상도와 비트 전송률 정보 확인
      /*print("==============================");
      print("stream : ${stream.qualityLabel}");
      //print("stream : ${stream.codec}");
      //print("stream : ${stream}");
      print("stream : ${stream.container}");
      print("stream : ${stream.size}");
      print("stream : ${stream.bitrate}");
      print("stream : ${stream.codec}");
      print("stream : ${stream.runtimeType}");*/
      if(stream.runtimeType.toString() == "AudioOnlyStreamInfo" && stream.codec.toString()=="audio/mp4; codecs=mp4a.40.2" && stream.container.toString()=="mp4"){
        var audioStream = stream;
        print("==============================");
        print("audioStream : ${audioStream}");
        print("stream : ${stream.toJson()}");
        //print("stream : ${stream.");
        print("==============================");
        var audioFile = await ytExplode.videos.streamsClient.get(audioStream);
        await _saveVideo(audioFile, "${video.title}_S");        
      }
      if(stream.runtimeType.toString() == "VideoOnlyStreamInfo" && stream.qualityLabel.toString()=="1080p60" && stream.container.toString()=="mp4"){
        var videoStream = stream;
        print("==============================");
        print("videoStream:${videoStream}");
        print("stream : ${stream.toJson()}");
        print("==============================");
        var videoFile = await ytExplode.videos.streamsClient.get(videoStream);
        await _saveVideo(videoFile, "${video.title}_V");
      }      
      print("==============================");
    }
    print("==============================");
    print("처리완료!");
    print("==============================");    
  }
  Future<void> _saveVideo(var videoFile, String videoTitle) async {
    //final appDocDir = await getApplicationDocumentsDirectory();
    //final Directory appDocDir = await getApplicationDocumentsDirectory();
    final Directory tempDir = await getTemporaryDirectory();
    //final Directory? downloadsDir = await getDownloadsDirectory();
    var file = File(tempDir.path + '/$videoTitle.mp4');
    var fileStream = file.openWrite();
    await videoFile.pipe(fileStream);
    print("==============================");
    print("${file}");
    print("==============================");
    // Close the file.
    await fileStream.flush();
    await fileStream.close();
  }

  //  파일을 저장하는 함수 - dart:io 필요
  void _saveVideo_back(var videoFile, String videoTitle) async {
    final appDocDir = await getApplicationDocumentsDirectory();
    final savePath = appDocDir.path + '/$videoTitle.mp4';

    final videoBytes = await videoFile.readAsBytes();
    final File file = File(savePath);

    await file.writeAsBytes(videoBytes);

    // Show a success message or handle errors here
  }

  // 다운로드 버튼을 누를경우 실해되는 함수
  void _youtubeDownloader() {
    setState(() {
      print("${_youtube_url}");
    });
    _downloadVideo(_youtube_url);
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
              'Input youtube url : ex>https://www.youtube.com/watch?v=_9JbnvOF-fM',
            ),
            SizedBox(width: 10, height: 10,), // 여백을 만들기 위해서 넣음.
            SizedBox(
              width: 450,
              child: TextField(
                controller: _idController,
                //obscureText: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'https://www.youtube.com/watch?v=**********',
                ),
                onChanged:(text){
                  _youtube_url=text;
                }
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _youtubeDownloader,
        tooltip: 'Download',
        child: const Icon(Icons.download),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
