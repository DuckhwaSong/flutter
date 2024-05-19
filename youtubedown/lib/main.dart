import 'package:flutter/material.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';  // 유튜브 라이브러리
import 'dart:io'; //파일 입출력을 위한 라이브러리
import 'package:path_provider/path_provider.dart';
//import 'package:archive/archive.dart';
//import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
//import 'package:cmd/cmd.dart';  // 커맨드 실행 라이브러리
import 'dart:io';


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

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  final TextEditingController _idController = TextEditingController();
  //Map<String, dynamic> input = Map<String, dynamic>();
  Map<String, dynamic> _userData={
    "isChecked":false,"isVisible":false,"_List2":null,"_formWidth":450,"_listWidth":520
    ,"_youtube_url":"","audioFile":"","vidioFile":"","mergeAble":false
    };

  Directory? _tempDir;
  Directory? _downloadDir;
  bool isVisible = false; // Initially, the text is hidden
  
  // 
  Future<bool> _mergeMuxFile() async{
    print("load : _mergeMuxFile");

    if(Platform.isAndroid){     // 안드로이드 처리
      //
    }
    if(Platform.isWindows){     // 윈도우즈 처리   
      String command = 'D:\\ffmpeg_win\\bin\\ffmpeg.exe';   // ffmpeg 경로 입력! => 윈도우용은 이게 최선?
      List<String> argV = ["-i",_userData['audioFile'],"-i",_userData['vidioFile'],"-c","copy",_userData['vidioFile'].replaceAll(".m4v",".mp4")];
      _excuteCmd(command,argV).then((stdout){
        print("stdout : ${stdout}");
        EasyLoading.showSuccess('merge Muxing File Success!');
      });
    }
    return true;
  }



  // 실행 명령어 처리
  Future<String> _excuteCmd(String command,List<String> argV) async {
    print("load : _excuteCmd");
    var process;
    try{
      process = await Process.run(command, argV);
    } catch(error){
      print("==============================");
      print(error);
      print("==============================");
      return "";
    }
    //print("==============================");
    //print('Exit code: ${process.exitCode}');
    //print('Stdout: ${process.stdout}');
    //print('Stderr: ${process.stderr}');
    //print("==============================");
    return process.stdout.toString();
  }

  Future<bool> _reset() async {
    _userData={
    "isChecked":false,"isVisible":false,"_List2":null,"_formWidth":450,"_listWidth":520
    ,"_youtube_url":"","audioFile":"","vidioFile":"","mergeAble":false
    };
    isVisible = false;
    _idController.clear();

    setState(() {
      EasyLoading.showToast('Reset'); // 문자열만 출력
      //EasyLoading.showInfo('Try Insert Youtube code OR Youtube URL');   // !아이콘과 함께 출력
      print("load : _reset");
    });    
    return true;
  }

  // 유튜브 다운로드를 위한 정보 확인 - youtube_explode_dart.dart 필요
  Future<bool> _mediaInfo(String url) async {
    _userData['ytExplode'] = YoutubeExplode();
    
    try{
      _userData['video'] = await _userData['ytExplode'].videos.get(url);
    } catch(error){
      print("==============================");
      print("error : ${error}");
      print("==============================");
      return false;
    }
    _userData['manifest'] = await _userData['ytExplode'].videos.streamsClient.getManifest(_userData['video'].id);
    return true;
  }
  Future<bool> _downloadMedia(var stream) async {
    String fileExt = "";
    if("${stream.runtimeType}"=="MuxedStreamInfo") fileExt="mp4";
    if("${stream.runtimeType}"=="AudioOnlyStreamInfo") fileExt="m4a";
    if("${stream.runtimeType}"=="VideoOnlyStreamInfo") fileExt="m4v";
    String streamTitle = _userData['video'].title.toString();
    
    var streamFile = await _userData['ytExplode'].videos.streamsClient.get(stream);
    //final Directory tempDir = await getTemporaryDirectory();    // 임시 디렉토리
    final Directory tempDir = await getApplicationDocumentsDirectory(); // 엡디렉토리
    //final Directory? downloadsDir = await getDownloadsDirectory();  // 다운로드 디렉토리    
    if(_tempDir == null) _tempDir = tempDir;
    

    // 파일불가 특수문자 제거
    // ex>[ENG SUB] 제니 ㄴㄴ 쟤니. (feat.박진주) | #놀면뭐하니? #유재석 #하하 #주우재 #박진주 MBC240511 방송.mp4
    streamTitle = streamTitle.replaceAll("\\","");
    streamTitle = streamTitle.replaceAll("/","");
    streamTitle = streamTitle.replaceAll(":","");
    streamTitle = streamTitle.replaceAll("?","");
    streamTitle = streamTitle.replaceAll("*","");
    streamTitle = streamTitle.replaceAll("\"","");
    streamTitle = streamTitle.replaceAll("<","");
    streamTitle = streamTitle.replaceAll(">","");
    streamTitle = streamTitle.replaceAll("|","");

    File file = File(tempDir.path + '/$streamTitle.$fileExt');
    var fileStream = file.openWrite();
    await streamFile.pipe(fileStream);
    print("==============================");
    print("stream : ${stream}");
    //print("streamFile : ${streamFile}");    
    print(" >> ${file}");
    print("==============================");
    // Close the file.
    await fileStream.flush();
    await fileStream.close();

    if(fileExt=="m4a") _userData['audioFile'] = tempDir.path + '/$streamTitle.$fileExt';  // AudioOnly 다운로드 기록
    if(fileExt=="m4v") _userData['vidioFile'] = tempDir.path + '/$streamTitle.$fileExt';  // VideoOnly 다운로드 기록

    if(_userData['audioFile']!="" && _userData['vidioFile']!="" ){
      print("==============================");
      print("audioFile : ${_userData['audioFile']}");
      print("vidioFile : ${_userData['vidioFile']}");
      print("==============================");

      _userData['mergeAble'] = true;
      setState(() {
        print("mergeAble : ${_userData['mergeAble']}");
      });
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

  

  // 유튜브 다운로드 함수 구현 - youtube_explode_dart.dart 필요
  /*
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
    
    var streamInfo = manifest.muxed.withHighestBitrate();
    print("==============================");
    print("streamInfo : ${streamInfo}");
    print("==============================");
    

    var videoFile = null;
    var audioFile = null;
    for (final stream in manifest.streams) {
      //final quality = stream.quality; // 해상도와 비트 전송률 정보 확인
      print("==============================");
      
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
  }*/
/*

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
    final Directory? downloadsDir = await getDownloadsDirectory();  // 다운로드 디렉토리
    if(_downloadDir == null) _downloadDir = downloadsDir;

    // assets 폴더에서 실행 파일 가져오기
    final assetFile = await rootBundle.load('asset/ffmpeg_win/bin/ffmpeg.exe');

    // 임시 폴더에 실행 파일 복사
    final tempDir = Directory.systemTemp;
    final tempFile = await tempDir.createTemp();
    await tempFile
    .writeAsBytes(assetFile.readAsBytes());
    
    // 별도의 프로세스로 실행
    final process = await Process.start(tempFile.path, ['arguments']);
  }

  // 안드로이드/IOS
  void _mergeVideo2(String videoFile,String audioFile){

  }
*/
  // 다운로드 버튼을 누를경우 실해되는 함수
  void _youtubeDownloader() {
    setState(() {
      print("${_userData['_youtube_url']}");
    });
    /*_downloadVideo(_userData['_youtube_url']).then((result){
      if(result) print("처리완료-성공");
      else print("처리완료-실패");
    });*/
  }

  // 체크 버튼을 누를경우 실해되는 함수
  void _youtubeCheck() {
    _easyloading(true);
    _mediaInfo(_userData['_youtube_url']).then((result){
      if(result) EasyLoading.showSuccess('mediaInfo Loading Success!');
      else EasyLoading.showError('mediaInfo Loading Error!');
      isVisible = result;
      setState(() {
        print("load : _mediaInfo");
      });
    });
    print("load : _youtubeCheck");
  }

  // 체크 버튼을 누를경우 실해되는 함수
  void _easyloading(bool onoff) {
    if(onoff) EasyLoading.showProgress(0.3, status: 'downloading...');
    else EasyLoading.dismiss();
  }
  bool value = false;



  List<Widget> _itemLists() {
    print("load : _itemLists");
    List<Widget> vari=[];
    int idx=0;
    if(_userData['manifest']!=null){      
      //print("streams[0] : ${_userData['manifest'].streams[0]}");
      for (final stream in _userData['manifest'].streams) {
        if("${stream.container}" =="mp4" && //"${stream.qualityLabel}" !="tiny"
            (
              ("${stream.runtimeType}" =="VideoOnlyStreamInfo" && int.parse("${stream.qualityLabel}".replaceAll(RegExp(r'[^\d\.]'), ""))>=1080) ||
              ("${stream.runtimeType}" =="MuxedStreamInfo" ) ||
              ("${stream.runtimeType}" =="AudioOnlyStreamInfo")
            )          
         ){                  // 필요한 미디어만 추출(필터)
          print("stream[${idx}] : ${stream}");
          print("==============================");
          print("stream.qualityLabel : ${stream.qualityLabel}");
          //print("stream.videoResolution : ${stream.videoResolution}");
          //print("stream : ${stream}");
          print("stream.container : ${stream.container}");
          print("stream.size : ${stream.size}");
          print("stream.bitrate : ${stream.bitrate}");
          print("stream.codec : ${stream.codec}");
          print("stream.runtimeType : ${stream.runtimeType}");
          //print("videoStream:${videoStream}");
          print("stream : ${stream.toJson()}");
          print("==============================");
          vari.add(Center(
            child: Container(
              width: 520,
              child: ListTile(
                onTap: (){
                  _downloadMedia(stream);
                },
                leading: const Icon(Icons.download),
                trailing: const Text(
                  "DOWN",
                  style: TextStyle(color: Colors.green, fontSize: 15),
                ),
                //title: Text("[${idx}] ${stream} ${stream.size}")
                title: Text("${stream} ${stream.size}")
              ),
            ),
          ));
        }
        idx++;
      }
    }
    
    return vari;
  }


  List<String> _List = [];
  /*
  List<Widget> _itemDropdown() {
    //String dropdownValue=_List.first;
    //String dropdownValue="";
    return [
      DropdownButton<String?>(
        //value: dropdownValue??null,
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
            //this.value=newValue;
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
  }*/

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
                  //onPressed:_excuteTest,
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
                children: _itemLists()
              ),
            ),
            SizedBox(width: 10, height: 10,), // 여백을 만들기 위해서 넣음.
            Visibility(
              visible: _userData['mergeAble'], // Determines visibility
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Container(
                      width: 520,
                      child: ListTile(
                        onTap: _mergeMuxFile,
                        leading: const Icon(Icons.download),
                        trailing: const Text(
                          "DOWN",
                          style: TextStyle(color: Colors.green, fontSize: 15),
                        ),
                        title: Text("merge audioFile + vidioFile => muxFile")
                      ),
                    ),
                  ),
                ]
              ),
            ),            
            /*SizedBox(width: 10, height: 10,), // 여백을 만들기 위해서 넣음.
            Visibility(
              visible: _userData['mergeAble'], // Determines visibility
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
                  children: _createChildren()
                ),
              ),*/
          ],
        ),
      ),
      floatingActionButton: Visibility(
        visible: isVisible, // Determines visibility
        child: FloatingActionButton(
          //onPressed: null,
          onPressed: _reset,
          tooltip: 'Download',
          backgroundColor: Colors.cyan,
          child: const Icon(Icons.restart_alt),
        ),
      ),
    );
  }
}
