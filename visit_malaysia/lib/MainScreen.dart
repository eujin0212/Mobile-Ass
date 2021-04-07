import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:progress_dialog/progress_dialog.dart';
import 'package:toast/toast.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:visit_malaysia/LocationScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:visit_malaysia/State.dart';
import 'Location.dart';

class MainScreen extends StatefulWidget {
  final PrefState prefState;

  const MainScreen({Key key, this.prefState}) : super(key: key);
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List destinationdata;
  int curnumber = 1;
  double screenHeight, screenWidth;
  String dropdownValue;
  SharedPreferences prefs;
  final _key = 'cur_r';

  @override
  void initState() {
    super.initState();
    print(widget.prefState.state);
    _read(); // read in initState
    _sortState(widget.prefState.state);
    print(dropdownValue);
  }

  _read() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      dropdownValue = prefs.getString(_key) ?? "one"; // get the value
    });
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.grey,
            title: Text(
              'MALAYSIATRACTIONS',
              style: TextStyle(color: Colors.black),
            ),
            actions: <Widget>[
              DropdownButton<String>(
                value: dropdownValue,
                onChanged: (String newValue) {
                  setState(() {
                    dropdownValue = newValue;
                    _sortState(dropdownValue);
                  });
                  prefs.setString(
                      _key, dropdownValue); // save value to SharedPreference
                },
                items: [
                  "Kedah",
                  "Johor",
                  "Kelantan",
                  "Perak",
                  "Negeri Sembilan",
                  "Pahang",
                  "Perlis",
                  "Penang",
                  "Terengganu",
                  "Sabah",
                  "Sarawak",
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ],
          ),
          body: Container(
            child: Column(
              children: <Widget>[
                destinationdata == null
                    ? Flexible(
                        child: Container(
                            child: Center(
                                child: Text(
                        " ",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold),
                      ))))
                    : Expanded(
                        child: GridView.count(
                            crossAxisCount: 2,
                            childAspectRatio: 0.9,
                            children:
                                List.generate(destinationdata.length, (index) {
                              return Container(
                                  child: GestureDetector(
                                onTap: () => _onLocationDetail(index),
                                child: Card(
                                  color: Colors.grey,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Container(
                                        padding: EdgeInsets.all(5),
                                        height: screenHeight / 4.9,
                                        width: screenWidth / 2.6,
                                        child: CachedNetworkImage(
                                          fit: BoxFit.cover,
                                          imageUrl:
                                              "http://slumberjer.com/visitmalaysia/images/${destinationdata[index]['imagename']}",
                                          placeholder: (context, url) =>
                                              new CircularProgressIndicator(),
                                          errorWidget: (context, url, error) =>
                                              new Icon(Icons.error),
                                        ),
                                      ),
                                      SizedBox(height: 5),
                                      Text(destinationdata[index]['loc_name'],
                                          textAlign: TextAlign.center,
                                          maxLines: 2,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                              color: Colors.black)),
                                      Text(
                                        destinationdata[index]['state'],
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                            color: Colors.black),
                                      ),
                                    ],
                                  ),
                                ),
                              ));
                            })))
              ],
            ),
          ),
        ));
  }

  void _sortState(String state) {
    try {
      ProgressDialog pr = new ProgressDialog(context,
          type: ProgressDialogType.Normal, isDismissible: true);
      pr.style(message: "Searching...");
      pr.show();
      String urlLoadJobs =
          "http://slumberjer.com/visitmalaysia/load_destinations.php";
      http.post(urlLoadJobs, body: {
        "state": state,
      }).then((res) {
        setState(() {
          var extractdata = json.decode(res.body);
          destinationdata = extractdata["locations"];
          FocusScope.of(context).requestFocus(new FocusNode());
          pr.hide();
        });
      }).catchError((err) {
        Toast.show("No Location in " + dropdownValue, context,
            duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
        destinationdata = null;
        print(err);
        pr.hide();
      });
      pr.hide();
    } catch (e) {
      Toast.show("Error", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }
  }

  _onLocationDetail(int index) async {
    print(destinationdata[index]['loc_name']);
    Location location = new Location(
        id: destinationdata[index]['id'],
        name: destinationdata[index]['loc_name'],
        state: destinationdata[index]['state'],
        description: destinationdata[index]['description'],
        url: destinationdata[index]['url'],
        address: destinationdata[index]['address'],
        latitude: destinationdata[index]['latitude'],
        longitude: destinationdata[index]['longitude'],
        phone: destinationdata[index]['contact'],
        image: destinationdata[index]['imagename']);
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => LocationScreen(
                  location: location,
                )));
  }
}
