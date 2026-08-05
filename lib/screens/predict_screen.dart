import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import 'home_screen.dart';
import 'map_screen.dart';
import 'emergency_screen.dart';
import 'profile_screen.dart';



class PredictScreen extends StatefulWidget {

  const PredictScreen({super.key});

  @override
  State<PredictScreen> createState() => _PredictScreenState();

}




class _PredictScreenState extends State<PredictScreen> {


  int currentIndex = 2;



  void navigate(int index){


    if(index == currentIndex){
      return;
    }


    switch(index){


      case 0:

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder:(context)=>const HomeScreen(),
          ),
        );

        break;



      case 1:

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder:(context)=>const MapScreen(),
          ),
        );

        break;



      case 2:

        break;



      case 3:

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder:(context)=>const EmergencyScreen(),
          ),
        );

        break;



      case 4:

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder:(context)=>const ProfileScreen(),
          ),
        );

        break;

    }

  }






@override
Widget build(BuildContext context){


return Scaffold(


backgroundColor:const Color(0xffF5F7FB),



body:SafeArea(

child:Column(

children:[



Container(

height:70,

width:double.infinity,

color:Colors.white,

padding:
const EdgeInsets.symmetric(horizontal:20),


child:Column(

crossAxisAlignment:
CrossAxisAlignment.start,


mainAxisAlignment:
MainAxisAlignment.center,


children:[


const Text(

"Risk Prediction",

style:TextStyle(

fontSize:22,

fontWeight:FontWeight.bold,

),

),



Text(

"AI-powered crime risk forecasting",

style:TextStyle(

fontSize:12,

color:Colors.grey,

),

),


],


),

),





Expanded(

child:SingleChildScrollView(

padding:
const EdgeInsets.all(18),



child:Column(

crossAxisAlignment:
CrossAxisAlignment.start,


children:[





Container(

padding:
const EdgeInsets.all(18),


decoration:BoxDecoration(

color:Colors.white,

borderRadius:
BorderRadius.circular(18),

),



child:Column(

children:[


Row(

mainAxisAlignment:
MainAxisAlignment.spaceBetween,


children:[


const Text(

"Risk Trend",

style:TextStyle(

fontSize:16,

fontWeight:FontWeight.bold,

),

),



Container(

padding:
const EdgeInsets.all(8),

decoration:BoxDecoration(

color:Colors.grey.shade100,

borderRadius:
BorderRadius.circular(15),

),


child:
const Text(
"1M   6M   1Y",
style:TextStyle(
fontSize:12,
),
),

)

],


),





const SizedBox(height:25),



SizedBox(

height:200,


child:LineChart(

LineChartData(


borderData:
FlBorderData(show:false),


gridData:
const FlGridData(show:false),


titlesData:
const FlTitlesData(show:false),



lineBarsData:[


LineChartBarData(


spots:[

FlSpot(0,35),

FlSpot(1,40),

FlSpot(2,37),

FlSpot(3,45),

FlSpot(4,42),

FlSpot(5,48),

],


isCurved:true,


color:Colors.redAccent,


barWidth:3,


belowBarData:BarAreaData(

show:true,

color:Colors.red.shade100,

),


)


],



),


),


),


],


),


),





const SizedBox(height:20),





const Text(

"Insights",

style:TextStyle(

fontSize:18,

fontWeight:FontWeight.bold,

),

),




const SizedBox(height:10),




insightCard(

Icons.warning,

"High Risk Alert",

"Predicted 15% increase in theft incidents in Colombo 07 area during late evening hours next week.",

Colors.red.shade50,

Colors.red,

),



const SizedBox(height:12),



insightCard(

Icons.check_circle,

"Safety Improvement",

"Kandy area shows a declining trend in hazard reports for the upcoming month.",

Colors.green.shade50,

Colors.green,

),





const SizedBox(height:20),





Container(

padding:
const EdgeInsets.all(18),


decoration:BoxDecoration(

color:Colors.white,

borderRadius:
BorderRadius.circular(18),

),



child:Column(

crossAxisAlignment:
CrossAxisAlignment.start,


children:[



const Text(

"Safe Travel Times",

style:TextStyle(

fontSize:16,

fontWeight:FontWeight.bold,

),

),



const SizedBox(height:20),




travelTime(
"06:00 AM - 10:00 AM",
"High Safety",
Colors.green
),



travelTime(
"10:00 AM - 04:00 PM",
"Moderate Safety",
Colors.orange
),



travelTime(
"07:00 PM - 12:00 AM",
"Low Safety",
Colors.red
),



],


),


)





],


),


),


)





],


),


),





bottomNavigationBar:BottomNavigationBar(


currentIndex:currentIndex,


type:
BottomNavigationBarType.fixed,


selectedItemColor:
Colors.blue,


unselectedItemColor:
Colors.grey,


onTap:navigate,



items: const [


BottomNavigationBarItem(

icon:Icon(Icons.home),

label:"Home",

),


BottomNavigationBarItem(

icon:Icon(Icons.map),

label:"Map",

),


BottomNavigationBarItem(

icon:Icon(Icons.analytics),

label:"Predict",

),


BottomNavigationBarItem(

icon:Icon(Icons.phone),

label:"Emergency",

),


BottomNavigationBarItem(

icon:Icon(Icons.person),

label:"Profile",

),


],



),



);


}






Widget insightCard(
IconData icon,
String title,
String desc,
Color bg,
Color iconColor
){


return Container(

padding:
const EdgeInsets.all(15),


decoration:BoxDecoration(

color:bg,

borderRadius:
BorderRadius.circular(15),

),


child:Row(

children:[


Icon(icon,color:iconColor),


const SizedBox(width:10),


Expanded(

child:Column(

crossAxisAlignment:
CrossAxisAlignment.start,


children:[


Text(

title,

style:const TextStyle(

fontWeight:FontWeight.bold,

),

),


const SizedBox(height:5),



Text(

desc,

style:const TextStyle(

fontSize:12,

),

)



],


),


)


],


),


);


}





Widget travelTime(
String time,
String status,
Color color
){


return Padding(

padding:
const EdgeInsets.only(bottom:15),


child:Row(

mainAxisAlignment:
MainAxisAlignment.spaceBetween,


children:[


Text(time),



Text(

status,

style:TextStyle(

color:color,

fontWeight:FontWeight.bold,

),

)


],


),


);


}



}