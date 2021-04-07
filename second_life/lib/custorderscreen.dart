import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:second_life/User.dart';
import 'package:second_life/orderdetailscreen.dart';
import 'order.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CustOrderScreen extends StatefulWidget {
  final User user;

  const CustOrderScreen({Key key, this.user}) : super(key: key);

  @override
  _CustOrderScreenState createState() => _CustOrderScreenState();
}

class _CustOrderScreenState extends State<CustOrderScreen> {
  List _custorderdata;

  String titlecenter = "Loading customer order";
  final f = new DateFormat('dd-MM-yyyy hh:mm a');
  var parsedDate;
  double screenHeight, screenWidth;
  String server = "https://madkiddo.com/second_life";

  @override
  void initState() {
    super.initState();
    _loadPaymentHistory();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('Customer Order'),
      ),
      body: Center(
        child: Column(children: <Widget>[
          SizedBox(height: 10),
          _custorderdata == null
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
                      itemCount: _custorderdata == null ? 0 : _custorderdata.length,
                      itemBuilder: (context, index) {
                        return Padding(
                            padding: EdgeInsets.fromLTRB(10, 1, 10, 1),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(20),
                              //onTap: () => loadOrderDetails(index),
                              child: Container(
                                  child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                elevation: 10,
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
                                                          "/productimage/${_custorderdata[index]['prodid']}.jpg",
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
                                          //width: screenWidth / 1.8,
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
                                                    _custorderdata[index]
                                                        ['name'],
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 18,
                                                        color: Colors.white),
                                                    maxLines: 1,
                                                  ),
                                                  Container(
                                                    width: 260,
                                                    child: Table(
                                                        defaultColumnWidth:
                                                            FlexColumnWidth(
                                                                1.0),
                                                        columnWidths: {
                                                          0: FlexColumnWidth(3),
                                                          1: FlexColumnWidth(7),
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
                                                                          color:
                                                                              Colors.white))),
                                                            ),
                                                            TableCell(
                                                              child: Container(
                                                                alignment: Alignment
                                                                    .centerLeft,
                                                                height: 20,
                                                                child: Text(
                                                                    _custorderdata[index]
                                                                            ['cquantity'] +
                                                                        " units(s)",
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
                                                                      "Order ID ",
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
                                                                   _custorderdata[index]
                                                                            ['orderid'],
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
                                                                  height: 60,
                                                                  child: Text(
                                                                      "Address ",
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
                                                                height: 60,
                                                                child: Text(
                                                                   _custorderdata[index]
                                                                            ['address'],
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
                                    ]
                                /*child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Container(
                                        padding:
                                            EdgeInsets.fromLTRB(20, 5, 10, 5),
                                        child: Table(
                                            defaultColumnWidth:
                                                FlexColumnWidth(1.0),
                                            columnWidths: {
                                              0: FlexColumnWidth(3),
                                              1: FlexColumnWidth(7),
                                            },
                                            //border: TableBorder.all(color: Colors.white),
                                            children: [
                                              TableRow(children: [
                                                TableCell(
                                                  child: Container(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      height: 20,
                                                      child: Text("Order ID",
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 18,
                                                              color: Colors
                                                                  .white))),
                                                ),
                                                TableCell(
                                                  child: Container(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    height: 20,
                                                    child: Text(
                                                        _custorderdata[index]
                                                            ['orderid'],
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 18,
                                                            color:
                                                                Colors.white)),
                                                  ),
                                                ),
                                              ]),
                                              TableRow(children: [
                                                TableCell(
                                                  child: Container(
                                                    height: 5,
                                                  ),
                                                ),
                                                TableCell(
                                                  child: Container(
                                                    height: 5,
                                                  ),
                                                ),
                                              ]),
                                              TableRow(children: [
                                                TableCell(
                                                  child: Container(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      height: 20,
                                                      child: Text("Address ",
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
                                                        Alignment.centerLeft,
                                                    height: 20,
                                                    child: Text(
                                                            _custorderdata[index]
                                                                ['address'],
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                Colors.white)),
                                                  ),
                                                ),
                                              ]),
                                              TableRow(children: [
                                                TableCell(
                                                  child: Container(
                                                    height: 5,
                                                  ),
                                                ),
                                                TableCell(
                                                  child: Container(
                                                    height: 5,
                                                  ),
                                                ),
                                              ]),
                                              TableRow(children: [
                                                TableCell(
                                                  child: Container(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      height: 20,
                                                      child: Text("Product ID ",
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
                                                        Alignment.centerLeft,
                                                    height: 20,
                                                    child: Text(
                                                            _custorderdata[index]
                                                                ['prodid'],
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                Colors.white)),
                                                  ),
                                                ),
                                              ]),
                                              TableRow(children: [
                                                TableCell(
                                                  child: Container(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      height: 20,
                                                      child: Text("Product Quan ",
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
                                                        Alignment.centerLeft,
                                                    height: 20,
                                                    child: Text(
                                                            _custorderdata[index]
                                                                ['cquantity'] + " unit(s)",
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                Colors.white)),
                                                  ),
                                                ),
                                              ]),
                                            ])),
                                  ],
                                ),*/
                              ))),
                            ));
                      }))
        ]),
      ),
    );
  }

  Future<void> _loadPaymentHistory() async {
    String urlLoadJobs =
        "https://madkiddo.com/second_life/php/load_custorder.php";
    await http
        .post(urlLoadJobs, body: {"email": widget.user.email}).then((res) {
      print(res.body);
      if (res.body == "nodata") {
        setState(() {
          _custorderdata = null;
          titlecenter = "No Customer Purchase";
        });
      } else {
        setState(() {
          var extractdata = json.decode(res.body);
          _custorderdata = extractdata["custorder"];
        });
      }
    }).catchError((err) {
      print(err);
    });
  }

  calculateTotal(int index) {
    var quantity = double.parse(_custorderdata[index]['cquantity']);
    var weight = double.parse(_custorderdata[index]['weight']);
    var totalweight = quantity * weight;
    return totalweight;
  }

  loadOrderDetails(int index) {
    Order order = new Order(
        billid: _custorderdata[index]['billid'],
        orderid: _custorderdata[index]['orderid'],
        total: _custorderdata[index]['total'],
        dateorder: _custorderdata[index]['date']);

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => OrderDetailScreen(
                  order: order,
                )));
  }
}
