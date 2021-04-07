import 'dart:async';
import 'package:second_life/User.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/material.dart';

class PaymentScreen extends StatefulWidget {
  final User user;
  final String orderid, val, address;

  PaymentScreen({this.user, this.orderid, this.val, this.address});

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  Completer<WebViewController> _controller = Completer<WebViewController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('PAYMENT'),
          // backgroundColor: Colors.deepOrange,
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: WebView(
                initialUrl:
                    'http://madkiddo.com/second_life/php/payment.php?email=' +
                        widget.user.email +
                        '&mobile=' +
                        widget.user.phone +
                        '&name=' +
                        widget.user.name +
                        '&amount=' +
                        widget.val +
                        '&orderid=' +
                        widget.orderid +
                        '&address=' +
                        widget.address , 
                javascriptMode: JavascriptMode.unrestricted,
                onWebViewCreated: (WebViewController webViewController) {
                  _controller.complete(webViewController);
                },
              ),
            ),
          ],
        ));
  }
}
