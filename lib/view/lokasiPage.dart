import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pariwisata/config/config.dart';
import 'package:pariwisata/view/pariwisataDetails.dart';
import 'lokasiDetails.dart';

class lokasiPage extends StatefulWidget {
  lokasiPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  lokasiPageState createState() => new lokasiPageState();
}

class lokasiPageState extends State<lokasiPage> {
  List<lokasiDetails> _searchResult = [];
  List<lokasiDetails> _lokasiDetails = [];
  TextEditingController controller = new TextEditingController();
  int _selectedIndex = 0;

  Future<Null> getLokasiDetails() async {
    String url = GET_LOKASI_HEADER;
    final response = await http.get(url);
    final responseJson = json.decode(response.body);
    print("Data " + responseJson.toString());
    final responseData = responseJson;
    setState(() {
      for (Map user in responseData) {
        _lokasiDetails.add(lokasiDetails.fromJson(user));
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
      itemCount: _lokasiDetails.length,
      itemBuilder: (context, index) {
        return new Card(
          child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => pariwisataDetails(lokasiid: _lokasiDetails[index].id)),
                  );
                },
              child: new ListTile(
                  title: new Text(_lokasiDetails[index].nama),
                  subtitle: Text(
                    _lokasiDetails[index].informasi,
                    style: TextStyle(
                        fontFamily: "Montserrat-Regular",
                        color: Colors.grey,
                        fontSize: 12.0),
                  ),
                 )),
          margin: const EdgeInsets.all(8.0),
        );
      },
    );
  }

  Widget _buildSearchResults() {
    return new ListView.builder(
      itemCount: _searchResult.length,
      itemBuilder: (context, i) {
        return new Card(
          margin: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => pariwisataDetails(lokasiid: _searchResult[i].id)),
              );
            },
            child: new ListTile(
                title: new Text(_searchResult[i].nama),
                subtitle: Text(
                  _searchResult[i].informasi,
                  style: TextStyle(
                      fontFamily: "Montserrat-Regular", color: Colors.grey),
                ),
                trailing: new Container(
                    child: Column(
                  children: <Widget>[
                    new Container(
                      child: FlatButton.icon(
                        onPressed: null,
                        icon: Icon(
                          Icons.image,
                          color: Colors.orange,
                        ),
                        color: Colors.transparent,
                      ),
                    ),
                  ],
                ))),
          ),
        );
      },
    );
  }

  Widget _buildSearchBox() {
    return new Padding(
      padding: const EdgeInsets.all(8.0),
      child: new Card(
        child: new ListTile(
          leading: new Icon(Icons.search),
          title: new TextField(
            controller: controller,
            decoration: new InputDecoration(
                hintText: 'Cari',
                border: InputBorder.none,
                hintStyle: TextStyle(
                    fontSize: 14.0, fontFamily: "Montserrat-Regular")),
            onChanged: onSearchTextChanged,
          ),
          trailing: new IconButton(
            icon: new Icon(Icons.cancel),
            onPressed: () {
              controller.clear();
              onSearchTextChanged('');
            },
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    return new Column(
      children: <Widget>[
        new Container(child: _buildSearchBox()),
        new Expanded(
            child: _searchResult.length != 0 || controller.text.isNotEmpty
                ? _buildSearchResults()
                : _buildPariwisataList()),
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
        title: Text(widget.title,
            style: TextStyle(
                color: Colors.grey,
                fontSize: 16.0,
                fontFamily: "Montserrat-Regular",
                fontWeight: FontWeight.bold)),
      ),
      body: _buildBody(),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              title: Text("Home")
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              title: Text("Account")
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
      backgroundColor: Colors.grey[200],
      resizeToAvoidBottomPadding: true,
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if(index == 0){
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => lokasiPage(title: "Dashboard Pariwisata")),
      );
    }
  }

  onSearchTextChanged(String text) async {
    _searchResult.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }
    _lokasiDetails.forEach((userDetail) {
      if (userDetail.nama.contains(text) ||
          userDetail.informasi.contains(text) ||
          userDetail.kota.toLowerCase().contains(text) ||
          userDetail.kecamatan.toLowerCase().contains(text))
        _searchResult.add(userDetail);
    });
    setState(() {});
  }
}
