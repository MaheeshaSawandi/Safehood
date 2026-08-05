import 'package:flutter/material.dart';


class SystemSettingsScreen extends StatefulWidget {

  const SystemSettingsScreen({super.key});


  @override
  State<SystemSettingsScreen> createState() =>
      _SystemSettingsScreenState();

}



class _SystemSettingsScreenState 
extends State<SystemSettingsScreen> {


  bool notifications = true;
  bool maintenanceMode = false;


  @override
  Widget build(BuildContext context) {


    return Scaffold(


      backgroundColor:
      const Color(0xffF5F7FB),


      appBar: AppBar(

        backgroundColor:
        const Color(0xff2856A6),

        title: const Text(

          "System Settings",

          style:TextStyle(
            color:Colors.white,
          ),

        ),

        iconTheme:
        const IconThemeData(
          color:Colors.white,
        ),

      ),




      body:Padding(

        padding:
        const EdgeInsets.all(20),


        child:Column(

          children:[



            Container(

              padding:
              const EdgeInsets.all(18),

              decoration:BoxDecoration(

                color:Colors.white,

                borderRadius:
                BorderRadius.circular(15),

              ),


              child:Column(

                children:[



                  SwitchListTile(

                    title:
                    const Text(
                      "Notifications",
                    ),

                    subtitle:
                    const Text(
                      "Enable system notifications",
                    ),

                    value:
                    notifications,


                    onChanged:(value){

                      setState((){

                        notifications=value;

                      });

                    },

                  ),




                  SwitchListTile(

                    title:
                    const Text(
                      "Maintenance Mode",
                    ),


                    subtitle:
                    const Text(
                      "Disable user access temporarily",
                    ),


                    value:
                    maintenanceMode,


                    onChanged:(value){

                      setState((){

                        maintenanceMode=value;

                      });

                    },


                  ),



                ],


              ),


            ),





            const SizedBox(height:20),




            ElevatedButton(


              style:
              ElevatedButton.styleFrom(

                backgroundColor:
                const Color(0xff2856A6),

                minimumSize:
                const Size(
                  double.infinity,
                  50,
                ),

              ),


              onPressed:(){


                ScaffoldMessenger.of(context)
                .showSnackBar(

                  const SnackBar(

                    content:
                    Text(
                      "Settings Saved",
                    ),

                  ),

                );


              },


              child:
              const Text(

                "Save Settings",

                style:
                TextStyle(

                  color:Colors.white,

                ),

              ),


            )



          ],


        ),


      ),


    );


  }


}