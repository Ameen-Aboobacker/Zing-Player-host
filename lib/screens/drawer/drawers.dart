import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:music_app/screens/drawer/drawer_about_us.dart';
import 'package:music_app/screens/drawer/drawer_privacy.dart';
import 'package:music_app/screens/drawer/drawer_widgets.dart';
import 'package:music_app/screens/drawer/reset_alert.dart';
import 'package:music_app/screens/drawer/share_app.dart';

class HomescreenDrawers extends StatelessWidget {
  const HomescreenDrawers({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/images/bg.jpg'), fit: BoxFit.cover),
      ),
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly, 
          children: [
          const SizedBox(
              height: 200,
              width: 230,
              child: Image(image: AssetImage('assets/images/logo2.png'),),
              ),
              Text('Zing',style: GoogleFonts.frederickaTheGreat(color:Colors.white,fontSize: 70,fontWeight: FontWeight.w500),),
          Column(children: [
            DrawerContent(
              drawername: 'About Us ',
              icon: Icons.person,
              onpressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const AboutUsDrawer()));
              },
            ),
            DrawerContent(
              drawername: 'Privacy & Policy',
              icon: Icons.lock_person_rounded,
              onpressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const PrivacyDrawer()));
              },
            ),
            DrawerContent(
              drawername: 'Share App',
              icon: Icons.share,
              onpressed: () {
                shareAppFile(context);
              },
            ),
            DrawerContent(
              drawername: 'Reset App',
              icon: Icons.replay_circle_filled,
              onpressed: () {
                resetDialogue(context);
              },
            ),
          ]),
        ]),
      ),
    );
  }

  Future<dynamic> resetDialogue(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return const ResetAlert();
      },
    );
  }
}
