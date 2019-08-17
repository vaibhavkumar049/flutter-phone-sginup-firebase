import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DashBoard extends StatefulWidget {
  @override
  _DashBoardState createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  String uid = '';
  getUid() {}
  @override
  void initState() {
    this.uid = '';
    FirebaseAuth.instance.currentUser().then((val) {
      setState(() {
        this.uid = val.uid;
      });
    }).catchError((e) {
      print("$e");
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text("You logged in as $uid"),
          OutlineButton(
            textColor: Colors.red,
            onPressed: () {
              FirebaseAuth.instance.signOut().then((action) {
                print("hiii33");
                Navigator.of(context).pushReplacementNamed('/landingpage');
              }).catchError((e) {
                print(e);
              });
            },
          )
        ],
      ),
    );
  }
}
