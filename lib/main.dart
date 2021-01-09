import 'package:flutter/material.dart';
import 'status_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return MaterialApp(
      title: 'Dropdown with Boxes',
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      home: Scaffold(
        body: Padding(
          padding: const EdgeInsets.only(top: 30, left: 0, right: 0),
          //OrderUnit Class in the according dart file needs to be instantiated in a ListView widget
          child: StatusScreen(),
        ),
      ),
    );
  }
}