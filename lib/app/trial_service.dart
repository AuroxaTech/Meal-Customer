import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WhiteScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Container(
          color: Colors.white,
          child: const Center(child: Text("App Crashed",style: TextStyle(color: Colors.red,fontSize: 30,
              fontWeight: FontWeight.w400),)),
        ),
      ),
    );
  }
}