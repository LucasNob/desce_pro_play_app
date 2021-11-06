import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../routes.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({Key? key}) : super(key: key);

  @override
  _UserProfileViewState createState() => _UserProfileViewState();
}

class _UserProfileViewState extends State<UserProfileScreen> {

  @override
  Widget build(BuildContext context) {

    User? currentUser = FirebaseAuth.instance.currentUser;
    CollectionReference userData = FirebaseFirestore.instance.collection('userdata');

    final mediaQuery = MediaQuery.of(context);

    //on user log out
    FirebaseAuth.instance
        .userChanges()
        .listen((User? user) {
      if (user == null)
        Navigator.of(context).pushNamed(AppRoutes.home_login);
      else
        user=null;
    });

    //loads user data
    final loadProfile = FutureBuilder<DocumentSnapshot>(
      future: userData.doc(currentUser!.email).get(),
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text("Erro ao Carregar");
        }
        if (snapshot.hasData && !snapshot.data!.exists) {
          return Text("Dados de usuario inexistente");
        }
        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data = snapshot.data!.data() as Map<String,dynamic>;
          return Container(
            //height: mediaQuery.size.height,
            alignment: Alignment.center,
            child: Column(
              children: [
                Text("User ID: "+ currentUser.uid),
                Text("User Email: "+ currentUser.email!),
                Text("Nome: ${data['first_name']}"),
                Text("Sobrenome: ${data['last_name']}"),
                Text("Telefone: ${data['phone_number']}"),
                Text("Aniversario: ${data['phone_number']}"),
                Text("Sexo: ${data['user_gender']}")
              ],
            ),
          );
        }
        return Text("loading...");
      }
    );

    return Container(
      height: mediaQuery.size.height,
      child: Material(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            loadProfile,
            ElevatedButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              },
            child: Text("LOGOUT")
            ),
          ],
        ),
      ),
    );
  }
}
