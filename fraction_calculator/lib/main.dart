import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

void main() => runApp(MyApp());
int frac1no1, frac1no2, frac2no1, frac2no2, result, result2;
TextEditingController afrac1no1 = new TextEditingController();
TextEditingController afrac1no2 = new TextEditingController();
TextEditingController afrac2no1 = new TextEditingController();
TextEditingController afrac2no2 = new TextEditingController();

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String selectedOperator;
  var listOfOperators = [
    Operators(type: "+", value: 1),
    Operators(type: "-", value: 2),
    Operators(type: "*", value: 3),
    Operators(type: "/", value: 4),
  ];

  @override
  Widget build(BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode());
    return MaterialApp(
      title: 'Fraction Calculator',
      home: Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          title: Text('Fraction Calculator'),
        ),
        body: Center(
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Container(
                        width: 120,
                        child: TextField(
                          controller: afrac1no1,
                          keyboardType: TextInputType.numberWithOptions(),
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'numerator'),
                        )),
                    Container(
                        width: 120,
                        child: TextField(
                          controller: afrac2no1,
                          keyboardType: TextInputType.numberWithOptions(),
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'numerator'),
                        ))
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    //Expanded(child: Divider())
                    Text('--------------------------------  '),
                    DropdownButton(
                        value: selectedOperator,
                        onChanged: (newValue) {
                          setState(() {
                            selectedOperator = newValue;
                          });
                        },
                        hint: Text('Select'),
                        items: listOfOperators.map((data) {
                          return DropdownMenuItem(
                            value: data.value.toString(),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: Text(
                                data.type,
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          );
                        }).toList()),
                    Text('  --------------------------------')
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Container(
                        width: 120,
                        child: TextField(
                          controller: afrac1no2,
                          keyboardType: TextInputType.numberWithOptions(),
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'denominator'),
                        )),
                    Container(
                        width: 120,
                        child: TextField(
                          controller: afrac2no2,
                          keyboardType: TextInputType.numberWithOptions(),
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'denominator'),
                        ))
                  ],
                ),
                Text('', style: TextStyle(fontSize: 20)),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      RaisedButton(
                        onPressed: _calculate,
                        child: Text('Calculate'),
                      ),
                      RaisedButton(
                        onPressed: _clear,
                        child: Text('Clear'),
                      ),
                    ]),
                Text('', style: TextStyle(fontSize: 35)),
                Text('The result is :',
                    style: TextStyle(fontSize: 35, color: Colors.redAccent)),
                Text('$result',
                    style: TextStyle(fontSize: 35, color: Colors.black)),
                Text('---------------------'),
                Text('$result2',
                    style: TextStyle(fontSize: 35, color: Colors.black)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _clear() {
    setState(() {
      afrac1no1.clear();
      afrac1no2.clear();
      afrac2no1.clear();
      afrac2no2.clear();
      result = 0;
      result2 = 0;
    });
  }

  void _calculate() {
    setState(() {
      frac1no1 = int.parse(afrac1no1.text);
      frac1no2 = int.parse(afrac1no2.text);
      frac2no1 = int.parse(afrac2no1.text);
      frac2no2 = int.parse(afrac2no2.text);
      if (selectedOperator == "1") {
        if (frac1no2 == frac2no2) {
          result = frac1no1 + frac2no1;
          result2 = frac2no2;
        } else {
          result = frac1no1 * frac2no2 + frac2no1 * frac1no2;
          result2 = frac1no2 * frac2no2;
        }
      }
      if (selectedOperator == "2") {
        if (frac1no2 == frac2no2) {
          result = frac1no1 - frac2no1;
          result2 = frac2no2;
        } else {
          result = frac1no1 * frac2no2 - frac2no1 * frac1no2;
          result2 = frac1no2 * frac2no2;
        }
      }
      if (selectedOperator == "3") {
        result = frac1no1 * frac2no1;
        result2 = frac1no2 * frac2no2;
      }
      if (selectedOperator == "4") {
        result = frac1no1 * frac2no2;
        result2 = frac1no2 * frac2no1;
      }

      for (int i = abs(result); i > 0; i--) {
        if (result % i == 0 && result2 % i == 0) {
          result = result ~/ i;
          result2 = result2 ~/ i;
          break;
        }
      }
    });
  }

  int abs(int result) {
    if (result < 0) {
      result = result * -1;
      return result;
    } else
      return result;
  }
}

class Operators {
  String type;
  int value;
  Operators({this.type, this.value});
}
