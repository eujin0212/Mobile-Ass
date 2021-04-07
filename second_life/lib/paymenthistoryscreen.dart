import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:second_life/User.dart';
import 'package:second_life/orderdetailscreen.dart';
import 'order.dart';
import 'package:intl/intl.dart';

class PaymentHistoryScreen extends StatefulWidget {
  final User user;

  const PaymentHistoryScreen({Key key, this.user}) : super(key: key);

  @override
  _PaymentHistoryScreenState createState() => _PaymentHistoryScreenState();
}

class _PaymentHistoryScreenState extends State<PaymentHistoryScreen> {
  List _paymentdata;

  String titlecenter = "Loading payment history";
  final f = new DateFormat('dd-MM-yyyy hh:mm a');
  var parsedDate;
  double screenHeight, screenWidth;

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
        title: Text('Payment History'),
      ),
      body: Center(
        child: Column(children: <Widget>[
          SizedBox(height: 10),
          _paymentdata == null
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
                      itemCount: _paymentdata == null ? 0 : _paymentdata.length,
                      itemBuilder: (context, index) {
                        return Padding(
                            padding: EdgeInsets.fromLTRB(10, 1, 10, 1),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(20),
                              onTap: () => loadOrderDetails(index),
                              child: Container(
                                  child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                elevation: 10,
                                child: Column(
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
                                                        _paymentdata[index]
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
                                                      child: Text("Date ",
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
                                                        f.format(DateTime.parse(
                                                            _paymentdata[index]
                                                                ['date'])),
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
                                                      child: Text("Total ",
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
                                                        "RM " +
                                                            _paymentdata[index]
                                                                ['total'],
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                              fontSize: 18,
                                                            color:
                                                                Colors.white)),
                                                  ),
                                                ),
                                              ]),
                                            ])),
                                  ],
                                ),
                              )),
                            ));
                      }))
        ]),
      ),
    );
  }

  Future<void> _loadPaymentHistory() async {
    String urlLoadJobs =
        "https://madkiddo.com/second_life/php/load_paymenthistory.php";
    await http
        .post(urlLoadJobs, body: {"email": widget.user.email}).then((res) {
      print(res.body);
      if (res.body == "nodata") {
        setState(() {
          _paymentdata = null;
          titlecenter = "No Previous Payment";
        });
      } else {
        setState(() {
          var extractdata = json.decode(res.body);
          _paymentdata = extractdata["payment"];
        });
      }
    }).catchError((err) {
      print(err);
    });
  }

  loadOrderDetails(int index) {
    Order order = new Order(
        billid: _paymentdata[index]['billid'],
        orderid: _paymentdata[index]['orderid'],
        total: _paymentdata[index]['total'],
        dateorder: _paymentdata[index]['date']);

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => OrderDetailScreen(
                  order: order,
                )));
  }
}
