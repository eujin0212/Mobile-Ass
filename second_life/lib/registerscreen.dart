import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:second_life/LoginScreen.dart';
import 'package:toast/toast.dart';

void main() => runApp(RegisterScreen());

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  double screenHeight;
  bool _isChecked = false;
  GlobalKey<FormState> _key = new GlobalKey();
  String urlRegister = "https://madkiddo.com/second_life/php/register_user.php";
  TextEditingController _nameEditingController = new TextEditingController();
  TextEditingController _emailEditingController = new TextEditingController();
  TextEditingController _phoneditingController = new TextEditingController();
  TextEditingController _passEditingController = new TextEditingController();
  bool _validate = false;
  String name, email, phone, password;

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      //theme: new ThemeData(
      //  primarySwatch: Colors.black,
      //),
      home: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Center(
              child: Column(
            children: <Widget>[
              SizedBox(height: 50),
              Image.asset(
                'assets/images/b.png',
                width: 180,
                height: 180,
              ),
              SizedBox(
                height: 20,
              ),
              new Form(
                key: _key,
                autovalidate: _validate,
                child: formUI(),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("Already register? ", style: TextStyle(fontSize: 16.0)),
                  GestureDetector(
                    onTap: _loginScreen,
                    child: Text(
                      "Login",
                      style: TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              )
            ],
          ))),
    );
  }

  Widget formUI() {
    return new Container(
      padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
      child: Column(
        children: <Widget>[
          new TextFormField(
            controller: _nameEditingController,
            decoration: new InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
                borderSide: BorderSide(color: Colors.black),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
              ),
              labelText: 'Name',
              prefixIcon: const Icon(
                Icons.person,
                color: Colors.black,
              ),
            ),
            validator: validateName,
            onSaved: (String val) {
              name = val;
            },
          ),
          SizedBox(height: 8),
          new TextFormField(
              controller: _phoneditingController,
              decoration: new InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  borderSide: BorderSide(color: Colors.black),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                ),
                labelText: 'Phone Number',
                prefixIcon: const Icon(
                  Icons.phone,
                  color: Colors.black,
                ),
              ),
              keyboardType: TextInputType.phone,
              validator: validateMobile,
              onSaved: (String val) {
                phone = val;
              }),
          SizedBox(height: 8),
          new TextFormField(
              controller: _emailEditingController,
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
                  )),
              keyboardType: TextInputType.emailAddress,
              validator: validateEmail,
              onSaved: (String val) {
                email = val;
              }),
          SizedBox(height: 8),
          new TextFormField(
              controller: _passEditingController,
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
                  )),
              obscureText: true,
              validator: validatePass,
              onSaved: (String val) {
                email = val;
              }),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Checkbox(
                value: _isChecked,
                onChanged: (bool value) {
                  _onChange(value);
                },
              ),
              GestureDetector(
                onTap: _showEULA,
                child: Text('I Agree to Terms  ',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
              MaterialButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0)),
                minWidth: 180,
                height: 50,
                child: Text(
                  'Register',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                color: Colors.black,
                textColor: Colors.white,
                onPressed: _confirmation,
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _confirmation() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          backgroundColor: Colors.white,
          title: new Text("Confirmation"),
          content: new Container(
            child: Text("Are you sure want to register ?"),
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
                child: new Text("Yes",
                    style: TextStyle(
                      color: Colors.black,
                    )),
                onPressed: _onRegister),
            new FlatButton(
              child: new Text("No",
                  style: TextStyle(
                    color: Colors.black,
                  )),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _onRegister() {
    Navigator.pop(context);
    String name = _nameEditingController.text;
    String email = _emailEditingController.text;
    String phone = _phoneditingController.text;
    String password = _passEditingController.text;

    if (!_isChecked) {
      Toast.show("Please Accept Term", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }

    http.post(urlRegister, body: {
      "name": name,
      "email": email,
      "password": password,
      "phone": phone,
    }).then((res) {
      print(res.body);
      if (res.body == "failed") {
        Toast.show("Registration failed", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      } else {
        Navigator.pop(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => LoginScreen()));
        Toast.show("Registration success", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      }
    }).catchError((err) {
      print(err);
    });
  }

  void _loginScreen() {
    Navigator.pop(context,
        MaterialPageRoute(builder: (BuildContext context) => LoginScreen()));
  }

  void _onChange(bool value) {
    setState(() {
      _isChecked = value;
      //savepref(value);
    });
  }

  void _showEULA() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          backgroundColor: Colors.white,
          title: new Text(
            "EULA",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: new Container(
            height: screenHeight / 2,
            child: Column(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: new SingleChildScrollView(
                    child: RichText(
                        softWrap: true,
                        textAlign: TextAlign.justify,
                        text: TextSpan(
                            style: TextStyle(
                              color: Colors.black,
                              //fontWeight: FontWeight.w500,
                              fontSize: 12.0,
                            ),
                            text:
                                "This End-User License Agreement is a legal agreement between you and madkiddo This EULA agreement governs your acquisition and use of our Second Life software (Software) directly from madkiddo or indirectly through a madkiddo authorized reseller or distributor (a Reseller).Please read this EULA agreement carefully before completing the installation process and using the Second Life software. It provides a license to use the Second Life software and contains warranty information and liability disclaimers. If you register for a free trial of the Second Life software, this EULA agreement will also govern that trial. By clicking accept or installing and/or using the Second Life software, you are confirming your acceptance of the Software and agreeing to become bound by the terms of this EULA agreement. If you are entering into this EULA agreement on behalf of a company or other legal entity, you represent that you have the authority to bind such entity and its affiliates to these terms and conditions. If you do not have such authority or if you do not agree with the terms and conditions of this EULA agreement, do not install or use the Software, and you must not accept this EULA agreement.This EULA agreement shall apply only to the Software supplied by madkiddo herewith regardless of whether other software is referred to or described herein. The terms also apply to any madkiddo updates, supplements, Internet-based services, and support services for the Software, unless other terms accompany those items on delivery. If so, those terms apply. This EULA was created by EULA Template for Second Life. madkiddo shall at all times retain ownership of the Software as originally downloaded by you and all subsequent downloads of the Software by you. The Software (and the copyright, and other intellectual property rights of whatever nature in the Software, including any modifications made thereto) are and shall remain the property of madkiddo. madkiddo reserves the right to grant licences to use the Software to third parties"
                            //children: getSpan(),
                            )),
                  ),
                )
              ],
            ),
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text(
                "Close",
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }
}

String validateName(String value) {
  String patttern = r'(^[a-zA-Z ]*$)';
  RegExp regExp = new RegExp(patttern);
  if (value.length == 0) {
    return "Name is Required";
  } else if (!regExp.hasMatch(value)) {
    return "Name must be a-z and A-Z";
  }
  return null;
}

String validateMobile(String value) {
  String patttern = r'(^[0-9]*$)';
  RegExp regExp = new RegExp(patttern);
  if (value.length == 0) {
    return "Mobile is Required";
  } else if (value.length < 10) {
    return "Mobile number must be at least 10 digits";
  } else if (!regExp.hasMatch(value)) {
    return "Mobile Number must be digits";
  }
  return null;
}

String validateEmail(String value) {
  String pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regExp = new RegExp(pattern);
  if (value.length == 0) {
    return "Email is Required";
  } else if (!regExp.hasMatch(value)) {
    return "Invalid Email";
  } else {
    return null;
  }
}

String validatePass(String value) {
  String patttern = r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{6,}$';
  RegExp regExp = new RegExp(patttern);
  if (value.length == 0) {
    return "Password is Required";
  } else if (value.length < 6) {
    return "Password must be at least 6 alphanumerics";
  } else if (!regExp.hasMatch(value)) {
    return "Password must contain at least a alphabert and a digit";
  }
  return null;
}
