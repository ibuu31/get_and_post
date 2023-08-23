import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<User> futureAlbum;
  @override
  void initState() {
    super.initState();
    // fetchAlbum() is an api calling method, it is called in initstate rather than build() method, because build method executes on every update, causing the app to slow down, and initstate is called one time.
    futureAlbum = fetchAlbum();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FutureBuilder(
                future: futureAlbum,
                builder:
                    (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  if (snapshot.hasData) {
                    return Text(snapshot.data.firstName.toString());
                  } else if (snapshot.hasError) {
                    Text(snapshot.error.toString());
                  }
                  return const CircularProgressIndicator();
                },
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                  onPressed: () {
                    setState(() {
                      futureAlbum = updateAlbum();
                    });
                  },
                  child: const Text('update data'))
            ],
          ),
        ),
      ),
    );
  }
}

Future<User> updateAlbum() async {
  final response =
      await http.post(Uri.parse('https://petstore.swagger.io/v2/user/ib4'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{
            'name': 'title 3',
          }));
  print(response.body);
  if (response.statusCode == 200) {
    return User.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 201 CREATED response,
    // then throw an exception.
    throw Exception('Failed to create album.');
  }
}

Future<User> fetchAlbum() async {
  final response = await http.get(
    Uri.parse('https://petstore.swagger.io/v2/user/ibuu'),
  );

  if (response.statusCode == 200) {
    return User.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to create album.');
  }
}

class User {
  User({
    required this.email,
    required this.firstName,
    required this.id,
    required this.lastName,
    required this.password,
    required this.phone,
    required this.userStatus,
    required this.username,
  });

  String? email;
  String? firstName;
  String? id;
  String? lastName;
  String? password;
  String? phone;
  String? userStatus;
  String? username;

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['lastName'];
    lastName = json['firstName'];
    password = json['password'];
    username = json['username'];
    email = json['email'];
    phone = json['phone'];
    userStatus = json['userStatus'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['lastName'] = lastName;
    data['firstName'] = firstName;
    data['password'] = password;
    data['username'] = username;
    data['email'] = email;
    data['phone'] = phone;
    data['userStatus'] = userStatus;
    return data;
  }
}
