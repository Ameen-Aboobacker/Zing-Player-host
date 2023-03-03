import 'package:flutter/material.dart';
import 'package:music_app/db/functions/recent_db.dart';
import 'package:music_app/screens/musicplayingscreen/music_playing_screen.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../../controller/get_all_song_controller.dart';

class SearchList extends StatelessWidget {
  const SearchList({
    
    super.key, required this.foundSongs,
  });
final List<SongModel> foundSongs;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(25, 30, 0, 0,),
        child: Column(
          children: [
            foundSongs.isNotEmpty
                ? ListView.separated(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return ListTile(
                        contentPadding: const EdgeInsets.all(0),
                        leading: Padding(
                          padding:
                              const EdgeInsets.only(left: 10),
                          child: QueryArtworkWidget(
                            id: foundSongs[index].id,
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
                          foundSongs[index].displayNameWOExt,
                          maxLines: 1,
                          style: const TextStyle(
                            fontFamily: 'UbuntuCondensed',
                            color: Color.fromARGB(
                                255, 255, 255, 255),
                            fontSize: 18,
                          ),
                        ),
                        subtitle: Text(
                          '${foundSongs[index].artist == "<unknown>" ? "Unknown Artist" : foundSongs[index].artist}',
                          maxLines: 1,
                          style: const TextStyle(
                            fontFamily: 'UbuntuCondensed',
                            color: Color.fromARGB(
                                255, 255, 255, 255),
                            fontSize: 11,
                          ),
                        ),
                        onTap: () {
                          GetAllSongController.audioPlayer
                              .setAudioSource(
                                  GetAllSongController
                                      .createSongList(
                                    foundSongs,
                                  ),
                                  initialIndex: index);
                          GetAllSongController.audioPlayer.play();
                          GetRecentSong.addRecentlyPlayed(
                              foundSongs[index].id);
                          Navigator.push(context,
                              MaterialPageRoute(
                                  builder: (context) {
                            return MusicPlayingScreen(
                              songModelList: foundSongs,
                            );
                          }));
                        },
                      );
                    },
                    itemCount: foundSongs.length,
                    separatorBuilder: (context, index) {
                      return const Divider(
                        height: 10.0,
                      );
                    },
                  )
                : const Center(
                    child: Text(
                    'No songs available',
                    style: TextStyle(color: Colors.white),
                  )),
          ],
        ),
      ),
    );
  }
}