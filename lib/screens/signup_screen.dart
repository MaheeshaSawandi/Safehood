import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';


class SignupScreen extends StatefulWidget {

  const SignupScreen({super.key});


  @override
  State<SignupScreen> createState()=>_SignupScreenState();

}



class _SignupScreenState extends State<SignupScreen>{


final nameController = TextEditingController();
final emailController = TextEditingController();
final passwordController = TextEditingController();
final confirmController = TextEditingController();


final auth = FirebaseAuth.instance;



// PASSWORD STRENGTH VALIDATION
bool checkPasswordStrength(String password){

  final hasUppercase =
      password.contains(RegExp(r'[A-Z]'));

  final hasLowercase =
      password.contains(RegExp(r'[a-z]'));

  final hasNumber =
      password.contains(RegExp(r'[0-9]'));


  return password.length >= 8 &&
      hasUppercase &&
      hasLowercase &&
      hasNumber;

}





// SIGNUP FUNCTION

void signup() async{


// FR-07 REQUIRED FIELD VALIDATION

if(
nameController.text.trim().isEmpty ||
emailController.text.trim().isEmpty ||
passwordController.text.isEmpty ||
confirmController.text.isEmpty
){

ScaffoldMessenger.of(context).showSnackBar(

const SnackBar(
content:Text(
"Please fill all required fields"
)
)

);

return;

}





// FR-04 PASSWORD MATCHING

if(passwordController.text != confirmController.text){


ScaffoldMessenger.of(context).showSnackBar(

const SnackBar(

content:Text(
"Passwords do not match"
)

)

);


return;

}





// FR-05 PASSWORD STRENGTH

if(!checkPasswordStrength(passwordController.text)){


ScaffoldMessenger.of(context).showSnackBar(

const SnackBar(

content:Text(
"Password must contain 8 characters, uppercase, lowercase and number"
)

)

);


return;

}





try{


// FR-06 PASSWORD HASHING
// Firebase automatically hashes and stores passwords securely


await auth.createUserWithEmailAndPassword(

email:emailController.text.trim(),

password:passwordController.text.trim(),

);




ScaffoldMessenger.of(context).showSnackBar(

const SnackBar(

content:Text(
"Account Created Successfully"
)

)

);



Navigator.pop(context);



}





on FirebaseAuthException catch(e){



// FR-03 UNIQUE EMAIL VALIDATION

if(e.code=="email-already-in-use"){


ScaffoldMessenger.of(context).showSnackBar(

const SnackBar(

content:Text(
"This email is already registered"
)

)

);


}



else if(e.code=="invalid-email"){


ScaffoldMessenger.of(context).showSnackBar(

const SnackBar(

content:Text(
"Enter a valid email address"
)

)

);


}



else{


ScaffoldMessenger.of(context).showSnackBar(

SnackBar(

content:Text(
e.message ?? "Signup failed"
)

)

);


}


}



}





// FR-02 REGISTRATION CANCELLATION

void cancelSignup(){


showDialog(

context:context,

builder:(context)=>AlertDialog(


title:const Text(
"Cancel Registration?"
),


content:const Text(
"Your entered details will be lost."
),


actions:[



TextButton(

onPressed:(){

Navigator.pop(context);

},

child:const Text(
"NO"
),

),




TextButton(

onPressed:(){

Navigator.pop(context);

Navigator.pop(context);

},

child:const Text(
"YES"
),

),



],


)

);


}





@override
Widget build(BuildContext context){


return Scaffold(


backgroundColor:
const Color(0xffF5F7FB),



appBar:AppBar(


backgroundColor:
Colors.transparent,


elevation:0,


leading:IconButton(

icon:
const Icon(Icons.arrow_back),


onPressed:cancelSignup,

),


title:
const Text(
"Sign Up"
),


),





body:SingleChildScrollView(


padding:
const EdgeInsets.all(20),



child:Column(


children:[



const SizedBox(height:20),



const Text(

"Create Account",

style:TextStyle(

fontSize:28,

fontWeight:
FontWeight.bold

),

),




const SizedBox(height:30),





TextField(

controller:nameController,


decoration:InputDecoration(


hintText:"Full Name",

prefixIcon:
const Icon(Icons.person),


border:
OutlineInputBorder(

borderRadius:
BorderRadius.circular(12)

)


),


),





const SizedBox(height:15),





TextField(

controller:emailController,


keyboardType:
TextInputType.emailAddress,


decoration:InputDecoration(


hintText:"Email",

prefixIcon:
const Icon(Icons.email),


border:
OutlineInputBorder(

borderRadius:
BorderRadius.circular(12)

)


),


),





const SizedBox(height:15),





TextField(

controller:passwordController,


obscureText:true,


decoration:InputDecoration(


hintText:"Password",


helperText:
"Minimum 8 chars with uppercase, lowercase & number",


prefixIcon:
const Icon(Icons.lock),


border:
OutlineInputBorder(

borderRadius:
BorderRadius.circular(12)

)


),


),





const SizedBox(height:15),





TextField(

controller:confirmController,


obscureText:true,


decoration:InputDecoration(


hintText:"Confirm Password",


prefixIcon:
const Icon(Icons.lock),


border:
OutlineInputBorder(

borderRadius:
BorderRadius.circular(12)

)


),


),





const SizedBox(height:30),






SizedBox(


width:
double.infinity,


height:50,



child:
ElevatedButton(


onPressed:signup,


style:
ElevatedButton.styleFrom(

backgroundColor:
Colors.blue

),



child:
const Text(

"Create Account",

style:
TextStyle(

color:Colors.white

)

),



),



),





const SizedBox(height:15),





TextButton(


onPressed:cancelSignup,


child:
const Text(

"Cancel"

),



)






],


),


),


);


}


}