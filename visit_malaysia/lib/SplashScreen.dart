import 'package:flutter/material.dart';
import 'package:visit_malaysia/MainScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:visit_malaysia/State.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

String dropdownValue;
SharedPreferences prefs;
final _key = 'cur_r';

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(width: 10),
                  Image.asset(
                    'assets/images/splashscreen.png',
                    width: 300,
                    height: 150,
                  ),
                ],
              ),
              Text(
                "MALAYSIATRACTIONS",
                style: TextStyle(
                    fontSize: 31,
                    color: Colors.grey,
                    fontWeight: FontWeight.w900),
              ),
              SizedBox(height: 50),
              new ProgressIndicator(),
            ],
          ),
        ),
      ),
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
          _read();
          if (animation.value > 0.99) {
            controller.stop();
            _passPrefState(dropdownValue);
            
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
      child: CircularProgressIndicator(
        value: animation.value,
        valueColor: new AlwaysStoppedAnimation<Color>(Colors.grey),
      ),
    ));
  }

  _passPrefState(String pass) async {
    print(pass);
    PrefState prefState = new PrefState(
      state: pass,
    );
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => MainScreen(
                  prefState: prefState,
                )));
  }

  _read() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      dropdownValue = prefs.getString(_key) ?? "one"; // get the value
    });
  }
}
