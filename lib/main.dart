// import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:barcode_scan/barcode_scan.dart';

//to import the json file
import 'dart:convert';
import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;

//TTS:
// import 'tts.dart';
import 'package:flutter_tts/flutter_tts.dart';

//extra buttons:
import 'extraButtons.dart';

class Product {
  int productBarCode;
  String name;
  String expDate;
  String category;
  int quantity_rem;

  Product(
      {this.productBarCode,
      this.name,
      this.expDate,
      this.category,
      this.quantity_rem});

  factory Product.fromJson(Map<String, dynamic> parsedJson) {
    return Product(
      productBarCode: parsedJson['productBarCode'],
      name: parsedJson['name'],
      expDate: parsedJson['expDate'],
      category: parsedJson['category'],
      quantity_rem: parsedJson['quantity_rem'],
    );
  }
}

Future<String> _loadAStudentAsset() async {
  return await rootBundle.loadString('assets/student.json');
}

Future<List<Product>> loadStudent() async {
  var products = new List<Product>();
  String jsonString = await _loadAStudentAsset();
  final jsonResponse = json.decode(jsonString);
  // print(jsonResponse);
  // print(jsonResponse is List);
  for (int i = 0; i < jsonResponse.length; i++) {
    // print("List element i ${jsonResponse[i]}");
    var p = new Product.fromJson(jsonResponse[i]);
    products.add(p);
  }
  // for (int i = 0; i < products.length; i++) {
  //   print("List element i ${products[i]}");
  //   print("Some info ${products[i].productBarCode}");
  //   print("Some info ${products[i].quantity_rem}");
  // }
  // print("products is done! $products");
  return products.toList();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var prods = await loadStudent();
  print("Im here");
  runApp(MaterialApp(
    theme: ThemeData(fontFamily: 'Lato'),
    title: 'Navigation Basics',
    home: ScanScreen(products: prods),
  ));
}

class ScanScreen extends StatefulWidget {
  final List<Product> products;
  ScanScreen({this.products});

  @override
  _ScanScreenState createState() => new _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  String barcode = "";
  bool toDisp = false;

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("Entered build with products as ${widget.products}");
    return new MaterialApp(
      title: "SCNNR",
      debugShowCheckedModeBanner: false,
      // theme: ThemeData(fontFamily: Roboto),
      home: Scaffold(
          // backgroundColor: Colors.grey,
          body: Center(
              child: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [Colors.purple, Colors.blue],
        )),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Stack(
              children: <Widget>[
                new Container(
                  height: 60.0,
                  width: 60.0,
                  decoration: new BoxDecoration(
                    borderRadius: new BorderRadius.circular(50.0),
                    // color: Colors.teal,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: new Icon(Icons.arrow_upward, color: Colors.white),
                )
              ],
            ),
            new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 60.0),
                  child: new Text(
                    "SCNNR",
                    style: new TextStyle(
                        fontSize: 30.0,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            new Row(
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 20.0, right: 20.0, bottom: 10.0),
                    child: new OutlineButton(
                      padding: const EdgeInsets.all(18.0),
                      splashColor: Colors.white,
                      onPressed: scan,
                      borderSide: BorderSide(width: 2.0, color: Colors.white),
                      child: new Text("Scan!",
                          style: new TextStyle(
                              fontSize: 20.0, color: Colors.white)),
                    ),
                  ),
                ),
                // (barcode != "")
                //     ? Text
                //     // Text("Nothing")
                //     : Text(""),
              ],
            ),
            new Row(
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 20.0, right: 10.0, top: 10.0),
                    child: new OutlineButton(
                      padding: const EdgeInsets.all(18.0),
                      splashColor: Colors.white,
                      onPressed: scan,
                      borderSide: BorderSide(width: 2.0, color: Colors.white),
                      child: new Text("More Info",
                          style: new TextStyle(
                              fontSize: 20.0, color: Colors.white)),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 10.0, right: 20.0, top: 10.0),
                    child: new OutlineButton(
                      padding: const EdgeInsets.all(18.0),
                      splashColor: Colors.white,
                      onPressed: () => {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SendEmail(),
                          ),
                        )
                      },
                      borderSide: BorderSide(width: 2.0, color: Colors.white),
                      child: new Text("Contact Us",
                          style: new TextStyle(
                              fontSize: 20.0, color: Colors.white)),
                    ),
                  ),
                ),
              ],
            ),
            Visibility(
              visible: toDisp,
              child: new Row(
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: new OutlineButton(
                        padding: const EdgeInsets.all(18.0),
                        splashColor: Colors.white,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TextToSpeech(
                                  barcode: barcode, products: widget.products),
                            ),
                          );
                        },
                        borderSide: BorderSide(width: 2.0, color: Colors.white),
                        child: new Text(
                            "Code: " +
                                barcode.toString() +
                                " Click to See Details",
                            style: new TextStyle(
                                fontSize: 20.0, color: Colors.white)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ))),
    );
  }

  Future scan() async {
    try {
      print('Inside scan!!');
      String barcode = await BarcodeScanner.scan();
      print("-------------------------------------------------------------");
      print(barcode);
      setState(() => {this.barcode = barcode, toDisp = true});
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        setState(() => {
              this.barcode = 'The user did not grant the camera permission!',
              toDisp = false
            });
      } else {
        setState(() => {this.barcode = 'Unknown error: $e', toDisp = false});
      }
    } on FormatException {
      setState(() => {
            this.barcode =
                'null (User returned using the "back"-button before scanning anything. Result)',
            toDisp =
                false //here instead of changing barcode and declaring false, we might want to retain the earlier value of barcode. ** optional.
          });
    } catch (e) {
      setState(() => {this.barcode = 'Unknown error: $e', toDisp = false});
    }
  }
}
// make another similar thing for QR Code
//check font application

//Text to Speech Part:

class TextToSpeech extends StatefulWidget {
  final String barcode;
  final List<Product> products;
  TextToSpeech({Key key, @required this.barcode, @required this.products})
      : super(key: key);

  @override
  _TextToSpeechState createState() => _TextToSpeechState();
}

class _TextToSpeechState extends State<TextToSpeech> {
  // String _text = 'Hello World';
  FlutterTts flutterTts;
  String language = "en-US";

  Product p = new Product(name: "None");

  @override
  initState() {
    super.initState();
    initTts();
  }

  initTts() {
    flutterTts = FlutterTts();
    flutterTts.setLanguage(language);
    flutterTts.setSpeechRate(1.0);
    flutterTts.setVolume(2.0);
    flutterTts.setPitch(1.0);
  }

  void _readText(_text) {
    setState(() {
      _read(_text);
    });
  }

  Future _read(String text) async {
    await flutterTts.stop();
    if (text != null && text.isNotEmpty) {
      await flutterTts.speak(text.toLowerCase());
    }
  }

  @override
  void dispose() {
    super.dispose();
    flutterTts.stop();
  }

  @override
  Widget build(BuildContext context) {
    retProd(widget.products, widget.barcode);
    print(widget.products);
    if (p.name == "None") {
      return Scaffold(
          body: Center(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [Colors.teal, Colors.indigo],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  "The barode you matched does not exist in our database. Try another barcode or notify us",
                  textAlign: TextAlign.center,
                  style: new TextStyle(
                      fontSize: 25.0,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
              new Row(
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 20.0, right: 10.0, top: 10.0),
                      child: new OutlineButton(
                        padding: const EdgeInsets.all(18.0),
                        splashColor: Colors.white,
                        onPressed: () => {
                          //code for something else
                        },
                        borderSide: BorderSide(width: 2.0, color: Colors.white),
                        child: new Text("Report",
                            textAlign: TextAlign.center,
                            style: new TextStyle(
                                fontSize: 25.0,
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 10.0, right: 20.0, top: 10.0),
                      child: new OutlineButton(
                        padding: const EdgeInsets.all(18.0),
                        splashColor: Colors.white,
                        onPressed: () => {Navigator.pop(context)},
                        borderSide: BorderSide(width: 2.0, color: Colors.white),
                        child: new Text("Go back",
                            textAlign: TextAlign.center,
                            style: new TextStyle(
                                fontSize: 25.0,
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ));
    } else {
      return Scaffold(
        body: Center(
          child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [Colors.teal, Colors.indigo],
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: genTab(),
                  ),
                  new Row(
                    //for both the bottom buttons
                    children: <Widget>[
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 20.0, right: 10.0, top: 10.0),
                          child: new OutlineButton(
                            padding: const EdgeInsets.all(18.0),
                            splashColor: Colors.white,
                            onPressed: () => {
                              Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SendEmail(),
                          ),
                        )
                            },
                            borderSide:
                                BorderSide(width: 2.0, color: Colors.white),
                            child: new Text("Report An Issue",
                                textAlign: TextAlign.center,
                                style: new TextStyle(
                                    fontSize: 25.0,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 10.0, right: 20.0, top: 10.0),
                          child: new OutlineButton(
                            padding: const EdgeInsets.all(18.0),
                            splashColor: Colors.white,
                            onPressed: () => {
                              //code to add to calendar
                            },
                            borderSide:
                                BorderSide(width: 2.0, color: Colors.white),
                            child: new Text("Set A Reminder",
                                textAlign: TextAlign.center,
                                style: new TextStyle(
                                    fontSize: 25.0,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 20.0, right: 20.0, top: 20.0),
                          child: new OutlineButton(
                            padding: const EdgeInsets.all(18.0),
                            splashColor: Colors.white,
                            onPressed: () => {
                              _readText(
                                  "The Product details are, Name.${p.name}, Expiry Date.${p.expDate}, Category.${p.category}")
                            },
                            borderSide:
                                BorderSide(width: 2.0, color: Colors.white),
                            child: new Text("READ OUT LOUD",
                                textAlign: TextAlign.center,
                                style: new TextStyle(
                                    fontSize: 25.0,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ),
                    ],
                  ),
                  // FloatingActionButton(
                  //   onPressed: () => {_readText("The Product details are, Name.${p.name}, Expiry Date.${p.expDate}, Category.${p.category}")},
                  //   tooltip: 'Random Tooltip?',
                  //   child: Icon(Icons.play_arrow),
                  // ),
                ],
              )
              // retProd(products, barcode),
              ),
        ),
      );
    }
  }

  void retProd(List products, String barcode) {
    print(products is List);
    print(products is Widget);
    print(products);
    int i;
    for (i = 0; i < products.length; i++) {
      if (barcode == products[i].productBarCode.toString()) {
        //If the barcode mathces then return a Text having that product detail or else return nothing.
        p = products[i];
        break;
        // return Text(
        //     "The product Matched!Barcode scanned: ${products[i].productBarCode} prodcut name is ${products[i].name} and quantity left ${products[i].quantity_rem} in category ${products[i].category}");
      }
    }
    if (i == products.length) {
      p.name = "None";
    }
    // return Text("No match found :/");
  }

  Widget genTab() {
    print(p);
    return Table(
      columnWidths: {
        0: FractionColumnWidth(.5),
      },
      border: TableBorder.all(
          color: Colors.white, width: 1.5, style: BorderStyle.solid),
      children: [
        TableRow(children: [
          Container(
            height: 120.0,
            padding: EdgeInsets.all(8.0),
            alignment: Alignment.center,
            child: Text(
              "Property",
              style: TextStyle(
                fontSize: 32.0,
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
          Container(
            height: 120.0,
            padding: EdgeInsets.all(8.0),
            alignment: Alignment.center,
            child: Text(
              "Description",
              style: TextStyle(
                fontSize: 32.0,
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ]),
        TableRow(children: [
          Container(
            height: 120.0,
            padding: EdgeInsets.all(8.0),
            alignment: Alignment.center,
            child: Text(
              "Name",
              style: TextStyle(
                fontSize: 32.0,
                color: Colors.white,
              ),
            ),
          ),
          Container(
            height: 120.0,
            padding: EdgeInsets.all(8.0),
            alignment: Alignment.center,
            child: Text(
              p.name,
              style: TextStyle(
                fontSize: 32.0,
                color: Colors.white,
              ),
            ),
          ),
        ]),
        TableRow(children: [
          Container(
            height: 120.0,
            padding: EdgeInsets.all(8.0),
            alignment: Alignment.center,
            child: Text(
              "Expiry Date",
              style: TextStyle(
                fontSize: 32.0,
                color: Colors.white,
              ),
            ),
          ),
          Container(
            height: 120.0,
            padding: EdgeInsets.all(8.0),
            alignment: Alignment.center,
            child: Text(
              p.expDate,
              style: TextStyle(
                fontSize: 32.0,
                color: Colors.white,
              ),
            ),
          ),
        ]),
        TableRow(children: [
          Container(
            height: 120.0,
            padding: EdgeInsets.all(8.0),
            alignment: Alignment.center,
            child: Text(
              "Category",
              style: TextStyle(
                fontSize: 32.0,
                color: Colors.white,
              ),
            ),
          ),
          Container(
            height: 120.0,
            padding: EdgeInsets.all(8.0),
            alignment: Alignment.center,
            child: Text(
              p.category,
              style: TextStyle(
                fontSize: 32.0,
                color: Colors.white,
              ),
            ),
          ),
        ]),
      ],
    );
  }
}
