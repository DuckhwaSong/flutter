import 'package:flutter/material.dart';
import 'package:base_app/widget/bottom_bar.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  _MyAppState createState()=>_MyAppState();
}

class _MyAppState extends State<MyApp> {
  //TabController controller;
  @override
  Widget build(BuildContext context){
    return MaterialApp(title:'Nflix',
    theme: ThemeData(
      brightness: Brightness.dark,
      primaryColor: Colors.black, 
      //colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.white).copyWith(secondary: Colors.grey),
      ),
    home: DefaultTabController(
      length:4,
      child:Scaffold(
        body: TabBarView(
          physics: NeverScrollableScrollPhysics(),
          children: <Widget>[
            Container(child:Center(child:Text('홈'))),
            Container(child:Text('검색',style: TextStyle(fontSize:9))),
            Container(child:Text('저장한컨텐츠목록',style: TextStyle(fontSize:9))),
            Container(child:Text('더보기',style: TextStyle(fontSize:9))),
          ],
          ),
          bottomNavigationBar: Bottom(),
         ),
      ),
    );
  }
}