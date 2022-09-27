import 'package:chat_app/pages/conversation.dart';
import 'package:chat_app/pages/costants.dart';
import 'package:chat_app/pages/search.dart';
import 'package:chat_app/pages/signIn.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatRoom extends StatefulWidget {
  const ChatRoom({Key? key}) : super(key: key);

  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {

  Stream<QuerySnapshot>? ChatRoomStream;

  Widget ChatRoomList(){
    return StreamBuilder<QuerySnapshot>(
      stream: ChatRoomStream,
      builder: (context,snapshot){
        if(snapshot.connectionState == ConnectionState.active){
          if(snapshot.hasData){
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context,index){
                Map<String,dynamic> roomMap =  snapshot.data!.docs[index].data() as Map<String,dynamic>;

                return ChatRoomTiles(userName: roomMap["chatroomID"].toString()
                    .replaceAll("_", "").replaceAll(constants.Myname.toString(), ""),
                  ChatRoomId: roomMap["chatroomID"],
                );
              },
            );
          } else {
            return Container();
          }
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      }
    );
  }

  @override
  void initState(){
    getUserInfo();
    super.initState();
  }

  getUserInfo() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    constants.Myname = prefs.getString("name");

    getChatRoom(constants.Myname).then((value){
      setState(() {
        ChatRoomStream = value;
      });
    });
  }

  getChatRoom(String? userName) async {
    return await FirebaseFirestore.instance.collection('chatRoom').where("users",arrayContains: userName).snapshots();
  }

  Future _signOut() async {
    try{
      await FirebaseAuth.instance.signOut();
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SignIn()));
    } on FirebaseAuthException catch(ex){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(ex.code.toString())));
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple[200],
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Amoeba',style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 32.0
              ),),
              GestureDetector(
                onTap: (){
                  _signOut();
                },
                  child: Icon(Icons.exit_to_app,size: 30.0,)
              )
            ],
          ),
        ),
      ),
      body: ChatRoomList(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple[200],
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => Search()));
        },
        child: Icon(Icons.search,size: 30.0),
      ),
    );
  }
}

class ChatRoomTiles extends StatelessWidget {
  final String userName;
  final String ChatRoomId;
  ChatRoomTiles({required this.userName,required this.ChatRoomId});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => ConversationScreen(chatroomID: ChatRoomId)));
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24.0,vertical: 16.0),
        decoration: BoxDecoration(
          color: Colors.grey[350],
            border: Border(
                bottom: BorderSide(width: 2.0, color: Colors.grey.shade200)
            )
        ),
        child: Row(
          children: [
            Container(
              height: 40.0,
              width: 40.0,
              decoration: BoxDecoration(
                color: Colors.deepPurple[200],
                shape: BoxShape.circle
              ),
              child: Center(child: Text("${userName.substring(0,1).toUpperCase()}",style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20.0
              ),)),
            ),
            SizedBox(width: 8.0),
            Center(
              child: Text(userName,style: TextStyle(
                color: Colors.white,
                fontSize: 20.0
              ),),
            )
          ],
        ),
      ),
    );
  }
}

