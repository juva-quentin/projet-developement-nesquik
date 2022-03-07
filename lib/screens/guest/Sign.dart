import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Sign extends StatefulWidget {
  const Sign({Key? key}) : super(key: key);

  @override
  _SignState createState() => _SignState();
}

class _SignState extends State<Sign> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _email = '';
  String _mdp = '';
  String _gender = '';

  bool _isSecret = true;
  bool _flag = true;

  DateTime _date = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Center(
          child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 35.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text: TextSpan(
                text: 'Welcome,\n',
                children: [
                  TextSpan(
                      text: 'Sign up to continue',
                      style: TextStyle(
                          fontSize: 20,
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold))
                ],
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 30,
                ),
              ),
            ),
            const SizedBox(height: 50.0),
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                // ignore: prefer_const_literals_to_create_immutables
                children: [
                  Text('Email'),
                  SizedBox(
                    height: 20.0,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Ex: paul.pifpaf@gmail.com',
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Text('Pseudo'),
                  SizedBox(
                    height: 20.0,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Ex: PaulTheRider',
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Text('Date de naissance'),
                  SizedBox(
                    height: 20.0,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      suffixIcon: InkWell(
                        onTap: () => showDatePicker(
                          context: context,
                          initialDate: _date,
                          firstDate: DateTime(1930),
                          lastDate: DateTime(2015),
                        ).then((date) {
                          setState(() {
                            _date = date!;
                          });
                        }),
                        child: Icon(Icons.calendar_today),
                      ),
                      hintText: 'Ex: 13/10/2002',
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Text('Mot de passe'),
                  SizedBox(
                    height: 20.0,
                  ),
                  TextFormField(
                    obscureText: _isSecret,
                    validator: (value) =>
                        value!.length < 6 ? '6 caractères minimum' : null,
                    decoration: InputDecoration(
                      suffixIcon: InkWell(
                        onTap: () => setState((() => _isSecret = !_isSecret)),
                        child: Icon(!_isSecret
                            ? Icons.visibility
                            : Icons.visibility_off),
                      ),
                      hintText: 'Ex: Sup3rP4uL',
                    ),
                  ),
                  SizedBox(
                    height: 50.0,
                  ),
                  Text('Genre'),
                  SizedBox(
                    height: 20.0,
                  ),
                  ElevatedButton(
                    onPressed: (() {
                      _gender = 'Homme';
                      print(_gender);
                    }),
                    // ignore: prefer_const_constructors
                    child: ButtonTheme(
                      minWidth: 20.0,
                      height: 20.0,
                      child: Text('H'),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: (() {
                      _gender = 'Femme';
                      print(_gender);
                    }),
                    child: Text('F'),
                  ),
                  ElevatedButton(
                    // ignore: prefer_const_constructors
                    onPressed: () => setState(() => _flag = !_flag),
                    child: Text(_flag ? 'Others' : 'Others'),
                    style: ElevatedButton.styleFrom(
                      primary:
                          _flag ? Colors.blue : Color.fromARGB(87, 0, 119, 255),
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                ],
              ),
            )
          ],
        ),
      )),
    ));
  }
}
