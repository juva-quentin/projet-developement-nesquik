import 'package:flutter/material.dart';

class Authscreen extends StatefulWidget {
  final Function(int) onChangedStep;

  Authscreen({Key? key, required this.onChangedStep}) : super(key: key);

  @override
  _AuthscreenState createState() => _AuthscreenState();
}

class _AuthscreenState extends State<Authscreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final RegExp emailRegex = RegExp(r"[a-z0-9\._-]+@[a-z0-9\._-]+\.[a-z]+");

  String _email = '';
  String _mdp = '';

  bool _isSecret = true;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 35.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              // ignore: prefer_const_literals_to_create_immutables
              children: [
                // ignore: prefer_const_literals_to_create_immutables
                RichText(
                    text: TextSpan(
                        text: 'Welcome Back,\n',
                        children: [
                          TextSpan(
                              text: 'Sign in to continue',
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.bold))
                        ],
                        style: const TextStyle(
                            color: Colors.black, fontSize: 30))),
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
                        onChanged: (value) => setState(() => _email = value),
                        validator: (value) =>
                            value == null || !emailRegex.hasMatch(value)
                                ? 'Email non conforme'
                                : null,
                        decoration: InputDecoration(
                          hintText: 'Ex: paul.pifpaf@gmail.com',
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
                        onChanged: (value) => setState(() => _mdp = value),
                        validator: (value) =>
                            value!.length < 6 ? '6 caractères minimum' : null,
                        decoration: InputDecoration(
                          suffixIcon: InkWell(
                            onTap: () =>
                                setState((() => _isSecret = !_isSecret)),
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
                      ElevatedButton(
                        onPressed: !emailRegex.hasMatch(_email) || _mdp == ""
                            ? null
                            : () {
                                if (_formKey.currentState!.validate()) {
                                  print(_email);
                                  widget.onChangedStep(1);
                                }
                              },
                        child: Text('Login'),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
