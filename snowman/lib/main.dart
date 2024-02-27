import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'setting.dart';
import 'httpcurl.dart';
import 'config.dart';
import 'dataaccess.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'snowMan',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MyHomePage(title: 'snowMan 용량확인'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  double _currentSliderPrimaryValue = 0.1;
  double _currentSliderSecondaryValue = 0.5;
  
  var responseData={};
  Map<String, double> userData={};

  dataAccess _dtAcc = new dataAccess();

  @override
  Widget build(BuildContext context) {
    print("MyApp 호출!!");

    if(_dtAcc.setRefresh){
      _dtAcc.setRefresh=false;
      print("리프레쉬가 되어야함:2");
      setState((){});
    }
    _dtAcc.setLogin().then((responseData) {
      print("setLogin 값:${responseData}");
      //print("responseData type:${responseData.runtimeType}");

      // 값이 없는 경우 설정으로 전환
      if(responseData['result'].toString()!='로그인성공'){
        print("tmp 값:${responseData['result']}");
        Navigator.push(context, MaterialPageRoute(builder: (context) => SettingPage())); // 설정페이지로 이동
      }
      else {    //값이 있는 경우 값을 변수에 매칭
        userData =  _dtAcc.dataRefresh(responseData);
        print("userData['data_total'] type:${userData['data_total'].runtimeType}");
        print("userData 값:${userData}");
        print("_dtAcc.keyStr 값:${_dtAcc.keyStr}"); 
      }
    });
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[    
            Padding(
              padding: EdgeInsets.all(20.0),
              child: new LinearPercentIndicator(
                animation: true,
                animationDuration: 1000,
                lineHeight: 20.0,
                leading: new Text("데이터"),
                trailing: new Text("${userData['data_total']} GB"),
                percent: userData['data_per']??0.0,
                center: Text("${userData['data_remain']} GB 남음"),
                barRadius: const Radius.circular(20.0),
                progressColor: Colors.blue,
              ),
            ),            
            Padding(
              padding: EdgeInsets.all(20.0),
              child: new LinearPercentIndicator(
                animation: true,
                animationDuration: 1000,
                lineHeight: 20.0,
                leading: new Text("통화량"),
                trailing: new Text("${userData['call_total']} 분"),
                percent: userData['call_per']??0.0,
                center: Text("${userData['call_remain']} 분 남음"),
                barRadius: const Radius.circular(20.0),
                progressColor: Colors.red,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: new LinearPercentIndicator(
                animation: true,
                animationDuration: 1000,
                lineHeight: 20.0,
                leading: new Text("문자량"),
                trailing: new Text("${userData['msg_total']} 건"),
                percent: userData['msg_per']??0.0,
                center: Text("${userData['msg_remain']} 건 남음"),
                barRadius: const Radius.circular(20.0),
                //progressColor: Colors.green,
                //progressColor: Colors.orange,
                progressColor: Colors.greenAccent,
              ),
            ),            
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
            Navigator.push(context, // 네비게이션 형식으로 push형식으로 전환
                MaterialPageRoute(builder: (context) => SettingPage())); // 화면전환 코드
          },
        tooltip: '설정하기',
        child: const Icon(Icons.settings),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
