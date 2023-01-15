import 'package:chat/chat-app/model/user-model.dart';
import 'package:chat/chat-app/screen/chat-screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
class SearchScreen extends StatefulWidget {
  UserModel user;
  SearchScreen(this.user);
  // const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<Map> searchResult=[];
  bool isLoading=false;
  void onSearch()async{
    setState(() {
      searchResult=[];
      isLoading=true;
    });
    await FirebaseFirestore.instance.collection('users').where("name",isEqualTo: searchController.text).get().then((value){
      if(value.docs.length<1){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('no user found')));
        setState(() {
      isLoading=false;
    });
    return ;
      }
      value.docs.forEach((user) { 
        if(user.data()['email']!=widget.user.email){
searchResult.add(user.data());
        }

      });
      setState(() {
        isLoading=false;
      });
    });

  }
  TextEditingController searchController=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('search your friend'),
        elevation: 0,
        backgroundColor: Colors.teal,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      helperText: 'type user name',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)
                      )
                    ),
                  ),
                ),
              ),
              IconButton(onPressed: (){
onSearch();
              }, icon: Icon(Icons.search))
            ],
          ),
          if(searchResult.length >0)
Expanded(
  child: ListView.builder(
    shrinkWrap: true,
    itemCount: searchResult.length,
    itemBuilder: (context,i){
    return ListTile(
      leading: CircleAvatar(
        child: Image.network(searchResult[i]['image']),
      ),
      title: Text(searchResult[i]['name']),
      subtitle: Text(searchResult[i]['email']),
      trailing: IconButton(onPressed: (){
        setState(() {
          searchController.text="";
        });
        Navigator.push(context, MaterialPageRoute(builder: (context)=>ChatScreen(
          currentuser: widget.user,
          friendId:searchResult[i]['uid'] ,
          friendName: searchResult[i]['name'],
          friendImage: searchResult[i]['image'],
        )));
      }, icon: Icon(Icons.message)),
    );
  })
  )
          else if(isLoading==true)
          Center(child: CircularProgressIndicator(),)
        ],
      ),
    );
  }
}