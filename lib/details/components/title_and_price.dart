import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../constants.dart';

class TitleAndPrice extends StatelessWidget {
  const TitleAndPrice({
    Key key,
    this.name,
    this.tarih,
    this.gebelikSure,
  }) : super(key: key);

  final String name;
  final int tarih;
  final int gebelikSure;

  @override
  Widget build(BuildContext context) {

    var convert = DateTime.fromMillisecondsSinceEpoch(tarih);
    String tarihFormatted = DateFormat('yyyy-MM-dd - kk:mm').format(convert);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text(name + " " + tarihFormatted + " tarihinde " + gebelikSure.toString() + " haftalık gebelik sonrasında doğdu.", style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20.0,
              fontFamily: 'ScrambledTofu',
              color: kTextColorB
          ),),)
        ],
      ),
    );
  }
}
