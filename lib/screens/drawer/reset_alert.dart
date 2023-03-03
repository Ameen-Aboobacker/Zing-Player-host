import 'package:flutter/material.dart';
import 'package:music_app/controller/get_all_song_controller.dart';
import 'package:music_app/db/functions/playlist_db.dart';

class ResetAlert extends StatelessWidget {
  const ResetAlert({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor:
          const Color.fromARGB(255, 15, 159, 167),
      title: const Text(
        'Reset App',
        style: TextStyle(
            fontFamily: 'UbuntuCondensed',
            color: Color.fromARGB(255, 255, 255, 255),
            fontSize: 17,
            fontWeight: FontWeight.w600),
      ),
      content: const Text(
        "Are you sure you want to reset the App?       your saved datas will be deleted ",
        style: TextStyle(
          fontFamily: 'UbuntuCondensed',
          color: Color.fromARGB(255, 255, 255, 255),
          fontSize: 15,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text(
            'No',
            style: TextStyle(
              fontFamily: 'UbuntuCondensed',
              color: Color.fromARGB(255, 255, 255, 255),
              fontSize: 15,
            ),
          ),
        ),
        TextButton(
          onPressed: () {
            PlaylistDb.resetAPP(context);
            GetAllSongController.audioPlayer.stop();
          },
          child: const Text(
            'Yes',
            style: TextStyle(
              fontFamily: 'UbuntuCondensed',
              color: Color.fromARGB(255, 255, 255, 255),
              fontSize: 15,
            ),
          ),
        ),
      ],
    );
  }
}