import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'signup_screen.dart';
import 'forgot_password_screen.dart';
import 'home_screen.dart';



class LoginScreen extends StatefulWidget {

  const LoginScreen({super.key});


  @override
  State<LoginScreen> createState()=>_LoginScreenState();

}



class _LoginScreenState extends State<LoginScreen>{


final emailController = TextEditingController();

final passwordController = TextEditingController();


bool rememberMe = false;


@override
void initState(){

super.initState();

loadRememberMe();

}


// LOAD SAVED EMAIL

Future<void> loadRememberMe() async{

final prefs = await SharedPreferences.getInstance();


bool savedRemember =
prefs.getBool("rememberMe") ?? false;


String savedEmail =
prefs.getString("email") ?? "";



setState((){

rememberMe = savedRemember;


if(savedRemember){

emailController.text = savedEmail;

}

});


}





// SAVE REMEMBER ME

Future<void> saveRememberMe() async{


final prefs = await SharedPreferences.getInstance();



if(rememberMe){


await prefs.setBool(
"rememberMe",
true
);


await prefs.setString(
"email",
emailController.text.trim()
);


}

else{


await prefs.remove("rememberMe");

await prefs.remove("email");


}


}







// LOGIN FUNCTION

Future<void> login() async{


String email =
emailController.text.trim();


String password =
passwordController.text.trim();





// FR-07 Required field validation

if(email.isEmpty || password.isEmpty){


showMessage(
"Please fill all required fields"
);


return;

}




// FR-10 Email validation

if(!RegExp(
r'^[\w-\.]+@([\w-]+\.)+[\w]{2,4}$'
).hasMatch(email)){


showMessage(
"Please enter a valid email address"
);


return;

}





try{


// FR-09 Firebase Login

await FirebaseAuth.instance
.signInWithEmailAndPassword(

email:email,

password:password,

);




// FR-08 Remember Me

await saveRememberMe();




showMessage(
"Login Successful",
color:Colors.green
);




Navigator.pushReplacement(

context,

MaterialPageRoute(

builder:(context)=>
const HomeScreen(),

),

);



}





on FirebaseAuthException catch(e){

String message = "Login failed";


print("Firebase Error Code: ${e.code}");



switch(e.code){


case "wrong-password":

message = "Incorrect password";

break;



case "invalid-credential":

message = "Incorrect email or password";

break;



case "user-not-found":

message = "No account found with this email";

break;



case "invalid-email":

message = "Invalid email address";

break;



case "too-many-requests":

message = "Too many attempts. Try again later";

break;



default:

message = e.message ?? "Login failed";

}



showMessage(message);


}




}





void showMessage(
String text,
{Color color = Colors.red}
){


ScaffoldMessenger.of(context)
.showSnackBar(

SnackBar(

content:Text(text),

backgroundColor:color,

),

);


}







@override
void dispose(){


emailController.dispose();

passwordController.dispose();


super.dispose();

}








@override
Widget build(BuildContext context){


return Scaffold(


backgroundColor:
const Color(0xffF5F7FB),



body:SafeArea(


child:SingleChildScrollView(


padding:
const EdgeInsets.all(20),



child:Column(

children:[




const SizedBox(height:40),




Container(

height:90,

width:90,


decoration:BoxDecoration(

color:Colors.blue,

borderRadius:
BorderRadius.circular(20),

),


child:
const Icon(

Icons.home,

size:50,

color:Colors.white,

),

),




const SizedBox(height:20),




const Text(

"Welcome Back",

style:TextStyle(

fontSize:28,

fontWeight:
FontWeight.bold,

),

),




const SizedBox(height:8),




const Text(

"Login to continue",

style:TextStyle(

color:Colors.grey,

fontSize:16,

),

),





const SizedBox(height:40),





TextField(

controller:
emailController,


decoration:InputDecoration(

hintText:
"Enter your email",

prefixIcon:
const Icon(
Icons.email_outlined
),


filled:true,

fillColor:Colors.white,


border:
OutlineInputBorder(

borderRadius:
BorderRadius.circular(12)

),

),

),





const SizedBox(height:20),






TextField(

controller:
passwordController,


obscureText:true,


decoration:InputDecoration(

hintText:
"Enter password",


prefixIcon:
const Icon(
Icons.lock_outline
),


filled:true,

fillColor:Colors.white,


border:
OutlineInputBorder(

borderRadius:
BorderRadius.circular(12)

),

),

),





const SizedBox(height:15),





Row(

mainAxisAlignment:
MainAxisAlignment.spaceBetween,


children:[



Row(

children:[


Checkbox(

value:
rememberMe,


onChanged:(value){


setState((){


rememberMe =
value ?? false;


});


},


),



const Text(

"Remember Me",

style:
TextStyle(fontSize:12),

),



],

),





GestureDetector(

onTap:(){


Navigator.push(

context,

MaterialPageRoute(

builder:(context)=>
const ForgotPasswordScreen(),

),

);


},


child:
const Text(

"Forgot Password?",


style:TextStyle(

color:Colors.blue,

fontSize:12,

),

),

),




],

),





const SizedBox(height:20),






SizedBox(

width:
double.infinity,

height:50,


child:
ElevatedButton(


style:
ElevatedButton.styleFrom(

backgroundColor:
Colors.blue,


shape:
RoundedRectangleBorder(

borderRadius:
BorderRadius.circular(12),

),

),



onPressed:
login,



child:
const Text(

"Login",

style:
TextStyle(

color:Colors.white,

fontSize:16,

),

),

),


),





const SizedBox(height:20),





TextButton(

onPressed:(){


Navigator.push(

context,

MaterialPageRoute(

builder:(context)=>
const SignupScreen(),

),

);


},


child:
const Text(

"Don't have an account? Sign Up",

style:
TextStyle(fontSize:15),

),

),




],

),


),


),


);


}



}