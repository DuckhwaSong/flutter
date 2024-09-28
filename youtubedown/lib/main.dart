import 'package:flutter/material.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';  // 유튜브 라이브러리
import 'dart:io'; //파일 입출력을 위한 라이브러리
import 'package:path_provider/path_provider.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
//import 'package:downloadsfolder/downloadsfolder.dart';
import 'package:flutter/services.dart' show rootBundle;           // 빌드후 asset 접근
import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:external_path/external_path.dart';                // 안드로이드 download DIR 사용을 위한 페키지


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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyAppPage(title: 'YouTube Video Download'),
      builder: EasyLoading.init(),
    );
  }
}

class MyAppPage extends StatefulWidget {
  const MyAppPage({super.key, required this.title});
  final String title;

  @override
  State<MyAppPage> createState() => _MyAppPageState();
}

class _MyAppPageState extends State<MyAppPage> {
  int _counter = 0;

  final TextEditingController _idController = TextEditingController();
  //Map<String, dynamic> input = Map<String, dynamic>();
  Map<String, dynamic> _userData={
    "isChecked":false,"isVisible":false,"_List2":null,"_formWidth":450,"_listWidth":520
    ,"_youtube_url":"","audioFile":"","vidioFile":"","mergeAble":false
    };

  //Directory? _tempDir;
  //Directory? _downloadDir;
  bool isVisible = false; // Initially, the text is hidden

  // 파일 읽기 쓰기 권한 처리
  Future<bool> _requestPermissions() async {
    var status = await Permission.manageExternalStorage.status;
    if (!status.isGranted) {
      await Permission.manageExternalStorage.request();
    }
    if (await Permission.manageExternalStorage.isGranted) return true;
    else return false;    
  }

  //다운로드 폴더 경로 받아오기 - 안드로이드에서 문제발생으로 추가처리
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
      else {
        final Directory tempDir = await getDownloadsDirectory()??await getApplicationDocumentsDirectory();
        downloadDirPath = tempDir.path;
      }

    return downloadDirPath!;
  }

  // 파일로 로그를 남긴다.
  Future<void> _writeLog(String message) async {
    // 디버깅 후 로그 남기는 부분 제외!
    /*bool storageAccess = await _requestPermissions();
    if(!storageAccess) return null;
    // 타임스템프
    final timestamp = DateTime.now().toIso8601String();
    String date = timestamp.substring(0,13);
    //final directory = await getApplicationDocumentsDirectory();
    String directory_path = await _getPublicDownloadPath();
    final path = '${directory_path}/${date}_youtubedown_log.txt';
    final file = File(path);

    // 로그 메시지에 타임스탬프 추가
    final logMessage = '$timestamp: $message\n';

    // 로그 메시지를 파일에 작성
    await file.writeAsString(logMessage, mode: FileMode.append);
    */
    print("==============================");
    print(message);
    print("==============================");
  }

  // 소리와 동영상을 병합한다
  Future<bool> _mergeMuxFile() async{
    _writeLog("load : _mergeMuxFile");
    
    EasyLoading.showProgress(0.3, status: 'Now download merge Muxing File ...');

    if(Platform.isAndroid || Platform.isIOS ){     // 안드로이드 처리
      String executeCommand = "-i '${_userData['audioFile']}' -i '${_userData['vidioFile']}' -c:v copy -c:a aac -strict experimental '${_userData['vidioFile'].replaceAll(".m4v",".mp4")}'";
      _writeLog("FFmpegKit.execute : ${executeCommand}");
      //await FFmpegKit.execute(executeCommand);
      //EasyLoading.showSuccess('merge Muxing File Success!');
      FFmpegKit.execute(executeCommand).then((session) async {
        //final returnCode = await session.getReturnCode();
        EasyLoading.showSuccess('merge Muxing File Success!');
      });      
    }
    else if(Platform.isWindows){     // 윈도우즈 처리   
      _writeLog("Platform : isWindows");

      //String path = await rootBundle.loadString('asset/MP4Box.exe');
      //_writeLog("asset_path : ${path}");

      // 애셋 파일 로드
      final byteData = await rootBundle.load('asset/MP4Box.exe');
      final buffer = byteData.buffer;

      // 파일 시스템의 임시 디렉토리 경로 가져오기
      final tempDir = await getTemporaryDirectory();
  
      // 바이너리 데이터를 파일로 저장
      final tempFile = File('${tempDir.path}/MP4Box.exe');
      await tempFile.writeAsBytes(buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

      /*
      // assets 폴더에서 실행 파일 가져오기
      var assetFile;
      try{
        assetFile = await File(filePath).readAsBytes();
      } catch(error){
        _writeLog("error : ${error}");
        return false;
      }      
      //final assetFile = await File('asset/MP4Box.exe').readAsBytes();
      if (assetFile == null) {
        _writeLog("Exception : Assets 파일을 읽을 수 없습니다");
        throw Exception('Assets 파일을 읽을 수 없습니다.');
      }
      // 임시 폴더에 실행 파일 복사
      final tempDir = Directory.systemTemp;
      final tempFile = await tempDir.createTemp();
      final tmpFile = await File(tempFile.path+'/MP4Box.exe').writeAsBytes(assetFile);
      */
      // 별도의 프로세스로 실행       // mp4box -add ccm.m4a -add ccm.m4v ccm.mp4
      List<String> argV = ["-add",_userData['audioFile'],"-add",_userData['vidioFile'],_userData['vidioFile'].replaceAll(".m4v",".mp4")];
      _excuteCmd('${tempDir.path}/MP4Box.exe',argV).then((stdout){
        EasyLoading.showSuccess('merge Muxing File Success!');
        tempFile.delete();
        sleep(Duration(seconds: 1)); // 1초 지연
        tempDir.delete();
      });
    }

    else _writeLog("미지원 Platform : ${Platform}");

    return true;
  }



  // 실행 명령어 처리
  Future<String> _excuteCmd(String command,List<String> argV) async {
    _writeLog("load : _excuteCmd");
    var process;
    try{
      process = await Process.run(command, argV);
    } catch(error){
      _writeLog("error : ${error}");
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
      _writeLog("load : _reset");
    });    
    return true;
  }

  // 유튜브 다운로드를 위한 정보 확인 - youtube_explode_dart.dart 필요
  Future<bool> _mediaInfo(String url) async {
    _userData['ytExplode'] = YoutubeExplode();    
    try{
      _userData['video'] = await _userData['ytExplode'].videos.get(url);
    } catch(error){
      _writeLog("error : ${error}");
      return false;
    }
    _userData['manifest'] = await _userData['ytExplode'].videos.streamsClient.getManifest(_userData['video'].id);
    return true;
  }

  // 유튜브 다운로드 - youtube_explode_dart.dart 필요
  Future<bool> _downloadMedia(var stream) async {
    bool storageAccess = await _requestPermissions();
    if(!storageAccess) return storageAccess;
    String fileExt = "";
    if("${stream.runtimeType}"=="MuxedStreamInfo") fileExt="mp4";
    if("${stream.runtimeType}"=="AudioOnlyStreamInfo") fileExt="m4a";
    if("${stream.runtimeType}"=="VideoOnlyStreamInfo") fileExt="m4v";
    String streamTitle = _userData['video'].title.toString();
    EasyLoading.showProgress(0.3, status: "Now download ${streamTitle}...");
    
    var streamFile = await _userData['ytExplode'].videos.streamsClient.get(stream);
    //final Directory tempDir = await getTemporaryDirectory();    // 임시 디렉토리
    //final Directory tempDir = await getApplicationDocumentsDirectory(); // 엡디렉토리
    //final Directory? downloadsDir = await getDownloadsDirectory();  // 다운로드 디렉토리
    //final Directory tempDir = await getDownloadsDirectory()??await getApplicationDocumentsDirectory();
    String tempDir_path = await _getPublicDownloadPath();

    print("==============================");
    print(tempDir_path);
    print("==============================");

    // 파일불가 특수문자 제거
    // ex>[ENG SUB] 제니 ㄴㄴ 쟤니. (feat.박진주) | #놀면뭐하니? #유재석 #하하 #주우재 #박진주 MBC240511 방송.mp4
    streamTitle = streamTitle.replaceAll("\\","").replaceAll("/","").replaceAll(":","").replaceAll("?","").replaceAll("*","");
    streamTitle = streamTitle.replaceAll("\"","").replaceAll("<","").replaceAll(">","").replaceAll("|","");

    File file = File(tempDir_path + '/$streamTitle.$fileExt');
    var fileStream = file.openWrite();
    await streamFile.pipe(fileStream);
    _writeLog("stream : ${stream} >> ${file}");
    EasyLoading.showSuccess("${streamTitle} File Download Success!");
    // Close the file.
    await fileStream.flush();
    await fileStream.close();

    if(fileExt=="m4a") _userData['audioFile'] = tempDir_path + '/$streamTitle.$fileExt';  // AudioOnly 다운로드 기록
    if(fileExt=="m4v") _userData['vidioFile'] = tempDir_path + '/$streamTitle.$fileExt';  // VideoOnly 다운로드 기록

    if(_userData['audioFile']!="" && _userData['vidioFile']!="" ){
      _writeLog("audioFile : ${_userData['audioFile']} \n vidioFile : ${_userData['vidioFile']} ");

      _userData['mergeAble'] = true;
      setState(() {
        _writeLog("mergeAble : ${_userData['mergeAble']}");
      });
    }
    return true;    
  }

  // 체크 버튼을 누를경우 실해되는 함수
  void _youtubeCheck() {
    EasyLoading.showProgress(0.3, status: 'Now download profiling...');
    _mediaInfo(_userData['_youtube_url']).then((result){
      if(result) EasyLoading.showSuccess('mediaInfo Loading Success!');
      else EasyLoading.showError('mediaInfo Loading Error!');
      isVisible = result;
      setState(() {
        _writeLog("load : _mediaInfo");
      });
    });
    _writeLog("load : _youtubeCheck");
  }

  // 다운로드 리스트 구현 함수
  List<Widget> _itemLists() {
    _writeLog("load : _itemLists");
    List<Widget> vari=[];
    int idx=0;
    if(_userData['manifest']!=null){      
      //print("streams[0] : ${_userData['manifest'].streams[0]}");
      for (final stream in _userData['manifest'].streams) {
        if("${stream.container}" =="mp4" && //"${stream.qualityLabel}" !="tiny"
            (
              ("${stream.runtimeType}" =="VideoOnlyStreamInfo" && int.parse("${stream.qualityLabel}".replaceAll(RegExp(r'[^\d\.]'), ""))>=0) ||
              ("${stream.runtimeType}" =="MuxedStreamInfo" ) ||
              ("${stream.runtimeType}" =="AudioOnlyStreamInfo")
            )          
         ){                  // 필요한 미디어만 추출(필터)
          /*print("stream[${idx}] : ${stream}");
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
          print("==============================");*/
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
    _requestPermissions();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: SingleChildScrollView(                  // 화면을 스크롤 할 수 있도록 감싸준다  
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const SelectableText(
                'Input youtube url : ex>https://www.youtube.com/watch?v=[YOUTUBECD]',
                style: TextStyle(
                  fontSize: 10,
                  //fontWeight: FontWeight.bold,
                  //color: Colors.orange,
                )
              ),
              SizedBox(width: 10, height: 10,), // 여백을 만들기 위해서 넣음.
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 280,
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
      ),
      floatingActionButton: Visibility(
        visible: isVisible, // Determines visibility
        child: FloatingActionButton(
          //onPressed: null,
          onPressed: _reset,
          tooltip: 'Reset',
          backgroundColor: Colors.cyan,
          child: const Icon(Icons.restart_alt),
        ),
      ),
    );
  }
}
