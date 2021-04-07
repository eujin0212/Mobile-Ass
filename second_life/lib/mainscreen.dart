import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:progress_dialog/progress_dialog.dart';
import 'package:second_life/User.dart';
import 'package:second_life/custorderscreen.dart';
import 'package:second_life/paymenthistoryscreen.dart';
import 'package:second_life/product.dart';
import 'package:second_life/productdetail.dart';
import 'package:second_life/sellingscreen.dart';
import 'package:toast/toast.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'cartscreen.dart';
import 'profilescreen.dart';

class MainScreen extends StatefulWidget {
  final User user;

  const MainScreen({Key key, this.user}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  GlobalKey<RefreshIndicatorState> refreshKey;
  List productdata;
  int curnumber = 1;
  double screenHeight, screenWidth;
  bool _visible = false;
  String curtype = "All";
  String cartquantity = "0";
  int quantity = 1;
  String titlecenter = "Loading products";
  String server = "https://madkiddo.com/second_life";

  @override
  void initState() {
    super.initState();
    _loadData();
    _loadCartQuantity();
    refreshKey = GlobalKey<RefreshIndicatorState>();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    TextEditingController _prdController = new TextEditingController();
    return WillPopScope(
        onWillPop: _onBackPressed,
        child: Scaffold(
          drawer: mainDrawer(context),
          appBar: AppBar(
            title: Text(
              'Products List',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            actions: <Widget>[
              IconButton(
                icon: _visible
                    ? new Icon(Icons.expand_more)
                    : new Icon(Icons.expand_less),
                onPressed: () {
                  setState(() {
                    if (_visible) {
                      _visible = false;
                    } else {
                      _visible = true;
                    }
                  });
                },
              ),

              //
            ],
          ),
          body: RefreshIndicator(
            key: refreshKey,
            color: Colors.white,
            onRefresh: () async {
              await refreshList();
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Visibility(
                  visible: _visible,
                  child: Card(
                      elevation: 10,
                      child: Padding(
                          padding: EdgeInsets.all(5),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: <Widget>[
                                Column(
                                  children: <Widget>[
                                    FlatButton(
                                        onPressed: () => _sortItem("All"),
                                        color: Colors.white,
                                        padding: EdgeInsets.all(10.0),
                                        child: Column(
                                          // Replace with a Row for horizontal icon + text
                                          children: <Widget>[
                                            Icon(MdiIcons.update,
                                                color: Colors.black),
                                            Text(
                                              "All",
                                              style: TextStyle(
                                                  color: Colors.black),
                                            )
                                          ],
                                        )),
                                  ],
                                ),
                                SizedBox(
                                  width: 3,
                                ),
                                Column(
                                  children: <Widget>[
                                    FlatButton(
                                        onPressed: () =>
                                            _sortItem("Appearance"),
                                        color: Colors.white,
                                        padding: EdgeInsets.all(10.0),
                                        child: Column(
                                          // Replace with a Row for horizontal icon + text
                                          children: <Widget>[
                                            Icon(
                                              MdiIcons.glasses,
                                              color: Colors.black,
                                            ),
                                            Text(
                                              "Appearance",
                                              style: TextStyle(
                                                  color: Colors.black),
                                            )
                                          ],
                                        )),
                                  ],
                                ),
                                SizedBox(
                                  width: 3,
                                ),
                                Column(
                                  children: <Widget>[
                                    FlatButton(
                                        onPressed: () => _sortItem("Digital"),
                                        color: Colors.white,
                                        padding: EdgeInsets.all(10.0),
                                        child: Column(
                                          // Replace with a Row for horizontal icon + text
                                          children: <Widget>[
                                            Icon(
                                              MdiIcons.phone,
                                              color: Colors.black,
                                            ),
                                            Text(
                                              "Digital",
                                              style: TextStyle(
                                                  color: Colors.black),
                                            )
                                          ],
                                        )),
                                  ],
                                ),
                                SizedBox(
                                  width: 3,
                                ),
                                Column(
                                  children: <Widget>[
                                    FlatButton(
                                        onPressed: () => _sortItem("Education"),
                                        color: Colors.white,
                                        padding: EdgeInsets.all(10.0),
                                        child: Column(
                                          // Replace with a Row for horizontal icon + text
                                          children: <Widget>[
                                            Icon(
                                              MdiIcons.book,
                                              color: Colors.black,
                                            ),
                                            Text(
                                              "Education",
                                              style: TextStyle(
                                                  color: Colors.black),
                                            )
                                          ],
                                        )),
                                  ],
                                ),
                                SizedBox(
                                  width: 3,
                                ),
                                Column(
                                  children: <Widget>[
                                    FlatButton(
                                        onPressed: () =>
                                            _sortItem("Electronic"),
                                        color: Colors.white,
                                        padding: EdgeInsets.all(10.0),
                                        child: Column(
                                          // Replace with a Row for horizontal icon + text
                                          children: <Widget>[
                                            Icon(
                                              MdiIcons.remote,
                                              color: Colors.black,
                                            ),
                                            Text(
                                              "Electronic",
                                              style: TextStyle(
                                                  color: Colors.black),
                                            )
                                          ],
                                        )),
                                  ],
                                ),
                                SizedBox(
                                  width: 3,
                                ),
                                Column(
                                  children: <Widget>[
                                    FlatButton(
                                        onPressed: () =>
                                            _sortItem("Entertainment"),
                                        color: Colors.white,
                                        padding: EdgeInsets.all(10.0),
                                        child: Column(
                                          // Replace with a Row for horizontal icon + text
                                          children: <Widget>[
                                            Icon(
                                              MdiIcons.gamepad,
                                              color: Colors.black,
                                            ),
                                            Text(
                                              "Entertainment",
                                              style: TextStyle(
                                                  color: Colors.black),
                                            )
                                          ],
                                        )),
                                  ],
                                ),
                                SizedBox(
                                  width: 3,
                                ),
                                Column(
                                  children: <Widget>[
                                    FlatButton(
                                        onPressed: () => _sortItem("Household"),
                                        color: Colors.white,
                                        padding: EdgeInsets.all(10.0),
                                        child: Column(
                                          // Replace with a Row for horizontal icon + text
                                          children: <Widget>[
                                            Icon(
                                              MdiIcons.homeAutomation,
                                              color: Colors.black,
                                            ),
                                            Text(
                                              "Household",
                                              style: TextStyle(
                                                  color: Colors.black),
                                            )
                                          ],
                                        )),
                                  ],
                                ),
                                SizedBox(
                                  width: 3,
                                ),
                                Column(
                                  children: <Widget>[
                                    FlatButton(
                                        onPressed: () => _sortItem("Other"),
                                        color: Colors.white,
                                        padding: EdgeInsets.all(10.0),
                                        child: Column(
                                          // Replace with a Row for horizontal icon + text
                                          children: <Widget>[
                                            Icon(
                                              MdiIcons.ornament,
                                              color: Colors.black,
                                            ),
                                            Text(
                                              "Others",
                                              style: TextStyle(
                                                  color: Colors.black),
                                            )
                                          ],
                                        )),
                                  ],
                                ),
                              ],
                            ),
                          ))),
                ),
                Visibility(
                    visible: _visible,
                    child: Card(
                      elevation: 5,
                      child: Container(
                        height: screenHeight / 12.5,
                        margin: EdgeInsets.fromLTRB(20, 2, 20, 2),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Flexible(
                                child: Container(
                              height: 30,
                              child: TextField(
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                  autofocus: false,
                                  controller: _prdController,
                                  decoration: InputDecoration(
                                      icon: Icon(Icons.search),
                                      border: OutlineInputBorder())),
                            )),
                            Flexible(
                                child: MaterialButton(
                                    color: Colors.white,
                                    onPressed: () =>
                                        _sortItembyName(_prdController.text),
                                    elevation: 5,
                                    child: Text(
                                      "Search Product",
                                      style: TextStyle(color: Colors.black),
                                    )))
                          ],
                        ),
                      ),
                    )),
                SizedBox(height: 10),
                productdata == null
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
                        child: GridView.count(
                            crossAxisCount: 2,
                            childAspectRatio:
                                (screenWidth / screenHeight) / 0.7,
                            children:
                                List.generate(productdata.length, (index) {
                              return Container(
                                  child: InkWell(
                                      onTap: () => {
                                            Navigator.of(context).pop(false),
                                            onProductDetail(index),
                                          },
                                      child: Card(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15.0),
                                          ),
                                          elevation: 10,
                                          child: Padding(
                                            padding: EdgeInsets.all(5),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: <Widget>[
                                                Container(
                                                  height: screenHeight / 5.7,
                                                  width: screenWidth / 3.3,
                                                  child: ClipOval(
                                                      child: CachedNetworkImage(
                                                    fit: BoxFit.fill,
                                                    imageUrl: server +
                                                        "/productimage/${productdata[index]['id']}.jpg",
                                                    placeholder: (context,
                                                            url) =>
                                                        new CircularProgressIndicator(),
                                                    errorWidget: (context, url,
                                                            error) =>
                                                        new Icon(Icons.error),
                                                  )),
                                                ),
                                                SizedBox(height: 10),
                                                Text(productdata[index]['name'],
                                                    maxLines: 1,
                                                    style: TextStyle(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.white)),
                                                Text(
                                                  "RM " +
                                                      productdata[index]
                                                          ['price'],
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white),
                                                ),
                                                Text(
                                                  productdata[index]['type'],
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white),
                                                ),
                                              ],
                                            ),
                                          ))));
                            })))
              ],
            ),
          ),
        ));
  }

  void _loadData() async {
    String urlLoadJobs = server + "/php/load_products.php";
    await http.post(urlLoadJobs, body: {}).then((res) {
      if (res.body == "nodata") {
        cartquantity = "0";
        titlecenter = "No product found";
        setState(() {
          productdata = null;
        });
      } else {
        setState(() {
          print(res.body);
          var extractdata = json.decode(res.body);
          productdata = extractdata["products"];
          cartquantity = widget.user.quantity;
        });
      }
    }).catchError((err) {
      print(err);
    });
  }

  void _loadCartQuantity() async {
    String urlLoadJobs = server + "/php/load_cartquantity.php";
    await http.post(urlLoadJobs, body: {
      "email": widget.user.email,
    }).then((res) {
      if (res.body == "nodata") {
      } else {
        widget.user.quantity = res.body;
      }
    }).catchError((err) {
      print(err);
    });
  }

  Widget mainDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text(widget.user.name),
            accountEmail: Text(widget.user.email),
            currentAccountPicture: CircleAvatar(
              backgroundColor:
                  Theme.of(context).platform == TargetPlatform.android
                      ? Colors.white
                      : Colors.white,
              child: Text(
                widget.user.name.toString().substring(0, 1).toUpperCase(),
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 40.0,
                    fontWeight: FontWeight.bold),
              ),
              backgroundImage: NetworkImage(
                  server + "/profileimages/${widget.user.email}.jpg?"),
            ),
            onDetailsPressed: () => {
              Navigator.pop(context),
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => ProfileScreen(
                            user: widget.user,
                          )))
            },
          ),
          ListTile(
              title: Text(
                "Product List",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              leading: Icon(MdiIcons.seal),
              onTap: () => {
                    Navigator.pop(context),
                    _loadData(),
                  }),
          ListTile(
              title: Text(
                "Shopping Cart",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              leading: Icon(MdiIcons.basketOutline),
              onTap: () => {
                    Navigator.pop(context),
                    gotoCart(),
                  }),
          ListTile(
              title: Text(
                "Payment History",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              leading: Icon(Icons.list),
              onTap: () => {
                    Navigator.pop(context),
                    gotoPurchaseHistory(),
                  }),
          Divider(
            height: 2,
            color: Colors.white,
          ),
          ListTile(
              title: Text(
                "My Products",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              leading: Icon(MdiIcons.cashUsd),
              onTap: () => {
                    Navigator.pop(context),
                    gotoSelling(),
                  }),
          ListTile(
              title: Text(
                "Customer Orders",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              leading: Icon(MdiIcons.truckDelivery),
              onTap: () => {
                    Navigator.pop(context),
                    gotoSellingHistory(),
                  }),
        ],
      ),
    );
  }

  onProductDetail(int index) async {
    print(productdata[index]['name']);
    Product _product = new Product(
      name: productdata[index]['name'],
      pid: productdata[index]['id'],
      price: productdata[index]['price'],
      quantity: productdata[index]['quantity'],
      weigth: productdata[index]['weigth'],
      type: productdata[index]['type'],
      date: productdata[index]['date'],
      description: productdata[index]['description'],
      location: productdata[index]['location'],
      email: productdata[index]['email'],
    );
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) =>
                ProductDetail(user: widget.user, product: _product)));
  }

  void _sortItem(String type) {
    try {
      ProgressDialog pr = new ProgressDialog(context,
          type: ProgressDialogType.Normal, isDismissible: true);
      pr.style(message: "Searching");
      pr.show();
      String urlLoadJobs = server + "/php/load_products.php";
      http.post(urlLoadJobs, body: {
        "type": type,
      }).then((res) {
        if (res.body == "nodata") {
          setState(() {
            productdata = null;
            curtype = type;
            titlecenter = "No product found";
          });
          pr.dismiss();
        } else {
          setState(() {
            curtype = type;
            var extractdata = json.decode(res.body);
            productdata = extractdata["products"];
            FocusScope.of(context).requestFocus(new FocusNode());
            pr.dismiss();
          });
        }
      }).catchError((err) {
        print(err);
        pr.dismiss();
      });
      pr.dismiss();
    } catch (e) {
      Toast.show("Error", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }
  }

  void _sortItembyName(String prname) {
    try {
      print(prname);
      ProgressDialog pr = new ProgressDialog(context,
          type: ProgressDialogType.Normal, isDismissible: true);
      pr.style(message: "Searching");
      pr.show();
      String urlLoadJobs = server + "/php/load_products.php";
      http
          .post(urlLoadJobs, body: {
            "name": prname.toString(),
          })
          .timeout(const Duration(seconds: 4))
          .then((res) {
            if (res.body == "nodata") {
              Toast.show("Product not found", context,
                  duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
              pr.dismiss();
              setState(() {
                titlecenter = "No product found";
                curtype = "search for " + "'" + prname + "'";
                productdata = null;
              });
              FocusScope.of(context).requestFocus(new FocusNode());

              return;
            } else {
              setState(() {
                var extractdata = json.decode(res.body);
                productdata = extractdata["products"];
                FocusScope.of(context).requestFocus(new FocusNode());
                //curtype = prname;
                curtype = "search for " + "'" + prname + "'";
                pr.dismiss();
              });
            }
          })
          .catchError((err) {
            pr.dismiss();
          });
      pr.dismiss();
    } on TimeoutException catch (_) {
      Toast.show("Time out", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    } on SocketException catch (_) {
      Toast.show("Time out", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    } catch (e) {
      Toast.show("Error", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }
  }

  gotoCart() async {
    if (widget.user.name == "unregistered") {
      Toast.show("Please sign in to use this function", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    } else if (widget.user.quantity == "0") {
      Toast.show("Cart empty", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    } else {
      await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => CartScreen(
                    user: widget.user,
                  )));
      _loadData();
      _loadCartQuantity();
    }
  }

  gotoPurchaseHistory() async {
    if (widget.user.name == "unregistered") {
      Toast.show("Please sign in to use this function", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    } else {
      await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => PaymentHistoryScreen(
                    user: widget.user,
                  )));
    }
  }

  gotoSelling() async {
    if (widget.user.name == "unregistered") {
      Toast.show("Please sign in to use this function", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    } else {
      await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => SellingScreen(
                    user: widget.user,
                  )));
    }
  }

  gotoSellingHistory() async {
    if (widget.user.name == "unregistered") {
      Toast.show("Please sign in to use this function", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    } else {
      await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => CustOrderScreen(
                    user: widget.user,
                  )));
    }
  }

  Future<Null> refreshList() async {
    await Future.delayed(Duration(seconds: 2));
    _loadData();
    return null;
  }

  Future<bool> _onBackPressed() {
    return showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            title: new Text(
              'Are you sure?',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            content: new Text(
              'Do you want to exit an App',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            actions: <Widget>[
              MaterialButton(
                  onPressed: () {
                    SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                  },
                  child: Text(
                    "Exit",
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
        ) ??
        false;
  }
}
