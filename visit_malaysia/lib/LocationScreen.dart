import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'Location.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationScreen extends StatefulWidget {
  final Location location;

  const LocationScreen({Key key, this.location}) : super(key: key);

  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  double screenHeight, screenWidth;
  GoogleMapController myMapController;
  final Set<Marker> _markers = new Set();
  static LatLng _mainLocation = const LatLng(6.426844, 100.460767);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    String phone = widget.location.phone;
    var latitude = double.parse(widget.location.latitude);
    var longitude = double.parse(widget.location.longitude);
    _mainLocation = new LatLng(latitude, longitude);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Colors.grey,
        title: Text(
          widget.location.name,
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Container(
        alignment: Alignment.topCenter,
        child: Column(
          children: <Widget>[
            Container(
              height: screenHeight / 2.5,
              width: screenWidth,
              child: CachedNetworkImage(
                fit: BoxFit.fill,
                imageUrl:
                    "http://slumberjer.com/visitmalaysia/images/${widget.location.image}",
                placeholder: (context, url) => new CircularProgressIndicator(),
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
                                color: Colors.black,
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
                                            color: Colors.black,
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
                                            padding: EdgeInsets.all(4),
                                            child: Text(
                                                widget.location.description,
                                                style: TextStyle(
                                                  color: Colors.black,
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
                                        child: Text("Link",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
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
                                            child: GestureDetector(
                                              child: SingleChildScrollView(
                                                scrollDirection:
                                                    Axis.horizontal,
                                                child: Text(
                                                  widget.location.url,
                                                  maxLines: 1,
                                                  style: TextStyle(
                                                    color: Colors.blue,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                              onTap: () => launch("http://" +
                                                  widget.location.url),
                                            ))),
                                  )),
                                ]),
                                TableRow(children: [
                                  TableCell(
                                    child: Container(
                                        alignment: Alignment.center,
                                        height: 40,
                                        child: Text("Contact No.",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
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
                                            child: GestureDetector(
                                              child: Text(
                                                phone,
                                                style: TextStyle(
                                                  color: Colors.blue,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              onTap: () =>
                                                  launch("tel://" + phone),
                                            ))),
                                  )),
                                ]),
                                TableRow(children: [
                                  TableCell(
                                    child: Container(
                                        alignment: Alignment.center,
                                        height: 40,
                                        child: Text("Address",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
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
                                            child: Text(widget.location.address,
                                                maxLines: 1),
                                          ),
                                        )),
                                  ))
                                ]),
                                TableRow(children: [
                                  TableCell(
                                    child: Container(
                                        alignment: Alignment.center,
                                        height: 250,
                                        child: Text("Google Map",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ))),
                                  ),
                                  TableCell(
                                      child: Container(
                                    height: 250,
                                    child: Container(
                                        alignment: Alignment.center,
                                        height: 40,
                                        child: Padding(
                                            padding: EdgeInsets.all(4),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: <Widget>[
                                                Expanded(
                                                  child: GoogleMap(
                                                    initialCameraPosition:
                                                        CameraPosition(
                                                      target: _mainLocation,
                                                      zoom: 11.0,
                                                    ),
                                                    markers: this.myMarker(),
                                                    mapType: MapType.normal,
                                                    onMapCreated: (controller) {
                                                      setState(() {
                                                        myMapController =
                                                            controller;
                                                      });
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ))),
                                  )),
                                ]),
                              ]),
                        ],
                      ))),
            )
          ],
        ),
      ),
    );
  }

  Set<Marker> myMarker() {
    setState(() {
      _markers.add(Marker(
        // This marker id can be anything that uniquely identifies each marker.
        markerId: MarkerId(_mainLocation.toString()),
        position: _mainLocation,
        infoWindow: InfoWindow(
          title: 'Historical City',
          snippet: '5 Star Rating',
        ),
        icon: BitmapDescriptor.defaultMarker,
      ));
    });

    return _markers;
  }
}
