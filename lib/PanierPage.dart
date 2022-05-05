import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:miaged/appData.dart';
import 'Produit.dart';
import 'package:fluttertoast/fluttertoast.dart';

class PanierPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new PanierPageState();
}

class PanierPageState extends State<PanierPage> {
  final List<Produit> itemsShop = <Produit>[];

  @override
  Widget build(BuildContext context) {
    double total = 0.0;
    itemsShop.forEach((produit) => total += double.parse(produit.prix));

    return Scaffold(
      body: new Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: SizedBox(
                  height: 580,
                  child: _buildSuggestions(context),
                ),
              ),
            ],
          ),
          Expanded(child: Divider()),
          Expanded(
            child: SizedBox(
              child: Text("Total : ${total}"),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestions(BuildContext context) {
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
            else if (snapshot.data.length > 0)
              return itemsList(context);
            else
              return Center(
                  child: Container(
                child: Text("PANIER VIDE"),
              ));
        }
      },
    );
  }

  Widget itemsList(BuildContext context) {
    return new ListView.builder(
      itemCount: itemsShop.length,
      itemBuilder: (BuildContext context, int index) {
        return _itemshop(itemsShop[index]);
      },
    );
  }

  Future<List<Produit>> allItems() async {
    final QuerySnapshot qs = await FirebaseFirestore.instance
        .collection('login')
        .doc(
          appData.userID,
        )
        .collection("panier")
        .get();
    for (final DocumentSnapshot ds in qs.docs) {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('shop').get();

      querySnapshot.docs.forEach((doc) {
        if (ds["id"] == doc.id) {
          var img = doc["img"];
          var prix = doc["prix"];
          var taille = doc["taille"];
          var titre = doc["titre"];
          var categorie = doc["categorie"];
          var id = ds.id;
          var produit = Produit(img, prix, taille, titre, id, categorie);
          if (!itemsShop.contains(produit))
            setState(() => itemsShop.add(produit));
        }
      });
    }
    return itemsShop;
  }

  Widget _itemshop(Produit produit) {
    return Card(
      elevation: 2,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            leading: Image.network(
              produit.img,
              width: 70,
              fit: BoxFit.cover,
            ),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                removeProduitInBasket(produit.id, produit.prix);
                showToastMessage(produit.titre + " est supprimé du panier");
                setState(() => itemsShop.remove(produit));
              },
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(produit.titre),
                Text(produit.prix + "\$"),
              ],
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Taille : " + produit.taille),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> removeProduitInBasket(String iditem, String prix) async {
    await FirebaseFirestore.instance
        .collection('login')
        .doc(
          appData.userID,
        )
        .collection("panier")
        .doc(iditem)
        .delete();
    setState(() => {});
  }

  void showToastMessage(String message) {
    Fluttertoast.showToast(
        msg: message, //message to show toast
        toastLength: Toast.LENGTH_LONG, //duration for message to show
        gravity: ToastGravity.CENTER, //where you want to show, top, bottom
        timeInSecForIosWeb: 1,
        textColor: Colors.white, //message text color
        fontSize: 16.0 //message font size
        );
  }
}
