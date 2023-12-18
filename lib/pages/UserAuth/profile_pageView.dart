// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ProfilePageView extends StatefulWidget {
  final bool isLoading;

  const ProfilePageView({Key? key, required this.isLoading}) : super(key: key);

  @override
  State<ProfilePageView> createState() => _ProfilePageViewState();
}

class _ProfilePageViewState extends State<ProfilePageView> {
  String userName = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: Colors.grey[300],
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios_new_rounded),
          color: Colors.black,
          iconSize: 35,
        ),
      ),
      body: widget.isLoading ? _buildSkeletonLoading() : _build(),
    );
  }

  Widget _build() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: Colors.black,
            child: Text(
              userName.isNotEmpty ? userName[0] : '',
              style: TextStyle(
                fontSize: 40,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(height: 20),
          Text(
            'Welcome, $userName',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  shimmerGradient() {
    return LinearGradient(
      colors: [Colors.grey[300]!, Colors.grey[100]!],
      begin: Alignment(-1.0, -1.0),
      end: Alignment(1.0, 1.0),
    );
  }

  Widget _buildSkeletonLoading() {
    return Container(
      color: Colors.grey[300],
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Shimmer effect can be added here for loading state
            Shimmer(
              gradient: shimmerGradient(),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(50),
                ),
                height: 100,
                width: 100,
              ),
            ),
            SizedBox(height: 20),

            Shimmer(
              gradient: shimmerGradient(),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(10),
                ),
                height: 20,
                width: 200,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
