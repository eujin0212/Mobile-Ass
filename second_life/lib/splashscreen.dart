import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'User.dart';
import 'mainscreen.dart';
import 'package:toast/toast.dart';

void main() => runApp(SplashScreen());

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double screenHeight;
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        accentColor: Colors.white,
        brightness: Brightness.dark,
        textTheme: GoogleFonts.anaheimTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      title: 'SECOND LIFE',
      home: Scaffold(
          body: Center(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'assets/images/b.png',
                width: 250,
                height: 250,
              ),
              SizedBox(
                height: 40,
              ),
              new ProgressIndicator(),
            ],
          ),
        ),
      )),
    );
  }
}

class ProgressIndicator extends StatefulWidget {
  @override
  _ProgressIndicatorState createState() => new _ProgressIndicatorState();
}

class _ProgressIndicatorState extends State<ProgressIndicator>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> animation;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    animation = Tween(begin: 0.0, end: 1.0).animate(controller)
      ..addListener(() {
        setState(() {
          //updating states
          if (animation.value > 0.99) {
            controller.stop();
            loadpref(this.context);

            // Navigator.push(
            //     context,
            //     MaterialPageRoute(
            //         builder: (BuildContext context) => LoginScreen()));
          }
        });
      });
    controller.repeat();
  }

  @override
  void dispose() {
    controller.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Center(
        child: new Container(
      width: 250,
      child: LinearProgressIndicator(
        value: animation.value,
        //backgroundColor: Colors.brown,
        valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
      ),
    ));
  }

  void loadpref(BuildContext ctx) async {
    print('Inside loadpref()');

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = (prefs.getString('email') ?? '');
    String pass = (prefs.getString('pass') ?? '');
    print("Splash:Preference" + email + "/" + pass);
    if (email.length > 5) {
      loginUser(email, pass, ctx);
    } else {
      loginUser("unregistered@grocery.com", "123456789", ctx);
    }
  }

  void loginUser(String email, String pass, BuildContext ctx) {
    http.post("https://madkiddo.com/second_life/php/login_user.php", body: {
      "email": email,
      "password": pass,
    }).then((res) {
      print(res.body);
      var string = res.body;
      List userdata = string.split(",");
      if (userdata[0] == "success") {
        User _user = new User(
            name: userdata[1],
            email: email,
            password: pass,
            phone: userdata[3],
            datereg: userdata[4],
            quantity: userdata[5]);
            if(userdata[1] == "unregistered"){
              Toast.show(
            "Fail to login with stored credential. Login as unregistered account.",
            context,
            duration: Toast.LENGTH_LONG,
            gravity: Toast.BOTTOM);
            }else{
              Toast.show(
            "Weclome back " + userdata[1],
            context,
            duration: Toast.LENGTH_LONG,
            gravity: Toast.BOTTOM);
            }
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => MainScreen(
                      user: _user,
                    )));
      } else {
        
        loginUser("unregistered@grocery.com", "123456789", ctx);
        print(res.body);
      }
    }).catchError((err) {
      print(err);
    });
  }
}
