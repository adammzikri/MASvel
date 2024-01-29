import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PlaceList extends StatefulWidget {
  const PlaceList({super.key});

  @override
  State<PlaceList> createState() => _PlaceListState();
}

class _PlaceListState extends State<PlaceList> {
  final _placeStream =
      FirebaseFirestore.instance.collection('locations').snapshots();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('')),
      body: StreamBuilder(
        stream: _placeStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Connection Error');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text('Loading...');
          }

          var docs = snapshot.data!.docs;
          //return Text('${docs.length}');
          return ListView.builder(
              itemCount: docs.length,
              itemBuilder: (context, index) {

                return ListTile(
                  leading: const Icon(Icons.person),
                  title: Text(docs[index]['name']),
                  subtitle: Text(docs[index]['description']),
                );
              });
        },
      ),
    );
  }
}
