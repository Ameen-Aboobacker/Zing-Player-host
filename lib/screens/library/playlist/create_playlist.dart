import 'package:flutter/material.dart';
import 'package:music_app/db/functions/playlist_db.dart';
import 'package:music_app/db/model/muzic_model.dart';

class CreatePlaylist extends StatelessWidget {
  const CreatePlaylist({
    super.key, required this.formKey, required this.nameController,
  });
 final GlobalKey<FormState>  formKey;
 final TextEditingController nameController;

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15))),
      backgroundColor: const Color.fromARGB(255, 45, 98, 243),
      children: [
        const SimpleDialogOption(
          child: Text(
            'New to Playlist',
            style: TextStyle(
                fontFamily: 'UbuntuCondensed',
                color: Color.fromARGB(255, 255, 255, 255),
                fontSize: 18,
                fontWeight: FontWeight.w600),
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        SimpleDialogOption(
          child: Form(
            key: formKey,
            child: TextFormField(
              controller: nameController,
              maxLength: 15,
              decoration: InputDecoration(
                  fillColor: Colors.white.withOpacity(0.7),
                  filled: true,
                  border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(30)),
                  contentPadding: const EdgeInsets.only(left: 15, top: 5)),
              style: const TextStyle(
                  fontFamily: 'UbuntuCondensed',
                  color: Color.fromARGB(255, 0, 0, 0),
                  fontSize: 16,
                  fontWeight: FontWeight.w600),
                  
            ),
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SimpleDialogOption(
              onPressed: () {
                Navigator.of(context).pop();
                nameController.clear();
              },
              child: const Text(
                'Cancel',
                style: TextStyle(
                    fontFamily: 'UbuntuCondensed',
                    color: Color.fromARGB(255, 255, 255, 255),
                    fontSize: 16,
                    fontWeight: FontWeight.w600),
              ),
            ),
            SimpleDialogOption(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  createPlaylist(context,nameController);
                }
              },
              child: const Text(
                'Create',
                style: TextStyle(
                    fontFamily: 'UbuntuCondensed',
                    color: Color.fromARGB(255, 255, 255, 255),
                    fontSize: 16,
                    fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

Future<void> createPlaylist(context,nameController) async {
    final name = nameController.text.trim();
    final music = MuzicModel(name: name, songId: []);

    final datas =
        PlaylistDb.playlistDb.values.map((e) => e.name.trim()).toList();
    if (name.isEmpty) {
      return;
    } else if (datas.contains(music.name)) {
      SnackBar snackbar = const SnackBar(
          duration: Duration(milliseconds: 750),
          backgroundColor: Colors.black,
          content: Text(
            'playlist already exist',
            style: TextStyle(color: Colors.white),
          ));
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
      Navigator.of(context).pop();
    } else {
      PlaylistDb.addPlaylist(music);
      SnackBar snackbar = const SnackBar(
          duration: Duration(milliseconds: 750),
          backgroundColor: Colors.black,
          content: Text(
            'playlist created successfully',
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
            ),
          ));
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
      Navigator.of(context).pop();
    }
  }