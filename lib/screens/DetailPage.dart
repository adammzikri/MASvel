import 'package:flutter/material.dart';

class DetailPage extends StatelessWidget {
  final String tripName;
  final int budget;
  final String dateTrip;
  final int numPlaces;
  final List<Map<String, dynamic>>?
      places; // Update the type to List<Map<String, dynamic>>?

  DetailPage({
    required this.tripName,
    required this.budget,
    required this.dateTrip,
    required this.numPlaces,
    this.places,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(tripName),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.all(10.0),
            child: Text(
              'Budget: RM$budget',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10.0),
            child: Text(
              'Date: $dateTrip',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10.0),
            child: Text(
              'Number of Places: $numPlaces',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          SizedBox(height: 20),
          //Text('Places within Budget:'),
          Expanded(
            child: ListView.builder(
              itemCount: places?.length ?? 0,
              itemBuilder: (context, index) {
                final place = places![index];
                return ListTile(
                  title: Text(place['name']),
                  subtitle: Text(place['description']),
                  //leading: Image.network(place['image']),
                  leading: ClipRect(
                    child: Container(
                      height: 90,
                      width: 90,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(place['image']),
                        ),
                        borderRadius: BorderRadius.circular(9),
                        color: Colors.grey,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
