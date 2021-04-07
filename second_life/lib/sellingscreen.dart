import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:progress_dialog/progress_dialog.dart';
import 'package:second_life/User.dart';
import 'package:second_life/editproduct.dart';
import 'package:second_life/newproduct.dart';
import 'package:second_life/product.dart';
import 'package:toast/toast.dart';
import 'package:cached_network_image/cached_network_image.dart';

class SellingScreen extends StatefulWidget {
  final User user;

  const SellingScreen({Key key, this.user}) : super(key: key);

  @override
  _SellingScreenState createState() => _SellingScreenState();
}

class _SellingScreenState extends State<SellingScreen> {
  List productdata;
  int curnumber = 1;
  double screenHeight, screenWidth;
  int quantity = 1;
  String titlecenter = "Loading products";
  var _tapPosition;
  String server = "https://madkiddo.com/second_life";
  String scanPrId;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Manage Your Products',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 10,
            ),
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
                                  onTap: () => _showPopupMenu(index),
                                  onTapDown: _storePosition,
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
                                                  placeholder: (context, url) =>
                                                      new CircularProgressIndicator(),
                                                  errorWidget:
                                                      (context, url, error) =>
                                                          new Icon(Icons.error),
                                                ),
                                              ),
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
                                                ),Text("Quantity: "+
                                                  productdata[index]
                                                      ['quantity'],
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
      floatingActionButton: FloatingActionButton(
        onPressed:createNewProduct,
        child: Icon(Icons.add),
        backgroundColor: Colors.white,
      ),
    );
  }

  void _loadData() {
    try {
      ProgressDialog pr = new ProgressDialog(context,
          type: ProgressDialogType.Normal, isDismissible: true);
      String urlLoadJobs = server + "/php/load_products.php";
      http.post(urlLoadJobs, body: {
        "email": widget.user.email,
      }).then((res) {
        if (res.body == "nodata") {
          setState(() {
            titlecenter = "No product found";
            productdata = null;
          });
          pr.dismiss();
          return;
        } else {
          setState(() {
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

  _onProductDetail(int index) async {
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
                EditProduct(user: widget.user, product: _product)));
    _loadData();
  }

  _showPopupMenu(int index) async {
    final RenderBox overlay = Overlay.of(context).context.findRenderObject();

    await showMenu(
      context: context,
      color: Colors.white,
      position: RelativeRect.fromRect(
          _tapPosition & Size(40, 40), // smaller rect, the touch area
          Offset.zero & overlay.size // Bigger rect, the entire screen
          ),
      items: [
        //onLongPress: () => _showPopupMenu(), //onLongTapCard(index),

        PopupMenuItem(
          child: GestureDetector(
              onTap: () =>
                  {Navigator.of(context).pop(), _onProductDetail(index)},
              child: Text(
                "Edit product",
                style: TextStyle(
                  color: Colors.black,
                ),
              )),
        ),
        PopupMenuItem(
          child: GestureDetector(
              onTap: () =>
                  {Navigator.of(context).pop(), _deleteProductDialog(index)},
              child: Text(
                "Delete",
                style: TextStyle(color: Colors.black),
              )),
        ),
      ],
      elevation: 8.0,
    );
  }

  void _storePosition(TapDownDetails details) {
    _tapPosition = details.globalPosition;
  }

  void _deleteProductDialog(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: new Text(
            "Delete " + productdata[index]['name'],
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          content:
              new Text("Are you sure?", style: TextStyle(color: Colors.white)),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text(
                "Yes",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                _deleteProduct(index);
              },
            ),
            new FlatButton(
              child: new Text(
                "No",
                style: TextStyle(
                  color: Colors.white,
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

  void _deleteProduct(int index) {
    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: "Deleting product");
    pr.show();
    print(productdata[index]['id']);
    http.post(server + "/php/delete_product.php", body: {
      "prodid": productdata[index]['id'],
    }).then((res) {
      print(res.body);
      pr.dismiss();
      if (res.body == "success") {
        Toast.show("Delete success", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        _loadData();
        Navigator.of(context).pop();
      } else {
        Toast.show("Delete failed", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      }
    }).catchError((err) {
      print(err);
      pr.dismiss();
    });
  }

  Future<void> createNewProduct() async {
    await Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) => NewProduct(user: widget.user,)));
    _loadData();
  }
}