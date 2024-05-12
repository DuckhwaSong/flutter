import 'package:flutter/material.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';  // 유튜브 라이브러리
import 'dart:io'; //파일 입출력을 위한 라이브러리
import 'package:path_provider/path_provider.dart';
//import 'package:archive/archive.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';


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
enum Char { A, B, C, D }
enum Fruit { Apple, Grapes, Pear, Lemon }

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  final TextEditingController _idController = TextEditingController();
  //Map<String, dynamic> input = Map<String, dynamic>();
  Map<String, dynamic> _userData={"_youtube_url":"","isChecked":false,"isVisible":false,"_List2":null};

  Directory? _tempDir;
  Directory? _downloadDir;
  bool isVisible = false; // Initially, the text is hidden
  


  // 유튜브 다운로드를 위한 정보 확인 - youtube_explode_dart.dart 필요
  Future<bool> _mediaInfo(String url) async {
    _userData['ytExplode'] = YoutubeExplode();
    _userData['video'] = await _userData['ytExplode'].videos.get(url);
    _userData['manifest'] = await _userData['ytExplode'].videos.streamsClient.getManifest(_userData['video'].id);
    return true;
  }

  // 유튜브 다운로드 함수 구현 - youtube_explode_dart.dart 필요
  Future<bool> _downloadVideo(String url) async {
    var ytExplode = YoutubeExplode();
    var video = await ytExplode.videos.get(url);
    print("==============================");
    print("${video}");
    print("==============================");
    //return false;

    var manifest = await ytExplode.videos.streamsClient.getManifest(video.id);
    print("==============================");
    print("${manifest}");
    print("==============================");
    
    /*var streamInfo = manifest.muxed.withHighestBitrate();
    print("==============================");
    print("streamInfo : ${streamInfo}");
    print("==============================");
    */

    var videoFile = null;
    var audioFile = null;
    for (final stream in manifest.streams) {
      //final quality = stream.quality; // 해상도와 비트 전송률 정보 확인
      /*print("==============================");
      */
      if(stream.runtimeType.toString() == "AudioOnlyStreamInfo" && stream.codec.toString()=="audio/mp4; codecs=mp4a.40.2" && stream.container.toString()=="mp4"){
        var audioStream = stream;
        print("==============================");
        print("audioStream : ${audioStream}");
        print("stream : ${stream.toJson()}");
        //print("stream : ${stream.");
        print("==============================");
        audioFile = await ytExplode.videos.streamsClient.get(audioStream);
        await _saveStrem(audioFile, "${video.title}_S");        
      }
      if(stream.runtimeType.toString() == "VideoOnlyStreamInfo" && stream.qualityLabel.toString()=="1080p60" && stream.container.toString()=="mp4"){
        var videoStream = stream;
        print("==============================");
        print("stream : ${stream.qualityLabel}");
        //print("stream : ${stream.codec}");
        //print("stream : ${stream}");
        print("stream : ${stream.container}");
        print("stream : ${stream.size}");
        print("stream : ${stream.bitrate}");
        print("stream : ${stream.codec}");
        print("stream : ${stream.runtimeType}");
        print("videoStream:${videoStream}");
        print("stream : ${stream.toJson()}");
        print("==============================");
        videoFile = await ytExplode.videos.streamsClient.get(videoStream);
        await _saveStrem(videoFile, "${video.title}_V");
      }      
      print("==============================");
    }
    print("==============================");
    print("처리완료!");
    print("==============================");    
    
    return await _saveStremToFile(video.title.toString(),videoFile,audioFile);
  }

  Future<bool> _saveStremToFile(String videoTitle, var videoFile, var audioFile) async {
    final Directory tempDir = await getTemporaryDirectory();    // 임시 디렉토리

    if(audioFile == null) {
      await _saveStrem(videoFile, "${videoTitle}");
    }
    else {
      // 비디오파일 처리
      await _saveStrem(videoFile, "${videoTitle}_V");

      // 오디오파일 처리
      await _saveStrem(audioFile, "${videoTitle}_A");

      // 병합처리
    }
    return true;
  }

  Future<void> _saveStrem(var videoFile, String videoTitle) async {
    final Directory tempDir = await getTemporaryDirectory();    // 임시 디렉토리
    if(_tempDir == null) _tempDir = tempDir;
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

  // 윈도우용
  Future<void> _mergeVideo1(String videoFile,String audioFile) async {
    //final Directory appDocDir = await getApplicationDocumentsDirectory(); // 엡디렉토리
    /*final Directory? downloadsDir = await getDownloadsDirectory();  // 다운로드 디렉토리
    if(_downloadDir == null) _downloadDir = downloadsDir;

    // assets 폴더에서 실행 파일 가져오기
    final assetFile = await rootBundle.load('asset/ffmpeg_win/bin/ffmpeg.exe');

    // 임시 폴더에 실행 파일 복사
    final tempDir = Directory.systemTemp;
    final tempFile = await tempDir.createTemp();
    await tempFile
    .writeAsBytes(assetFile.readAsBytes());
    
    // 별도의 프로세스로 실행
    final process = await Process.start(tempFile.path, ['arguments']);*/
  }

  // 안드로이드/IOS
  void _mergeVideo2(String videoFile,String audioFile){

  }

  // 다운로드 버튼을 누를경우 실해되는 함수
  void _youtubeDownloader() {
    setState(() {
      print("${_userData['_youtube_url']}");
    });
    _downloadVideo(_userData['_youtube_url']).then((result){
      if(result) print("처리완료-성공");
      else print("처리완료-실패");
    });
  }

  // 체크 버튼을 누를경우 실해되는 함수
  void _youtubeCheck() {
    _List = ['소리만 다운로드(음악)','동영상 다운로드(간편)','동영상 다운로드(최고화질)'];
    _List.add(_userData['_youtube_url']);
    _userData['radioButton'] = ['소리만 다운로드(음악)','동영상 다운로드(간편)','동영상 다운로드(최고화질)'];
    _easyloading(true);
    _mediaInfo(_userData['_youtube_url']);
    if(!isVisible) isVisible = true;
    //else isVisible = false;
    setState(() {
      print("${_userData['_youtube_url']}");
    });
    //_easyloading(false);
  }

  // 체크 버튼을 누를경우 실해되는 함수
  void _easyloading(bool onoff) {
    if(onoff) EasyLoading.showSuccess('Great Success!');
    else EasyLoading.dismiss();
  }
  bool value = false;

  
  //SingingCharacter? _character = SingingCharacter.lafayette;
  Char _char = Char.A; // 라디오 버튼의 선택 초기화
  Fruit? _fruit = Fruit.Apple;

  List<String> _List = [];
  List<Widget> _itemDropdown() {
    //String dropdownValue=_List.first;
    return [
      DropdownButton<String?>(
        //value: dropdownValue,
        icon: const Icon(Icons.arrow_downward),
        elevation: 16,
        style: const TextStyle(color: Colors.deepPurple),
        underline: Container(
          height: 2,
          color: Colors.deepPurpleAccent,
        ),
        onChanged: (String? newValue) {          
          setState(() {
            //dropdownValue = newValue!;
            print(newValue);
          });
        },
        items: _List.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      )
    ];
  }

  List<Widget> _createChildren2() {
    return new List<Widget>.generate(_List.length, (int index) {
      //print("index : ${index} => ${_List[index].toString()}");
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget> [
          ListTile(
            title: const Text('Apple'),
            leading: Radio<Fruit>(
              value: Fruit.Apple,
              groupValue: _fruit,
              onChanged: (Fruit? value) {
                setState(() {
                  _fruit = value;
                });
              }
            ),
          ),
          SizedBox(width: 10, height: 10,), // 여백을 만들기 위해서 넣음.
          Text(_List[index].toString()),          
        ]
      );
    });
  }

  List<Widget> _createChildren() {
    return new List<Widget>.generate(_List.length, (int index) {
      //print("index : ${index} => ${someList[index]}");
      return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Checkbox(
                  value: _userData['isChecked']??false,
                  onChanged: (bool? value) {
                    _userData['isChecked'] = value!;
                    setState(() {
                      print("isChecked : ${_userData['isChecked']}");
                    });
                  },
                ),
                SizedBox(width: 10, height: 10,), // 여백을 만들기 위해서 넣음.
                Text(_List[index].toString()),
              ]
            );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SelectableText(
              'Input youtube url : ex>https://www.youtube.com/watch?v=[YOUTUBECD]',
            ),
            SizedBox(width: 10, height: 10,), // 여백을 만들기 위해서 넣음.
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
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
                      _userData['_youtube_url']=text;
                    }
                  ),
                ),
                SizedBox(width: 10, height: 10,), // 여백을 만들기 위해서 넣음.
                FloatingActionButton(
                  onPressed: _youtubeCheck,
                  tooltip: 'check',
                  child: const Icon(Icons.check),
                ),
              ]
            ),
            SizedBox(width: 10, height: 10,), // 여백을 만들기 위해서 넣음.
            Visibility(
              visible: isVisible, // Determines visibility
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: _itemDropdown()
              ),
            ),            
            SizedBox(width: 10, height: 10,), // 여백을 만들기 위해서 넣음.
            Visibility(
                visible: isVisible, // Determines visibility
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: _createChildren()/*[
                    Text("Hello, World! : ${Colors.cyan}"),
                    Checkbox(
                      value: isChecked,
                      onChanged: (bool? value) {
                        isChecked = value!;
                        setState(() {
                          print("isChecked : ${isChecked}");
                        });
                      },
                    )
                  ]*/
                ),
              ),
          ],
        ),
      ),
      floatingActionButton: Visibility(
        visible: isVisible, // Determines visibility
        child: FloatingActionButton(
          //onPressed: null,
          onPressed: _youtubeDownloader,
          tooltip: 'Download',
          backgroundColor: Colors.cyan,
          child: const Icon(Icons.download),
        ),
      ),
    );
  }
}
