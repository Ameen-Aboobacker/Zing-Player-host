import 'package:flutter/material.dart';
import 'package:music_app/controller/get_all_song_controller.dart';
import 'package:music_app/db/functions/favorite_db.dart';
import 'package:music_app/db/functions/mostly_played_db.dart';
import 'package:music_app/db/functions/recent_db.dart';
import 'package:music_app/screens/homescreen/home_screen.dart';
import 'package:music_app/screens/homescreen/more.dart';
import 'package:music_app/screens/homescreen/more_home.dart';
import 'package:music_app/screens/musicplayingscreen/music_playing_screen.dart';
import 'package:on_audio_query/on_audio_query.dart';

class SongList extends StatelessWidget {
  const SongList({
    super.key,
    required OnAudioQuery audioQuery,
    required this.allSongs,
  }) : _audioQuery = audioQuery;

  final OnAudioQuery _audioQuery;
  final List<SongModel> allSongs;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 15, 0),
      child: FutureBuilder<List<SongModel>>(
        future: _audioQuery.querySongs(
          sortType: null,
          orderType: OrderType.ASC_OR_SMALLER,
          uriType: UriType.EXTERNAL,
          ignoreCase: true,
        ),
        builder: (context, item) {
          if (item.data == null) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (item.data!.isEmpty) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 200, horizontal: 100),
              child: Text(
                'No Songs Available',
                style: TextStyle(
                  fontFamily: 'UbuntuCondensed',
                  color: Color.fromARGB(255, 255, 255, 255),
                  fontSize: 19,
                ),
              ),
            );
          }
          startSong = item.data!;
          if (!FavoriteDb.isInitialized) {
            FavoriteDb.intialize(item.data!);
          }

          GetAllSongController.songscopy = item.data!;

          return Container(
            padding: const EdgeInsets.only(
              top: 20,
            ),
            child: ListView.separated(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index) {
                allSongs.addAll(item.data!);
                return ValueListenableBuilder(
                  valueListenable: GetRecentSong.recentSongNotifier,
                  builder: (BuildContext context, List<SongModel> value,
                      Widget? child) {
                    return ListTile(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      minVerticalPadding: 10.0,
                      contentPadding: const EdgeInsets.all(0),
                      leading: const Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Icon(
                          Icons.music_note,
                          color: Colors.white,
                          size: 33,
                        ),
                      ),
                      title: Text(
                        item.data![index].displayNameWOExt,
                        maxLines: 1,
                        style: const TextStyle(
                          fontFamily: 'UbuntuCondensed',
                          color: Color.fromARGB(255, 255, 255, 255),
                          fontSize: 18,
                        ),
                      ),
                      subtitle: Text(
                        '${item.data![index].artist == "<unknown>" ? "Unknown Artist" : item.data![index].artist}',
                        maxLines: 1,
                        style: const TextStyle(
                          fontFamily: 'UbuntuCondensed',
                          color: Color.fromARGB(255, 255, 255, 255),
                          fontSize: 11,
                        ),
                      ),
                      trailing: Wrap(
                        children: [
                          IconButton(
                            onPressed: () {
                              final song=item.data![index];
                              showDialog(
                                context: context,
                                builder: (ctx) => MoreDialogue(song:song,index:index),
                              );
                            },
                            icon: const Icon(
                              Icons.more_vert,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      onTap: () {
                        GetAllSongController.audioPlayer.setAudioSource(
                            GetAllSongController.createSongList(
                              item.data!,
                            ),
                            initialIndex: index);
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return MusicPlayingScreen(
                            songModelList: item.data!,
                          );
                        }));

                        //recent song function
                        GetRecentSong.addRecentlyPlayed(item.data![index].id);

                        //mostly played
                        GetMostlyPlayed.addmostlyPlayed(item.data![index].id);

                        GetAllSongController.audioPlayer.play();
                      },
                    );
                  },
                );
              },
              itemCount: item.data!.length,
              separatorBuilder: (context, index) {
                return const Divider(
                  height: 10.0,
                );
              },
            ),
          );
        },
      ),
    );
  }
}

