import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:plant_app/details/components/babydetails/baby_description.dart';
import 'package:plant_app/details/components/babydetails/baby_log.dart';
// import 'package:plant_app/details/guide.dart';
import 'package:plant_app/model/baby.dart';
import 'package:plant_app/postPage/mainTitles.dart';

import '../../../constants.dart';
import 'icon_card.dart';

class ImageAndIcons extends StatelessWidget {
  const ImageAndIcons({
    Key key,
    this.size,
    this.baby,
    this.visibilityVariable,
  }) : super(key: key);

  final Size size;
  final Baby baby;
  final bool visibilityVariable;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: kDefaultPadding * 1.5),
      child: SizedBox(
        height: size.height * 0.8,
        child: Row(
          children: <Widget>[
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: kDefaultPadding * 5),
                child: Column(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.topLeft,
                      child: IconButton(
                        padding:
                            EdgeInsets.symmetric(horizontal: kDefaultPadding),
                        icon: SvgPicture.asset("assets/icons/back_arrow.svg",
                            color: kPrimaryColor),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    Spacer(),
                    GestureDetector(
                      child: IconCard(icon: "assets/icons/paper.png"),
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BabyLog(
                                baby: baby,
                                visibilityVariable: visibilityVariable),
                          ),
                        );
                      },
                    ),
                    GestureDetector(
                      child: IconCard(icon: "assets/icons/feather-pen.png"),
                      onTap: () {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) => BabyDescription(
                                baby: baby,
                                visibilityVariable: visibilityVariable)));
                      },
                    ),
                    GestureDetector(
                      child: IconCard(icon: "assets/icons/guide-book.png"),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MainTitles(
                                visibiltyVariable: visibilityVariable),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            Container(
              height: size.height * 0.5,
              width: size.width * 0.8,
              margin: EdgeInsets.only(top: 90),
              padding: EdgeInsets.only(top: 200),
              decoration: BoxDecoration(
                border: Border.all(color: kPrimaryColor, width: 2),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(100),
                  bottomLeft: Radius.circular(100),
                ),
                boxShadow: [
                  BoxShadow(
                    offset: Offset(0, 10),
                    blurRadius: 60,
                    color: kPrimaryColor.withOpacity(0.20),
                  ),
                ],
                image: DecorationImage(
                  alignment: Alignment.center,
                  fit: BoxFit.cover,
                  image: NetworkImage(baby.image),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
