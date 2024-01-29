import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class placeModel {
  String name;
  String address;
  String description;
  String image;
  int price;
  String time;
  String type;
  String summary;

  placeModel(
    this.name,
    this.address,
    this.description,
    this.image,
    this.price,
    this.time,
    this.type,
    this.summary,
  );

  placeModel.fromSnapshot(DocumentSnapshot snapshot)
      : name = snapshot['name'],
        address = snapshot['address'],
        description = snapshot['description'],
        image = snapshot['image'],
        price = snapshot['price'],
        time = snapshot['time'],
        type = snapshot['type'],
        summary = snapshot['summary'];

  Map<String, Icon> types() => {
        "time": Icon(Icons.access_time_filled),
        "address": Icon(Icons.location_on_outlined),
      };
}

class placeModel2 {
  String name;
  String description;
  String image;

  placeModel2(
    this.name,
    this.description,
    this.image,
  );

  placeModel2.fromSnapshot(DocumentSnapshot snapshot)
      : name = snapshot['name'],
        description = snapshot['description'],
        image = snapshot['image'];
}
