import 'package:chat_app/pages/chatRoom.dart';
import 'package:chat_app/pages/forgotPassword.dart';
import 'package:chat_app/pages/signUp.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();

  Future SignIn() async {
    if(emailTextEditingController.text.trim() == "" || passwordTextEditingController.text.trim() == ""){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please fill in all the required fields')));
    }

    else{
      try{
        UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: emailTextEditingController.text.trim(),
            password: passwordTextEditingController.text.trim()
        );
        if(userCredential != null){
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ChatRoom()));
        }
      } on FirebaseAuthException catch(ex){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(ex.code.toString())));
      }
    }
  }

  Future PasswordReset() async {
    try{
      await FirebaseAuth.instance.sendPasswordResetEmail(email: emailTextEditingController.text.trim());
    } on FirebaseAuthException catch(ex){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(ex.code.toString())));
    }
  }

  @override
  void dispose() {
    passwordTextEditingController.dispose();
    super.dispose();
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28.0,vertical: 10.0),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 60.0),
            child: Column(
              children: [
                 Container(
                  width: 150.0,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.deepPurple[200]
                  ),
                  child: Image.asset('images/send-mail.png',width: 25.0),
                ),
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
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 15.0,vertical: 5.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.0),
                      border: Border.all(color: Colors.deepPurple.shade200)
                  ),
                  child: TextField(
                    controller: passwordTextEditingController,
                    style: TextStyle(
                      fontSize: 18.0,
                    ),
                    obscureText: true,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Password',
                    ),
                  ),
                ),
                SizedBox(height: 15.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('chinchin',style: TextStyle(
                      color: Colors.white
                    ),),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => ResetPassword()));
                      },
                      child: Text('Forgot Password?',style: TextStyle(
                        fontSize: 15.0,
                        color: Colors.deepPurple,
                      ),),
                    ),
                  ],
                ),
                SizedBox(height: 20.0),
                GestureDetector(
                  onTap: (){
                    SignIn();
                  },
                  child: Container(
                    height: 60.0,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.deepPurple[200],
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Center(
                      child: Text('Sign In',style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 24.0
                      ),),
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Dont Have an Account?',style: TextStyle(
                      fontSize: 15.0,
                    ),),
                    SizedBox(width: 8.0),
                    GestureDetector(
                      onTap: (){
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SignUp()));
                      },
                      child: Text('Register Now',style: TextStyle(
                        fontSize: 15.0,
                        color: Colors.deepPurple
                      ),),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
