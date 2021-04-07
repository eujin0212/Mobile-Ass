import 'dart:convert';

import 'package:flutter/material.dart';
import 'order.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';

class OrderDetailScreen extends StatefulWidget {
  final Order order;

  const OrderDetailScreen({Key key, this.order}) : super(key: key);
  @override
  _OrderDetailScreenState createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  List _orderdetails;
  String titlecenter = "Loading order details";
  double screenHeight, screenWidth;
  String server = "https://madkiddo.com/second_life";

  @override
  void initState() {
    super.initState();
    _loadOrderDetails();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Details'),
      ),
      body: Center(
        child: Column(children: <Widget>[
          SizedBox(
            height: 10,
          ),
          _orderdetails == null
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
                      //Step 6: Count the data
                      itemCount:
                          _orderdetails == null ? 0 : _orderdetails.length,
                      itemBuilder: (context, index) {
                        return Padding(
                            padding: EdgeInsets.fromLTRB(10, 1, 10, 1),
                            child: Card(
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
                                                        child:
                                                            CachedNetworkImage(
                                                      fit: BoxFit.scaleDown,
                                                      imageUrl: server +
                                                          "/productimage/${_orderdetails[index]['id']}.jpg",
                                                      placeholder: (context,
                                                              url) =>
                                                          new CircularProgressIndicator(),
                                                      errorWidget: (context,
                                                              url, error) =>
                                                          new Icon(Icons.error),
                                                    )),
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
                                          width: screenWidth / 1.8,
                                          //color: Colors.blue,
                                          child: Row(
                                            //crossAxisAlignment: CrossAxisAlignment.center,
                                            //mainAxisAlignment: MainAxisAlignment.center,
                                            children: <Widget>[
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Text(
                                                    _orderdetails[index]
                                                        ['name'],
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 18,
                                                        color: Colors.white),
                                                    maxLines: 1,
                                                  ),
                                                  Container(
                                                    width: 220,
                                                    child: Table(
                                                        defaultColumnWidth:
                                                            FlexColumnWidth(
                                                                1.0),
                                                        columnWidths: {
                                                          0: FlexColumnWidth(4),
                                                          1: FlexColumnWidth(6),
                                                        },
                                                        //border: TableBorder.all(color: Colors.white),
                                                        children: [
                                                          TableRow(children: [
                                                            TableCell(
                                                              child: Container(
                                                                  alignment:
                                                                      Alignment
                                                                          .centerLeft,
                                                                  height: 20,
                                                                  child: Text(
                                                                      "Quantity",
                                                                      style: TextStyle(
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          fontSize:
                                                                              15,
                                                                          color:
                                                                              Colors.white))),
                                                            ),
                                                            TableCell(
                                                              child: Container(
                                                                alignment: Alignment
                                                                    .centerLeft,
                                                                height: 20,
                                                                child: Text(
                                                                    _orderdetails[index]
                                                                            [
                                                                            'cquantity'] +
                                                                        " units(s)",
                                                                    style: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        fontSize:
                                                                            15,
                                                                        color: Colors
                                                                            .white)),
                                                              ),
                                                            ),
                                                          ]),
                                                          TableRow(children: [
                                                            TableCell(
                                                              child: Container(
                                                                  alignment:
                                                                      Alignment
                                                                          .centerLeft,
                                                                  height: 20,
                                                                  child: Text(
                                                                      "Price",
                                                                      style: TextStyle(
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          color:
                                                                              Colors.white))),
                                                            ),
                                                            TableCell(
                                                              child: Container(
                                                                alignment: Alignment
                                                                    .centerLeft,
                                                                height: 20,
                                                                child: Text(
                                                                    "RM " +
                                                                        _orderdetails[index]
                                                                            [
                                                                            'price'],
                                                                    style: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        color: Colors
                                                                            .white)),
                                                              ),
                                                            ),
                                                          ]),
                                                          TableRow(children: [
                                                            TableCell(
                                                              child: Container(
                                                                  alignment:
                                                                      Alignment
                                                                          .centerLeft,
                                                                  height: 20,
                                                                  child: Text(
                                                                      "Total ",
                                                                      style: TextStyle(
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          color:
                                                                              Colors.white))),
                                                            ),
                                                            TableCell(
                                                              child: Container(
                                                                alignment: Alignment
                                                                    .centerLeft,
                                                                height: 20,
                                                                child: Text(
                                                                    "RM " +
                                                                        calculateTotal(index)
                                                                            .toStringAsFixed(
                                                                                2),
                                                                    style: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        color: Colors
                                                                            .white)),
                                                              ),
                                                            ),
                                                          ]),
                                                        ]),
                                                        
                                                  )
                                                ],
                                              ),
                                            ],
                                          )),
                                    ]))));
                      }))
        ]),
      ),
    );
  }

  calculateTotal(int index) {
    var quantity = double.parse(_orderdetails[index]['cquantity']);
    var price = double.parse(_orderdetails[index]['price']);
    var totalprice = quantity * price;
    return totalprice;
  }

  _loadOrderDetails() async {
    String urlLoadJobs =
        "https://madkiddo.com/second_life/php/load_carthistory.php";
    await http.post(urlLoadJobs, body: {
      "orderid": widget.order.orderid,
    }).then((res) {
      print(res.body);
      if (res.body == "nodata") {
        setState(() {
          _orderdetails = null;
          titlecenter = "No Previous Payment";
        });
      } else {
        setState(() {
          var extractdata = json.decode(res.body);
          _orderdetails = extractdata["carthistory"];
        });
      }
    }).catchError((err) {
      print(err);
    });
  }
}
