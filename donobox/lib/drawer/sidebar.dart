import 'package:donobox/pages/AboutUsPage.dart';
import 'package:donobox/pages/AskUsPage.dart';
import 'package:donobox/pages/crowdfunds.dart';
import 'package:donobox/pages/mynotification_page.dart';
import 'package:flutter/material.dart';
import 'package:donobox/pages/artikel_page.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:donobox/pages/login.dart';
import 'package:donobox/pages/profile.dart';
import 'package:donobox/pages/editprofilepage.dart';
import '../pages/homepage.dart';

// var url = "https://pbp-c04.up.railway.app/profile/";
// var adaPP = false;

class drawer extends StatelessWidget {
  drawer({
    Key? key,
    required this.loggedUsername,
    required this.loggedRole,
  }) : super(key: key);

  String loggedUsername;
  String loggedRole;

  @override
  Widget build(BuildContext context) {
    final request = context.read<CookieRequest>();

    print(request);
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          buildHeader(context, request),
          buildMenuItems(context, request),
        ],
      ),
    );
  }

  Widget buildHeader(BuildContext context, CookieRequest request) => Material(
        color: Color(0xFF3F4E4F),
        child: request.loggedIn
            ? InkWell(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ProfilePage(
                          loggedUsername: loggedUsername,
                          loggedRole: loggedRole,
                        )),
                  );
                },
                child: Container(
                  color: Color(0xFF3F4E4F),
                  padding: EdgeInsets.only(
                    top: 24 + MediaQuery.of(context).padding.top,
                    bottom: 24,
                  ),
                  child: Column(
                    children: [
                      Image.asset('assets/logo.png', height: 70,
                        width: 70,
                        fit: BoxFit.fitWidth,),
                      SizedBox(height: 12),
                      Text(
                        request.jsonData['username'] == null
                            ? ""
                            : "${request.jsonData['username']}",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      )
                    ],
                  ),
                ),
              )
            : Container(),
      );

  Widget buildMenuItems(BuildContext context, CookieRequest request) =>
      Container(
        padding: const EdgeInsets.all(20),
        child: Wrap(
          runSpacing: 10,
          children: [
            ListTile(
              leading: const Icon(Icons.home, color: Color(0xFFA2CC83)),
              title: const Text('Home'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage(
                    loggedUsername: loggedUsername,
                    loggedRole: loggedRole,
                  )),
                );
              },
            ),
            request.loggedIn
                ? ListTile(
                    leading: const Icon(Icons.notifications,
                        color: Color(0xFFA2CC83)),
                    title: const Text('Notifications'),
                    onTap: () {
                      // Route menu ke halaman notifikasi
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MyNotificationPage(
                              loggedUsername: loggedUsername,
                              loggedRole: loggedRole,
                            )),
                      );
                    },
                  )
                : Container(),
            ListTile(
              leading: Image.asset(
                'assets/logo.png',
                width: 35,
              ),
              title: const Text('About Us'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => AboutUs(
                              loggedUsername: loggedUsername,
                              loggedRole: loggedRole,
                  )),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.article, color: Color(0xFFA2CC83)),
              title: const Text('Article'),
              onTap: () {
                // Route menu ke halaman utama
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => ArtikelPage(
                              loggedUsername: loggedUsername,
                              loggedRole: loggedRole,
                  )),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.wallet, color: Color(0xFFA2CC83)),
              title: const Text('Cek Saldo'),
              onTap: () {
                // Route menu ke halaman utama
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => ProfilePage(
                              loggedUsername: loggedUsername,
                              loggedRole: loggedRole,
                  )),
                );
              },
            ),
            ListTile(
              leading:
                  const Icon(Icons.money_rounded, color: Color(0xFFA2CC83)),
              title: const Text('CrowdFund'),
              onTap: () {
                // Route menu ke halaman utama
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => CrowdfundsPage(
                              loggedUsername: loggedUsername,
                              loggedRole: loggedRole,
                  )),
                );
              },
            ),
            !request.loggedIn
                ? ListTile(
                    leading: const Icon(Icons.login, color: Color(0xFFA2CC83)),
                    title: const Text('Login'),
                    onTap: () {
                      // Route menu ke halaman form
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LoginPage(
                              loggedUsername: loggedUsername,
                              loggedRole: loggedRole,
                            )),
                      );
                    },
                  )
                : ListTile(
                    leading: const Icon(Icons.logout, color: Color(0xFFA2CC83)),
                    title: const Text("Logout"),
                    onTap: () async {
                      final response = await request.logout(
                          "https://pbp-c04.up.railway.app/autentikasi/logout_apk/");
                      loggedUsername = '';
                      loggedRole = '';
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => HomePage(
                                loggedUsername: loggedUsername,
                                loggedRole: loggedRole,
                              )));
                    },
                  )
          ],
        ),
      );
}
