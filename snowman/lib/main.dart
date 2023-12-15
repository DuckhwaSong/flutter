import 'package:flutter/material.dart';
import 'setting.dart';

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
  double _currentSliderPrimaryValue = 0.2;
  double _currentSliderSecondaryValue = 0.5;

  void _incrementCounter() {
    setState(() {
      _counter++;
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
                        Text(
              '$_currentSliderPrimaryValue',
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
