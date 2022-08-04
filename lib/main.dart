// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, prefer_final_fields, unnecessary_null_comparison, prefer_is_empty, prefer_interpolation_to_compose_strings

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart'; 
import 'package:flutter/material.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Dictionary',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MyHomePage());
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _url = "https://owlbot.info/api/v4/dictionary/";
  String _token = "012ca4acc375588aedf4f1d8616ada3ef62df5c6";

  TextEditingController _controller = TextEditingController();
  
  late StreamController _streamcontroller;
  late Stream _stream;

  _search() async{
    if (_controller.text == null || _controller.text.length == 0){
      _streamcontroller.add(null);
    }
    Response response = await get(Uri.parse(_url + _controller.text.trim()), headers: {"Authorization":"Token " + _token}); 
    _streamcontroller.add(json.decode(response.body));   
  }
  
  @override 
  void initState() {
    super.initState();
    _streamcontroller = StreamController();
    _stream = _streamcontroller.stream;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Owlbot Dictionary"),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(52.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(left: 12, bottom: 8),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24.0)),
                    child: TextFormField(
                      onChanged: (String text) {},
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: "Search for a Word",
                        contentPadding: const EdgeInsets.only(left: 24),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.search, color: Colors.white),
                  onPressed: () {
                    _search();
                  },
                ),
              ],
            ),
          ),
        ),
        body: StreamBuilder(
           stream: _stream,
           builder: (BuildContext ctx, AsyncSnapshot snapshot){
            if (snapshot.data == null){
              return Center(
              child: Text("Enter a word to search"),);
            }
            return ListView.builder(
            itemCount: snapshot.data['definations'].length,
            itemBuilder:(BuildContext context, int index){
              return ListBody(
                children: <Widget> [
                  Container(color: Colors.grey[300],
                  child: ListTile(
                    leading: snapshot.data['definations'][index]['image_url'] == null ? null : CircleAvatar(
                      backgroundImage: NetworkImage(snapshot.data['definations'][index]['image_url']),
                    ),
                    title: Text(_controller.text.trim() + "("+ snapshot.data['definations'][index]['type'] +")"),
                  ),
                  )
                ],
              );
            },);
           }, 
        ));
  }

}
