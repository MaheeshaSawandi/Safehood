import 'package:flutter/material.dart';

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({super.key});

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {

  String selectedLanguage = "English";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F7FB),

      appBar: AppBar(
        title: const Text("Language"),
        backgroundColor: const Color(0xff2856A6),
        foregroundColor: Colors.white,
      ),

      body: ListView(

        children: [

          RadioListTile(

            value: "English",

            groupValue: selectedLanguage,

            title: const Text("English"),

            onChanged: (value){
              setState(() {
                selectedLanguage = value!;
              });
            },

          ),
          
/*
          RadioListTile(

            value: "Sinhala",

            groupValue: selectedLanguage,

            title: const Text("සිංහල"),

            onChanged: (value){
              setState(() {
                selectedLanguage = value!;
              });
            },

          ),

*/
          const SizedBox(height:25),

          Padding(

            padding: const EdgeInsets.all(20),

            child: ElevatedButton(

              onPressed: (){

                ScaffoldMessenger.of(context).showSnackBar(

                  SnackBar(
                    content: Text(
                      "Language changed to $selectedLanguage",
                    ),
                  ),

                );

              },

              child: const Text("Save"),

            ),

          ),

        ],

      ),

    );
  }
}