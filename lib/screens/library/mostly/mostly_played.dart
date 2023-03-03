import 'package:flutter/material.dart';
import 'package:music_app/controller/get_all_song_controller.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:music_app/db/functions/favorite_db.dart';
import 'package:music_app/db/functions/mostly_played_db.dart';
import 'package:music_app/screens/miniplayer/mini_player.dart';
import 'package:music_app/screens/musicplayingscreen/music_playing_screen.dart';
import 'package:on_audio_query/on_audio_query.dart';

class MostlyPlayed extends StatefulWidget {
  const MostlyPlayed({super.key});

  @override
  State<MostlyPlayed> createState() => _MostlyPlayedState();
}

class _MostlyPlayedState extends State<MostlyPlayed> {
  final OnAudioQuery _audioQuery = OnAudioQuery();
  static List<SongModel> mostSong = [];
  @override
  void initState() {
    super.initState();
    allmostlyplayedsong();
    setState(() {});
  }

  Future allmostlyplayedsong() async {
    await GetMostlyPlayed.getMostlyPlayedSongs();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/images/bg.jpg'), fit: BoxFit.cover),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          centerTitle: true,
          title: const Text(
            'Mostly Played',
            style: TextStyle(
              fontFamily: 'UbuntuCondensed',
              color: Color.fromARGB(255, 15, 159, 167),
              fontSize: 26,
            ),
          ),
          elevation: 0,
        ),
        body: Padding(
          padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
          child: SingleChildScrollView(
            child: Column(
              children: [
                ValueListenableBuilder(
                  valueListenable: GetMostlyPlayed.mostlyPlayedNotifier,
                  builder: (BuildContext context, List<SongModel> value,
                      Widget? child) {
                    if (value.isEmpty) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 200),
                        child: Center(
                          child: Column(
                            children: const [
                              Text(
                                'No Songs',
                                style: TextStyle(
                                  fontFamily: 'UbuntuCondensed',
                                  color: Color.fromARGB(255, 255, 255, 255),
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    } else {
                      mostSong =value;
                      
                      return FutureBuilder<List<SongModel>>(
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
                          }
                          else if (item.data!.isEmpty) {
                            return const Center(
                                child: Text(
                              'No Songs Available',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ));
                          }
                          return ListView.separated(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (BuildContext context, int index) {
                              return ListTile(
                                tileColor:
                                    const Color.fromARGB(255, 12, 12, 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                minVerticalPadding: 10.0,
                                contentPadding: const EdgeInsets.all(0),
                                leading: Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: QueryArtworkWidget(
                                    id: mostSong[index].id,
                                    type: ArtworkType.AUDIO,
                                    nullArtworkWidget: const Padding(
                                      padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                                      child: Icon(
                                        Icons.music_note,
                                        color: Colors.white,
                                        size: 33,
                                      ),
                                    ),
                                  ),
                                ),
                                title: Text(
                                  mostSong[index].displayNameWOExt,
                                  maxLines: 1,
                                  style: GoogleFonts.ubuntuCondensed(
                                    textStyle: const TextStyle(
                                        color:
                                            Color.fromARGB(255, 255, 255, 255)),
                                    fontSize: 18,
                                  ),
                                ),
                                subtitle: Text(
                                  '${mostSong[index].artist == "<unknown>" ? "Unknown Artist" : mostSong[index].artist}',
                                  maxLines: 1,
                                  style: GoogleFonts.ubuntuCondensed(
                                      textStyle: const TextStyle(
                                          color: Color.fromARGB(
                                              255, 248, 245, 245)),
                                      fontSize: 11),
                                ),
                                onTap: () {
                                  GetAllSongController.audioPlayer
                                      .setAudioSource(
                                          GetAllSongController.createSongList(
                                              mostSong),
                                          initialIndex: index);
                                  GetAllSongController.audioPlayer.play();
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return MusicPlayingScreen(
                                        songModelList: mostSong);
                                  }));
                                },
                              );
                            },
                            itemCount: mostSong.length,
                            separatorBuilder: (context, index) {
                              return const Divider(
                                height: 10.0,
                              );
                            },
                          );
                        },
                      );
                    }
                  },
                )
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
      ),
    );
  }
}

