import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:music_app/db/functions/favorite_db.dart';
import 'package:music_app/db/functions/playlist_db.dart';
import 'package:music_app/db/model/muzic_model.dart';
import 'package:music_app/screens/homescreen/home_screen.dart';
import 'package:music_app/screens/library/playlist/create_playlist.dart';
import 'package:music_app/screens/library/playlist/list_of_playlist.dart';
import 'package:music_app/screens/miniplayer/mini_player.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../../../controller/get_all_song_controller.dart';

class PlaylistScreen extends StatefulWidget {
  const PlaylistScreen({
    super.key,
  });

  @override
  State<PlaylistScreen> createState() => _PlaylistScreenState();
}

TextEditingController nameController = TextEditingController();
final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

class _PlaylistScreenState extends State<PlaylistScreen> {
  @override
  void initState() {
    super.initState();
  }

  final play = Hive.box<MuzicModel>('playlistDb');

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: const BoxDecoration(
          image: DecorationImage(image: AssetImage('assets/images/bg.jpg'))),
      child: ValueListenableBuilder(
        valueListenable: Hive.box<MuzicModel>('playlistDb').listenable(),
        builder:
            (BuildContext context, Box<MuzicModel> musicList, Widget? child) {
          return Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              title: const Text(
                'Playlist',
                style: TextStyle(
                  fontFamily: 'UbuntuCondensed',
                  color: Color.fromARGB(255, 255, 255, 255),
                  fontSize: 26,
                ),
              ),
              centerTitle: true,
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                nameController.clear();
                newplaylist(context, _formKey, nameController);
              },
              backgroundColor: const Color.fromARGB(255, 5, 64, 141),
              child: const Icon(
                Icons.playlist_add,
                color: Color.fromARGB(255, 255, 255, 255),
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    play.isEmpty
                        ? Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 100, horizontal: 50),
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(80.0),
                                child: Column(
                                  children: const [
                                    Text(
                                      'No Playlist',
                                      style: TextStyle(
                                        fontFamily: 'UbuntuCondensed',
                                        color:
                                            Color.fromARGB(255, 255, 255, 255),
                                        fontSize: 18,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        : PlaylistView(
                            musicList: musicList,
                          ),
                  ],
                ),
              ),
            ),
            bottomNavigationBar: ValueListenableBuilder(
              valueListenable: FavoriteDb.favoriteSongs,
              builder:
                  (BuildContext context, List<SongModel> music, Widget? child) {
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      if (GetAllSongController.audioPlayer.currentIndex != null)
                        const MiniPlayer()
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

Future newplaylist(BuildContext context, formKey, nameController) {
  return showDialog(
    context: context,
    builder: (ctx) =>
        CreatePlaylist(formKey: formKey, nameController: nameController),
  );
}
