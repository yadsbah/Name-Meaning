import 'dart:convert';
import 'dart:io';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart';
import 'package:launch_review/launch_review.dart';
import 'package:namemeanning/codes.dart';
import 'package:url_launcher/url_launcher.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String name = "";
  bool ignor = false;
  static List<String> meanings = new List<String>();
  Widget item(index) {
    return Padding(
      padding: EdgeInsets.only(left: 10, right: 10, top: 25),
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black45,
              blurRadius: 9.0,
              spreadRadius: 2,
              offset: Offset(4, 3),
            )
          ],
          color: Colors.grey.shade300,
        ),
        height: 70,
        padding: EdgeInsets.all(5),
        child: AutoSizeText(
          meanings[index],
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  void _showMaterialDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              title: Text(
                'Searching...',
                textAlign: TextAlign.center,
              ),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[CircularProgressIndicator()],
              ));
        });
  }
  _dismissDialog() {
    if (Navigator.canPop(context)) Navigator.pop(context);
  }
  @override
  void initState() {
    FirebaseAdMob.instance
        .initialize(appId: "ca-app-pub-7815219498446862~4888303321");
    super.initState();
    myBanner.load();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: Text(
          "What my Name Mean",
        ),
        centerTitle: true,
        primary: true,
        backgroundColor: Colors.blue.shade900,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
            child: TextField(
              autocorrect: false,
              textAlign: TextAlign.center,
              onChanged: (text) => name = text,
              decoration: InputDecoration(
                labelText: "Name Here",
                prefixIcon: Icon(Icons.supervised_user_circle),
                border: UnderlineInputBorder(),
              ),
              maxLines: 1,
            ),
          ),
          IgnorePointer(
            child: RaisedButton(
              child: Text("Search"),
              onPressed: () async {
               var x = await Codes.geta('avar');
               print(x);
               var v = await post("http://kakayado.com/nametr.php",body: {'tr':jsonEncode(x)});
              print(v.body);
              },
            ),
            ignoring: ignor,
          ),
          Divider(
            endIndent: 3,
            height: 2,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: meanings.length,
              scrollDirection: Axis.vertical,
              itemBuilder: (BuildContext context, int index) {
                return item(index);
              },
            ),
          )
        ],
      ),
      bottomNavigationBar: BottomAppBar(
          shape: CircularNotchedRectangle(),
          color: Colors.blue.shade900,
          child: Container(
            height: MediaQuery.of(context).size.height * 0.10,
            child: Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * 0.10),
                ),
                IconButton(
                  icon: Icon(Icons.star, color: Colors.white,),
                  onPressed: () {
                    LaunchReview.launch(androidAppId: "com.kaka.name",
                    );
                  },
                ),
                Expanded(
                  child: Container(),
                ),
                IconButton(icon: Icon(Icons.exit_to_app,color: Colors.white,), onPressed: () {
                  exit(0);
                }),
                Padding(
                  padding: EdgeInsets.only(
                      right: MediaQuery.of(context).size.width * 0.10),
                ),
              ],
            ),
          )),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
          onPressed: () async{
            if(await canLaunch("https://facebook.com/kakayado1998")) await launch("https://facebook.com/kakayado1998");
          },
          backgroundColor: Colors.blue.shade900,
          child: Icon(FontAwesomeIcons.facebookF)),
    );
  }

  static MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
      keywords: <String>[
        'name',
        'game apps',
        'beautiful name',
        'nice',
        'gamming'
      ],
      contentUrl: 'https://www.names.org/',
      childDirected: false,
      );
  BannerAd myBanner = BannerAd(
    adUnitId: "ca-app-pub-7815219498446862/2961796371",
    size: AdSize.smartBanner,
    targetingInfo: targetingInfo,
    listener: (MobileAdEvent event) {
      print("BannerAd event is $event");
    },
  );
}
