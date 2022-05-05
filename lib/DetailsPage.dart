import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:miaged/appData.dart';
import 'package:icon_shadow/icon_shadow.dart';
import 'package:fluttertoast/fluttertoast.dart';

class DetailsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new DetailsPageState();
}

class DetailsPageState extends State<DetailsPage> {
  var id = "";
  var img = "";
  var prix = "";
  var taille = "";
  var titre = "";
  var categorie = "";
  var isInBasket = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: getInfo(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return Container();
            case ConnectionState.waiting:
              return Container();
            default:
              if (snapshot.hasError)
                return new Text('Error: ${snapshot.error}');
              else
                return _item();
          }
        },
      ),
    );
  }

  Future<void> getInfo() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('shop').get();

    for (var doc in querySnapshot.docs) {
      if (appData.itemID == doc.id) {
        id = doc.id;
        img = doc["img"];
        prix = doc["prix"];
        taille = doc["taille"];
        titre = doc["titre"];
        categorie = doc["categorie"];
        break;
      }
    }
    querySnapshot = await FirebaseFirestore.instance
        .collection('login')
        .doc(appData.userID)
        .collection('panier')
        .get();

    for (var doc in querySnapshot.docs) {
      if (doc.id == id) {
        isInBasket = true;
        break;
      }
    }
  }

  Widget _item() {
    double height = MediaQuery.of(context).size.height;
    return Stack(
      children: <Widget>[
        Center(
            child: Image.network(img,
                width: double.infinity,
                height: height * 1.3,
                fit: BoxFit.cover)),
        Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
          colors: [Color(0xFFdad9d5), Color(0xFFdcd9d2).withOpacity(.1)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [0.0, 0.2],
          tileMode: TileMode.clamp,
        ))),
        Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
          colors: [Color(0xFFdad9d5), Color(0xFFdcd9d2).withOpacity(.1)],
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          stops: [0.0, 0.2],
          tileMode: TileMode.clamp,
        ))),
        Positioned(
            top: 40,
            left: 20,
            right: 20,
            child: Row(children: <Widget>[
              IconButton(
                icon: IconShadowWidget(
                  Icon(
                    Icons.arrow_back_ios,
                    color: Colors.brown,
                  ),
                  //shadowColor: Colors.black,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ])),
        Column(
          children: <Widget>[
            Expanded(
              child: Container(),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 30),
              height: 100,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        ConstrainedBox(
                            constraints: BoxConstraints(
                              maxWidth: 400,
                            ),
                            child: Text(titre,
                                style: TextStyle(
                                  fontSize: 25,
                                  fontFamily: "Montserrat",
                                  fontWeight: FontWeight.w600,
                                ))),
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              Text(prix + "\$",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontFamily: "Montserrat",
                                    fontWeight: FontWeight.w700,
                                  ))
                            ])
                      ]),
                  Expanded(child: Divider()),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "Marque : " + categorie,
                            style: TextStyle(
                              fontSize: 15,
                              fontFamily: "Montserrat",
                              fontWeight: FontWeight.w200,
                            ),
                          ),
                          Text(
                            "Taille : " + taille,
                            style: TextStyle(
                              fontSize: 15,
                              fontFamily: "Montserrat",
                              fontWeight: FontWeight.w200,
                            ),
                          ),
                        ],
                      ),
                      ElevatedButton(
                        onPressed: isInBasket
                            ? null
                            : () {
                                addProduitInBasket();
                                showToastMessage(titre + " ajouté au panier");
                                setState(() {
                                  isInBasket = true;
                                });
                                //removeProduitInBasket();
                              },
                        child: Icon(Icons.shopping_basket_outlined),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Container(child: Divider()),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> addProduitInBasket() async {
    return FirebaseFirestore.instance
        .collection('login')
        .doc(appData.userID)
        .collection("panier")
        .doc(appData.itemID)
        .set({"id": appData.itemID});
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
