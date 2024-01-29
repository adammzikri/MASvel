// ignore_for_file: unused_local_variable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../firebase/place_model.dart';

class DetailsPage extends StatelessWidget {
  final placeModel model;
  DetailsPage({Key? key, required this.model}) : super(key: key);

  final docs = FirebaseFirestore.instance.collection('locations').snapshots();

  @override
  Widget build(
    BuildContext context,
  ) {
    final placeModelTypes = model.types();
    var iconKeys = placeModelTypes.keys.toList();

    return Scaffold(
      body: Center(
        child: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              title: Text(
                'Details',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              backgroundColor: Colors.blueAccent,
              expandedHeight: 350.0,
              floating: false,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                background: Image.network(
                  '${model.image}',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SliverFixedExtentList(
                delegate: SliverChildListDelegate([
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          model.name,
                          style: const TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Text(
                          model.description,
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Padding(padding: EdgeInsets.only(bottom: 10)),
                        Text(
                          model.summary,
                          textAlign: TextAlign.justify,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ],
                    ),
                  ),
                ]),
                itemExtent: 310),
            /*Text(
              'Details',
              style: const TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w500,
              ),
            ),*/

            SliverToBoxAdapter(
                child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  height: 400,
                  color: Colors.deepPurple[300],
                  padding: EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.access_time_filled,
                        size: 25,
                      ),
                      Text(
                        model.time,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          //wordSpacing: 4,
                        ),
                      ),
                      Padding(padding: EdgeInsets.only(top: 20)),
                      Icon(
                        Icons.location_on,
                        size: 25,
                      ),
                      Text(
                        model.address,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          wordSpacing: 4,
                        ),
                      ),
                      Padding(padding: EdgeInsets.only(top: 20)),
                      Icon(
                        Icons.money,
                        size: 25,
                      ),
                      model.price == 0
                          ? Text(
                              "FREE",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                wordSpacing: 4,
                              ),
                            )
                          : Text(
                              'From RM${model.price} per person',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                //wordSpacing: 4,
                              ),
                            )
                    ],
                  ),
                ),
              ),
            ))
          ],
        ),
      ),
    );
  }
}
