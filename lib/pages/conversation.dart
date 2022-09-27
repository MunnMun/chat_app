import 'package:chat_app/pages/costants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ConversationScreen extends StatefulWidget {
  final String chatroomID;
  ConversationScreen({required this.chatroomID});

  @override
  State<ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {

  TextEditingController MessageEditingController = TextEditingController();

  Stream<QuerySnapshot>? ChatMessageStream;

  Widget ChatMessageList(){
    return StreamBuilder<QuerySnapshot>(
      stream: ChatMessageStream,
      builder: (context, snapshot){
        if(snapshot.connectionState == ConnectionState.active){
          if(snapshot.hasData){
            return  ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context,index){
                  Map<String,dynamic> userMap =  snapshot.data!.docs[index].data() as Map<String,dynamic>;

                  return MessageTile(message: userMap["message"],isSentByMe: userMap["sendby"] == constants.Myname);
                },
            );
          } else{
            return Container();
          }
        } else{
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      }
    );
  }

  addConversationChat(String chatroomID, messageMap){
    FirebaseFirestore.instance.collection("chatRoom").doc(chatroomID).collection("chats").add(messageMap).catchError((e){
      print(e.toString());
    });
  }

  GetConversationChat(String chatroomID) async {
    return await FirebaseFirestore.instance.collection("chatRoom").doc(chatroomID).collection("chats").orderBy("time",descending: false).snapshots();
  }


  sendMessage(){
    if(MessageEditingController.text.isNotEmpty){
      Map<String,dynamic> messageMap = {
        "message" : MessageEditingController.text..trim(),
        "sendby" : constants.Myname!,
        "time" : DateTime.now().microsecondsSinceEpoch
      };
      addConversationChat(widget.chatroomID, messageMap);
    }
  }

  @override
  void initState() {
    GetConversationChat(widget.chatroomID).then((value) {
      setState(() {
        ChatMessageStream = value;
      });
    });
    super.initState();
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
            Expanded(
                child: ChatMessageList(),
            ),
            SizedBox(height: 10.0),
            Container(
              alignment: Alignment.bottomCenter,
              child: Container(
                color: Colors.grey[300],
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0,vertical: 15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(child: TextField(
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Message...',
                          hintStyle: TextStyle(
                            fontSize: 18.0,
                          ),
                        ),
                        controller: MessageEditingController,
                      )),
                      GestureDetector(
                        onTap: () {
                          sendMessage();
                          MessageEditingController.clear();
                        },
                        child: Container(
                          width: 40.0,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.deepPurple[200]
                          ),
                            child: Image.asset('images/send-mail.png',width: 25.0),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageTile extends StatelessWidget {
  final String message;
  final bool isSentByMe;

  MessageTile({required this.message,required this.isSentByMe});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: isSentByMe ? 15 : 24, right: isSentByMe ? 24 : 15),
      margin: EdgeInsets.symmetric(vertical: 8.0),
      width: MediaQuery.of(context).size.width,
      alignment: isSentByMe ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 24.0,vertical: 16.0),
          decoration: BoxDecoration(
            color: isSentByMe ? Colors.deepPurple[200] : Colors.grey[600],
            borderRadius: isSentByMe ?
            BorderRadius.only(topRight: Radius.circular(23),topLeft: Radius.circular(23),bottomLeft: Radius.circular(23)) :
            BorderRadius.only(topRight: Radius.circular(23),topLeft: Radius.circular(23),bottomRight: Radius.circular(23))
          ),
          child: Text(message,style: TextStyle(
            color: Colors.white,
            fontSize: 18.0
          ),),
        ),
    );
  }
}
