// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously

import 'package:NikeStore/authHandle/googleAuth_handle.dart';
import 'package:NikeStore/authHandle/login_handle.dart';
import 'package:NikeStore/components/AuthComponents/auth_button.dart';
import 'package:NikeStore/components/AuthComponents/auth_textfield.dart';
import 'package:NikeStore/components/alert_snackbar.dart';
import 'package:NikeStore/pages/UserAuth/signup_page.dart';
import 'package:NikeStore/pages/profile_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:top_snackbar_flutter/top_snack_bar.dart';

final GoogleAuthHandle _authService = GoogleAuthHandle();

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void initState() {
    super.initState();
    _emailController.text = '';
    _passwordController.text = '';
  }

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[300],
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.close),
          color: Colors.black,
          iconSize: 35,
        ),
      ),
      backgroundColor: Colors.grey[300],
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(children: [
                Image.asset(
                  'lib/asset/images/NikeLogo.png',
                  width: 120,
                ),
                SizedBox(height: 50),
                Text(
                  'Welcome back',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
                AuthTextField(
                  labelText: 'Email',
                  controller: _emailController,
                ),
                SizedBox(height: 20),
                AuthTextField(
                  labelText: 'Password',
                  obScureText: true,
                  controller: _passwordController,
                ),
                SizedBox(height: 20),
                AuthButton(
                  onTap: () {
                    LoginHandle().loginUser(
                      context: context,
                      email: _emailController.text,
                      password: _passwordController.text,
                    );
                  },
                  buttonLabel: 'Sign In',
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Not a member?',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SignupPage()));
                      },
                      child: Text(
                        'Sign Up',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ]),
              Column(children: [
                Row(
                  children: [
                    Expanded(
                      child: Divider(
                        color: Colors.grey[400],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        'Or continue with',
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: 15,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        color: Colors.grey[400],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        // Trigger Google Sign-In
                        User? user = await _authService.signInWithGoogle();

                        if (user != null) {
                          showTopSnackBar(
                            Overlay.of(context),
                            CustomAlertBar.success(
                              messageStatus: 'Success',
                              message: 'Logged in successfully',
                            ),
                          );
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProfilePage(),
                            ),
                          );
                        } else {
                          showTopSnackBar(
                            Overlay.of(context),
                            CustomAlertBar.error(
                              messageStatus: 'Error',
                              message: 'Error signing with google',
                            ),
                          );
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Image.asset(
                          'lib/asset/images/Google.png',
                          width: 60,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ]),
            ],
          ),
        ),
      ),
    );
  }
}
