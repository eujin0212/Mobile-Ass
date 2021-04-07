import 'dart:async';
import 'dart:convert';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:second_life/User.dart';
import 'package:toast/toast.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoder/geocoder.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:random_string/random_string.dart';
import 'mainscreen.dart';
import 'payment.dart';
import 'package:intl/intl.dart';

class CartScreen extends StatefulWidget {
  final User user;

  const CartScreen({Key key, this.user}) : super(key: key);

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  String server = "https://madkiddo.com/second_life";
  List cartData;
  double screenHeight, screenWidth;
  double _weight = 0.0, _totalprice = 0.0;
  Position _currentPosition;
  String curaddress;
  Completer<GoogleMapController> _controller = Completer();
  GoogleMapController gmcontroller;
  CameraPosition _home;
  MarkerId markerId1 = MarkerId("12");
  Set<Marker> markers = Set();
  double latitude, longitude;
  String label;
  CameraPosition _userpos;
  double deliverycharge;
  double amountpayable;
  String titlecenter = "Loading your cart";

  @override
  void initState() {
    super.initState();
    _getLocation();
    _loadCart();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
        appBar: AppBar(title: Text('My Cart'), actions: <Widget>[
          IconButton(
            icon: Icon(MdiIcons.deleteEmpty),
            onPressed: () {
              deleteAll();
            },
          ),
        ]),
        body: Container(
            child: Column(
          children: <Widget>[
            SizedBox(height: 10),
            cartData == null
                ? Flexible(
                    child: Container(
                        child: Center(
                            child: Text(
                    titlecenter,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold),
                  ))))
                : Expanded(
                    child: ListView.builder(
                        itemCount: cartData == null ? 1 : cartData.length + 2,
                        itemBuilder: (context, index) {
                          if (index == cartData.length) {
                            return Container(
                                height: screenHeight / 8,
                                width: screenWidth / 2.5,
                                child: InkWell(
                                  onLongPress: () => print("Delete"),
                                  child: Card(
                                    //color: Colors.yellow,
                                    elevation: 5,
                                    child: Column(
                                      children: <Widget>[
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text("Delivery to ",
                                            style: TextStyle(
                                                fontSize: 20.0,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white)),
                                        SizedBox(height: 5),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Container(
                                              width: 280,
                                              child: SingleChildScrollView(
                                                scrollDirection: Axis.horizontal,
                                                child: Text(
                                                  curaddress ??
                                                      "Address not set",
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    //fontWeight: FontWeight.bold
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 10),
                                            GestureDetector(
                                                onTap: _loadMapDialog,
                                                child: Icon(Icons.edit)),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ));
                          }

                          if (index == cartData.length + 1) {
                            return Container(
                                height: screenHeight / 3.2,
                                child: Card(
                                  elevation: 5,
                                  child: Column(
                                    children: <Widget>[
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text("Payment",
                                          style: TextStyle(
                                              fontSize: 20.0,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white)),
                                      SizedBox(height: 10),
                                      Container(
                                          padding:
                                              EdgeInsets.fromLTRB(5, 0, 5, 0),
                                          //color: Colors.red,
                                          child: Table(
                                              defaultColumnWidth:
                                                  FlexColumnWidth(1.0),
                                              columnWidths: {
                                                0: FlexColumnWidth(5),
                                                1: FlexColumnWidth(5),
                                              },
                                              //border: TableBorder.all(color: Colors.white),
                                              children: [
                                                TableRow(children: [
                                                  TableCell(
                                                    child: Container(
                                                        alignment:
                                                            Alignment.center,
                                                        height: 20,
                                                        child: Text(
                                                            "Total Item Price ",
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .white))),
                                                  ),
                                                  TableCell(
                                                    child: Container(
                                                      alignment:
                                                          Alignment.center,
                                                      height: 20,
                                                      child: Text(
                                                          "RM" +
                                                                  _totalprice
                                                                      .toStringAsFixed(
                                                                          2) ??
                                                              "0.0",
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 14,
                                                              color: Colors
                                                                  .white)),
                                                    ),
                                                  ),
                                                ]),
                                                TableRow(children: [
                                                  TableCell(
                                                    child: Container(
                                                        alignment:
                                                            Alignment.center,
                                                        height: 20,
                                                        child: Text("Weight ",
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .white))),
                                                  ),
                                                  TableCell(
                                                    child: Container(
                                                      alignment:
                                                          Alignment.center,
                                                      height: 20,
                                                      child: Text(
                                                          _weight.toStringAsFixed(
                                                                  2) +
                                                              " kg",
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 14,
                                                              color: Colors
                                                                  .white)),
                                                    ),
                                                  ),
                                                ]),
                                                TableRow(children: [
                                                  TableCell(
                                                    child: Container(
                                                        alignment:
                                                            Alignment.center,
                                                        height: 20,
                                                        child: Text(
                                                            "Delivery Charge ",
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .white))),
                                                  ),
                                                  TableCell(
                                                    child: Container(
                                                      alignment:
                                                          Alignment.center,
                                                      height: 20,
                                                      child: Text(
                                                          "RM" +
                                                                  deliverycharge
                                                                      .toStringAsFixed(
                                                                          2) ??
                                                              "0.0",
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 14,
                                                              color: Colors
                                                                  .white)),
                                                    ),
                                                  ),
                                                ]),
                                                TableRow(children: [
                                                  TableCell(
                                                    child: Container(
                                                        alignment:
                                                            Alignment.center,
                                                        height: 20,
                                                        child: Text(
                                                            "Total Amount ",
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .white))),
                                                  ),
                                                  TableCell(
                                                    child: Container(
                                                      alignment:
                                                          Alignment.center,
                                                      height: 20,
                                                      child: Text(
                                                          "RM" +
                                                                  amountpayable
                                                                      .toStringAsFixed(
                                                                          2) ??
                                                              "0.0",
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: Colors
                                                                  .white)),
                                                    ),
                                                  ),
                                                ]),
                                              ])),
                                      SizedBox(
                                        height: 3,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                              "Note : Delivery charge is calculated as RM 5.00 per kg",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.grey))
                                        ],
                                      ),
                                      SizedBox(
                                        height: 3,
                                      ),
                                      MaterialButton(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20.0)),
                                        minWidth: 200,
                                        height: 40,
                                        child: Text(
                                          'Make Payment',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        color: Colors.white,
                                        textColor: Colors.black,
                                        elevation: 10,
                                        onPressed: makePayment,
                                      ),
                                    ],
                                  ),
                                ));
                          }
                          index -= 0;

                          return Card(
                              elevation: 10,
                              child: Padding(
                                  padding: EdgeInsets.all(5),
                                  child: Row(children: <Widget>[
                                    Column(
                                      children: <Widget>[
                                        Padding(
                                            padding: EdgeInsets.all(5),
                                            child: Column(
                                              children: <Widget>[
                                                Container(
                                                  height: screenHeight / 8,
                                                  width: screenWidth / 5,
                                                  child: ClipOval(
                                                      child: CachedNetworkImage(
                                                    fit: BoxFit.scaleDown,
                                                    imageUrl: server +
                                                        "/productimage/${cartData[index]['id']}.jpg",
                                                    placeholder: (context,
                                                            url) =>
                                                        new CircularProgressIndicator(),
                                                    errorWidget: (context, url,
                                                            error) =>
                                                        new Icon(Icons.error),
                                                  )),
                                                ),
                                                SizedBox(height: 5),
                                                Text(
                                                  "RM " +
                                                      cartData[index]['price'],
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ],
                                            ))
                                      ],
                                    ),
                                    Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(10, 1, 10, 1),
                                        child: SizedBox(
                                            width: 2,
                                            child: Container(
                                              height: screenWidth / 3.5,
                                              color: Colors.grey,
                                            ))),
                                    Container(
                                        width: screenWidth / 2,
                                        //color: Colors.blue,
                                        child: Row(
                                          //crossAxisAlignment: CrossAxisAlignment.center,
                                          //mainAxisAlignment: MainAxisAlignment.center,
                                          children: <Widget>[
                                            Flexible(
                                              child: Column(
                                                children: <Widget>[
                                                  Text(
                                                    cartData[index]['name'],
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 16,
                                                        color: Colors.white),
                                                    maxLines: 1,
                                                  ),
                                                  Text(
                                                    "Available " +
                                                        cartData[index]
                                                            ['quantity'] +
                                                        " unit",
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  Text(
                                                    "Your Quantity " +
                                                        cartData[index]
                                                            ['cquantity'],
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  SizedBox(height: 5),
                                                  Container(
                                                      height: 20,
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: <Widget>[
                                                          FlatButton(
                                                            onPressed: () =>
                                                                _updateCart(
                                                                    index,
                                                                    "add"),
                                                            child: Icon(
                                                                MdiIcons.plus,
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                          Text(
                                                            cartData[index]
                                                                ['cquantity'],
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          ),
                                                          FlatButton(
                                                            onPressed: () =>
                                                                _updateCart(
                                                                    index,
                                                                    "remove"),
                                                            child: Icon(
                                                                MdiIcons.minus,
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                        ],
                                                      )),
                                                  SizedBox(height: 10),
                                                  Text(
                                                      "Total RM " +
                                                          cartData[index]
                                                              ['yourprice'],
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.white)),
                                                ],
                                              ),
                                            )
                                          ],
                                        )),
                                    Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(10, 1, 6, 1),
                                        child: SizedBox(
                                            width: 2,
                                            child: Container(
                                              height: screenWidth / 3.5,
                                              color: Colors.grey,
                                            ))),
                                    Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Container(
                                            width: screenWidth / 11,
                                            child: FlatButton(
                                              onPressed: () =>
                                                  _deleteCart(index),
                                              child: Icon(
                                                MdiIcons.delete,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ])
                                  ])));
                        })),
          ],
        )));
  }

  void _loadCart() {
    _weight = 0.0;
    _totalprice = 0.0;
    amountpayable = 0.0;
    deliverycharge = 0.0;
    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: "Updating cart");
    pr.show();
    String urlLoadJobs = server + "/php/load_cart.php";
    http.post(urlLoadJobs, body: {
      "email": widget.user.email,
    }).then((res) {
      print(res.body);
      pr.dismiss();
      if (res.body == "Cart Empty") {
        //Navigator.of(context).pop(false);
        widget.user.quantity = "0";
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => MainScreen(
                      user: widget.user,
                    )));
      }

      setState(() {
        var extractdata = json.decode(res.body);
        cartData = extractdata["cart"];
        for (int i = 0; i < cartData.length; i++) {
          _weight = double.parse(cartData[i]['weight']) *
                  int.parse(cartData[i]['cquantity']) +
              _weight;
          _totalprice = double.parse(cartData[i]['yourprice']) + _totalprice;
        }
        _weight = _weight / 1000;
        deliverycharge = _weight * 5;
        amountpayable = _totalprice + deliverycharge;
        print(_weight);
        print(_totalprice);
      });
    }).catchError((err) {
      print(err);
      pr.dismiss();
    });
    pr.dismiss();
  }

  _updateCart(int index, String op) {
    int curquantity = int.parse(cartData[index]['quantity']);
    int quantity = int.parse(cartData[index]['cquantity']);
    if (op == "add") {
      quantity++;
      if (quantity == (curquantity + 1)) {
        Toast.show("Quantity not available", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        return;
      }
    }
    if (op == "remove") {
      quantity--;
      if (quantity == 0) {
        _deleteCart(index);
        return;
      }
    }
    String urlLoadJobs = server + "/php/update_cart.php";
    http.post(urlLoadJobs, body: {
      "email": widget.user.email,
      "prodid": cartData[index]['id'],
      "quantity": quantity.toString()
    }).then((res) {
      print(res.body);
      if (res.body == "success") {
        Toast.show("Cart Updated", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        _loadCart();
      } else {
        Toast.show("Failed", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      }
    }).catchError((err) {
      print(err);
    });
  }

  _deleteCart(int index) {
    showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
        title: new Text(
          'Delete item?',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        actions: <Widget>[
          MaterialButton(
              onPressed: () {
                Navigator.of(context).pop(false);
                http.post(server + "/php/delete_cart.php", body: {
                  "email": widget.user.email,
                  "prodid": cartData[index]['id'],
                }).then((res) {
                  print(res.body);

                  if (res.body == "success") {
                    _loadCart();
                  } else {
                    Toast.show("Failed", context,
                        duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                  }
                }).catchError((err) {
                  print(err);
                });
              },
              child: Text(
                "Yes",
                style: TextStyle(
                  color: Colors.white,
                ),
              )),
          MaterialButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text(
                "Cancel",
                style: TextStyle(
                  color: Colors.white,
                ),
              )),
        ],
      ),
    );
  }

  _getLocation() async {
    final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
    _currentPosition = await geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    final coordinates =
        new Coordinates(_currentPosition.latitude, _currentPosition.longitude);
    var addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var first = addresses.first;
    setState(() {
      curaddress = first.addressLine;
      print(curaddress);
      if (curaddress != null) {
        latitude = _currentPosition.latitude;
        longitude = _currentPosition.longitude;
        return;
      }
    });
    print("${first.featureName} : ${first.addressLine}");
  }

  _getLocationfromlatlng(double lat, double lng, newSetState) async {
    final Geolocator geolocator = Geolocator()
      ..placemarkFromCoordinates(lat, lng);
    _currentPosition = await geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    //debugPrint('location: ${_currentPosition.latitude}');
    final coordinates = new Coordinates(lat, lng);
    var addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var first = addresses.first;
    newSetState(() {
      curaddress = first.addressLine;
      if (curaddress != null) {
        latitude = _currentPosition.latitude;
        longitude = _currentPosition.longitude;
        return;
      }
    });
    setState(() {
      curaddress = first.addressLine;
      if (curaddress != null) {
        latitude = _currentPosition.latitude;
        longitude = _currentPosition.longitude;
        return;
      }
    });

    print("${first.featureName} : ${first.addressLine}");
  }

  _loadMapDialog() {
    try {
      if (_currentPosition.latitude == null) {
        Toast.show("Location not available. Please wait", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        _getLocation(); //_getCurrentLocation();
        return;
      }
      _controller = Completer();
      _userpos = CameraPosition(
        target: LatLng(latitude, longitude),
        zoom: 14.4746,
      );

      markers.add(Marker(
          markerId: markerId1,
          position: LatLng(latitude, longitude),
          infoWindow: InfoWindow(
            title: 'Current Location',
            snippet: 'Delivery Location',
          )));

      showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, newSetState) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20.0))),
                title: Text(
                  "Select New Delivery Location",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                titlePadding: EdgeInsets.all(5),
                //content: Text(curaddress),
                actions: <Widget>[
                  Text(
                    curaddress,
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  Container(
                    height: screenHeight / 2 ?? 600,
                    width: screenWidth ?? 360,
                    child: GoogleMap(
                        mapType: MapType.normal,
                        initialCameraPosition: _userpos,
                        markers: markers.toSet(),
                        onMapCreated: (controller) {
                          _controller.complete(controller);
                        },
                        onTap: (newLatLng) {
                          _loadLoc(newLatLng, newSetState);
                        }),
                  ),
                  MaterialButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0)),
                    //minWidth: 200,
                    height: 30,
                    child: Text('Close'),
                    color: Colors.white,
                    textColor: Colors.black,
                    elevation: 10,
                    onPressed: () =>
                        {markers.clear(), Navigator.of(context).pop(false)},
                  ),
                ],
              );
            },
          );
        },
      );
    } catch (e) {
      print(e);
      return;
    }
  }

  void _loadLoc(LatLng loc, newSetState) async {
    newSetState(() {
      print("insetstate");
      markers.clear();
      latitude = loc.latitude;
      longitude = loc.longitude;
      _getLocationfromlatlng(latitude, longitude, newSetState);
      _home = CameraPosition(
        target: loc,
        zoom: 14,
      );
      markers.add(Marker(
          markerId: markerId1,
          position: LatLng(latitude, longitude),
          infoWindow: InfoWindow(
            title: 'New Location',
            snippet: 'New Delivery Location',
          )));
    });
    _userpos = CameraPosition(
      target: LatLng(latitude, longitude),
      zoom: 14.4746,
    );
    _newhomeLocation();
  }

  Future<void> _newhomeLocation() async {
    gmcontroller = await _controller.future;
    gmcontroller.animateCamera(CameraUpdate.newCameraPosition(_home));
    //Navigator.of(context).pop(false);
    //_loadMapDialog();
  }

  Future<void> makePayment() async {
    var now = new DateTime.now();
    var formatter = new DateFormat('ddMMyyyy');
    String orderid = formatter.format(now) + randomNumeric(6);
    print(orderid);
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => PaymentScreen(
                  user: widget.user,
                  val: amountpayable.toStringAsFixed(2),
                  orderid: orderid,
                  address: curaddress,
                )));
    _loadCart();
  }

  void deleteAll() {
    showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
        title: new Text(
          'Delete all items?',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        actions: <Widget>[
          MaterialButton(
              onPressed: () {
                Navigator.of(context).pop(false);
                http.post(server + "/php/delete_cart.php", body: {
                  "email": widget.user.email,
                }).then((res) {
                  print(res.body);

                  if (res.body == "success") {
                    _loadCart();
                  } else {
                    Toast.show("Failed", context,
                        duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                  }
                }).catchError((err) {
                  print(err);
                });
              },
              child: Text(
                "Yes",
                style: TextStyle(
                  color: Colors.white,
                ),
              )),
          MaterialButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text(
                "Cancel",
                style: TextStyle(
                  color: Colors.white,
                ),
              )),
        ],
      ),
    );
  }
}
