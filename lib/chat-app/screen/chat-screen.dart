import 'package:chat/chat-app/model/user-model.dart';
import 'package:chat/chat-app/widgets/message_textfield.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
class ChatScreen extends StatelessWidget {
 final UserModel currentuser;
 final String friendId;
final String friendName;
final String friendImage;
ChatScreen({
  required this.currentuser,
  required this.friendId,
  required this.friendName,
  required this.friendImage
});
  // const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(80),
                child: Image.network(friendImage,height: 30,),
              ),
              SizedBox(width: 10,),
              Text(friendName,style: TextStyle(fontSize: 20),)
            ],
          ),
       
        elevation: 0,backgroundColor:Colors.teal,
      ),
      body: Column(
        children: [
          Expanded(child: Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(25),topRight:Radius.circular(25) )
            ),
            child: StreamBuilder(
              stream: FirebaseFirestore.instance.collection('users').doc(currentuser.uid).collection('messages').doc(friendId).collection('chats').orderBy("date",descending: true).snapshots(),
              builder: (context,AsyncSnapshot snapshot){
                if(snapshot.hasData){
if(snapshot.data.docs.length <1){
  return Center(child: Text('say hi'),);
}
return ListView.builder(
  itemCount: snapshot.data.docs.length,
  reverse: true,
  physics: BouncingScrollPhysics(),
  itemBuilder: (context,i){
    bool isMe=snapshot.data.docs[i]['senderId']==currentuser.uid;
return Row(
  mainAxisAlignment: isMe?MainAxisAlignment.end:MainAxisAlignment.start,
  children: [
    Container(
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.all(16),
      constraints: BoxConstraints(maxWidth: 200),
      decoration: BoxDecoration(
        color: isMe?Colors.black:Colors.orange,
        borderRadius: BorderRadius.all(Radius.circular(12))
      ),
      child: Text(snapshot.data.docs[i]['message'],style: TextStyle(color: Colors.white),),
    )
  ],
);
  },
);
                }
                return Center(child: CircularProgressIndicator(),);
              }),
          )),
          MessageTextField(currentuser.uid,friendId)
        ],
      ),
    );
  }
}