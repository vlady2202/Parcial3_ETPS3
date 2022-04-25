import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:parcial3/models/StarsWars.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(ApiWeb());
}

class ApiWeb extends StatefulWidget {
  @override
  State<ApiWeb> createState() => _ApiWebState();
}

class _ApiWebState extends State<ApiWeb> {
  late Future<List<StarsWars>> _listadoStarsWars;
  Future<List<StarsWars>> _getStarsWars() async {
    final response =
        await http.get(Uri.parse("https://swapi.dev/api/planets/"));
    String body;
    List<StarsWars> lista = [];
    if (response.statusCode == 200) {
      print(response.body);
      body = utf8.decode(response.bodyBytes);
      final jsonData = jsonDecode(body);
      for (var item in jsonData["results"]) {
        lista.add(StarsWars(
            item["name"],
            item["diameter"],
            item["population"],
            item["climate"],
            item["url"],
            "https://starwars-visualguide.com/assets/img/planets/" +
                item["url"].replaceAll(new RegExp(r'[^0-9]'), '') +
                ".jpg"));
        //print(item["url"].replaceAll(new RegExp(r'[^0-9]'),''));
        //print("https://starwars-visualguide.com/assets/img/characters/"+item["url"].replaceAll(new RegExp(r'[^0-9]'),'')+".jpg");
        //source images: "https://starwars-visualguide.com/#/"
      }
    } else {
      throw Exception("Falla en conexion");
    }
    return lista;
  }

  @override
  void initState() {
    super.initState();
    _listadoStarsWars = _getStarsWars();
  }

  @override
  Widget build(BuildContext context) {
    var futureBuilder = FutureBuilder(
      future: _listadoStarsWars,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView(
            children: _listadoStarsWarss(snapshot.data),
          );
        } else if (snapshot.hasError) {
          print(snapshot.error);
          return Text("Error");
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Webservice',
      home: Scaffold(
          appBar: AppBar(
            title: Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(
                    FeatherIcons.arrowLeft,
                    color: Colors.black,
                  ),
                  Text(
                    'STARS WARS',
                    style: TextStyle(color: Colors.black),
                  ),
                ],
              ),
            ),
          ),
          body: futureBuilder),
    );
  }

  List<Widget> _listadoStarsWarss(data) {
    List<Widget> startwarsObject = [];

    for (var itempk in data) {
      startwarsObject.add(Card(
        elevation: 2.0,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            // Text(itempk.num),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.all(2.0),
              height: 250,
              width: 200,
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: NetworkImage(itempk.img), fit: BoxFit.cover),
              ),
            ),
            SizedBox(height: 10),
            Text("Nombre: " + itempk.name),
            SizedBox(height: 5),
            Text("Diametro: " + itempk.diameter),
            SizedBox(height: 5),
            Text("Población: " + itempk.population),
            SizedBox(height: 5),
            Text("Clima: " + itempk.climate),
            SizedBox(height: 15),
          ],
        ),
      ));
    }
    return startwarsObject;
  }
}
