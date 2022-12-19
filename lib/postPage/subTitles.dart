import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:plant_app/firebaseFunctions.dart';
// import '../home/home_screen.dart';
import 'package:plant_app/model/mainTitle.dart';
import 'package:plant_app/model/postmodel.dart';
import 'package:plant_app/myDrawer.dart';
import 'package:plant_app/postPage/content.dart';
// import 'package:plant_app/postPage/mainTitles.dart';
import '../constants.dart';

class SubTitles extends StatefulWidget {
  const SubTitles({
    this.visibiltyVariable,
    this.mainTitleModel,
  });

  final bool visibiltyVariable;
  final MainTitleModel mainTitleModel;
  @override
  _SubTitlesState createState() =>
      _SubTitlesState(visibiltyVariable: visibiltyVariable);
}

class _SubTitlesState extends State<SubTitles> {
  final bool visibiltyVariable;

  _SubTitlesState({
    this.visibiltyVariable,
  });
  TextEditingController textEditingController = TextEditingController();
  List<PostModel> postList;
  User user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        drawer: MyDrawer(),
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
                    margin: EdgeInsets.only(right: 10),
                    width: 40,
                    height: 25,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kPrimaryColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(9.0)),
                      ),
                      // child: Icon(Icons.add, color: Colors.white),
                      child: Text("+",
                          style: TextStyle(
                              //fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: Colors.white,
                              fontFamily: "ScrambledTofu")),
                      onPressed: () async {
                        showAlertDialogAdd(context);
                      },
                    ),
                  ),
                ),
              ],
            ),
            Center(
              child: Container(
                child: Text("Alt İçerikler",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
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
            getSubtitleFutureBuilder(context),
          ],
        )));
  }

  Widget getSubtitleFutureBuilder(BuildContext context) {
    return FutureBuilder(
        future: FirebaseService().getPostDocuments(widget.mainTitleModel),
        builder: (context, AsyncSnapshot<List> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            postList = snapshot.data;
            postList.sort((a, b) => a.baslik.compareTo(b.baslik));
            return Expanded(
              child: SingleChildScrollView(
                child: ListView.builder(
                    itemCount: postList.length,
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
                            decoration: BoxDecoration(color: Colors.purple.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(20)),
                            child: ListTile(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Content(
                                        post: postList[index],
                                        visibiltyVariable: visibiltyVariable),
                                  ),
                                );
                              },
                              title: Transform.translate(
                                offset: Offset(-16, 0),
                                child: Text(
                                  postList[index].baslik,
                                  style: TextStyle(
                                      fontSize: 17.0,
                                      fontFamily: 'ScrambledTofu',
                                      color: kTextColorB),
                                ),
                              ),
                              leading: Container(
                                  height: double.infinity,
                                  child: Icon(Icons.baby_changing_station_rounded,
                                      color: kTextColorB, size: 23)),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Visibility(
                                    visible: visibiltyVariable,
                                    child: IconButton(
                                        onPressed: () async {
                                          showAlertDialogUpdate(
                                              context, postList[index]);
                                          postList = snapshot.data;
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
                                              context, postList[index]);
                                          postList = snapshot.data;
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
        await FirebaseService()
            .addSubTitle(widget.mainTitleModel, textEditingController.text);
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

  showAlertDialogUpdate(BuildContext context, PostModel post) {
    textEditingController.text = post.baslik;
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
        await FirebaseService().updateSubTitle(post);
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
          post.baslik = value;
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

  showAlertDialogDelete(BuildContext context, PostModel postModel) {
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
        await FirebaseService().deleteSubTitle(postModel);
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
          "Seçili Alt Başlığı Silmek İstediğinize Emin misiniz? Bu işlem Geri Alınamaz.",
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
}
