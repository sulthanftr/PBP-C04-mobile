import 'package:donobox/pages/profile.dart';
import 'package:flutter/material.dart';
import 'package:donobox/pages/homepage.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';


bool isEmail(String em) {

  String p = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

  RegExp regExp = new RegExp(p);

  return regExp.hasMatch(em);
}

bool isNumeric(String s) {
  if (s == null) {
    return false;
  }
  return double.tryParse(s) != null;
}


class EditProfilePage extends StatefulWidget {
  const EditProfilePage({
    super.key,
    required this.loggedUsername,
    required this.loggedRole,
  });

  final String loggedUsername;
  final String loggedRole;

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  DateTime selectedDate = DateTime.now();
  String _convertedDate = "";

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1990, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        _convertedDate = "${selectedDate.year.toString()}-${selectedDate.month.toString().padLeft(2,'0')}-${selectedDate.day.toString().padLeft(2,'0')}";
      });
    }
  }


  final _formKey = GlobalKey<FormState>();
  String _bio = "";
  String _phoneNumber = "";
  String _email = "";

  @override
  Widget build(BuildContext context) {
    final request = context.read<CookieRequest>();
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF3F4E4F),
          title: const Text('Edit Profile'),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.notifications_active,
                color: Color(0xFF879999),
                size: 30,),
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
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Padding(
                  // Menggunakan padding sebesar 8 pixels
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                      hintText: "",
                      labelText: "Bio",
                      // Menambahkan icon agar lebih intuitif
                      icon: const Icon(Icons.people),
                      // Menambahkan circular border agar lebih rapi
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),

                    // Menambahkan behavior saat email diketik
                    onChanged: (String? value) {
                      setState(() {
                        _bio = value!;
                      });
                    },
                    // Menambahkan behavior saat data disimpan
                    onSaved: (String? value) {
                      setState(() {
                        _bio = value!;
                      });
                    },

                  ),
                ),
                Padding(
                  // Menggunakan padding sebesar 8 pixels
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                      hintText: "08123456789",
                      labelText: "Phone Number",
                      // Menambahkan icon agar lebih intuitif
                      icon: const Icon(Icons.phone),
                      // Menambahkan circular border agar lebih rapi
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    // Menambahkan behavior saat phone diketik
                    onChanged: (String? value) {
                      setState(() {
                        _phoneNumber = value!;
                      });
                    },
                    // Menambahkan behavior saat data disimpan
                    onSaved: (String? value) {
                      setState(() {
                        _phoneNumber = value!;
                      });
                    },
                    validator: (String? value){
                      if (_phoneNumber.isNotEmpty && !isNumeric(_phoneNumber)){
                        return 'Nomor telepon tidak valid';
                      }
                      return null;
                    },
                  ),
                ),

                Padding(
                  // Menggunakan padding sebesar 8 pixels
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                      hintText: "dono@donobox.com",
                      labelText: "Email",
                      // Menambahkan icon agar lebih intuitif
                      icon: const Icon(Icons.mail),
                      // Menambahkan circular border agar lebih rapi
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),

                    // Menambahkan behavior saat email diketik
                    onChanged: (String? value) {
                      setState(() {
                        _email = value!;
                      });
                    },
                    // Menambahkan behavior saat data disimpan
                    onSaved: (String? value) {
                      setState(() {
                        _email = value!;
                      });
                    },
                    validator: (String? value){
                      if (_email.isNotEmpty && !isEmail(_email)){
                        return 'Email tidak valid';
                      }
                      return null;
                    },
                  ),
                ),

                TextButton(
                  child: const Text(
                    "Simpan",
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Color(0xFFA2CC83)),
                  ),
                  onPressed: () async{
                    if (_formKey.currentState!.validate()) {
                      final response = await request.post(
                          "https://pbp-c04.up.railway.app/profile/edit-profile-flutter",

                          {
                            'bio': _bio,
                            'phone': _phoneNumber,
                            'email' : _email,
                          }).then((value) => {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                              ProfilePage(
                                loggedUsername: widget.loggedUsername,
                                loggedRole: widget.loggedRole,
                              ),
                        )
                        )});


                    }
                  },
                ),
              ],
            ),
          ),
        ),

      )
    );
  }
}