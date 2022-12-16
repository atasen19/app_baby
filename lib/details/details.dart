import 'package:flutter/material.dart';
import 'package:plant_app/model/baby.dart';
import 'package:plant_app/myDrawer.dart';

import '../constants.dart';
import 'components/image_and_icons.dart';
import 'components/title_and_price.dart';

//import 'package:plant_app/screens/details/components/body.dart';

class DetailsScreen extends StatelessWidget {
  final Baby babydata;
  final bool visibilityVariable;

  const DetailsScreen({
    this.babydata,
    this.visibilityVariable
});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
        color: kSecondaryColor,
      ),
      child: Scaffold(
        drawer: MyDrawer(),
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                ImageAndIcons(size: size, baby: babydata, visibilityVariable: visibilityVariable),
                TitleAndPrice(name: "${babydata.name}", tarih: babydata.birthDay, gebelikSure: babydata.ageOfBirth),
                SizedBox(height: kDefaultPadding),
              ],
            ),
          ),
        ),
      ),
    );
  }

}
