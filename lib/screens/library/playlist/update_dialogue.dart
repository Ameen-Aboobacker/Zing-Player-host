import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:music_app/db/model/muzic_model.dart';
import 'package:music_app/screens/library/playlist/delete_playlist.dart';
import 'package:music_app/screens/library/playlist/edit_playlist.dart';

class UpdateDialogue extends StatelessWidget {
  const UpdateDialogue({
    super.key,
    required this.controller,
    required this.formkey,
    required this.index,
    required this.musicList,
  });
  final int index;
  final Box<MuzicModel> musicList;
  final TextEditingController controller;
  final GlobalKey<FormState> formkey;

  @override
  Widget build(BuildContext context) {
    final MuzicModel data = musicList.values.toList()[index];
    return SimpleDialog(
      title: Text(
        data.name,
        style: const TextStyle(
          color: Colors.white,
        ),
        textAlign: TextAlign.center,
      ),
      contentPadding: const EdgeInsets.only(top: 10, bottom: 8),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15))),
      backgroundColor: const Color.fromARGB(255, 12, 137, 144),
      children: [
        SimpleDialogOption(
          onPressed: () {
            Navigator.of(context).pop();
            controller.text = data.name;
            editplaylist(index, context, formkey, controller, musicList);
          },
          child: Row(
            children: const [
              Icon(
                Icons.edit,
                color: Colors.white,
              ),
              SizedBox(width: 4),
              Text(
                'Edit playlist Name',
                style: TextStyle(
                    fontFamily: 'UbuntuCondensed',
                    color: Color.fromARGB(255, 255, 255, 255),
                    fontSize: 16,
                    fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        SimpleDialogOption(
          onPressed: () {
            Navigator.of(context).pop();
            deleteplaylist(context, musicList, index);
          },
          child: Row(
            children: const [
              Icon(
                Icons.delete,
                color: Color.fromARGB(255, 227, 8, 8),
              ),
              SizedBox(width: 4),
              Text(
                'Delete',
                style: TextStyle(
                    fontFamily: 'UbuntuCondensed',
                    color: Color.fromARGB(255, 255, 255, 255),
                    fontSize: 16,
                    fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

Future editplaylist(index, context, formkey, controller, musicList) {
  return showDialog(
    context: context,
    builder: (ctx) => EditPlaylist(
      controller: controller,
      formkey: formkey,
      index: index,
    ),
  );
}

Future<dynamic> deleteplaylist(contxt, musicList, index) {
  return showDialog(
    context: contxt,
    builder: (context) {
      return DeletePlaylist(musicList: musicList, index: index);
    },
  );
}
