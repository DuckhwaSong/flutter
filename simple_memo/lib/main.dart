import 'package:flutter/material.dart';
//import 'package:simple_memo/headBar.dart';
import 'package:simple_memo/ThirdPage.dart';
import 'package:simple_memo/HomeBody.dart';
import 'package:simple_memo/bottom_bar1.dart';
import 'package:simple_memo/bottom_bar2.dart';
import 'package:simple_memo/head_bar1.dart';
import 'package:simple_memo/headBar.dart';
import 'package:simple_memo/float_button1.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,  // 실질적으로 모든 앱을 감싸고 있다.
      title: 'Flutter Demo',  // 앱을 총칭하는 이름 -> 스마트 폰 앱에서 최근 사용한 앱 보여줄 때의 이름
      theme: ThemeData(
        //primarySwatch: Colors.red, // 특정색의 응용들을 기본 색상으로 지정해서 사용하겠 
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
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

  void _incrementCounter() {
    setState(() {
      _counter++;
    });

    ScaffoldMessenger.of(context).showSnackBar( // 스캐폴드메신저 만들기
      // 가장 가까운 스캐폴드 찾아서 반환해
      SnackBar( // 스낵바
        content: Text('Like a new Snack Bar!'), // 내
        duration: Duration(seconds: 5),
        action: SnackBarAction( // 스낵바 액션 - 우측에 달리는 아이템 버튼!
          label: 'Undo',
          onPressed: () {
            Navigator.push(context, // 네비게이션 형식으로 push형식으로 전환
                MaterialPageRoute(builder: (context) => ThirdPage())); // 화면전환 코드
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: headBar(),
      appBar: AppBar(
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      title: Text(widget.title),
      leading: IconButton(
        // 간단한 위젯이나 타이틀들을 앱바의 왼쪽에 위치시키는 것을 말함
        icon: Icon(Icons.menu), // 아이콘
        onPressed: () {
          // 버튼을 눌렀을 때
          print("menu button is clicked");
        },
      ),
      actions: [ // action 속성은 복수의 아이콘 버튼 등을 오른쪽에 배치할 때
        IconButton( // 간단한 위젯이나 타이틀들을 앱바의 왼쪽에 위치시키는 것을 말함
          icon: Icon(Icons.shopping_cart), // 아이콘
          onPressed: () {
            // 버튼을 눌렀을 때
            print("shopping_cart is clicked");
          },
        ),
        IconButton(  // 간단한 위젯이나 타이틀들을 앱바의 왼쪽에 위치시키는 것을 말함
          icon: Icon(Icons.search), // 아이콘
          onPressed: () {
            // 버튼을 눌렀을 때
            print("search is clicked");
          },
        )
      ],
    ),
      //body: HomeBody(), // 바디 부분에 홈 바디를 둔다.
      body:
      Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            HomeBody(),
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            Padding(
              padding: const EdgeInsets.only(top:20),
            ),
            SizedBox(
              width: 300,
              child: TextField(
                //obscureText: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Password1',
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatButton1(),
      /*floatingActionButton: SizedBox(
        width: 150.0,
        height: 60.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            FloatingActionButton(
              onPressed: _incrementCounter,
              tooltip: 'Increment',
              child: const Icon(Icons.thumb_up),
            ),
            FloatingActionButton(
              onPressed: _incrementCounter,
              tooltip: 'Increment',
              child: const Icon(Icons.thumb_up),
            ),            
          ],
        ),
      ),*/
      bottomNavigationBar: BottomBar1()
    );
  }
}
