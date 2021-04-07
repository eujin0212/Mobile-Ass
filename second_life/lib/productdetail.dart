import 'package:flutter/material.dart';
import 'package:second_life/User.dart';
import 'package:second_life/mainscreen.dart';
import 'package:second_life/product.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:toast/toast.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:http/http.dart' as http;

class ProductDetail extends StatefulWidget {
  final User user;
  final Product product;

  const ProductDetail({Key key, this.user, this.product}) : super(key: key);

  @override
  _ProductDetailState createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  int curnumber = 1;
  double screenHeight, screenWidth;
  String cartquantity = "0";
  int quantity = 1;
  String server = "https://madkiddo.com/second_life";

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) =>
                        MainScreen(user: widget.user)))),
        title: Text(widget.product.name),
      ),
      body: Padding(
        padding: EdgeInsets.all(5),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: <Widget>[
              Container(
                height: screenHeight / 2,
                width: screenWidth,
                child: CachedNetworkImage(
                  fit: BoxFit.fill,
                  imageUrl: server + "/productimage/${widget.product.pid}.jpg",
                  placeholder: (context, url) =>
                      new CircularProgressIndicator(),
                  errorWidget: (context, url, error) => new Icon(Icons.error),
                ),
              ),
              Container(
                height: screenHeight / 2.1,
                width: screenWidth,
                child: Padding(
                    padding: EdgeInsets.all(10),
                    child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Column(
                          children: <Widget>[
                            Table(
                                border: TableBorder.all(
                                  color: Colors.white,
                                ),
                                columnWidths: {
                                  0: FlexColumnWidth(3),
                                  1: FlexColumnWidth(7),
                                },
                                children: [
                                  TableRow(children: [
                                    TableCell(
                                      child: Container(
                                        alignment: Alignment.center,
                                        height: 100,
                                        child: Text("Description",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            )),
                                      ),
                                    ),
                                    TableCell(
                                      child: Container(
                                          alignment: Alignment.center,
                                          height: 100,
                                          child: SingleChildScrollView(
                                            scrollDirection: Axis.vertical,
                                            child: Padding(
                                              padding: EdgeInsets.all(10),
                                              child: Text(
                                                  widget.product.description,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                  )),
                                            ),
                                          )),
                                    ),
                                  ]),
                                  TableRow(children: [
                                    TableCell(
                                      child: Container(
                                          alignment: Alignment.center,
                                          height: 40,
                                          child: Text("Price",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ))),
                                    ),
                                    TableCell(
                                        child: Container(
                                      height: 40,
                                      child: Container(
                                          alignment: Alignment.center,
                                          height: 40,
                                          child: Padding(
                                            padding: EdgeInsets.all(4),
                                            child: SingleChildScrollView(
                                              scrollDirection: Axis.horizontal,
                                              child: Text(
                                                "RM " + widget.product.price,
                                                maxLines: 1,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          )),
                                    )),
                                  ]),
                                  TableRow(children: [
                                    TableCell(
                                      child: Container(
                                          alignment: Alignment.center,
                                          height: 40,
                                          child: Text("Quantity",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ))),
                                    ),
                                    TableCell(
                                        child: Container(
                                      height: 40,
                                      child: Container(
                                          alignment: Alignment.center,
                                          height: 40,
                                          child: Padding(
                                            padding: EdgeInsets.all(4),
                                            child: SingleChildScrollView(
                                              scrollDirection: Axis.horizontal,
                                              child: Text(
                                                widget.product.quantity +
                                                    " unit(s)",
                                                maxLines: 1,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          )),
                                    )),
                                  ]),
                                  TableRow(children: [
                                    TableCell(
                                      child: Container(
                                          alignment: Alignment.center,
                                          height: 40,
                                          child: Text("Weigth",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ))),
                                    ),
                                    TableCell(
                                        child: Container(
                                      alignment: Alignment.center,
                                      height: 40,
                                      child: Padding(
                                        padding: EdgeInsets.all(4),
                                        child: Text(
                                          widget.product.weigth + " grams",
                                          maxLines: 1,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    )),
                                  ]),
                                  TableRow(children: [
                                    TableCell(
                                      child: Container(
                                          alignment: Alignment.center,
                                          height: 40,
                                          child: Text("Shipped From",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ))),
                                    ),
                                    TableCell(
                                        child: Container(
                                      height: 40,
                                      child: Container(
                                          alignment: Alignment.center,
                                          height: 40,
                                          child: Padding(
                                            padding: EdgeInsets.all(4),
                                            child: SingleChildScrollView(
                                                scrollDirection:
                                                    Axis.horizontal,
                                                child: Text(
                                                  widget.product.location,
                                                  maxLines: 1,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                  ),
                                                )),
                                          )),
                                    ))
                                  ]),
                                  TableRow(children: [
                                    TableCell(
                                      child: Container(
                                          alignment: Alignment.center,
                                          height: 40,
                                          child: Text("Purchase",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ))),
                                    ),
                                    TableCell(
                                        child: Container(
                                      height: 40,
                                      child: Container(
                                        alignment: Alignment.center,
                                        height: 40,
                                        child: MaterialButton(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20.0)),
                                          minWidth: 90,
                                          height: 25,
                                          child: Text('Add to Cart',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              )),
                                          color: Colors.white,
                                          textColor: Colors.black,
                                          elevation: 10,
                                          onPressed: () => _addtocartdialog(),
                                        ),
                                      ),
                                    )),
                                  ]),
                                ]),
                          ],
                        ))),
              )
            ],
          ),
        ),
      ),
    );
  }

  _addtocartdialog() {
    if (widget.user.email == "unregistered@grocery.com") {
      Toast.show("Please register to use this function", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    //condition if the user choose on it own product
    if (widget.user.email == widget.product.email) {
      Toast.show("Own Product!!", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    quantity = 1;
    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, newSetState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0))),
              title: new Text(
                "Add " + widget.product.name + " to Cart?",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    "Select quantity of product",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          FlatButton(
                            onPressed: () => {
                              newSetState(() {
                                if (quantity > 1) {
                                  quantity--;
                                }
                              })
                            },
                            child: Icon(
                              MdiIcons.minus,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            quantity.toString(),
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          FlatButton(
                            onPressed: () => {
                              newSetState(() {
                                if (quantity <
                                    (int.parse(widget.product.quantity))) {
                                  quantity++;
                                } else {
                                  Toast.show("Quantity not available", context,
                                      duration: Toast.LENGTH_LONG,
                                      gravity: Toast.BOTTOM);
                                }
                              })
                            },
                            child: Icon(
                              MdiIcons.plus,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
              actions: <Widget>[
                MaterialButton(
                    onPressed: () {
                      Navigator.of(context).pop(false);
                      _addtoCart();
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
            );
          });
        });
  }

  void _addtoCart() {
    if (widget.user.email == "unregistered@grocery.com") {
      Toast.show("Please register first", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    if (widget.user.email == widget.product.email) {
      Toast.show("Own Product !!", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    try {
      int cquantity = int.parse(widget.product.quantity);
      print(cquantity);
      print(widget.product.pid);
      print(widget.user.email);
      if (cquantity > 0) {
        ProgressDialog pr = new ProgressDialog(context,
            type: ProgressDialogType.Normal, isDismissible: true);
        pr.style(message: "Add to cart...");
        pr.show();
        String urlLoadJobs = server + "/php/insert_cart.php";
        http.post(urlLoadJobs, body: {
          "email": widget.user.email,
          "proid": widget.product.pid,
          "quantity": quantity.toString(),
        }).then((res) {
          print(res.body);
          if (res.body == "failed") {
            Toast.show("Failed add to cart", context,
                duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
            pr.dismiss();
            return;
          } else {
            List respond = res.body.split(",");
            setState(() {
              cartquantity = respond[1];
              widget.user.quantity = cartquantity;
            });
            Toast.show("Success add to cart", context,
                duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
          }
          pr.dismiss();
        }).catchError((err) {
          print(err);
          pr.dismiss();
        });
        pr.dismiss();
      } else {
        Toast.show("Out of stock", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      }
    } catch (e) {
      Toast.show("Failed add to cart", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }
  }
}
