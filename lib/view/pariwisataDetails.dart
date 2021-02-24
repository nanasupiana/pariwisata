import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pariwisata/config/config.dart';
import 'lokasiDetails.dart';
import 'pariwisataData.dart';

class pariwisataDetails extends StatefulWidget {
  pariwisataDetails({Key key, this.lokasiid}) : super(key: key);
  final String lokasiid;
  @override
  pariwisataDetailsState createState() => new pariwisataDetailsState();
}

class pariwisataDetailsState extends State<pariwisataDetails> {
  List<pariwisataData> _pariwisatadata = [];
  TextEditingController controller = new TextEditingController();

  Future<Null> getLokasiDetails() async {
    String url = GET_LOKASI_DETAIL;
    Map data = {
      "id" : widget.lokasiid.toString()
    };
    //encode Map to JSON
    print("URL POST LOKASI " + url);
    var body = json.encode(data);
    var response = await http.post(url,
        headers: {"Content-Type": "application/json"}, body: body);
    //final responseData = response;
    final responseJson = json.decode(response.body);
   setState(() {
      for (Map _data in responseJson) {
        _pariwisatadata.add(pariwisataData.fromJson(_data));
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getLokasiDetails();
  }

  Widget _buildPariwisataList() {
    return new ListView.builder(
      itemCount: _pariwisatadata.length,
      itemBuilder: (context, index) {
        return new Card(
          semanticContainer: true,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          child: Image.memory(
            _pariwisatadata[index].foto,
            fit: BoxFit.fill,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          elevation: 5,
          margin: EdgeInsets.all(10),
        );
      },
    );
  }

  Widget _buildBody() {
    return new Column(
      children: <Widget>[
        new Expanded(
            child: _buildPariwisataList()),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        automaticallyImplyLeading: true,
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back, color: Colors.grey),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.white,
        title: Text("Pariwisata",
            style: TextStyle(
                color: Colors.grey,
                fontSize: 16.0,
                fontFamily: "Montserrat-Regular",
                fontWeight: FontWeight.bold)),
      ),
      body: _buildBody(),
      backgroundColor: Colors.grey[200],
      resizeToAvoidBottomPadding: true,
    );
  }
}
