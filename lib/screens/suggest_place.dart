import 'dart:math';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:masvel/screens/categories.dart';
import 'package:masvel/services/planner.dart';

import '../firebase/place_model.dart';
import '../widgets/Button.dart';
import 'detail_page.dart';

class SuggestPlace extends StatefulWidget {
  final String tripName;
  final int budget;
  final String dateTrip;
  final int numPlaces;
  const SuggestPlace({
    Key? key,
    required this.tripName,
    required this.budget,
    required this.dateTrip,
    required this.numPlaces,
  }) : super(key: key);

  @override
  State<SuggestPlace> createState() => _SuggestPlaceState();
}

class _SuggestPlaceState extends State<SuggestPlace> {
  var plannerService = PlannerService();
  List<List<placeModel>> allCombinations = [];
  List<placeModel> place = [];
  List<List<List<placeModel>>> result = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    List<List<placeModel>> data =
        await plannerService.getPlace(widget.budget, widget.numPlaces);
    setState(() {
      allCombinations = data;
      place = getRandomCombination();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.tripName),
      ),
      body: Column(
        children: [
          Padding(padding: EdgeInsets.only(top: 25)),
          Text(
            "Date: ${widget.dateTrip}",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w400,
            ),
          ),
          Padding(padding: EdgeInsets.only(top: 10)),
          Text(
            "Budget: RM${widget.budget}",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w400,
              wordSpacing: 5,
            ),
          ),
          Padding(padding: EdgeInsets.only(top: 20)),
          getListPlace(place),
          getTotal(place),
          TextButton(
            onPressed: () {
              setState(() {
                place = getRandomCombination();
              });
            },
            child: Text('Change'),
          ),
          TextButton(
            onPressed: () {
              TravelPlannerScreen();
              // Post the data to Firebase Firestore
              postTripData(place);
            },
            child: Text('Done'),
          ),
        ],
      ),
    );
  }

  List<placeModel> getRandomCombination() {
    if (allCombinations.isEmpty) {
      throw Exception('No combinations available.');
    }

    Random random = Random();
    int randomIndex = random.nextInt(allCombinations.length);
    return allCombinations[randomIndex] ?? [];
  }

  Widget getTotal(List<placeModel> place) {
    int total = 0;
    place.forEach((element) {
      total += element.price;
    });

    return Text(
      "Total Cost: RM$total",
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.normal,
        wordSpacing: 5,
      ),
    );
  }

  Widget getListPlace(List<placeModel> place) {
    return ListView.builder(
      primary: false,
      shrinkWrap: true,
      itemCount: place.length,
      itemBuilder: (context, index) {
        return ListTile(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DetailsPage(
                  model: place[index],
                ),
              ),
            );
          },
          leading: ClipRect(
            child: Container(
              height: 90,
              width: 90,
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(place[index].image),
                ),
                borderRadius: BorderRadius.circular(9),
                color: Colors.grey,
              ),
            ),
          ),
          title: Text(place[index].name),
          subtitle: Text(place[index].description),
          trailing: LikeButton(
            isLiked: true,
            onTap: () {},
          ),
        );
      },
    );
  }

  void postTripData(List<placeModel> places) {
    FirebaseFirestore.instance.collection('trips').add({
      'tripName': widget.tripName,
      'budget': widget.budget,
      'dateTrip': widget.dateTrip,
      'numPlaces': widget.numPlaces,
      'places': places
          .map((place) => {
                'name': place.name,
                'description': place.description,
                'image': place.image,
                // Include other properties of placeModel here
              })
          .toList(),
    }).then((value) {
      // Data posted successfully
      print('Trip data posted to Firestore!');
    }).catchError((error) {
      // Error occurred while posting data
      print('Failed to post trip data: $error');
    });
  }
}
