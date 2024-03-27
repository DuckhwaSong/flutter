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

    /*if(_dtAcc.setRefresh){
      _dtAcc.setRefresh=false;
      print("리프레쉬가 되어야함:2");
      //setState((){});
    }*/
    _dtAcc.setLogin().then((responseData) {      
      if(_dtAcc.setRefresh) {
        setState((){});
        _dtAcc.setRefresh=false;
      }
      print("_dtAcc.userData 값1:${_dtAcc.userData}"); 
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
                trailing: new Text("${_dtAcc.userData['data_total']} GB"),
                //percent: _dtAcc.data_per??0.0,
                percent: _dtAcc.userData['data_per']??0.0,
                center: Text("${_dtAcc.userData['data_remain']} GB 남음"),
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
                trailing: new Text("${_dtAcc.userData['call_total']} 분"),
                percent: _dtAcc.userData['call_per']??0.0,
                center: Text("${_dtAcc.userData['call_remain']} 분 남음"),
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
                trailing: new Text("${_dtAcc.userData['msg_total']} 건"),
                percent: _dtAcc.userData['msg_per']??0.0,
                center: Text("${_dtAcc.userData['msg_remain']} 건 남음"),
                barRadius: const Radius.circular(20.0),
                //progressColor: Colors.green,
                //progressColor: Colors.orange,
                progressColor: Colors.greenAccent,
              ),
            ),            
          ],
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              print("새로고침 들아간다");
              _dtAcc.setLogin().then((responseData) {      
                //setState((){});
                print("_dtAcc.userData 값2:${_dtAcc.userData}");
              });
            },
            tooltip: '새로고침',
            child: const Icon(Icons.replay),
          ),
          SizedBox(width: 10, height: 10,), // 여백을 만들기 위해서 넣음.
          FloatingActionButton(
            onPressed: () {
            print("설정하기로 들아간다");
            Navigator.push(context, // 네비게이션 형식으로 push형식으로 전환
                MaterialPageRoute(builder: (context) => SettingPage())).then((_){
                  print("돌아왔을 때 화면을 리로드");
                  setState(() {});  // 돌아왔을 때 화면을 리로드
                  _dtAcc.setLogin().then((responseData) {      
                    setState((){});
                    print("_dtAcc.userData 값2:${_dtAcc.userData}");
                  });
                }); // 화면전환 코드
            },
            tooltip: '설정하기',
            child: const Icon(Icons.settings),
          ),
          /*SizedBox(width: 10, height: 10,), // 여백을 만들기 위해서 넣음.
          FloatingActionButton(
            onPressed: () {},
            backgroundColor: Colors.blue,
            child: const Text('5')
          ),
          SizedBox(width: 10, height: 10,), // 여백을 만들기 위해서 넣음.
          FloatingActionButton(
            onPressed: () {},
            backgroundColor: Colors.pink,
            child: const Icon(Icons.remove)
          ),*/
        ],
      ),

      /*floatingActionButton: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment(Alignment.bottomRight.x,Alignment.bottomRight.y-0.2),
              child:FloatingActionButton(
                onPressed: () {
                  print("설정하기로 들아간다");
                  Navigator.push(context, // 네비게이션 형식으로 push형식으로 전환
                      MaterialPageRoute(builder: (context) => SettingPage())).then((_){
                        print("돌아왔을 때 화면을 리로드");
                        setState(() {});  // 돌아왔을 때 화면을 리로드
                        _dtAcc.setLogin().then((responseData) {      
                          setState((){});
                          print("_dtAcc.userData 값2:${_dtAcc.userData}");
                        });
                      }); // 화면전환 코드
                },
                tooltip: '설정하기',
                child: const Icon(Icons.settings),
              ),
            ),
          Align(
            alignment: Alignment.bottomRight,
            child:FloatingActionButton(
              onPressed: () {
                print("설정하기로 들아간다");
              },
              tooltip: '설정하기',
              child: const Icon(Icons.add),
            ),
          ),  
        ]
      ),*/


      /* floatingActionButton: FloatingActionButton(
        onPressed: () {
            print("설정하기로 들아간다");
            Navigator.push(context, // 네비게이션 형식으로 push형식으로 전환
                MaterialPageRoute(builder: (context) => SettingPage())).then((_){
                  print("돌아왔을 때 화면을 리로드");
                  setState(() {});  // 돌아왔을 때 화면을 리로드
                  _dtAcc.setLogin().then((responseData) {      
                    setState((){});
                    print("_dtAcc.userData 값2:${_dtAcc.userData}");
                  });
                }); // 화면전환 코드
          },
        tooltip: '설정하기',
        child: const Icon(Icons.settings),
      ), */ // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
