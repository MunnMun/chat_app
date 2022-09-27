import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({Key? key}) : super(key: key);

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  TextEditingController emailTextEditingController = TextEditingController();

  void forgotPassword() async {
    try{
      await FirebaseAuth.instance.sendPasswordResetEmail(email: emailTextEditingController.text.trim());
      showDialog(context: context, builder: (context){
        return AlertDialog(
          content: Text(
            'please check your mail if you did not recieve any mail pls check spam'
          ),
        );
      });
    } on FirebaseAuthException catch(ex) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(ex.code.toString())));
    }
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28.0,vertical: 10.0),
          child: Column(
            children: [
              SizedBox(height: 20.0),
              Text('Enter Your Mail',style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold
              ),),
              SizedBox(height: 20.0),
              Text('We will send you a Password Reset link',style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold
              ),),
              SizedBox(height: 50.0),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 15.0,vertical: 5.0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.0),
                    border: Border.all(color: Colors.deepPurple.shade200)
                ),
                child: TextField(
                  controller: emailTextEditingController,
                  style: TextStyle(
                    fontSize: 18.0,
                  ),
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'E-mail'
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              GestureDetector(
                onTap: (){
                  forgotPassword();
                },
                child: Container(
                  height: 60.0,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.deepPurple[200],
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Center(
                    child: Text('Reset',style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 24.0
                    ),),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
