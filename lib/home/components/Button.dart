import 'package:flutter/material.dart';

class Button extends StatelessWidget{
  @override
  Widget build(BuildContext context) {

    return Container(
      height: 50,
      margin: EdgeInsets.symmetric(horizontal: 50),

      decoration: BoxDecoration(
        boxShadow: [ BoxShadow(
          color: Colors.grey.withOpacity(0.5),
          spreadRadius: 5,
          blurRadius: 7,
          offset: Offset(0, 3),
        )],
        borderRadius: BorderRadius.circular(10),
        gradient: LinearGradient(begin: Alignment.topCenter, colors: [
          Colors.purpleAccent,
          Colors.purple,
          Colors.deepPurple,
        ]),
      ),
      child: Center(
        child: Text("Giriş",style: TextStyle(
          color: Colors.white,
          fontSize: 20,
        ),),
      ),
    );
  }
}