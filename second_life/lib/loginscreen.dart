import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:second_life/mainscreen.dart';
import 'package:second_life/registerscreen.dart';
import 'package:toast/toast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:google_fonts/google_fonts.dart';

import 'User.dart';

void main() => runApp(LoginScreen());
bool rememberMe = false;

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  double screenHeight;
  TextEditingController _emailEditingController = new TextEditingController();
  TextEditingController _passEditingController = new TextEditingController();
  String urlLogin = "https://madkiddo.com/second_life/php/login_user.php";

  @override
  void initState() {
    super.initState();
    print("Hello i'm in INITSTATE");
    this.loadPref();
  } 

  @override
   Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.black,
        brightness: Brightness.light,
        textTheme: GoogleFonts.anaheimTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      home: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  'assets/images/b.png',
                  width: 180,
                  height: 180,
                ),
                SizedBox(
                  height: 40,
                ),
                Container(
                  width: 360,
                  child: TextField(
                    controller: _emailEditingController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: new InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      ),
                      labelText: 'Email',
                      prefixIcon: const Icon(
                        Icons.email,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  width: 360,
                  child: TextField(
                    controller: _passEditingController,
                    obscureText: true,
                    decoration: new InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      ),
                      labelText: 'Password',
                      prefixIcon: const Icon(
                        Icons.lock,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Checkbox(
                        value: rememberMe,
                        onChanged: (bool value) {
                          _onRememberMeChanged(value);
                        },
                      ),
                      Text('Remember Me ',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold,color: Colors.black)),
                      SizedBox(
                        width: 30,
                      ),
                      MaterialButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0)),
                        minWidth: 180,
                        height: 50,
                        child: Text('Login',style: TextStyle(fontWeight: FontWeight.bold),),
                        color: Colors.black,
                        textColor: Colors.white,
                        onPressed: _userLogin,
                      ),
                    ]),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("Don't have an account ? ",
                        style: TextStyle(fontSize: 16.0,color: Colors.black)),
                    GestureDetector(
                      onTap: _registerUser,
                      child: Text(
                        "Create account",
                        style: TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.bold ,color: Colors.black),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 3,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("Forgot your password ? ",
                        style: TextStyle(fontSize: 16.0,color: Colors.black)),
                    GestureDetector(
                      onTap: _forgotPassword,
                      child: Text(
                        "Reset Password",
                        style: TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.bold ,color: Colors.black),
                      ),
                    ),
                  ],
                )
              ],
            ),
          )),
    );
  }

  void _userLogin() async {
    try {
      ProgressDialog pr = new ProgressDialog(context,
          type: ProgressDialogType.Normal, isDismissible: false);
      pr.style(message: "Log in");
      pr.show();
      String _email = _emailEditingController.text;
      String _password = _passEditingController.text;
      http.post(urlLogin, body: {
        "email": _email,
        "password": _password,
      })
          //.timeout(const Duration(seconds: 4))
          .then((res) {
        print(res.body);
        var string = res.body;
        List userdata = string.split(",");
        if (userdata[0] == "success") {
          User _user = new User(
            name: userdata[1],
            email: _email,
            password: _password,
            phone: userdata[3],
            datereg: userdata[4],
            quantity: userdata[5]);
          pr.dismiss();
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => MainScreen(
                        user: _user,
                      )));
        } else {
          pr.dismiss();
          Toast.show("Login failed", context,
              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        }
      }).catchError((err) {
        print(err);
        pr.dismiss();
      });
    } on Exception catch (_) {
      Toast.show("Error", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }
  }

  void _registerUser() {
    Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) => RegisterScreen()));
  }

  void _forgotPassword() {
    TextEditingController phoneController = TextEditingController();
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(
            "Forgot Password?",
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          content: new Container(
            height: 100,
            child: Column(
              children: <Widget>[
                Text(
                  "Enter your recovery email",
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
                TextField(
                    decoration: InputDecoration(
                  labelText: 'Email',
                  icon: Icon(Icons.email),
                ))
              ],
            ),
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text(
                "Yes",
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                print(
                  phoneController.text,
                );
              },
            ),
            new FlatButton(
              child: new Text(
                "No",
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _onRememberMeChanged(bool newValue) => setState(() {
        rememberMe = newValue;
        print(rememberMe);
        if (rememberMe) {
          savepref(true);
        } else {
          savepref(false);
        }
      });

  Future<void> loadPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = (prefs.getString('email')) ?? '';
    String password = (prefs.getString('pass')) ?? '';
    if (email.length > 1) {
      setState(() {
        _emailEditingController.text = email;
        _passEditingController.text = password;
        rememberMe = true;
      });
    }
  }

  void savepref(bool value) async {
    String email = _emailEditingController.text;
    String password = _passEditingController.text;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (value) {
      //save preference
      await prefs.setString('email', email);
      await prefs.setString('pass', password);
      Toast.show("Preferences have been saved", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    } else {
      //delete preference
      await prefs.setString('email', '');
      await prefs.setString('pass', '');
      setState(() {
        _emailEditingController.text = '';
        _passEditingController.text = '';
        rememberMe = false;
      });
      Toast.show("Preferences have removed", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    }
  }
}
