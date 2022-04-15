import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:projet_developement_nesquik/auth/auth_util.dart';
import 'package:projet_developement_nesquik/flutter_flow/flutter_flow_widgets.dart';

import '../flutter_flow/flutter_flow_theme.dart';
import '../signin/signin_widget.dart';

class ForgotPassword extends StatelessWidget {
  static String id = 'forgot-password';
  final _formKey = GlobalKey<FormState>();
  TextEditingController textController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    final imageSize = 170.0;
    return Scaffold(
      backgroundColor: Color(0xFF72B0EA),
      body: Form(
        key: _formKey,
        child: Stack(children: [
          Positioned(
            left: MediaQuery.of(context).size.width * 0.5 - (imageSize / 2),
            top: MediaQuery.of(context).size.height * 0.1,
            child: Image.asset(
              'assets/images/avatar-planet-ride-big-orange.png',
              width: imageSize,
              height: imageSize,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Entrer votre email',
                  style: TextStyle(fontSize: 30, color: Colors.white),
                ),
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  controller: textController,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Email',
                    icon: Icon(
                      Icons.mail,
                      color: Colors.white,
                    ),
                    errorStyle: TextStyle(color: Colors.white),
                    labelStyle: TextStyle(color: Colors.white),
                    hintStyle: TextStyle(color: Colors.white),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    errorBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Entrer un email';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                FFButtonWidget(
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      await resetPassword(textController.text, context);
                    }
                  },
                  text: 'Envoyer un mail',
                  options: FFButtonOptions(
                    width: 200,
                    height: 50,
                    color: Color.fromARGB(255, 244, 244, 244),
                    textStyle: FlutterFlowTheme.of(context).subtitle2.override(
                          fontFamily: 'Lexend Deca',
                          color: Color.fromARGB(255, 85, 85, 85),
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                    elevation: 3,
                    borderSide: BorderSide(
                      color: Colors.transparent,
                      width: 1,
                    ),
                    borderRadius: 20,
                  ),
                ),
                FlatButton(
                  child: Text('Sign In',
                      style: TextStyle(
                        color: Color.fromARGB(255, 85, 85, 85),
                      )),
                  onPressed: () {
                    Navigator.pop(
                      context,
                    );
                  },
                )
              ],
            ),
          )
        ]),
      ),
    );
  }
}
