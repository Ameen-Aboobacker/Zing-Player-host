import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:music_app/controller/get_all_song_controller.dart';
import 'package:music_app/db/functions/favorite_db.dart';
import 'package:music_app/db/model/muzic_model.dart';
import 'package:music_app/screens/miniplayer/mini_player.dart';
import 'package:music_app/screens/musicplayingscreen/music_playing_screen.dart';
import 'package:music_app/screens/library/playlist/add_songs_list.dart';
import 'package:on_audio_query/on_audio_query.dart';

class PlaylistSongs extends StatefulWidget {
  const PlaylistSongs(
      {super.key, required this.playlist, required this.findex});
  final MuzicModel playlist;
  final int findex;

  @override
  State<PlaylistSongs> createState() => _PlaylistSongsState();
}

class _PlaylistSongsState extends State<PlaylistSongs> {
  late List<SongModel> songPlaylist;
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
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          title: Text(
            widget.playlist.name,
            style: const TextStyle(
                fontFamily: 'UbuntuCondensed',
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.w600),
          ),
          centerTitle: true,
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(15.0, 3, 15, 2),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  ValueListenableBuilder(
                    valueListenable:
                        Hive.box<MuzicModel>('playlistDb').listenable(),
                    builder: (BuildContext context, Box<MuzicModel> music,
                        Widget? child) {
                      songPlaylist = listPlaylist(
                          music.values.toList()[widget.findex].songId);
                      return songPlaylist.isEmpty
                          ? const Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 250, horizontal: 110),
                              child: Text(
                                'Add some Songs',
                                style: TextStyle(
                                  fontFamily: 'UbuntuCondensed',
                                  color: Color.fromARGB(255, 255, 255, 255),
                                  fontSize: 17,
                                ),
                              ))
                          : ListView.separated(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  tileColor: Colors.transparent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  minVerticalPadding: 10.0,
                                  contentPadding: const EdgeInsets.all(0),
                                  leading: Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: QueryArtworkWidget(
                                      id: songPlaylist[index].id,
                                      type: ArtworkType.AUDIO,
                                      nullArtworkWidget: const Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(5, 5, 5, 5),
                                        child: Icon(
                                          Icons.music_note,
                                          color: Colors.white,
                                          size: 31,
                                        ),
                                      ),
                                    ),
                                  ),
                                  title: Text(
                                    songPlaylist[index].displayNameWOExt,
                                    maxLines: 1,
                                    style: const TextStyle(
                                      fontFamily: 'UbuntuCondensed',
                                      color: Color.fromARGB(255, 255, 255, 255),
                                      fontSize: 18,
                                    ),
                                  ),
                                  subtitle: Text(
                                    songPlaylist[index].artist!,
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
                                          widget.playlist.deleteData(
                                              songPlaylist[index].id);
                                        },
                                        icon: const Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ],
                                  ),
                                  onTap: () {
                                    List<SongModel> newMusicList = [
                                      ...songPlaylist
                                    ];
                                    GetAllSongController.audioPlayer.stop();
                                    GetAllSongController.audioPlayer
                                        .setAudioSource(
                                            GetAllSongController.createSongList(
                                                newMusicList),
                                            initialIndex: index);
                                    GetAllSongController.audioPlayer.play();
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (ctx) =>
                                                MusicPlayingScreen(
                                                  songModelList: songPlaylist,
                                                )));
                                  },
                                );
                              },
                              itemCount: songPlaylist.length,
                              separatorBuilder: (context, index) {
                                return const Divider(
                                  height: 10.0,
                                );
                              },
                            );
                    },
                  )
                ],
              ),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) {
                  return SongListPage(playlist: widget.playlist);
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
        bottomNavigationBar: ValueListenableBuilder(
        valueListenable: FavoriteDb.favoriteSongs,
        builder:
            (BuildContext context, List<SongModel> music, Widget? child) {
          return SingleChildScrollView(
            child: Column(
              children: [
                if (GetAllSongController.audioPlayer.currentIndex != null)
                 const  MiniPlayer()  
              ],
            ),
          );
        },
      ),
      ),
    );
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
}
