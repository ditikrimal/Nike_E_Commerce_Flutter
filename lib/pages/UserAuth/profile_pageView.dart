// ignore_for_file: prefer_const_constructors
import 'dart:io';
import 'package:NikeStore/components/ShopPage/shoes_list.dart';
import 'package:NikeStore/components/back_button.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:NikeStore/components/AuthComponents/profile_list_tile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shimmer/shimmer.dart';

class ProfilePageView extends StatefulWidget {
  bool isLoading;
  ProfilePageView({Key? key, this.isLoading = false}) : super(key: key);

  @override
  State<ProfilePageView> createState() => _ProfilePageViewState();
}

class _ProfilePageViewState extends State<ProfilePageView> {
  XFile _imageFile = XFile('');
  final ImagePicker profilePicker = ImagePicker();

  String userName = '';
  String photoUrl = '';
  final user = '';
  @override
  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      userName = user.displayName ?? '';
      photoUrl = user.photoURL ?? '';
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        toolbarHeight: 75,
        backgroundColor: Colors.grey[300],
        leading: backArrow(context),
      ),
      body: widget.isLoading ? _buildSkeleton() : _build(),
    );
  }

  Widget _build() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Stack(
          children: [
            CircleAvatar(
              radius: 60,
              backgroundColor: Colors.grey[400],
              child: FutureBuilder(
                future: loadImage(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return ShimmerImage();
                  } else if (snapshot.connectionState == ConnectionState.done) {
                    return ClipOval(
                        child: Image(
                      image: snapshot.data as ImageProvider,
                      width: 120,
                      height: 120,
                      fit: BoxFit.cover,
                    ));
                  } else {
                    return ShimmerImage();
                  }
                },
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: InkWell(
                onTap: () async {
                  showModalBottomSheet(
                    context: context,
                    builder: (builder) => imagePickOptions(),
                  );
                },
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
          ],
        ),
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
                  'My Wishlist', Icons.favorite_border_outlined, () {}),
              ProfileListTile(
                  'Help & Support', Icons.help_outline_rounded, () {}),
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

  Widget _buildSkeleton() {
    return Shimmer(
      gradient: shimmerGradient(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 60,
                backgroundColor: Colors.grey[400],
                child: ShimmerImage(),
              ),
            ],
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 40,
                width: 250,
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Column(
              children: [
                ProfileListTile('Orders', Icons.shopping_bag_outlined, () {}),
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
      ),
    );
  }

  Widget ShimmerImage() {
    return Shimmer(
      gradient: shimmerGradient(),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[400],
          borderRadius: BorderRadius.circular(100),
        ),
      ),
    );
  }

  Future<ImageProvider<Object>> loadImage() async {
    if (photoUrl.isNotEmpty) {
      try {
        final image = NetworkImage(photoUrl);
        return image;
      } catch (e) {
        return AssetImage('lib/asset/images/UserPlaceholder.png');
      }
    } else {
      return AssetImage('lib/asset/images/UserPlaceholder.png');
    }
  }

  Widget imagePickOptions() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          margin: EdgeInsets.only(top: 20),
          child: Text(
            'Choose Profile Picture',
            style: TextStyle(
              color: Colors.black,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          GestureDetector(
            onTap: () {
              getPhoto(ImageSource.camera);
              Navigator.pop(context);
            },
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              height: 80,
              width: MediaQuery.of(context).size.width / 2.5,
              decoration: BoxDecoration(
                color: Colors.grey[400],
                borderRadius: BorderRadius.circular(50),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(
                    Icons.camera_alt_rounded,
                    color: Colors.black,
                    size: 30,
                  ),
                  Text(
                    'Open Camera',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              getPhoto(ImageSource.gallery);
              Navigator.pop(context);
            },
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              height: 80,
              width: MediaQuery.of(context).size.width / 2.5,
              decoration: BoxDecoration(
                color: Colors.grey[400],
                borderRadius: BorderRadius.circular(50),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(
                    Icons.camera_alt_rounded,
                    color: Colors.black,
                    size: 30,
                  ),
                  Text(
                    'Open Gallery',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          )
        ]),
      ],
    );
  }

  void getPhoto(ImageSource source) async {
    final pickedFile = await profilePicker.pickImage(source: source);
    setState(() {
      _imageFile = pickedFile!;
    });

    // Upload the image to Firebase Storage and store in Firestore
    uploadImage();
  }

  void uploadImage() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return;
    }
    setState(() {});
    final storage = FirebaseStorage.instance;
    final storageRef = storage.ref().child('profile_images/${user.uid}');
    await storageRef.putFile(File(_imageFile.path));
    final imageUrl = await storageRef.getDownloadURL();
    await user.updatePhotoURL(imageUrl);
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
}
