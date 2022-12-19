import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:plant_app/firebaseFunctions.dart';
import 'package:plant_app/model/mainTitle.dart';
import 'package:plant_app/myDrawer.dart';
import './subTitles.dart';
import '../constants.dart';

class MainTitles extends StatefulWidget {
  final bool visibiltyVariable;
  MainTitles({
    this.visibiltyVariable,
  });

  @override
  _MainTitlesState createState() =>
      _MainTitlesState(visibiltyVariable: visibiltyVariable);
}

class _MainTitlesState extends State<MainTitles> {
  final bool visibiltyVariable;

  _MainTitlesState({
    this.visibiltyVariable,
  });

  TextEditingController textEditingController = TextEditingController();
  String valueText;

  List<MainTitleModel> array2;
  User user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: MyDrawer(),
        resizeToAvoidBottomInset: false,
        backgroundColor: kSecondaryColor,
        body: SafeArea(
            child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                      onPressed: () {
                        Navigator.pop(context, true);
                      },
                      icon: Icon(Icons.arrow_back, color: kPrimaryColor),
                      iconSize: 30.0),
                ),
                Visibility(
                  visible: visibiltyVariable,
                  child: Container(
                    margin:EdgeInsets.only(top: 10, right: 10),
                    width: 40,
                    height: 40,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kPrimaryColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(9.0)),
                      ),
                      // child: Icon(Icons.add, color: Colors.white, size: 10),
                      child: Text("+",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.white,
                              fontFamily: "ScrambledTofu")),
                      onPressed: () async {
                        await showAlertDialogAdd(context);
                      },
                    ),
                  ),
                ),
              ],
            ),
            Center(
              child: Container(
                child: Text("Rehber Sayfası",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 35,
                        color: kTextColorB,
                        fontFamily: "ScrambledTofu")),
              ),
            ),
            const Divider(
              color: Colors.purple,
              height: 20,
              thickness: 3,
              indent: 20,
              endIndent: 20,
            ),
            getFutureBuilder(context),
          ],
        )));
  }

  Widget getFutureBuilder(BuildContext context) {
    return FutureBuilder(
        future: FirebaseService().getPosts(),
        builder: (context, AsyncSnapshot<List> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            array2 = snapshot.data;
            array2.sort((a, b) => a.baslik.compareTo(b.baslik));
            return Expanded(
              child: SingleChildScrollView(
                child: ListView.builder(
                    itemCount: array2.length,
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 1.0, horizontal: 0.0),
                        child: Card(
                          color: Colors.transparent,
                          shadowColor: Colors.transparent,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.purple.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(20)
                            ),
                            child: ListTile(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SubTitles(
                                        mainTitleModel: array2[index],
                                        visibiltyVariable: visibiltyVariable),
                                  ),
                                );
                              },
                              title: Transform.translate(
                                offset: Offset(-16, 0),
                                child: Text(
                                  array2[index].baslik,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20.0,
                                      fontFamily: 'ScrambledTofu',
                                      color: kTextColorB),
                                ),
                              ),
                              leading: Container(
                                  height: double.infinity,
                                  child: Icon(Icons.circle_rounded,
                                      color: kTextColorB, size: 13)),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Visibility(
                                    visible: visibiltyVariable,
                                    child: IconButton(
                                        onPressed: () async {
                                          await showAlertDialogUpdate(
                                              context, array2[index]);
                                          array2 = snapshot.data;
                                        },
                                        icon: Icon(Icons.edit,
                                            color: kTextColorB, size: 20),
                                        padding: EdgeInsets.zero,
                                        constraints: BoxConstraints()),
                                  ),
                                  Visibility(
                                    visible: visibiltyVariable,
                                    child: IconButton(
                                        onPressed: () async {
                                          showAlertDialogDelete(
                                              context, array2[index]);
                                          array2 = snapshot.data;
                                        },
                                        icon: Icon(Icons.delete,
                                            color: kTextColorB, size: 20)),
                                  ),
                                  Container(
                                      height: double.infinity,
                                      child: Icon(Icons.arrow_right,
                                          color: kTextColorB, size: 30)),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
              ),
            );
          } else if (snapshot.connectionState == ConnectionState.none) {
            return null;
          }
          return SizedBox(
              height: MediaQuery.of(context).size.height / 1.3,
              child: Center(child: CircularProgressIndicator()));
        });
  }

  //alert dialog silme butonu için
  showAlertDialogDelete(BuildContext context, MainTitleModel mainTitleModel) {
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
        await FirebaseService().deleteMainTitle(mainTitleModel);
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
          "Seçili Başlığı Silmek İstediğinize Emin misiniz? Bu işlem Geri Alınamaz.",
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

  showAlertDialogUpdate(BuildContext context, MainTitleModel mainTitleModel) {
    textEditingController.text = mainTitleModel.baslik;
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
        await FirebaseService().updateMainTitle(mainTitleModel);
        Navigator.of(context).pop();
        setState(() {});
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(32)),
      ),
      title: Text("Başlık İsmi Giriniz", style: TextStyle(color: kTextColorB)),
      content: TextField(
        controller: textEditingController,
        decoration: InputDecoration(
          hintStyle: TextStyle(fontSize: 20.0, fontFamily: 'ScrambledTofu'),
          fillColor: Colors.white60,
          filled: true,
          contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
        ),
        onChanged: (value) {
          mainTitleModel.baslik = value;
        },
      ),
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

  showAlertDialogAdd(BuildContext context) {
    textEditingController.text = "";
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
        await FirebaseService().addMainTitle(textEditingController.text);
        Navigator.of(context).pop();
        setState(() {});
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(32)),
      ),
      title: Text("Başlık İsmi Giriniz", style: TextStyle(color: kTextColorB)),
      content: TextField(
        controller: textEditingController,
        decoration: InputDecoration(
          hintStyle: TextStyle(fontSize: 20.0, fontFamily: 'ScrambledTofu'),
          fillColor: Colors.white60,
          filled: true,
          contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
        ),
      ),
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
}
