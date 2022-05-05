import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'appData.dart';
import 'DetailsPage.dart';
import 'Produit.dart';

class BoutiquePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _BoutiquePageState();
}

class _BoutiquePageState extends State<BoutiquePage> {
  final List<Produit> items = <Produit>[];
  List<Produit> catitems = <Produit>[];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Color(0xFF3E2723),
            toolbarHeight: 75,
            bottom: TabBar(
              unselectedLabelColor: Colors.white,
              labelColor: Color(0xFFFFEB3B),
              indicatorColor: Colors.yellow,
              tabs: [
                Tab(icon: Text("All")),
                Tab(icon: Text("PUCCI")),
                Tab(icon: Text("PIOR")),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/brown.png'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: _buildSuggestions(),
              ),
              Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/sally.png'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: _buildSuggestionsCat("PUCCI"),
              ),
              Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/cony.png'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: _buildSuggestionsCat("PIOR"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<List<Produit>> allItems() async {
    FirebaseFirestore.instance
        .collection('shop')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        var img = doc["img"];
        var prix = doc["prix"];
        var taille = doc["taille"];
        var titre = doc["titre"];
        var categorie = doc["categorie"];
        var id = doc.id;
        var produit = Produit(img, prix, taille, titre, id, categorie);
        if (!items.contains(produit)) setState(() => items.add(produit));
      });
    });
    return items;
  }

  Future<List<Produit>> catItems(String categorie) async {
    final List<Produit> itemscat = <Produit>[];
    items.forEach((produit) {
      if (produit.categorie == categorie) itemscat.add(produit);
    });
    return itemscat;
  }

  Widget _item(Produit produit) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: new InkWell(
        onTap: () {
          appData.itemID = produit.id;
          return Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => DetailsPage()));
        },
        child: Column(
          children: [
            ListTile(
              title: Text("[" + produit.categorie + "] " + produit.titre),
              trailing: Text(produit.prix + "\$"),
              subtitle: Text(
                "Taille : " + produit.taille,
                style: TextStyle(color: Colors.black.withOpacity(0.6)),
              ),
            ),
            Image.network(
              produit.img,
              height: 300,
              width: 500,
              fit: BoxFit.cover,
              alignment: Alignment.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget shopItemsList(List<Produit> produits) {
    return new ListView.builder(
      itemCount: produits.length,
      itemBuilder: (BuildContext context, int index) {
        return _item(produits[index]);
      },
    );
  }

  Widget _buildSuggestions() {
    return new FutureBuilder(
      future: allItems(),
      builder: (BuildContext context, AsyncSnapshot<List<Produit>> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
          case ConnectionState.active:
            return Container();
          case ConnectionState.done:
          default:
            if (snapshot.hasError)
              return new Text('Error: ${snapshot.error}');
            else
              return shopItemsList(snapshot.data);
        }
      },
    );
  }

  Widget _buildSuggestionsCat(String categorie) {
    return new FutureBuilder(
      future: catItems(categorie),
      builder: (BuildContext context, AsyncSnapshot<List<Produit>> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
          case ConnectionState.active:
            return Container();
          case ConnectionState.done:
          default:
            if (snapshot.hasError)
              return new Text('Error: ${snapshot.error}');
            else
              return shopItemsList(snapshot.data);
        }
      },
    );
  }
}
