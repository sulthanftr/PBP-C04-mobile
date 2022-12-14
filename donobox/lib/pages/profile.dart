import 'package:donobox/pages/editprofilepage.dart';
import 'package:flutter/material.dart';
import 'package:donobox/main.dart';
import 'package:donobox/pages/profile.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import '../drawer/sidebar.dart';
import 'package:donobox/pages/homepage.dart';
import 'package:http/http.dart' as http;
import 'package:donobox/model/profile.dart';
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';


class ProfilePage extends StatefulWidget {
  const ProfilePage({
    Key? key,
    required this.loggedUsername,
    required this.loggedRole,
  }) : super(key: key);

  final String loggedUsername;
  final String loggedRole;

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _tambahSaldoFormKey = GlobalKey<FormState>();
  var nominalSaldo = "0";
  var profilePictureUrl = "";
  var url = "https://pbp-c04.up.railway.app/profile/";
  var adaPP = false;

  Future<List<Profile>> fetchProfile() async {
    final request = context.read<CookieRequest>();
    final response = await request.get('https://pbp-c04.up.railway.app/profile/json');

    // melakukan konversi data json menjadi object MyNotification
    List<Profile> listProfile = [];
    print(response);
    for (var d in response) {
      if (d != null) {
        listProfile.add(Profile.fromJson(d));
      }
    }
    var linkPicture = listProfile[0].fields.picture;
    if (linkPicture != 'media/person.png'){
      adaPP = true;
    }
    url = "https://pbp-c04.up.railway.app/profile/";
    url += listProfile[0].fields.picture;
    print("URLPROFILEPICTURE: " + url);
    return listProfile;

  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF3F4E4F),
          title: const Text('Profile'),
          actions: <Widget>[
            IconButton(
              icon: const Icon(
                Icons.notifications_active,
                color: Color(0xFF879999),
                size: 30,
              ),
              tooltip: 'Notification',
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage(
                    loggedUsername: widget.loggedUsername,
                    loggedRole: widget.loggedRole,
                  )),
                );
              },
            ),
          ],
        ),
        drawer: drawer(
          loggedUsername: widget.loggedUsername,
          loggedRole: widget.loggedRole,
        ),
        body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 1,
              child: FutureBuilder(
                  future: fetchProfile(),
                  builder: (context, AsyncSnapshot snapshot) {
                    if (snapshot.data == null) {
                      return const Center(child: CircularProgressIndicator());
                    } else {
                      if (!snapshot.hasData) {
                        return Column(
                          children: const [
                            Text(
                              "Tidak ada data!",
                              style:
                              TextStyle(color: Color(0xff59A5D8), fontSize: 20),
                            ),
                            SizedBox(height: 8),
                          ],
                        );
                      } else {
                        return ListView.builder(
                            itemCount: snapshot.data!.length,
                            itemBuilder: (_, index) =>
                            Column(
                              children: [
                                Padding(
                                    padding : EdgeInsets.fromLTRB(30, 40, 30, 40),
                                    child: Center(
                                      child:
                                      // CachedNetworkImage(
                                      //   imageUrl: 'https://pbp-c04.up.railway.app/profile/media/Fhl4-CZagAA7yEG.jpeg',
                                      //   imageBuilder: (context, imageProvider) => Container(
                                      //     width: 80.0,
                                      //     height: 80.0,
                                      //     decoration: BoxDecoration(
                                      //       shape: BoxShape.circle,
                                      //       image: DecorationImage(
                                      //           image: imageProvider, fit: BoxFit.cover),
                                      //     ),
                                      //   ),
                                      //   placeholder: (context, url) => CircularProgressIndicator(),
                                      //   errorWidget: (context, url, error) => Icon(Icons.error),
                                      // ),
                                      CircleAvatar(
                                        backgroundImage: adaPP?
                                        NetworkImage(url):
                                        AssetImage('assets/profile.png') as ImageProvider,
                                         //  const [NetworkImage(url)]
                                         // : const [AssetImage('asset/profile.png')],
                                        radius: 60,
                                      ),
                                    )
                                ),
                                if (snapshot.data![index].fields.bio != null)
                                    Text("'${snapshot.data![index].fields.bio}'",
                                      style: TextStyle(
                                          color: Color(0xFF879999),
                                          letterSpacing: 2
                                      ),
                                    ),
                                    SizedBox(height: 40),

                                Text(
                                  'Saldo',
                                  style: TextStyle(
                                      color: Color(0xFF879999),
                                      letterSpacing: 2
                                  ),
                                ),
                                SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Rp.${snapshot.data![index].fields.saldo}",
                                      style: TextStyle(
                                          color: Color(0xFF879999),
                                          letterSpacing: 1,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 40),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.people,
                                      color: Color(0xFF879999),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      "${snapshot.data![index].fields.role}",
                                      style: TextStyle(
                                          color: Color(0xFF879999),
                                          fontSize: 18,
                                          letterSpacing: 1
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Icon(
                                      Icons.email,
                                      color: Color(0xFF879999),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    if (snapshot.data![index].fields.email != null)
                                      Text(
                                        "${snapshot.data![index].fields.email}",
                                        style: TextStyle(
                                            color: Color(0xFF879999),
                                            fontSize: 18,
                                            letterSpacing: 1
                                        ),
                                      ),
                                  ],
                                ),
                                SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Icon(
                                      Icons.phone,
                                      color: Color(0xFF879999),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    if (snapshot.data![index].fields.phone != null)
                                      Text(
                                        "${snapshot.data![index].fields.phone}",
                                        style: TextStyle(
                                            color: Color(0xFF879999),
                                            fontSize: 18,
                                            letterSpacing: 1
                                        ),
                                      ),
                                  ],
                                ),
                                SizedBox(height: 100),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    FloatingActionButton.extended(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => EditProfilePage(
                                            loggedUsername: widget.loggedUsername,
                                            loggedRole: widget.loggedRole,
                                          )),
                                        );
                                      },
                                      heroTag: 'editprofile',
                                      elevation: 0,
                                      label: const Text("Edit Profile"),
                                      icon: const Icon(Icons.person_add_alt_1),
                                        backgroundColor: Color(0xFFA2CC83),
                                    ),
                                    const SizedBox(width: 16.0),
                                    FloatingActionButton.extended(
                                      onPressed: () {
                                        showModalBottomSheet(
                                            context: context,
                                            builder: (BuildContext context){
                                          return Scaffold(
                                            body: Form(
                                              key: _tambahSaldoFormKey,
                                              child:
                                                SingleChildScrollView(
                                                  child: Column(
                                                    children: [
                                                      Container(
                                                        margin: const EdgeInsets.all(20.0),
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          children : const [
                                                            Text(
                                                              "Tambah Saldo",
                                                              style: TextStyle(fontSize: 22),
                                                            )
                                                          ]
                                                        )
                                                      ),
                                                      Padding(
                                                        padding: const EdgeInsets.all(8.0),
                                                          child: TextFormField(
                                                            keyboardType: TextInputType.number,
                                                            decoration: InputDecoration(
                                                              labelText: "Nominal",
                                                              labelStyle: const TextStyle(
                                                                  color: Color(0xFF3F4E4F)),
                                                              border: OutlineInputBorder(
                                                                borderRadius:
                                                                BorderRadius.circular(5.0),
                                                                borderSide: const BorderSide(
                                                                    color: Color(0xFF3F4E4F)),
                                                              ),
                                                              focusedBorder: OutlineInputBorder(
                                                                borderRadius:
                                                                BorderRadius.circular(5.0),
                                                                borderSide: const BorderSide(
                                                                    color: Color(0xFF3F4E4F)),
                                                              ),
                                                            ),
                                                            validator: (String? value) {
                                                              if (value == null || value.isEmpty || int.parse(value) < 1) {
                                                                return 'Error';
                                                              }
                                                              return null;
                                                            },
                                                            onChanged: (String? value) {
                                                              setState(() {
                                                                nominalSaldo = value!;
                                                                print(nominalSaldo);
                                                              });
                                                            },
                                                            onSaved: ((String? value) {
                                                              setState(() {
                                                                nominalSaldo = value!;
                                                              });
                                                            }),
                                                          )
                                                      ),
                                                Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      Padding(
                                                        padding: const EdgeInsets.all(8.0),
                                                        child: TextButton(
                                                          style: ElevatedButton.styleFrom(
                                                            backgroundColor: Color(0xFFA2CC83),
                                                            shape: RoundedRectangleBorder(
                                                              borderRadius:
                                                              BorderRadius.circular(10.0),
                                                            ),
                                                            padding: const EdgeInsets.all(16.0),
                                                            tapTargetSize: MaterialTapTargetSize
                                                                .shrinkWrap,
                                                            alignment: Alignment.center,
                                                          ),
                                                          onPressed: () async {
                                                            if (_tambahSaldoFormKey.currentState!
                                                                .validate()) {
                                                              final response = await request.post(
                                                                  "https://pbp-c04.up.railway.app/profile/saldo-flutter",
                                                                  {
                                                                    'saldo': (nominalSaldo),
                                                                  }).then((value) => {
                                                                Navigator.pushReplacement(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder: (context) =>
                                                                      ProfilePage(
                                                                        loggedUsername: widget.loggedUsername,
                                                                        loggedRole: widget.loggedRole,
                                                                      )),
                                                                )
                                                              });
                                                              print(response);
                                                            }
                                                          },
                                                          child: const Text("Tambah",
                                                              style: TextStyle(
                                                                  color: Colors.white,
                                                                  fontSize: 20)),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding: const EdgeInsets.all(8.0),
                                                        child: TextButton(
                                                          style: ElevatedButton.styleFrom(
                                                            shape: RoundedRectangleBorder(
                                                              borderRadius:
                                                              BorderRadius.circular(10.0),
                                                            ),
                                                            backgroundColor: Color(0xFFA2CC83),
                                                            padding: const EdgeInsets.all(16.0),
                                                            tapTargetSize: MaterialTapTargetSize
                                                                .shrinkWrap,
                                                            alignment: Alignment.center,
                                                          ),
                                                          onPressed: () => Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: (context) =>
                                                                ProfilePage(
                                                                  loggedUsername: widget.loggedUsername,
                                                                  loggedRole: widget.loggedRole,
                                                                )),
                                                          ),
                                                          child: const Text("Kembali",
                                                              style: TextStyle(
                                                                  color: Colors.white,
                                                                  fontSize: 20)),
                                                        ),
                                                      ),
                                                    ]
                                                  )
                                                ])
                                            )
                                          )
                                              );
                                        }
                                        );
                                      },
                                      heroTag: 'mesage',
                                      elevation: 0,
                                      backgroundColor: Color(0xFFA2CC83),
                                      label: const Text("Tambah Saldo"),
                                      icon: const Icon(Icons.money),
                                    ),
                                  ],
                                ),
                              ],
                            )
                            //     InkWell(
                            //     child: Container(
                            //         margin: const EdgeInsets.symmetric(
                            //             horizontal: 16, vertical: 12),
                            //         padding: const EdgeInsets.all(20.0),
                            //         decoration: BoxDecoration(
                            //           color: Colors.white,
                            //           borderRadius: BorderRadius.circular(10.0),
                            //         ),
                            //         child: Row(
                            //           children: [
                            //             Text("${snapshot.data![index].fields.role}",
                            //                 style: const TextStyle(
                            //                   fontSize: 18.0,
                            //                   fontWeight: FontWeight.bold,
                            //                 )),
                            //           ],
                            //         )
                            //     )
                            // )
                        );
                      }
                    }
                  }
              ),
            ),

        ],
        )


    );
  }
}