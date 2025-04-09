import 'package:chatbot/GenerateImage.dart';
import 'package:chatbot/HomePage.dart';
import 'package:flutter/material.dart';
import 'package:chatbot/summarizer.dart';

import 'dashboard.dart';

class Onboarding extends StatelessWidget {
  const Onboarding({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFE9CE),
      body: Center(

        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            
            crossAxisAlignment: CrossAxisAlignment.center,
                 
            children: [
              SizedBox(height: 90),
              Text('Hello,',style: TextStyle(fontSize: 50, fontWeight: FontWeight.w100, color: Color(0xFF4E51BF))),
              SizedBox(height: 1),
              Text("I'm LoreAI",style: TextStyle(fontSize: 50, fontWeight: FontWeight.w100, color: Color(0xFF4E51BF))),
              SizedBox(height: 100),
              Image(image: AssetImage("assets/images/bot.png"), height: 170),
              SizedBox(height: 130),
              ElevatedButton(onPressed: (){
                Navigator.pushAndRemoveUntil(context, 
                MaterialPageRoute(builder: (context) => Dashboard()),
                (route) => false);
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)
                ),
                padding: EdgeInsets.only(left: 28, right: 28, top: 18, bottom: 18),
                backgroundColor: Color(0xFF4E51BF),
                foregroundColor: Colors.white,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Continue',style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300)),
                  SizedBox(width: 8),
                  Icon(Icons.arrow_forward, color: Colors.white,)
                ],
              ),)
            ],
          ),
        ),
      ),
    );
  }
}