import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:masvel/screens/plan_travel.dart';
import 'package:masvel/screens/DetailPage.dart';

class TravelPlannerScreen extends StatelessWidget {
  TravelPlannerScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NewTrip()),
          );
        },
        child: Icon(Icons.add),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('trips').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          final trips = snapshot.data!.docs;

          return ListView.builder(
            itemCount: trips.length,
            itemBuilder: (context, index) {
              final tripData = trips[index].data() as Map<String, dynamic>;

              // Assuming you have retrieved the places data from Firestore
              List<Map<String, dynamic>> placesData =
                  List<Map<String, dynamic>>.from(tripData['places']);

              return ListTile(
                title: Text(
                  tripData['tripName'],
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text('Budget: ${tripData['budget']}'),
                trailing: Text('${tripData['dateTrip']}'),
                onTap: () {
                  // Pass the places data to the detail page
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailPage(
                        tripName: tripData['tripName'],
                        budget: tripData['budget'],
                        dateTrip: tripData['dateTrip'],
                        numPlaces: tripData['numPlaces'],
                        places: placesData,
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
