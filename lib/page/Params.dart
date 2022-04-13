import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:projet_developement_nesquik/auth/auth_util.dart';
import 'package:projet_developement_nesquik/backend/database.dart';

import '../auth/firebase_user_provider.dart';
import '../home_page/home_page_widget.dart';

class Params extends StatefulWidget {
  const Params({Key key}) : super(key: key);

  @override
  State<Params> createState() => _ParamsState();
}

class _ParamsState extends State<Params> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF72B0EA),
          title: Text("Paramètres"),
        ),
        body: UserInformation());
  }
}

class UserInformation extends StatefulWidget {
  @override
  _UserInformationState createState() => _UserInformationState();
}

class _UserInformationState extends State<UserInformation> {
  bool showPassword = false;
  final Stream<QuerySnapshot<Map<String, dynamic>>> _usersStream =
      FirebaseFirestore.instance.collection('users').snapshots();
  TextEditingController pseudoController;
  TextEditingController emailController;
  TextEditingController passwordController;
  TextEditingController objectifController;
  DatabaseService database = DatabaseService();
  @override
  void initState() {
    pseudoController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    objectifController = TextEditingController();

    super.initState();
  }

  @override
  Widget buildTextField(String labelText, String placeholder,
      bool isPasswordTextField, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 35.0),
      child: TextField(
        controller: controller,
        obscureText: isPasswordTextField ? showPassword : false,
        decoration: InputDecoration(
            suffixIcon: isPasswordTextField
                ? IconButton(
                    onPressed: () {
                      setState(() {
                        showPassword = !showPassword;
                      });
                    },
                    icon: Icon(
                      Icons.remove_red_eye,
                      color: Colors.grey,
                    ),
                  )
                : null,
            contentPadding: EdgeInsets.only(bottom: 3),
            labelText: labelText,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            hintText: placeholder,
            hintStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.normal,
              color: Color.fromARGB(255, 168, 168, 168),
            )),
      ),
    );
  }

  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.user.uid)
          .get(),
      builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError)
          return Center(
            child: Text(snapshot.hasError.toString()),
          );
        return snapshot.hasData
            ? Container(
                padding: EdgeInsets.only(left: 16, top: 25, right: 16),
                child: GestureDetector(
                  onTap: () {
                    FocusScope.of(context).unfocus();
                  },
                  child: ListView(
                    children: [
                      SizedBox(
                        height: 15,
                      ),
                      Center(
                        child: Stack(
                          children: [
                            Container(),
                            Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  height: 40,
                                  width: 40,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      width: 4,
                                      color: Theme.of(context)
                                          .scaffoldBackgroundColor,
                                    ),
                                    color: Color(0xFF72B0EA),
                                  ),
                                  child: Icon(
                                    Icons.edit,
                                    color: Colors.white,
                                  ),
                                )),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 35,
                      ),
                      buildTextField("Pseudo", snapshot.data["pseudo"], false,
                          pseudoController),
                      buildTextField("E-mail", snapshot.data["email"], false,
                          emailController),
                      buildTextField(
                          "Objectif de la semaine (km)",
                          snapshot.data["objectif"].toString(),
                          false,
                          objectifController),
                      ElevatedButton(
                        onPressed: () {
                          var pseudo;
                          var email;
                          var password;
                          var objectif;
                          setState(() {
                            pseudo = pseudoController.text;
                            email = emailController.text;
                            password = pseudoController.text;
                            objectif = objectifController.text;
                          });
                          print("ok" + pseudo + email + password + objectif);
                          if (pseudo == "") {
                            pseudo = snapshot.data["pseudo"];
                          }
                          if (email == "") {
                            email = snapshot.data["email"];
                          }
                          if (objectif == "") {
                            objectif = snapshot.data["objectif"].toString();
                          }
                          database.UpdateProfile(
                              pseudo, email, objectif, context);
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Color(0xFF72B0EA),
                        ),
                        child: Text(
                          "SAUVEGARDER",
                          style: TextStyle(
                              fontSize: 19,
                              letterSpacing: 2.2,
                              color: Colors.white),
                        ),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          resetPassword(snapshot.data["email"], context);
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Color.fromARGB(255, 6, 167, 164),
                        ),
                        child: Text(
                          "CHANGER MOT DE PASSE",
                          style: TextStyle(
                              fontSize: 19,
                              letterSpacing: 2.2,
                              color: Colors.white),
                        ),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          database.DeleteUser(context);
                          await Navigator.push(
                              context,
                              PageTransition(
                                type: PageTransitionType.bottomToTop,
                                duration: Duration(milliseconds: 300),
                                reverseDuration: Duration(milliseconds: 300),
                                child: HomePageWidget(),
                              ));
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Color.fromARGB(255, 255, 30, 0),
                        ),
                        child: Text(
                          "SUPPRIMER VOTRE COMPTE",
                          style: TextStyle(
                              fontSize: 19,
                              letterSpacing: 2.2,
                              color: Colors.white),
                        ),
                      )
                    ],
                  ),
                ),
              )
            : Container();
      },
    );
  }
}
