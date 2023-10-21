import 'dart:math';

import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key:key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int number=1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: GestureDetector(
          onTap:(){
            print('click');
            final newNumber=Random().nextInt(6)+1;
            setState(() {
              number=newNumber;
            });
          },
          child: Image.asset(
          'asset/img/dice$number.png'
          )          
        )
      )
    );
  }
}