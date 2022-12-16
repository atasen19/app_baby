import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:plant_app/addBabyScreen/addBabyScreen.dart';
import 'package:plant_app/constants.dart';
import 'package:plant_app/details/details.dart';
import 'package:plant_app/firebaseFunctions.dart';
// import 'package:plant_app/login/LoginPage.dart';
import 'package:plant_app/model/baby.dart';
import 'package:plant_app/model/user_model.dart';

class Body extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return BodyState();
  }
}

class BodyState extends State<Body> {
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection("users")
        .doc(firebaseUser.uid)
        .get()
        .then((value) {
      this.loggedInUser = UserModel.fromMap(value.data());
      setState(() {
        if (loggedInUser.admin == 1) {
          visibilityVariable = true;
          print(visibilityVariable);
        } else {
          visibilityVariable = false;
          print(visibilityVariable);
        }
      });
    });
    search();
  }

  bool visibilityVariable = false;
  UserModel loggedInUser = UserModel();

  final auth = FirebaseAuth.instance;
  var firebaseUser = FirebaseAuth.instance.currentUser;

  List<Baby> babySearchResultList = [];
  List<Baby> babySearchList = [];

  TextEditingController searchBoxController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(bottom: kDefaultPadding * 0.5),
          // It will cover 20% of our total height
          height: size.height * 0.2,
          child: Stack(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(
                  left: kDefaultPadding,
                  right: kDefaultPadding,
                  bottom: 36 + kDefaultPadding,
                ),
                height: size.height * 0.2 - 27,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(36),
                    bottomRight: Radius.circular(36),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Hoşgeldiniz!',
                      style: Theme.of(context).textTheme.headlineSmall.copyWith(
                          color: kPrimaryColor,
                          fontSize: 30.0,
                          fontFamily: 'ScrambledTofu'),
                    ),
                    //Spacer(),
                    //CircleAvatar(backgroundImage: AssetImage("assets/image/baby_0.png"), radius: 32,) profil fotosu
                  ],
                ),
              ),
              Positioned(
                bottom: 20,
                left: 0,
                right: 0,
                child: Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.symmetric(horizontal: kDefaultPadding),
                  padding: EdgeInsets.symmetric(horizontal: kDefaultPadding),
                  height: 54,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        offset: Offset(0, 10),
                        blurRadius: 50,
                        color: kPrimaryColor.withOpacity(0.23),
                      ),
                    ],
                  ),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: TextField(
                          controller: searchBoxController,
                          autofocus: false,
                          onChanged: (value) {
                            onSearchTextChanged(value);
                          },
                          decoration: InputDecoration(
                            hintText: "İsim giriniz",
                            hintStyle: TextStyle(
                                fontSize: 15.0, fontFamily: 'ScrambledTofu'),
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                          ),
                        ),
                      ),
                      SvgPicture.asset("assets/icons/search.svg",
                          color: kPrimaryColor),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        Center(
          child: Container(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: kPrimaryColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24)),
              ),
              child: Icon(Icons.add, color: Colors.white),
              onPressed: () {
                Baby baby = Baby(
                  image:
                      "https://firebasestorage.googleapis.com/v0/b/appbaby-68c8d.appspot.com/o/images%2Fbebek2.jpg?alt=media&token=08e729d7-701d-47ad-bcd3-51e603e574d7",
                  name: "",
                  age: 0,
                  gender: "Özel",
                  desc: "",
                  birthDay: 1637960400000,
                  ageOfBirth: 20,
                  birthWeight: 1250,
                  birthLength: 41.5,
                  headSize: 28.0,
                );
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            AddBabyScreen(option: 1, baby: baby)));
              },
            ),
          ),
        ),
        //TitleWithMoreBtn(title: "", press: () {}),
        SizedBox(height: 20),
        Expanded(
          child: SingleChildScrollView(
            child: Container(
              decoration: BoxDecoration(
                //color: Color.fromRGBO(155, 208, 232, 0.5),
                color: Colors.transparent,
              ),
              child: babySearchResultList.length != 0 ||
                      searchBoxController.text.isNotEmpty
                  ? ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                      itemCount: babySearchResultList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 1.0, horizontal: 0.0),
                          child: Card(
                            color: Colors.transparent,
                            shadowColor: Colors.transparent,
                            child: ListTile(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DetailsScreen(
                                        babydata: babySearchResultList[index],
                                        visibilityVariable: visibilityVariable),
                                  ),
                                ).then((value) {
                                  search();
                                });
                              },
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    AddBabyScreen(
                                                        option: 2,
                                                        baby:
                                                            babySearchResultList[
                                                                index])));
                                      },
                                      icon: ImageIcon(
                                          AssetImage(
                                              "assets/icons/editbutton.png"),
                                          color: kPrimaryColor)),
                                  SizedBox(width: 0),
                                  IconButton(
                                      onPressed: () {
                                        showAlertDialog(context,
                                            babySearchResultList[index]);
                                      },
                                      icon: ImageIcon(
                                          AssetImage(
                                              "assets/icons/deletebutton.png"),
                                          color: kPrimaryColor)),
                                ],
                              ),
                              title: Align(
                                alignment: Alignment(-0.7, 0),
                                child: Text(
                                  babySearchResultList[index].name,
                                  style: TextStyle(
                                      fontSize: 25.0,
                                      fontFamily: 'ScrambledTofu',
                                      color: kPrimaryColor),
                                ),
                              ),
                              leading: CircleAvatar(
                                radius: 25,
                                backgroundColor: kPrimaryColor,
                                child: CircleAvatar(
                                  backgroundImage: Image.network(
                                          babySearchResultList[index].image)
                                      .image,
                                  radius: 24,
                                  //backgroundImage: AssetImage(babies[index].image), burada backgrund image çek
                                ),
                              ),
                            ),
                          ),
                        );
                      })
                  : ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                      itemCount: babySearchList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 1.0, horizontal: 0.0),
                          child: Card(
                            color: Colors.transparent,
                            shadowColor: Colors.transparent,
                            child: ListTile(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DetailsScreen(
                                        babydata: babySearchList[index],
                                        visibilityVariable: visibilityVariable),
                                  ),
                                ).then((value) {
                                  search();
                                });
                              },
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    AddBabyScreen(
                                                        option: 2,
                                                        baby: babySearchList[
                                                            index])));
                                      },
                                      icon: ImageIcon(
                                          AssetImage(
                                              "assets/icons/editbutton.png"),
                                          color: kPrimaryColor)),
                                  SizedBox(width: 0),
                                  IconButton(
                                      onPressed: () {
                                        showAlertDialog(
                                            context, babySearchList[index]);
                                      },
                                      icon: ImageIcon(
                                          AssetImage(
                                              "assets/icons/deletebutton.png"),
                                          color: kPrimaryColor)),
                                ],
                              ),
                              title: Align(
                                alignment: Alignment(-0.7, 0),
                                child: Text(
                                  babySearchList[index].name,
                                  style: TextStyle(
                                      fontSize: 25.0,
                                      fontFamily: 'ScrambledTofu',
                                      color: kPrimaryColor),
                                ),
                              ),
                              leading: CircleAvatar(
                                radius: 25,
                                backgroundColor: kPrimaryColor,
                                child: CircleAvatar(
                                  backgroundImage:
                                      Image.network(babySearchList[index].image)
                                          .image,
                                  radius: 24,
                                  //backgroundImage: AssetImage(babies[index].image), burada backgrund image çek
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
            ),
          ),
        ),
        SizedBox(
          height: 35,
        ),
      ],
    );
  }

  showAlertDialog(BuildContext context, Baby baby) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("İptal", style: TextStyle(color: Colors.lightGreen)),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = TextButton(
      child: Text("Devam Et", style: TextStyle(color: Colors.red)),
      onPressed: () async {
        await FirebaseService().deleteImage(baby.image);
        await FirebaseService(uid: firebaseUser.uid).deleteBaby(baby);

        babySearchResultList.remove(baby);
        babySearchList.remove(baby);

        Navigator.of(context).pop();
        setState(() {});
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(32)),
      ),
      title: Text("Dikkat edin!", style: TextStyle(color: kTextColorB)),
      content: Text(
          "Seçili Bebeği Silmek İstediğinize Emin misiniz? Bu işlem Geri Alınamaz.",
          style: TextStyle(color: kTextColorB, fontSize: 15.0)),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  onSearchTextChanged(String text) async {
    babySearchResultList.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }

    babySearchList.forEach((baby) {
      if (baby.name.contains(text)) babySearchResultList.add(baby);
    });

    setState(() {});
  }

  Future search() async {
    babySearchList = await FirebaseService(uid: firebaseUser.uid).getBabies();
    setState(() {});
  }
}
