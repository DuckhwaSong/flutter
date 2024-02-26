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
      home: const MyHomePage(title: 'snowMan 용량확인'),
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
  var userData={
    "data_total":0.8,"data_remain":0,"data_use":0,
    "call_total":100,"call_remain":0,"call_use":0,
    "msg_total":100,"msg_remain":0,"msg_use":0
  };

  dataAccess _dtAcc = new dataAccess();

  @override
  Widget build(BuildContext context) {
    _dtAcc.setLogin().then((responseData) {
      print("setLogin 값:${responseData}");
      //print("responseData type:${responseData.runtimeType}");

      // 값이 없는 경우 설정으로 전환
      if(responseData['result'].toString()!='로그인성공'){
        print("tmp 값:${responseData['result']}");
        Navigator.push(context, MaterialPageRoute(builder: (context) => SettingPage())); // 설정페이지로 이동
      }
      else {    //값이 있는 경우 값을 변수에 매칭
        //String tmp = responseData['data0'].replaceAll(RegExp(r'[^\d\.]'), "");  // 숫자만 추출
        //print("tmp 값:${tmp}");
        userData['data_total'] = double.parse(responseData['data0'].replaceAll(RegExp(r'[^\d\.]'), ""));  // 숫자만 추출
        userData['data_remain'] = double.parse(responseData['data1'].replaceAll(RegExp(r'[^\d\.]'), ""));  // 숫자만 추출
        userData['data_use'] = double.parse(responseData['data2'].replaceAll(RegExp(r'[^\d\.]'), ""));  // 숫자만 추출
        userData['call_total'] = double.parse(responseData['data3'].replaceAll(RegExp(r'[^\d\.]'), ""));  // 숫자만 추출
        userData['call_remain'] = double.parse(responseData['data4'].replaceAll(RegExp(r'[^\d\.]'), ""));  // 숫자만 추출
        userData['call_use'] = double.parse(responseData['data5'].replaceAll(RegExp(r'[^\d\.]'), ""));  // 숫자만 추출
        userData['msg_total'] = double.parse(responseData['data6'].replaceAll(RegExp(r'[^\d\.]'), ""));  // 숫자만 추출
        userData['msg_remain'] = double.parse(responseData['data7'].replaceAll(RegExp(r'[^\d\.]'), ""));  // 숫자만 추출
        userData['msg_use'] = double.parse(responseData['data8'].replaceAll(RegExp(r'[^\d\.]'), ""));  // 숫자만 추출                
        //userData['data_total'] = 11;
        print("userData 값:${userData}");
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
                percent: 0.2,
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
                leading: new Text("통화"),
                trailing: new Text("총 10GB"),
                percent: 0.2,
                center: Text("2GB(20.0%) 남음"),
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
                leading: new Text("문자"),
                trailing: new Text("총 10GB"),
                percent: 0.2,
                center: Text("2GB(20.0%) 남음"),
                barRadius: const Radius.circular(20.0),
                //progressColor: Colors.green,
                //progressColor: Colors.orange,
                progressColor: Colors.greenAccent,
              ),
            ),            
            /*
                        Text(
              '*$_currentSliderPrimaryValue',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            Slider(
              value: _currentSliderPrimaryValue,
              //min: _currentSliderPrimaryValue,
              //max: _currentSliderPrimaryValue,
              onChanged: (value) => null,
              /*onChanged: (double value) {
                setState(() {
                  _currentSliderPrimaryValue = value;
                });
              },*/
            ),    
                        Text(
              '$_currentSliderSecondaryValue',
              style: Theme.of(context).textTheme.headlineMedium,
            ),        
            Slider(
              value: _currentSliderSecondaryValue,
              onChanged: (double value) {
                setState(() {
                  _currentSliderSecondaryValue = value;
                });
              },
            ),
            */
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
