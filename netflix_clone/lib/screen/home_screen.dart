import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:netflix_clone/model/model_movie.dart';
import 'package:netflix_clone/widget/carousel_slider.dart';

class HomeScreen extends StatefulWidget {
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>{
  List<Movie> movies=[
    Movie.fromMap({
      'title':'신세계',
      'keyword':'엑션/르와르/신세계',
      'poster':'newworld.jpg',
      'like':false,
    })
  ];
  
  @override
  void initState(){
    super.initState();
  }
  
  /*@override
  Widget build(BuildContext context){
    return Container(
      child: Center(
        child: Text('real home1'),
      ),
    );
  }*/

  @override
  Widget build(BuildContext context){
    //return TopBar();
    return ListView(
      children:<Widget>[
        Stack(
          children:<Widget>[
            CarouselImage(movies: movies),
            TopBar()
          ]
        )
      ]
    );
  }
}

class TopBar extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return Container(
      padding: EdgeInsets.fromLTRB(20,7,20,7),
      child:Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Image.asset(
            'asset/images/logo.png',
            fit: BoxFit.contain,
            height: 25,
          ),
          Container(
            padding: EdgeInsets.only(right: 1),
            child:Text(
              'TV프로그램',
              style:TextStyle(fontSize: 14)
            )
          ),
          Container(
            padding: EdgeInsets.only(right: 1),
            child:Text(
              'TV프로그램',
              style:TextStyle(fontSize: 14)
            )
          ),
          Container(
            padding: EdgeInsets.only(right: 1),
            child:Text(
              'TV프로그램',
              style:TextStyle(fontSize: 14)
            )
          ),        
        ],
      )
    );
  }
}