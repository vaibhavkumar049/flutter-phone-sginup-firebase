import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'homepage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat App',
      theme: ThemeData.dark()
          .copyWith(primaryColor: Colors.white, accentColor: Colors.white),
      home: MyHomePage(),
      routes: <String, WidgetBuilder>{
        '/homepage': (BuildContext context) => DashBoard(),
        '/landingpage': (BuildContext context) => MyHomePage()
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String phoneNo;
  String smsCode;
  String verificationID;

  Future<void> verifyPhone() async {
    print("button pressed");
    final PhoneCodeAutoRetrievalTimeout autoRetrive = (String verID) {
      this.verificationID = verID;
    };

    final PhoneCodeSent smsCodeSent = (String verID, [int forceCodeResend]) {
      this.verificationID = verID;
      smsCodeDialog(context).then((value) {
        print("Signed in");
      });
    };
    print("hi");
    final PhoneVerificationCompleted verifiedSuccess = (AuthCredential phoneAuthCredential) {
      FirebaseAuth.instance.signInWithCredential(phoneAuthCredential);
      print("Verified");
    };
    print("hi2");

    final PhoneVerificationFailed veriFailed = (AuthException exception) {
      print("${exception.message}");
    };

    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: this.phoneNo,
        codeAutoRetrievalTimeout: autoRetrive,
        codeSent: smsCodeSent,
        timeout: const Duration(seconds: 5),
        verificationCompleted: verifiedSuccess,
        verificationFailed: veriFailed);
  }

  Future<bool> smsCodeDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Enter SMS Code'),
            content: TextField(
              onChanged: (value) {
                this.smsCode = value;
              },
            ),
            actions: <Widget>[
              FlatButton(
                child: Text("DONE"),
                onPressed: () {
                  FirebaseAuth.instance.currentUser().then((user) {
                    if (user != null) {
                      Navigator.of(context).pop();
                      Navigator.of(context).pushReplacementNamed("/homepage");
                    } else {
                      Navigator.of(context).pop();
                      signIn();
                    }
                  });
                },
              )
            ],
          );
        });
  }

  signIn() async {
    final AuthCredential credential = PhoneAuthProvider.getCredential(
        verificationId: verificationID, smsCode: smsCode);
    final FirebaseUser user = await FirebaseAuth.instance
        .signInWithCredential(credential)
        .then((user) {
      Navigator.of(context).pushReplacementNamed('/homepage');
    }).catchError((e) {
      print("$e");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Phone Auth"),
      ),
      body: Center(
        child: Container(
          child: Column(
            children: <Widget>[
              TextField(
                decoration: InputDecoration(hintText: "Enter Phone nUmber"),
                onChanged: (value) {
                  this.phoneNo = value;
                },
                keyboardType: TextInputType.number,
              ),
              SizedBox(
                height: 10.0,
              ),
              RaisedButton(
                onPressed: verifyPhone,
                child: Text('verify'),
                textColor: Colors.white,
                elevation: 10.0,
                color: Colors.blue,
              )
            ],
          ),
        ),
      ),
    );
  }
}
