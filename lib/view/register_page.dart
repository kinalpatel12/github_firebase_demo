import 'package:firebase_prectice_app/service_page/facebook_auth_service.dart';
import 'package:firebase_prectice_app/service_page/firebase_auth_service.dart';
import 'package:firebase_prectice_app/service_page/google_sign_in.dart';
import 'package:flutter/material.dart';

import 'home_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final email = TextEditingController();
  final password = TextEditingController();
  final _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Form(
          key: _formkey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: email,
                decoration: InputDecoration(hintText: 'Email'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'email can not be empty';
                  }
                },
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: password,
                decoration: InputDecoration(hintText: 'Password'),
                validator: (value) {
                  if (value!.length < 6) {
                    return 'password must be at lest 6 digit';
                  } else if (value!.isEmpty) {
                    return 'password can not be empty';
                  }
                },
              ),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                  onPressed: () {
                    if (_formkey.currentState!.validate()) {
                      FirebaseAuthService.registerUser(
                              email: email.text.trim(),
                              password: password.text.trim())
                          .then(
                        (value) => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HomePage(),
                          ),
                        ),
                      );
                    }
                  },
                  child: Text('Register')),
              SizedBox(
                height: 20,
              ),
              MaterialButton(
                onPressed: () {
                  signInWithGoogle().then(
                    (value) => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomePage(),
                      ),
                    ),
                  );
                },
                height: 50,
                minWidth: 360,
                color: Colors.grey.shade300,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
                child: Text('Sign in with Google'),
              ),
              SizedBox(
                height: 20,
              ),
              MaterialButton(
                onPressed: () {
                  FaceBookAuthService.facebookLogin().then(
                    (value) => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomePage(),
                      ),
                    ),
                  );
                },
                minWidth: 360,
                height: 50,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
                color: Colors.grey.shade300,
                child: Text('Sign in with facebook'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
