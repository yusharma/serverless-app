import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:serverless_app/apis/firebase_apis.dart';
import 'package:serverless_app/homepage.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

Map<String, num> globalCart = {};

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Serverless App',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text("Get My Coffee"),
          actions: [
            TextButton(
              onPressed: () {
                print(globalCart);
                FirebaseApi.updateStock(globalCart);
                globalCart = {};
                setState(() {});
              },
              child: Text(
                "Order it!",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            )
          ],
        ),
        body: HomePage(),
      ),
    );
  }
}
