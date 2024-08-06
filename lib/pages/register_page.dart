import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterPage extends StatefulWidget {
  final Function toggleView;
  const RegisterPage({required this.toggleView, super.key});

  @override
  State<RegisterPage>createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (val) => val!.isEmpty ? 'Enter an email' : null,
                onChanged: (val) {
                  setState(() => email = val);
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (val) => val!.length < 6 ? 'Enter a password 6+ chars long' : null,
                onChanged: (val) {
                  setState(() => password = val);
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    try {
                      UserCredential result = await _auth.createUserWithEmailAndPassword(
                        email: email,
                        password: password,
                      );
                      User? user = result.user;
                      if (user != null) {
                        // Handle successful registration and navigate to the sign-in page
                        print('Registration successful');
                        widget.toggleView();
                      }
                    } catch (error) {
                      setState(() {
                        this.error = error.toString();
                      });
                    }
                  }
                },
                child: const Text('Register'),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () => widget.toggleView(),
                child: const Text('Already have an account? Sign in here'),
              ),
              const SizedBox(height: 20),
              Text(
                error,
                style: const TextStyle(color: Colors.red),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
