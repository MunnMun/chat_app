import 'package:chat_app/pages/conversation.dart';
import 'package:chat_app/pages/costants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  TextEditingController SearchTextEditingController = TextEditingController();

  QuerySnapshot? searchSnapshot;

  GetUserByName() async {
    return await FirebaseFirestore.instance.collection('users')
        .where("name", isEqualTo: SearchTextEditingController.text.trim()).get().then((value){
          setState(() {
            searchSnapshot = value;
          });
    });
  }

  Widget SearchList(){
    return searchSnapshot != null ? ListView.builder(
      itemCount: searchSnapshot!.docs.length,
        shrinkWrap: true,
        itemBuilder: (context,index){
        return SearchTile(
            name: searchSnapshot!.docs[index]["name"],
            email: searchSnapshot!.docs[index]["email"],
        );
      }
    ) : Container();
  }

  @override
  void initState() {
    super.initState();
  }


  createChatroomandConversation(String username) async{
    if(username != constants.Myname){
      String chatRoomID = getChatRoomId(username, constants.Myname!);

      List<String> users = [username, constants.Myname!];
      Map<String,dynamic> chatRoomMap = {
        "users" : users,
        "chatroomID" : chatRoomID
      };

      await FirebaseFirestore.instance.collection("chatRoom").doc(chatRoomID).set(chatRoomMap).catchError((e){
        print(e.toString());
      });

      Navigator.push(context, MaterialPageRoute(builder: (context) => ConversationScreen(chatroomID: chatRoomID)));
    } else{
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Loner')));
    }
  }

  Widget SearchTile({required String name,required String email}){
    return Container(
      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(width: 2.0, color: Colors.grey.shade200)
          )
      ),
      height: 80.0,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(name,style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w500,
                ),),
                SizedBox(height: 10.0),
                Text(email,style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w500,
                ),),
              ],
            ),
            GestureDetector(
              onTap: (){
                createChatroomandConversation(SearchTextEditingController.text.trim());
              },
              child: Container(
                height: 50,
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                decoration: BoxDecoration(
                  color: Colors.deepPurple[200],
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Center(child: Text('Message',style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white
                ),)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple[200],
        title: Text('Amoeba',style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 32.0
        ),),
      ),
      body: Container(
        child: Column(
          children: [
            Container(
              color: Colors.grey[300],
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0,vertical: 15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: TextField(
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Search username...',
                        hintStyle: TextStyle(
                          fontSize: 18.0,
                        ),
                      ),
                      controller: SearchTextEditingController,
                    )),
                    GestureDetector(
                      onTap: () {
                        GetUserByName();
                      },
                      child: Image.asset('images/search.png',width: 25.0),
                    )
                  ],
                ),
              ),
            ),
            SearchList(),
          ],
        )
      ),
    );
  }
}

getChatRoomId(String a, String b) {
  if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
    return "$b\_$a";
  } else {
    return "$a\_$b";
  }
}

