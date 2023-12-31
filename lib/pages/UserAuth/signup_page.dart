// ignore_for_file: prefer_const_constructors

import 'package:NikeStore/authHandle/register_handle.dart';
import 'package:NikeStore/components/AuthComponents/auth_button.dart';
import 'package:NikeStore/components/AuthComponents/auth_textfield.dart';
import 'package:flutter/material.dart';

class SignupPage extends StatefulWidget {
  SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  @override
  void initState() {
    super.initState();
    _fullNameController.text = '';
    _emailController.text = '';
    _passwordController.text = '';
  }

  final TextEditingController _fullNameController = TextEditingController();

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
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Image.asset(
                'lib/asset/images/NikeLogo.png',
                width: 120,
              ),
              SizedBox(height: 30),
              Column(children: [
                Text(
                  'Setup your account',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),

                AuthTextField(
                  labelText: 'Full Name',
                  controller: _fullNameController,
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
                //Create a full width Login Button
                AuthButton(
                  onTap: () {
                    RegisterHandle().registerUser(
                      name: _fullNameController.text,
                      email: _emailController.text,
                      password: _passwordController.text,
                      context: context,
                    );
                  },
                  buttonLabel: 'Sign up',
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account?',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Sign In',
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
              SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
