// ignore_for_file: unused_import, unused_local_variable

import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../firebase/place_model.dart';

class PlannerService {
  List<placeModel> places = [];
  List<placeModel> selectedPlaces = [];
  List<List<placeModel>> combinations = [];

  Future getPlace(int budget, int numPlaces) async {
    places.clear();
    selectedPlaces.clear();
    combinations.clear();
    final _placeStream = await FirebaseFirestore.instance
        .collection('locations')
        .get()
        .then((value) => value.docs.forEach((element) {
              var model = placeModel.fromSnapshot(element);
              places.add(model);
            }));

    void backtrack(List<placeModel> currentCombination, int remainingBudget,
        int remainingPlaces) {
      if (remainingPlaces == 0 || remainingBudget <= 0) {
        if (currentCombination.length == numPlaces) {
          combinations.add(List.from(currentCombination));
        }
        return;
      }

      for (int i = 0; i < places.length; i++) {
        placeModel place = places[i];
        if (currentCombination.contains(place)) {
          continue; // Skip already selected places
        }
        if (place.price > remainingBudget) {
          continue; // Skip places that exceed remaining budget
        }

        currentCombination.add(place);
        backtrack(currentCombination, remainingBudget - place.price,
            remainingPlaces - 1);
        currentCombination.remove(place);
      }
    }

    backtrack([], budget, numPlaces);
    return combinations;
  }
}
