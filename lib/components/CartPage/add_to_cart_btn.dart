// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AddToCartButton extends StatefulWidget {
  final Function onTap;
  final bool disableAnimation; // New parameter to disable animation

  const AddToCartButton({
    Key? key,
    required this.onTap,
    this.disableAnimation = false, // Default value is false
  }) : super(key: key);

  @override
  _AddToCartButtonState createState() => _AddToCartButtonState();
}

class _AddToCartButtonState extends State<AddToCartButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isButtonDisabled = false;

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
              if (isLoggedIn()) {
                widget.onTap();

                if (!widget.disableAnimation) {
                  _controller.forward();

                  setState(() {
                    _isButtonDisabled = true;
                  });

                  await Future.delayed(Duration(seconds: 3));

                  if (mounted) {
                    setState(() {
                      _isButtonDisabled = false;
                      _controller.reset();
                    });
                  }
                }
              } else {
                Navigator.pushNamed(context, '/login');
              }
            },
      child: Container(
        padding: EdgeInsets.all(17),
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
              angle:
                  widget.disableAnimation ? 0 : _animation.value * (3.14 * 2),
              child: Icon(
                _animation.isCompleted ? Icons.check : Icons.add,
                size: 32,
                color: Colors.white,
              ),
            );
          },
        ),
      ),
    );
  }

  bool isLoggedIn() {
    final user = FirebaseAuth.instance.currentUser;
    return user != null;
  }
}
