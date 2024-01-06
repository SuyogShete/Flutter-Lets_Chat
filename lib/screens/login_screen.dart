import 'package:flutter/material.dart';
import 'package:lets_chat/components/MyButton.dart';
import 'package:lets_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lets_chat/screens/chat_screen.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:lets_chat/components/RoundedButton.dart';

class LoginScreen extends StatefulWidget {
  static const id = 'login_screen';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;
  bool showSpinner = false;
  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Hero(
                tag: 'logo',
                // child: Container(
                //   height: 200.0,
                //   child: Image.asset('images/logo.png'),
                // ),
                child: Icon(
                  Icons.lock,
                  size: 100,
                ),
              ),
              SizedBox(
                height: 25.0,
              ),
              Center(
                child: Text(
                  'Welcome back master..!!',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                height: 30.0,
              ),
              TextField(
                textAlign: TextAlign.center,
                onChanged: (value) {
                  email = value;
                },
                decoration:
                    kTextFeildDecoration.copyWith(hintText: 'Enter your Username'),
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                textAlign: TextAlign.center,
                onChanged: (value) {
                  password = value;
                },
                decoration: kTextFeildDecoration.copyWith(
                    hintText: 'Enter your Password'),
              ),
              SizedBox(
                height: 24.0,
              ),
              // RoundedButton(
              //   colour: Color(0xff233743),
              //   title: 'Log In',
              //   onPressed: () async{
              //     setState(() {
              //       showSpinner = true;
              //     });
              //     try {
              //       final user = await _auth.signInWithEmailAndPassword(
              //           email: email, password: password);
              //
              //       if (user != null)
              //         {
              //           Navigator.pushNamed(context, ChatScreen.id);
              //         }
              //       setState(() {
              //         showSpinner = false;
              //       });
              //     }
              //     catch(e)
              //     {
              //       print(e);
              //     }
              //
              //   },
              //  ),
              MyButton(
                  title: 'log In',
                  onTap: () async {
                    setState(() {
                      showSpinner = true;
                    });
                    try {
                      final user = await _auth.signInWithEmailAndPassword(
                          email: email, password: password);

                      if (user != null) {
                        Navigator.pushNamed(context, ChatScreen.id);
                      }
                      setState(() {
                        showSpinner = false;
                      });
                    } catch (e) {
                      print(e);
                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
