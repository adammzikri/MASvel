// ignore_for_file: duplicate_import, unused_import

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:masvel/screens/auth/login.dart';
import 'package:masvel/widgets/text_widget.dart';
import 'package:provider/provider.dart';
import 'package:masvel/widgets/text_widget.dart';
import '../provider/dark_theme_provider.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  final TextEditingController _addressTextController =
      TextEditingController(text: "");
  final currentUser = FirebaseAuth.instance.currentUser!;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  String? username;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUsername();
  }

  Future<void> fetchUsername() async {
    try {
      DocumentSnapshot snapshot =
          await firestore.collection('users').doc(currentUser.uid).get();
      if (snapshot.exists && snapshot.data() != null) {
        setState(() {
          username = snapshot.get('username');
          isLoading = false;
        });
      } else {
        setState(() {
          username = 'No username found';
          isLoading = false;
        });
      }
    } catch (error) {
      print('Error fetching username: $error');
      setState(() {
        username = 'No username found';
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _addressTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeState = Provider.of<DarkThemeProvider>(context);
    final Color color = themeState.getDarkTheme ? Colors.white : Colors.black;

    return Scaffold(
        body: Center(
      child: SingleChildScrollView(
        child: isLoading
            ? CircularProgressIndicator()
            : Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 0,
                    ),
                    RichText(
                      text: TextSpan(
                          text: 'Hi,  ',
                          style: const TextStyle(
                            color: Colors.cyan,
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              text: currentUser.email!,
                              style: TextStyle(
                                color: color,
                                fontSize: 23,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ]),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    /*TextWidget(
                      text: currentUser.email!,
                      color: color,
                      textSize: 19,
                      //isTitle: true,
                    ),*/
                    const SizedBox(
                      height: 20,
                    ),
                    const Divider(
                      thickness: 2,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    _listTiles(
                      title: 'Address ',
                      subtitle: 'Parit Raja, Johor',
                      icon: IconlyBold.profile,
                      onPressed: () async {
                        await _showAddressDialog();
                      },
                      color: color,
                    ),
                    /*_listTiles(
                title: 'History',
                icon: IconlyBold.bookmark,
                onPressed: () {},
                color: color,
              ),
              _listTiles(
                title: 'FAQ',
                icon: IconlyBold.moreCircle,
                onPressed: () {},
                color: color,
              ),
              _listTiles(
                title: 'Feedback',
                icon: IconlyBold.message,
                onPressed: () {},
                color: color,
              ),
              _listTiles(
                title: 'About Us',
                icon: IconlyBold.infoCircle,
                onPressed: () {},
                color: color,
              ),*/
                    SwitchListTile(
                      title: TextWidget(
                        text: themeState.getDarkTheme
                            ? 'Dark mode'
                            : 'Light mode',
                        color: color,
                        textSize: 18,
                        //isTitle: true,
                      ),
                      secondary: Icon(themeState.getDarkTheme
                          ? Icons.dark_mode_outlined
                          : Icons.light_mode_outlined),
                      onChanged: (bool value) {
                        setState(() {
                          themeState.setDarkTheme = value;
                        });
                      },
                      value: themeState.getDarkTheme,
                    ),
                    _listTiles(
                      title: 'Log Out',
                      icon: IconlyBold.logout,
                      onPressed: () {
                        FirebaseAuth.instance.signOut().then((value) {
                          print("Signed Out");
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LogInScreen()));
                        });

                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LogInScreen()));
                      },
                      color: color,
                    ),
                  ],
                ),
              ),
      ),
    ));
  }

  Future<void> _showAddressDialog() async {
    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Update'),
            content: TextField(
              onChanged: (value) {
                print(
                    '_addressTextController.text ${_addressTextController.text}');
              },
              controller: _addressTextController,
              maxLines: 5,
              decoration: const InputDecoration(hintText: "Your Address"),
            ),
            actions: [
              TextButton(
                onPressed: () {},
                child: const Text('Update'),
              ),
            ],
          );
        });
  }

  Widget _listTiles({
    required String title,
    String? subtitle,
    required IconData icon,
    required Function onPressed,
    required Color color,
  }) {
    return ListTile(
      title: TextWidget(
        text: title,
        color: color,
        textSize: 22,
        //isTitle: true,
      ),
      subtitle: TextWidget(
        text: subtitle == null ? "" : subtitle,
        color: color,
        textSize: 18,
      ),
      leading: Icon(icon),
      trailing: const Icon(IconlyLight.arrowRight2),
      onTap: () {
        onPressed();
      },
    );
  }
}
