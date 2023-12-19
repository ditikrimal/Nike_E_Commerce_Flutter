// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nike_e_commerce/components/AuthComponents/profile_list_tile.dart';
import 'package:shimmer/shimmer.dart';

class ProfilePageView extends StatefulWidget {
  final bool isLoading;

  const ProfilePageView({Key? key, required this.isLoading}) : super(key: key);

  @override
  State<ProfilePageView> createState() => _ProfilePageViewState();
}

class _ProfilePageViewState extends State<ProfilePageView> {
  String userName = '';
  final user = FirebaseAuth.instance.currentUser!;
  @override
  void initState() {
    super.initState();
    userName = FirebaseAuth.instance.currentUser!.displayName!;
  }

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
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Stack(children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: Colors.grey[400],
            child: Text(
              userName.isNotEmpty ? userName[0] : '',
              style: TextStyle(
                fontSize: 40,
                color: Colors.white,
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: InkWell(
              onTap: () async {},
              child: CircleAvatar(
                radius: 15,
                backgroundColor: Colors.black,
                child: Icon(
                  Icons.add_a_photo_outlined,
                  color: Colors.white,
                  size: 18,
                ),
              ),
            ),
          )
        ]),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome, ',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
            Text(
              userName.toUpperCase(),
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            )
          ],
        ),
        SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            children: [
              ProfileListTile('Account', Icons.person_outline_rounded, () {}),
              ProfileListTile('Orders', Icons.shopping_bag_outlined, () {}),
              ProfileListTile(
                  'Help & Support', Icons.help_outline_rounded, () {}),
              ProfileListTile('About', Icons.info_outline_rounded, () {}),
              ProfileListTile('Settings', Icons.settings_outlined, () {}),
              ProfileListTile('Logout', Icons.logout, () {
                logoutDialog();
              }),
            ],
          ),
        ),
        SizedBox(height: 40)
      ],
    );
  }

  logoutDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.grey[300],
          title: Text(
            'Confirm Logout',
            style: TextStyle(
              color: Colors.black,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            'Are you sure you want to logout?',
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
                Navigator.pop(context);
              },
              child: Text(
                'Logout',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                ),
              ),
            ),
          ],
        );
      },
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
