import 'package:chat/chat-app/model/user-model.dart';
import 'package:chat/chat-app/screen/auth_screen.dart';
import 'package:chat/chat-app/screen/home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main()async {
WidgetsFlutterBinding.ensureInitialized();
await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  Future<Widget> userSignedIn()async{
    User? user=FirebaseAuth.instance.currentUser;
    if(user !=null){
      DocumentSnapshot userdata=await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      UserModel usermodel=UserModel.fromJson(userdata);
      return HomeScreen(usermodel);
    }else{
      return AuthScreen();
    }
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: FutureBuilder(
        future: userSignedIn(),
        builder: (context,AsyncSnapshot snapshot){
          if(snapshot.hasData){
            return snapshot.data;
          }
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        )
    );
  }
}


