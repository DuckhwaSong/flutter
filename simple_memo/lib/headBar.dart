import 'package:flutter/material.dart';


class headBar extends AppBar{
  @override
  Widget build(BuildContext context){
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      title: Text('widget.title'),
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
    );
  }
}