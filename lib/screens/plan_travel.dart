// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:masvel/firebase/place_model.dart';
import 'package:masvel/screens/suggest_place.dart';

import '../widgets/reusable_widget.dart';

class NewTrip extends StatefulWidget {
  //final placeModel model;
  NewTrip({
    Key? key,
    /*required this.model*/
  }) : super(key: key);

  @override
  State<NewTrip> createState() => _NewTripState();
}

class _NewTripState extends State<NewTrip> {
  TextEditingController _titleController = new TextEditingController();
  TextEditingController _budgetController = new TextEditingController();
  TextEditingController _dateController = new TextEditingController();
  TextEditingController _capController = new TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _titleController.dispose();
    _budgetController.dispose();
    _dateController.dispose();
    _capController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //_titleController.text =  model.
    final phoneHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Trip Budget'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            height: phoneHeight * 0.80,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Enter Your Trip Name",
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: TextField(
                    controller: _titleController,
                    //autofocus: true,
                  ),
                ),
                Text(
                  "Enter Your Budget",
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: TextField(
                    controller: _budgetController,
                    //autofocus: true,
                  ),
                ),
                Text(
                  "Enter Number of Places",
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: TextField(
                    controller: _capController,
                    //autofocus: true,
                  ),
                ),
                Text(
                  "Enter Date Trip",
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: TextField(
                    controller: _dateController,
                    //autofocus: true,
                  ),
                ),
                TextButton(
                  style: ButtonStyle(
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.blue),
                  ),
                  onPressed: () {
                    String title = _titleController.text.trim();
                    int? budget = int.tryParse(_budgetController.text.trim());
                    String date = _dateController.text.trim();
                    int? cap = int.tryParse(_capController.text.trim());
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SuggestPlace(
                                  tripName: title,
                                  budget: budget!,
                                  dateTrip: date,
                                  numPlaces: cap!,
                                )));
                  },
                  child: Text('Continue'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
