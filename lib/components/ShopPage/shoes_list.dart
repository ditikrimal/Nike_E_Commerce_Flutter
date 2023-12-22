// ignore: non_constant_identifier_names
// ignore_for_file: non_constant_identifier_names, prefer_const_constructors

import 'package:NikeStore/components/ShopPage/shoe_tile.dart';
import 'package:NikeStore/models/shoe.dart';
import 'package:flutter/material.dart';

import 'package:shimmer/shimmer.dart';

SizedBox shoeList(List<Shoe> shoes, {bool isLoading = false}) {
  return SizedBox(
    height: 450,
    child: Container(
      padding: EdgeInsets.only(left: 10, right: 10),
      child: isLoading
          ? _buildSkeletonLoading()
          : ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: shoes.length,
              itemBuilder: (context, index) {
                return ShoeTile(
                  shoe: shoes[index],
                );
              },
            ),
    ),
  );
}

SizedBox emptyShoesList() {
  return SizedBox(
    child: Container(
      margin: EdgeInsets.only(top: 200),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'No shoes Available',
              style: TextStyle(
                fontSize: 20,
                color: Colors.grey[600],
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'Try searching for something or refresh the page',
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey[600],
              ),
            ),
          ]),
    ),
  );
}

shimmerGradient() {
  return LinearGradient(
    colors: [
      Colors.grey[300]!,
      Colors.grey[400]!,
      Colors.grey[300]!,
    ],
    begin: Alignment(-1.0, -1.0),
    end: Alignment(1.0, 1.0),
  );
}

Widget _buildSkeletonLoading() {
  return (SizedBox(
    height: 200, // Adjust the height as needed
    child: ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: 5, // You can adjust the number of skeleton items
      itemBuilder: (context, index) {
        return Container(
          margin: EdgeInsets.only(left: 20, top: 12, right: 20),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(15),
          ),
          width: 300,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Shimmer(
                gradient: shimmerGradient(),
                child: Container(
                  margin: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(15),
                  ),
                  height: 200,
                ),
              ),
              Shimmer(
                gradient: shimmerGradient(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Container(
                    height: 20,
                    color: Colors.grey[300],
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: EdgeInsets.only(left: 15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      margin: EdgeInsets.only(bottom: 5),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Shimmer(
                            gradient: shimmerGradient(),
                            child: Container(
                              height: 20,
                              width: 100,
                              color: Colors.grey[300],
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Shimmer(
                              gradient: shimmerGradient(),
                              child: Container(
                                height: 20,
                                width: 50,
                                color: Colors.grey[300],
                              ))
                        ],
                      ),
                    ),
                    Shimmer(
                        gradient: shimmerGradient(),
                        child: Container(
                          padding: EdgeInsets.all(17),
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadiusDirectional.only(
                                topStart: Radius.circular(15),
                                bottomEnd: Radius.circular(15)),
                          ),
                          child: Icon(
                            Icons.add,
                            size: 32,
                            color: Colors.white,
                          ),
                        ))
                  ],
                ),
              ),
            ],
          ),
        );
      },
    ),
  ));
}
