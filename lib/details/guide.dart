import 'package:flutter/material.dart';

class GuideScreen extends StatelessWidget {
  const GuideScreen ({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Text("GuideScreen"),
        ),
      ),
    );
  }
}
