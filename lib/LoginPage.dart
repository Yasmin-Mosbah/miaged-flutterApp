import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'appData.dart';
import 'MainScreen.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  bool isconnected = false;
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Center(child: Text('MIAGED BROWN')),
          automaticallyImplyLeading: false,
        ),
        body: Padding(
            padding: EdgeInsets.all(10),
            child: ListView(
              children: <Widget>[
                Container(
                  height: 250.0,
                  width: 200.0,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/brownhead.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  child: TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Login',
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: TextField(
                    obscureText: true,
                    controller: passwordController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Password',
                    ),
                  ),
                ),
                Container(
                    height: 50,
                    padding: EdgeInsets.fromLTRB(100, 10, 100, 0),
                    child: RaisedButton(
                      textColor: Colors.white,
                      color: Colors.brown,
                      child: Text('Se connecter'),
                      onPressed: () {
                        checkinginfo(
                            nameController.text, passwordController.text);
                      },
                    )),
              ],
            )));
  }

  void checkinginfo(String log, String pas) async {
    FirebaseFirestore.instance
        .collection('login')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        print("----------------------------------------");
        print("login renseigner :" + log);
        print("password renseigner :" + pas);
        if (log == doc["id"] && pas == doc["password"]) {
          isconnected = true;
          print(isconnected);
          appData.userLogin = doc["id"];
          appData.userAdresse = doc["adresse"];
          appData.userBirth = doc["birthday"];
          appData.userVille = doc["ville"];
          appData.userPostalCode = doc["postalcode"];
          appData.userPassword = doc["password"];
          appData.userID = doc.id;
          print("Connection...");
          return Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MainScreen()),
          );
        }
      });
      if (isconnected == true) {
        isconnected = false;
        return Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MainScreen()),
        );
      } else {
        showDialog<void>(
          context: context,
          barrierDismissible: false, // user must tap button!
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Mon petit Brownie a du mal a se connecter ?'),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    Container(
                      height: 170.0,
                      width: 50.0,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/browncry.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: Text('ZÉPARTI'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    });
  }
}
