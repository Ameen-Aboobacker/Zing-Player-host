import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:music_app/controller/get_all_song_controller.dart';
import 'package:music_app/db/functions/favorite_db.dart';
import 'package:music_app/db/functions/recent_db.dart';
import 'package:music_app/screens/library/favoritescreen/add_songs_list.dart';
import 'package:music_app/screens/miniplayer/mini_player.dart';
import 'package:music_app/screens/musicplayingscreen/music_playing_screen.dart';
import 'package:on_audio_query/on_audio_query.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  late List<SongModel> song;
  @override
  Widget build(BuildContext context) {
    return Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
            image: DecorationImage(image: AssetImage('assets/images/bg.jpg'))),
        child: Scaffold(
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return const SongListPage();
                  },
                ),
              );
            },
            label: const Text('Add Songs'),
            icon: const Icon(
              Icons.add_circle_outline,
              size: 35,
            ),
            backgroundColor: const Color.fromARGB(255, 3, 18, 83),
          ),
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: const Text(
              'Favorite',
              style: TextStyle(
                fontFamily: 'UbuntuCondensed',
                color: Colors.white,
                fontSize: 26,
              ),
            ),
            centerTitle: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          body: Padding(
            padding: const EdgeInsets.fromLTRB(15, 5, 15, 0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ValueListenableBuilder(
                      valueListenable: Hive.box<int>('FavoriteDB').listenable(),
                      builder: (BuildContext ctx, Box<int> favoriteData,
                          Widget? child) {
                            song=listPlaylist(favoriteData.values.toList());
                        return song.isEmpty
                            ? Padding(
                                padding:
                                    const EdgeInsets.only(top: 70, left: 10),
                                child: Center(
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.18,
                                      ),
                                      const Text(
                                        'No Favorite Songs',
                                        style: TextStyle(
                                          fontFamily: 'UbuntuCondensed',
                                          color: Color.fromARGB(
                                              255, 255, 255, 255),
                                          fontSize: 18,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : ListView.separated(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: song.length,
                                itemBuilder: (ctx, index) {
                                  return ListTile(
                                    tileColor:
                                        const Color.fromARGB(255, 12, 12, 12),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    minVerticalPadding: 10.0,
                                    contentPadding: const EdgeInsets.all(0),
                                    onTap: () {
                                      List<SongModel> favoriteList =[ ...song];              
                                      GetAllSongController.audioPlayer
                                          .setAudioSource(
                                              GetAllSongController
                                                  .createSongList(favoriteList),
                                              initialIndex: index);
                                      GetAllSongController.audioPlayer.play();
                                      GetRecentSong.addRecentlyPlayed(
                                          favoriteList[index].id);
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (ctx) => MusicPlayingScreen(
                                            songModelList: favoriteList,
                                          ),
                                        ),
                                      );
                                    },
                                    leading: Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: QueryArtworkWidget(
                                        id: song[index].id,
                                        type: ArtworkType.AUDIO,
                                        nullArtworkWidget: const Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(5, 5, 5, 5),
                                          child: Icon(
                                            Icons.music_note,
                                            color: Colors.white,
                                            size: 33,
                                          ),
                                        ),
                                      ),
                                    ),
                                    title: Text(
                                      song[index].displayNameWOExt,
                                      maxLines: 1,
                                      style: const TextStyle(
                                        fontFamily: 'UbuntuCondensed',
                                        color:
                                            Color.fromARGB(255, 255, 255, 255),
                                        fontSize: 18,
                                      ),
                                    ),
                                    subtitle: Text(
                                      song[index].artist.toString(),
                                      maxLines: 1,
                                      style: const TextStyle(
                                        fontFamily: 'UbuntuCondensed',
                                        color:
                                            Color.fromARGB(255, 255, 255, 255),
                                        fontSize: 11,
                                      ),
                                    ),
                                    trailing: IconButton(
                                        onPressed: () {
                                          FavoriteDb.favoriteSongs
                                              .notifyListeners();
                                          FavoriteDb.delete(
                                              song[index].id);
                                          SnackBar snackbar = const SnackBar(
                                            backgroundColor: Colors.black,
                                            content: Text(
                                              'Song deleted from your favorites',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                            duration: Duration(
                                              seconds: 1,
                                            ),
                                          );
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(snackbar);
                                        },
                                        icon: const Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                        )),
                                  );
                                },
                                separatorBuilder:
                                    (BuildContext context, index) {
                                  return const Divider(
                                    height: 10.0,
                                  );
                                },
                              );
                      }),
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
                      const MiniPlayer(),
                  ],
                ),
              );
            },
          ),
        ));
  }
}
List<SongModel> listPlaylist(List<int> songlist) {
    List<SongModel> songs = [];
    for (int i = 0; i < GetAllSongController.songscopy.length; i++) {
      for (int j = 0; j < songlist.length; j++) {
        if (GetAllSongController.songscopy[i].id == songlist[j]) {
          songs.add(GetAllSongController.songscopy[i]);
        }
      }
    }
    return songs;
  }

