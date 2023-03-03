import 'dart:async';
import 'package:flutter/material.dart';
import 'package:music_app/screens/homescreen/home_screen.dart';
import 'package:google_fonts/google_fonts.dart';


class SplashScreen extends StatefulWidget {
  const  SplashScreen({super.key});
 
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
 
  @override
  void initState() {
    super.initState();
    goToHome(context); 
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/Splash.jpg'), fit: BoxFit.cover),
          ),
      child:  Scaffold(
        backgroundColor: Colors.transparent, 
        body: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 280,),
              Row( 
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Zi',style: GoogleFonts.frederickaTheGreat(color:Colors.white,fontSize: 70,fontWeight: FontWeight.w500),),
                  const SizedBox(width:30),
                  Text('n',style: GoogleFonts.frederickaTheGreat(color:Colors.white,fontSize: 70,fontWeight: FontWeight.w500),),
                  const SizedBox(width:25),
                  Text('g',style: GoogleFonts.frederickaTheGreat(color:Colors.white,fontSize: 70,fontWeight: FontWeight.w500),),
                ],
              ),
            ],
          ))
        
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}

Future<void> goToHome(context) async {
  Timer(const Duration(seconds: 5), (() {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) =>  const HomeScreen()));  
  }));
}
