import 'package:chat/chat-app/model/user-model.dart';
import 'package:chat/chat-app/screen/auth_screen.dart';
import 'package:chat/chat-app/screen/chat-screen.dart';
import 'package:chat/chat-app/screen/search_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
class HomeScreen extends StatefulWidget {
  UserModel user;
  HomeScreen(this.user);
  // const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        centerTitle: true,
        elevation: 0,backgroundColor:Colors.teal,
        actions: [
          IconButton(onPressed: ()async{
            await GoogleSignIn().signOut();
            await FirebaseAuth.instance.signOut();
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>AuthScreen()), (route) => false);
          }, icon: Icon(Icons.logout))
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('users').doc(widget.user.uid).collection('messages').snapshots(),
        builder: ((context, snapshot){
          if(snapshot.hasData){
if(snapshot.data!.docs.length < 1){
  return Center(child: Text('no chats available'),);
}
return ListView.builder(
  itemCount: snapshot.data!.docs.length,
  itemBuilder: (context,i){
    var friendId=snapshot.data!.docs[i].id;
     var lastMessage=snapshot.data!.docs[i]['last_msg'];
    return FutureBuilder(
future: FirebaseFirestore.instance.collection('users').doc(friendId).get(),
builder: (conntext,AsyncSnapshot asyncsnapshot){
  if(asyncsnapshot.hasData){
var friend=asyncsnapshot.data;
return ListTile(
  leading: CircleAvatar(
    child: Image.network(friend['image']),
  ),
  title: Text(friend['name']),
  subtitle: Container(
    child: Text("$lastMessage",style: TextStyle(color: Colors.grey),overflow: TextOverflow.ellipsis,),
  ),
  onTap: (){
    Navigator.push(context, MaterialPageRoute(builder: (context)=>ChatScreen(
      currentuser: widget.user, 
      friendId: friend['uid'], 
      friendName: friend['name'], 
      friendImage: friend['image'])));
  },
);
  }
  return LinearProgressIndicator();
},
    );
  }
  ); 
          }
          return Center(child: CircularProgressIndicator(),) ;
        })
        ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.search),
        onPressed: (){
Navigator.push(context, MaterialPageRoute(builder: (context)=>SearchScreen(widget.user)));
      }),
    );
  }
}