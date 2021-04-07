import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:second_life/User.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;
import 'package:progress_dialog/progress_dialog.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:random_string/random_string.dart';
import 'package:intl/intl.dart';
class NewProduct extends StatefulWidget {
  final User user;

  const NewProduct({Key key, this.user}) : super(key: key);

  @override
  _NewProductState createState() => _NewProductState();
}

class _NewProductState extends State<NewProduct> {
  String server = "https://madkiddo.com/second_life";
  double screenHeight, screenWidth;
  File _image;
  String prodid;
  String pathAsset = 'assets/images/phonecam.png';
  TextEditingController pridEditingController = new TextEditingController();
  TextEditingController prnameEditingController = new TextEditingController();
  TextEditingController priceEditingController = new TextEditingController();
  TextEditingController qtyEditingController = new TextEditingController();
  TextEditingController typeEditingController = new TextEditingController();
  TextEditingController weigthEditingController = new TextEditingController();
  TextEditingController addressEditingController = new TextEditingController();
  TextEditingController desEditingController = new TextEditingController();
  var now = new DateTime.now();
  var formatter = new DateFormat('ddMMyyyy');
  String selectedType, selectedState;
  List<String> listType = [
    "Appearance",
    "Digital",
    "Education",
    "Electronic",
    "Entertainment",
    "Household",
    "Other",
  ];
  List<String> listState = [
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
  ];

  @override
  void initState() {
    super.initState();
    prodid = formatter.format(now) + randomNumeric(6);
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('New Product'),
      ),
      body: Center(
        child: Container(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                SizedBox(height: 6),
                GestureDetector(
                    onTap: () => _choose(),
                    child: Container(
                      height: screenHeight / 3,
                      width: screenWidth / 1.8,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: _image == null
                              ? AssetImage(pathAsset)
                              : FileImage(_image),
                          fit: BoxFit.cover,
                        ),
                        border: Border.all(
                          width: 3.0,
                          color: Colors.grey,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(
                                5.0) //         <--- border radius here
                            ),
                      ),
                    )),
                SizedBox(height: 5),
                Text("Click the above image to take picture of your product",
                    style: TextStyle(fontSize: 10.0, color: Colors.white)),
                SizedBox(height: 5),
                Container(
                    width: screenWidth / 1.2,
                    //height: screenHeight / 2,
                    child: Card(
                        elevation: 6,
                        child: Padding(
                            padding: EdgeInsets.all(10),
                            child: Column(
                              children: <Widget>[
                                Table(
                                    defaultColumnWidth: FlexColumnWidth(1.0),
                                    children: [
                                      TableRow(children: [
                                        TableCell(
                                          child: Container(
                                              alignment: Alignment.centerLeft,
                                              height: 30,
                                              child: Text("Product ID",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                  ))),
                                        ),
                                        TableCell(
                                            child: Container(
                                          height: 30,
                                          child: Container(
                                            alignment: Alignment.centerLeft,
                                            height: 30,
                                            child: Text(prodid,
                                                style: TextStyle(
                                                  color: Colors.white,
                                                )),
                                          ),
                                        )),
                                      ]),
                                      TableRow(children: [
                                        TableCell(
                                          child: Container(
                                              alignment: Alignment.centerLeft,
                                              height: 30,
                                              child: Text("Product Name",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                  ))),
                                        ),
                                        TableCell(
                                          child: Container(
                                            margin:
                                                EdgeInsets.fromLTRB(5, 1, 5, 1),
                                            height: 30,
                                            child: TextFormField(
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ),
                                                controller:
                                                    prnameEditingController,
                                                keyboardType:
                                                    TextInputType.text,
                                                decoration: new InputDecoration(
                                                  contentPadding:
                                                      const EdgeInsets.all(5),
                                                  fillColor: Colors.white,
                                                  border:
                                                      new OutlineInputBorder(
                                                    borderRadius:
                                                        new BorderRadius
                                                            .circular(5.0),
                                                    borderSide:
                                                        new BorderSide(),
                                                  ),

                                                  //fillColor: Colors.green
                                                )),
                                          ),
                                        ),
                                      ]),
                                      TableRow(children: [
                                        TableCell(
                                          child: Container(
                                              alignment: Alignment.centerLeft,
                                              height: 30,
                                              child: Text("Price (RM)",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white))),
                                        ),
                                        TableCell(
                                          child: Container(
                                            margin:
                                                EdgeInsets.fromLTRB(5, 1, 5, 1),
                                            height: 30,
                                            child: TextFormField(
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ),
                                                controller:
                                                    priceEditingController,
                                                keyboardType:
                                                    TextInputType.number,
                                                decoration: new InputDecoration(
                                                  fillColor: Colors.white,
                                                  border:
                                                      new OutlineInputBorder(
                                                    borderRadius:
                                                        new BorderRadius
                                                            .circular(5.0),
                                                    borderSide:
                                                        new BorderSide(),
                                                  ),
                                                  //fillColor: Colors.green
                                                )),
                                          ),
                                        ),
                                      ]),
                                      TableRow(children: [
                                        TableCell(
                                          child: Container(
                                              alignment: Alignment.centerLeft,
                                              height: 30,
                                              child: Text("Quantity",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white))),
                                        ),
                                        TableCell(
                                          child: Container(
                                            margin:
                                                EdgeInsets.fromLTRB(5, 1, 5, 1),
                                            height: 30,
                                            child: TextFormField(
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ),
                                                controller:
                                                    qtyEditingController,
                                                keyboardType:
                                                    TextInputType.number,
                                                decoration: new InputDecoration(
                                                  fillColor: Colors.white,
                                                  border:
                                                      new OutlineInputBorder(
                                                    borderRadius:
                                                        new BorderRadius
                                                            .circular(5.0),
                                                    borderSide:
                                                        new BorderSide(),
                                                  ),
                                                  //fillColor: Colors.green
                                                )),
                                          ),
                                        ),
                                      ]),
                                      TableRow(children: [
                                        TableCell(
                                          child: Container(
                                              alignment: Alignment.centerLeft,
                                              height: 30,
                                              child: Text("Type",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white))),
                                        ),
                                        TableCell(
                                          child: Container(
                                            margin:
                                                EdgeInsets.fromLTRB(5, 1, 5, 1),
                                            height: 40,
                                            child: Container(
                                              height: 40,
                                              child: DropdownButton(
                                                //sorting dropdownoption
                                                hint: Text(
                                                  'Type',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                  ),
                                                ), // Not necessary for Option 1
                                                value: selectedType,
                                                onChanged: (newValue) {
                                                  setState(() {
                                                    selectedType = newValue;
                                                    print(selectedType);
                                                  });
                                                },
                                                items: listType
                                                    .map((selectedType) {
                                                  return DropdownMenuItem(
                                                    child: new Text(
                                                        selectedType,
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white)),
                                                    value: selectedType,
                                                  );
                                                }).toList(),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ]),
                                      TableRow(children: [
                                        TableCell(
                                          child: Container(
                                              alignment: Alignment.centerLeft,
                                              height: 30,
                                              child: Text("Weigth (gram)",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white))),
                                        ),
                                        TableCell(
                                          child: Container(
                                            margin:
                                                EdgeInsets.fromLTRB(5, 1, 5, 1),
                                            height: 30,
                                            child: TextFormField(
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ),
                                                controller:
                                                    weigthEditingController,
                                                keyboardType:
                                                    TextInputType.number,
                                                decoration: new InputDecoration(
                                                  fillColor: Colors.white,
                                                  border:
                                                      new OutlineInputBorder(
                                                    borderRadius:
                                                        new BorderRadius
                                                            .circular(5.0),
                                                    borderSide:
                                                        new BorderSide(),
                                                  ),
                                                  //fillColor: Colors.green
                                                )),
                                          ),
                                        ),
                                      ]),
                                      TableRow(children: [
                                        TableCell(
                                          child: Container(
                                              alignment: Alignment.centerLeft,
                                              height: 30,
                                              child: Text("Delivered from",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white))),
                                        ),
                                        TableCell(
                                          child: Container(
                                            margin:
                                                EdgeInsets.fromLTRB(5, 1, 5, 1),
                                            height: 40,
                                            child: Container(
                                              height: 40,
                                              child: DropdownButton(
                                                //sorting dropdownoption
                                                hint: Text(
                                                  'State',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                  ),
                                                ), // Not necessary for Option 1
                                                value: selectedState,
                                                onChanged: (newValue) {
                                                  setState(() {
                                                    selectedState = newValue;
                                                    print(selectedState);
                                                  });
                                                },
                                                items: listState
                                                    .map((selectedState) {
                                                  return DropdownMenuItem(
                                                    child: new Text(
                                                        selectedState,
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white)),
                                                    value: selectedState,
                                                  );
                                                }).toList(),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ]),
                                      TableRow(children: [
                                        TableCell(
                                          child: Container(
                                              alignment: Alignment.centerLeft,
                                              height: 65,
                                              child: Text("Description",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white))),
                                        ),
                                        TableCell(
                                          child: Container(
                                            margin:
                                                EdgeInsets.fromLTRB(5, 1, 5, 1),
                                            height: 65,
                                            child: TextFormField(
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ),
                                                controller:
                                                    desEditingController,
                                                decoration: new InputDecoration(
                                                  fillColor: Colors.white,
                                                  border:
                                                      new OutlineInputBorder(
                                                    borderRadius:
                                                        new BorderRadius
                                                            .circular(5.0),
                                                    borderSide:
                                                        new BorderSide(),
                                                  ),
                                                  //fillColor: Colors.green
                                                )),
                                          ),
                                        ),
                                      ]),
                                    ]),
                                SizedBox(height: 3),
                                MaterialButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(10.0)),
                                  minWidth: screenWidth / 1.5,
                                  height: 40,
                                  child: Text(
                                    'Insert New Product',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  color: Colors.white,
                                  textColor: Colors.black,
                                  elevation: 5,
                                  onPressed: _insertNewProduct,
                                ),
                              ],
                            )))),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _choose() async {
    _image = await ImagePicker.pickImage(
        source: ImageSource.camera, maxHeight: 800, maxWidth: 800);
    _cropImage();
    setState(() {});
  }

  Future<Null> _cropImage() async {
    File croppedFile = await ImageCropper.cropImage(
        sourcePath: _image.path,
        aspectRatioPresets: Platform.isAndroid
            ? [
                CropAspectRatioPreset.square,
                //CropAspectRatioPreset.ratio3x2,
                //CropAspectRatioPreset.original,
                //CropAspectRatioPreset.ratio4x3,
                //CropAspectRatioPreset.ratio16x9
              ]
            : [
                //CropAspectRatioPreset.original,
                CropAspectRatioPreset.square,
                //CropAspectRatioPreset.ratio3x2,
                //CropAspectRatioPreset.ratio4x3,
                //CropAspectRatioPreset.ratio5x3,
                //CropAspectRatioPreset.ratio5x4,
                //CropAspectRatioPreset.ratio7x5,
                //CropAspectRatioPreset.ratio16x9
              ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          title: 'Cropper',
        ));
    if (croppedFile != null) {
      _image = croppedFile;
      setState(() {});
    }
  }

  void _insertNewProduct() {
    if (_image == null) {
      Toast.show("Please take product photo", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    if (prnameEditingController.text.length < 1) {
      Toast.show("Please enter product name", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    if (qtyEditingController.text.length < 1) {
      Toast.show("Please enter product quantity", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    if (priceEditingController.text.length < 1) {
      Toast.show("Please enter product price", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    if (weigthEditingController.text.length < 1) {
      Toast.show("Please enter product weight", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    if (desEditingController.text.length < 10) {
      Toast.show("Please enter product description", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: new Text(
            "Insert New Product " + prnameEditingController.text,
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
                insertProduct();
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

  insertProduct() {
    double price = double.parse(priceEditingController.text);
    double weigth = double.parse(weigthEditingController.text);

    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: "Inserting new product");
    pr.show();
    String base64Image = base64Encode(_image.readAsBytesSync());

    http.post(server + "/php/insert_product.php", body: {
      "prid": prodid,
      "prname": prnameEditingController.text,
      "quantity": qtyEditingController.text,
      "price": price.toStringAsFixed(2),
      "type": selectedType,
      "weight": weigth.toStringAsFixed(2),
      "description": desEditingController.text,
      "location": selectedState,
      "email": widget.user.email,
      "encoded_string": base64Image,
    }).then((res) {
      print(res.body);
      pr.dismiss();
      if (res.body == "found") {
        Toast.show("Product id already in database", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        return;
      }
      if (res.body == "success") {
        Toast.show("Insert success", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        Navigator.of(context).pop();
      } else {
        Toast.show("Insert failed", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      }
    }).catchError((err) {
      print(err);
      pr.dismiss();
    });
  }

}
