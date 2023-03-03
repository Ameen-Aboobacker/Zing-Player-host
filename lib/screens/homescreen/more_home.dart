import 'package:flutter/material.dart';
import 'package:music_app/screens/homescreen/add_to_playlist.dart';
import 'package:music_app/screens/homescreen/home_screen.dart';
import 'package:music_app/screens/library/favoritescreen/favorite_button.dart';
import 'package:on_audio_query/on_audio_query.dart';

class MoreDialogue extends StatelessWidget {
  const MoreDialogue({
    super.key,
    required this.index, required this.song,
  });

  final int  index;
  final SongModel song;

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Text(
        song.displayNameWOExt.toUpperCase(),
        style: const TextStyle(color: Colors.white),
      ),
      contentPadding: const EdgeInsets.only(top: 7, bottom: 7),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15))),
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      children: [
        const SizedBox(
          height: 7,
        ),
        SimpleDialogOption(
          onPressed: () {
            Navigator.of(context).pop();
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => AddtoPlaylist(
                      findex: index,
                    )));
          },
          child: Row(
            children: const [
              Icon(
                Icons.playlist_add,
                color: Colors.white,
              ),
              SizedBox(width: 4),
              Text(
                'Add to playlist',
                style: TextStyle(
                    fontFamily: 'UbuntuCondensed',
                    color: Color.fromARGB(255, 255, 255, 255),
                    fontSize: 16,
                    fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
        SimpleDialogOption(
          child: Row(
            children: [
              const Icon(
                Icons.favorite,
                color: Colors.white,
              ),
              FavoriteButton(songFavorite: startSong[index]),
            ],
          ),
        ),
      ],
    );
  }
}
