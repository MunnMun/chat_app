import 'package:chat_app/pages/signIn.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController UserNameTextEditingController = TextEditingController();
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();
  TextEditingController confirmpasswordTextEditingController = TextEditingController();

  void createAccount() async {
    String Username = UserNameTextEditingController.text.trim();
    String Email = emailTextEditingController.text.trim();
    String  Password = passwordTextEditingController.text.trim();
    String cPassword = confirmpasswordTextEditingController.text.trim();

    final SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setString("name", Username);
    await prefs.setString("email", Email);

    if(Username == "" || Email == "" || Password == "" || cPassword == ""){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please fill in all the required fields')));
    }
    else if(Password != cPassword){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Passwords do not match')));
    }
    else{
      try{
        UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: Email, password: Password);
        FirebaseFirestore.instance.collection('users').add({
          "name": Username,
          "email": Email
        });

        if(userCredential.user != null){
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SignIn()));
        }
      } on FirebaseAuthException catch(ex){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(ex.code.toString())));
      }
    }
  }

  @override
  void dispose() {
    passwordTextEditingController.dispose();
    confirmpasswordTextEditingController.dispose();
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
            padding: const EdgeInsets.only(top: 20.0),
            child: Column(
              children: [
                SizedBox(height: 30.0),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 15.0,vertical: 5.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.0),
                      border: Border.all(color: Colors.deepPurple.shade200)
                  ),
                  child: TextField(
                    controller: UserNameTextEditingController,
                    style: TextStyle(
                      fontSize: 18.0,
                    ),
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'username'
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
                SizedBox(height: 20.0),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 15.0,vertical: 5.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.0),
                      border: Border.all(color: Colors.deepPurple.shade200)
                  ),
                  child: TextField(
                    controller: confirmpasswordTextEditingController,
                    style: TextStyle(
                      fontSize: 18.0,
                    ),
                    obscureText: true,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Confirm Password',
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
                GestureDetector(
                  onTap: (){
                    createAccount();
                  },
                  child: Container(
                    height: 60.0,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.deepPurple[200],
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Center(
                      child: Text('Sign Up',style: TextStyle(
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
                    Text('Already Have an Account?',style: TextStyle(
                      fontSize: 15.0,
                    ),),
                    SizedBox(width: 8.0),
                    GestureDetector(
                      onTap: (){
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SignIn()));
                      },
                      child: Text('Sign In Now',style: TextStyle(
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
      )
    );
  }
}
