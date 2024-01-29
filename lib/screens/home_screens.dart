// ignore_for_file: unused_import, unused_local_variable

import 'package:card_swiper/card_swiper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:masvel/firebase/place_listview.dart';
import 'package:masvel/firebase/place_model.dart';
import 'package:masvel/provider/dark_theme_provider.dart';
import 'package:masvel/screens/detail_page.dart';
import 'package:masvel/services/utils.dart';
import 'package:masvel/widgets/Button.dart';
import 'package:masvel/widgets/text_widget.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //late final PlaceModel place;
  String name = "";
  final List<String> _bannerImages = [
    'assets/img/banner1.jpg',
    'assets/img/banner2.jpg',
    'assets/img/banner3.jpg',
    'assets/img/banner4.jpg',
  ];

  bool isLiked = false;

  void toggleLike() {
    setState(() {
      isLiked = !isLiked;
    });
  }

  @override
  Widget build(BuildContext context) {
    final _placeStream =
        FirebaseFirestore.instance.collection('locations').snapshots();

    final Utils utils = Utils(context);
    final themeState = utils.getTheme;
    Size size = Utils(context).getScreenSize;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: size.height * 0.33,
              child: Swiper(
                itemBuilder: (BuildContext context, int index) {
                  return Image.asset(
                    _bannerImages[index],
                    fit: BoxFit.fill,
                  );
                },
                autoplay: true,
                itemCount: _bannerImages.length,
                pagination: const SwiperPagination(
                    alignment: Alignment.bottomCenter,
                    builder: DotSwiperPaginationBuilder(
                        color: Colors.white, activeColor: Colors.blue)),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  TextField(
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.search), hintText: 'Search...'),
                    onChanged: (val) {
                      setState(() {
                        name = val;
                      });
                    },
                  ),
                  Container(
                    width: double.maxFinite,
                    //height: 500,
                    child: StreamBuilder(
                      stream: _placeStream,
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                              snapshot) {
                        if (snapshot.hasData && snapshot.data != null) {
                          if (snapshot.data!.docs.isNotEmpty) {
                            return ListView.builder(
                                primary: false,
                                shrinkWrap: true,
                                itemCount: snapshot.data!.docs.length,
                                itemBuilder: (context, index) {
                                  ImageProvider image = NetworkImage(
                                      '${snapshot.data!.docs.elementAt(index).get("image")}');
                                  if (name.isEmpty) {
                                    //final bool isLiked;
                                    return ListTile(
                                      onTap: () {
                                        var data = snapshot.data!.docs
                                            .elementAt(index);
                                        var model =
                                            new placeModel.fromSnapshot(data);

                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    DetailsPage(
                                                      model: model,
                                                    )));
                                      },
                                      leading: ClipRect(
                                        child: Container(
                                          height: 90,
                                          width: 90,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              fit: BoxFit.cover,
                                              image: NetworkImage(
                                                  '${snapshot.data!.docs.elementAt(index).get("image")}'),
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(9),
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ),
                                      title: Text(
                                          '${snapshot.data!.docs.elementAt(index).get("name")}'),
                                      subtitle: Text(
                                          '${snapshot.data!.docs.elementAt(index).get("description")}'),
                                      trailing: LikeButton(
                                        isLiked: false,
                                        onTap: toggleLike,
                                      ),
                                    );
                                  }
                                  if ('${snapshot.data!.docs.elementAt(index).get("name")}'
                                      .toLowerCase()
                                      .contains(name.toLowerCase())) {
                                    return ListTile(
                                      onTap: () {
                                        var data = snapshot.data!.docs
                                            .elementAt(index);
                                        var model =
                                            new placeModel.fromSnapshot(data);

                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    DetailsPage(
                                                      model: model,
                                                    )));
                                      },
                                      leading: ClipRect(
                                        child: Container(
                                          height: 70,
                                          width: 70,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              fit: BoxFit.cover,
                                              image: NetworkImage(
                                                  '${snapshot.data!.docs.elementAt(index).get("image")}'),
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(6),
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ),
                                      title: Text(
                                          '${snapshot.data!.docs.elementAt(index).get("name")}'),
                                      subtitle: Text(
                                          '${snapshot.data!.docs.elementAt(index).get("description")}'),
                                      trailing: LikeButton(
                                        isLiked: isLiked,
                                        onTap: toggleLike,
                                      ),
                                    );
                                  }
                                  return Container();
                                });
                          } else {
                            return Center(
                              child: Text("Empty"),
                            );
                          }
                        } else {
                          return Center(
                            child: Text("Error"),
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
