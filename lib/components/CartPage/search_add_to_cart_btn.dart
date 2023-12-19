// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AddToCartButtonSearch extends StatefulWidget {
  final Function onTap;

  const AddToCartButtonSearch({
    Key? key,
    required this.onTap,
  }) : super(key: key);

  @override
  _AddToCartButtonSearchState createState() => _AddToCartButtonSearchState();
}

class _AddToCartButtonSearchState extends State<AddToCartButtonSearch>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isButtonDisabled = false; // Flag to track button state

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );

    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _isButtonDisabled
          ? null
          : () async {
              // Check if the user is logged in before triggering animation
              if (isLoggedIn()) {
                // Perform the addToCart action
                widget.onTap();

                // Trigger the animation
                _controller.forward();

                // Disable the button to prevent further interactions
                setState(() {
                  _isButtonDisabled = true;
                });

                // Wait for 5 seconds and then reset the button state
                await Future.delayed(Duration(seconds: 3));

                // Check if the widget is still in the tree before calling setState
                if (mounted) {
                  // Reset button state
                  setState(() {
                    _isButtonDisabled = false;
                    _controller.reset();
                  });
                }
              } else {
                // Navigate to the login page if not logged in
                Navigator.pushNamed(context, '/login');
              }
            },
      child: Container(
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: _isButtonDisabled ? Colors.grey : Colors.black,
          borderRadius: BorderRadiusDirectional.only(
            topStart: Radius.circular(15),
            bottomEnd: Radius.circular(15),
          ),
        ),
        child: AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return Transform.rotate(
              angle: _animation.value * (3.14 * 2), // Full rotation
              child: Icon(
                _animation.isCompleted ? Icons.check : Icons.add,
                size: 18,
                color: Colors.white,
              ),
            );
          },
        ),
      ),
    );
  }

  // Example function to check if the user is logged in
  bool isLoggedIn() {
    final user = FirebaseAuth.instance.currentUser;
    return user != null;
  }
}
