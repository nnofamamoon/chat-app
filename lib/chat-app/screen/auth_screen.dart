import 'package:chat/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  GoogleSignIn googleSignIn=GoogleSignIn();
  FirebaseFirestore firestore=FirebaseFirestore.instance;
  Future signInFunction()async{
GoogleSignInAccount? googleuser=await googleSignIn.signIn();
if(googleuser ==null){
  return ;
}
final googleAuth=await googleuser.authentication;
final credential=GoogleAuthProvider.credential(
  accessToken: googleAuth.accessToken,
  idToken: googleAuth.idToken
);
UserCredential userCredential=await FirebaseAuth.instance.signInWithCredential(credential);
DocumentSnapshot userExsist=await firestore.collection('users').doc(userCredential.user!.uid).get();
// if(userExsist.exists){
//   print('**************');
//   print('user already exsist');
// }else{
await firestore.collection('users').doc(userCredential.user!.uid).set({
'email':userCredential.user!.email,
'name':userCredential.user!.displayName,
'image':userCredential.user!.photoURL,
'uid':userCredential.user!.uid,
'date':DateTime.now()
});
Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>MyApp()), (route) => false);
// }
print('//////////////////////////////');
print(userCredential.user!.email);
print(userCredential.user!.displayName);

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(image: NetworkImage('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTVwMMhYl16MgXCBJC6DDLVVyvFgR_EymqYsw&usqp=CAU'))
                ),
              ),
            ),
            Text('Chat app',style: TextStyle(fontSize: 36,fontWeight: FontWeight.bold),),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 20),
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.black),
                  padding: MaterialStateProperty.all(EdgeInsets.symmetric(vertical: 12))
                ),
                onPressed: ()async{
                  await signInFunction();
                }, 
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
            Image.network('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSK5q0FP74VV9wbfwP378_7kj7iDomHuKrxkXsxDdUT28V9dlVMNUe-EMzaLwaFhneeuZI&usqp=CAU',height: 36,),
            SizedBox(width: 10,),
            Text('Sign in with google',style: TextStyle(fontSize: 20),)
                ],
              )),
            )
          ],
        ),
      ),
    );
  }
}