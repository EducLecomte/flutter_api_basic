import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: const MyHomePage(title: 'Flutter Demo PokeApi'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Map<String, dynamic> dataMap = new Map();
  bool recupDataBool = false;
  int id = 1;

  void recupData() async {
    await recupDataJson();
    if (mounted) {
      setState(() {
        recupDataJson;
      });
    }
  }

  Future<void> recupDataJson() async {
    String url = "https://pokeapi.co/api/v2/pokemon/" + this.id.toString();
    var reponse = await http.get(Uri.parse(url));
    if (reponse.statusCode == 200) {
      dataMap = convert.jsonDecode(reponse.body);
      recupDataBool = true;
    }
  }

  Widget afficheData() {
    Column contenu = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.empty(growable: true),
    );

    if (recupDataBool) {
      Map<String, dynamic> spritesData = dataMap['sprites'];
      //contenu.children.add(Image.network(spritesData['front_default'].toString()));
      contenu.children.add(Image.network(spritesData['other']['official-artwork']['front_default'].toString()));
      List<dynamic> formsData = dataMap['forms'];
      contenu.children.add(Text("Name: " + formsData[0]['name'].toString()));
      contenu.children.add(Text("Height: " + dataMap['height'].toString()));
      contenu.children.add(Text("Weight: " + dataMap['weight'].toString()));
    }
    Center affichage = Center(child: contenu);
    return affichage;
  }

  Widget attente() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const <Widget>[
          Text('En attente des données', style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
          CircularProgressIndicator(),
        ],
      ),
    );
  }

  decrement() {
    setState(() {
      if (id > 1) {
        id--;
        recupDataBool = false;
      }
    });
  }

  increment() {
    setState(() {
      if (id < 151) {
        id++;
        recupDataBool = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!recupDataBool) {
      recupData();
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: recupDataBool ? afficheData() : attente(),
      floatingActionButton: FloatingActionButton(
        child: Text("Id: " + id.toString()),
        onPressed: null,
      ),
      /*floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
       bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        color: Colors.red,
        child: Container(
          height: 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              IconButton(
                icon: const Icon(
                  Icons.navigate_before,
                  color: Colors.white,
                ),
                onPressed: decrement,
              ),
              IconButton(
                icon: const Icon(
                  Icons.navigate_next,
                  color: Colors.white,
                ),
                onPressed: increment,
              ),
            ],
          ),
        ),
      ), */
    );
  }
}
