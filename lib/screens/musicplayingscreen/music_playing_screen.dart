import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_app/controller/get_all_song_controller.dart';
import 'package:music_app/db/functions/favorite_db.dart';
import 'package:music_app/db/functions/mostly_played_db.dart';
import 'package:music_app/db/functions/recent_db.dart';
import 'package:music_app/screens/library/favoritescreen/favbut_musicplaying.dart';
import 'package:music_app/screens/homescreen/add_to_playlist.dart';
import 'package:on_audio_query/on_audio_query.dart';

class MusicPlayingScreen extends StatefulWidget {
  const MusicPlayingScreen({
    super.key,
    required this.songModelList,
  });
  final List<SongModel> songModelList;
  @override
  State<MusicPlayingScreen> createState() => _MusicPlayingScreenState();
}

TextEditingController playlistController = TextEditingController();

class _MusicPlayingScreenState extends State<MusicPlayingScreen> {
  Duration _duration = const Duration();
  Duration _position = const Duration();

  bool _isShuffle = false;
  int currentIndex = 0;
  int counter = 0;

  @override
  void initState() {
    GetAllSongController.audioPlayer.currentIndexStream.listen((index) {
      if (index != null) {
        setState(() {
          currentIndex = index;
        });
        GetAllSongController.currentIndexes = index;
      }
    });
    super.initState();
    playSong();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: (() async {
        FavoriteDb.favoriteSongs.notifyListeners();
        return true;
      }),
      child: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/bg.jpg'), fit: BoxFit.cover),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            setState(() {});
                            Navigator.of(context).pop();
                            FavoriteDb.favoriteSongs.notifyListeners();
                          },
                          icon: const Icon(Icons.arrow_back),
                          color: Colors.white,
                        ),
                        const SizedBox(width: 60,),
                        const Text('...NOW PLAYING...', style: TextStyle(fontSize: 20,color: Colors.white),)
                      ],
                    ),
                    const SizedBox(
                      height:  50,
                    ),
                    ClipRRect(
                      child: SizedBox(
                          width: MediaQuery.of(context).size.height * 0.32,
                          height: MediaQuery.of(context).size.width * 0.55,
                          child:  Image.asset(
                                'assets/images/music logo2-modified (1).png'),
                          )),
                    
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.04,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 20, right: 12),
                          child: Text(
                            widget.songModelList[currentIndex].displayNameWOExt,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontFamily: 'UbuntuCondensed',
                              color: Color.fromARGB(255, 255, 255, 255),
                              fontSize: 23,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 13,
                        ),
                        Text(
                          widget.songModelList[currentIndex].artist
                                      .toString() ==
                                  "<unknown>"
                              ? "Unknown artist"
                              : widget.songModelList[currentIndex].artist
                                  .toString(),
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontSize: 12, color: Colors.white),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.075,
                        ),
                        Row(
                          children: [
                            Text(
                              _position.toString().substring(2, 7),
                              style: const TextStyle(color: Colors.white),
                            ),
                            Expanded(
                              child: SliderTheme(
                                data: SliderTheme.of(context).copyWith(
                                    activeTrackColor:
                                        const Color.fromARGB(255, 2, 94, 99),
                                    thumbShape: const RoundSliderThumbShape(
                                        enabledThumbRadius: 8.0),
                                    overlayShape: const RoundSliderOverlayShape(
                                        overlayRadius: 2.0),
                                    trackHeight: 3),
                                child: Slider(
                                  value: _position.inSeconds.toDouble(),
                                  onChanged: ((double value) {
                                    setState(() {
                                      changeToSeconds(value.toInt());
                                      value = value;
                                    });
                                  }),
                                  min: 0.0,
                                  max: _duration.inSeconds.toDouble(),
                                  inactiveColor:
                                      const Color.fromARGB(255, 73, 198, 236),
                                  activeColor:
                                      const Color.fromARGB(255, 4, 12, 124),
                                ),
                              ),
                            ),
                            Text(
                              _duration.toString().substring(2, 7),
                              style: const TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.075,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            IconButton(
                              onPressed: () {
                                GetAllSongController.audioPlayer.loopMode ==
                                        LoopMode.one
                                    ? GetAllSongController.audioPlayer
                                        .setLoopMode(LoopMode.all)
                                    : GetAllSongController.audioPlayer
                                        .setLoopMode(LoopMode.one);
                              },
                              icon: StreamBuilder<LoopMode>(
                                stream: GetAllSongController
                                    .audioPlayer.loopModeStream,
                                builder: (context, snapshot) {
                                  final loopMode = snapshot.data;
                                  if (LoopMode.one == loopMode) {
                                    return Icon(
                                      Icons.repeat,
                                      color: Colors.red[600],
                                      size: 30,
                                    );
                                  } else {
                                    return const Icon(
                                      Icons.repeat,
                                      color: Colors.white,
                                      size: 30,
                                    );
                                  }
                                },
                              ),
                            ),
                            
                            Container(
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 19, 102, 170),
                                border: Border.all(
                                  color: Colors.white,
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(70),
                              ),
                              width: 200,
                              height: 63,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                
                                  IconButton(
                                    padding: const EdgeInsets.only(
                                        bottom: 0, left: 0),
                                    onPressed: () async {
                                      if (GetAllSongController
                                          .audioPlayer.hasPrevious) {
                                        // add to recent
                                        GetRecentSong.addRecentlyPlayed(widget
                                            .songModelList[currentIndex - 1]
                                            .id);

                                        //add to mostly
                                        GetMostlyPlayed.addmostlyPlayed(widget
                                            .songModelList[currentIndex - 1]
                                            .id);

                                        await GetAllSongController.audioPlayer
                                            .seekToPrevious();
                                        await GetAllSongController.audioPlayer
                                            .play();
                                      } else {
                                        await GetAllSongController.audioPlayer
                                            .play();
                                      }
                                    },
                                    iconSize: 40,
                                    icon: const Icon(
                                      Icons.skip_previous,
                                      color: Colors.white,
                                    ),
                                  ),
                                  IconButton(
                                    color: Colors.white,
                                    onPressed: () async {
                                      if (GetAllSongController
                                          .audioPlayer.playing) {
                                        await GetAllSongController.audioPlayer
                                            .pause();
                                      } else {
                                        await GetAllSongController.audioPlayer
                                            .play();
                                        setState(() {});
                                      }
                                    },
                                    padding: const EdgeInsets.only(
                                      bottom: 10,
                                    ),
                                    iconSize: 60,
                                    icon: StreamBuilder<bool>(
                                      stream: GetAllSongController
                                          .audioPlayer.playingStream,
                                      builder: (context, snapshot) {
                                        bool? playingStage = snapshot.data;
                                        if (playingStage != null &&
                                            playingStage) {
                                          return const Icon(
                                            Icons.pause_circle_outline,
                                          );
                                        } else {
                                          return const Icon(
                                            Icons.play_circle_outline,
                                          );
                                        }
                                      },
                                    ),
                                  ),
                                  IconButton(
                                      onPressed: () async {
                                        if (GetAllSongController
                                            .audioPlayer.hasNext) {
                                          //add recent
                                          GetRecentSong.addRecentlyPlayed(widget
                                              .songModelList[currentIndex + 1]
                                              .id);
                                          // add mostly
                                          GetMostlyPlayed.addmostlyPlayed(widget
                                              .songModelList[currentIndex + 1]
                                              .id);
                                          await GetAllSongController.audioPlayer
                                              .seekToNext();
                                          await GetAllSongController.audioPlayer
                                              .play();
                                        } else {
                                          await GetAllSongController.audioPlayer
                                              .play();
                                        }
                                      },
                                      padding: const EdgeInsets.only(
                                        bottom: 0,
                                      ),
                                      iconSize: 40,
                                      icon: const Icon(
                                        Icons.skip_next,
                                        color: Colors.white,
                                      )),
                                ],
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                _isShuffle == false
                                    ? GetAllSongController.audioPlayer
                                        .setShuffleModeEnabled(true)
                                    : GetAllSongController.audioPlayer
                                        .setShuffleModeEnabled(false);
                              },
                              icon: StreamBuilder<bool>(
                                stream: GetAllSongController
                                    .audioPlayer.shuffleModeEnabledStream,
                                builder: (BuildContext context,
                                    AsyncSnapshot snapshot) {
                                  _isShuffle = snapshot.data;
                                  if (_isShuffle) {
                                    return Icon(
                                      Icons.shuffle,
                                      color: Colors.red[600],
                                      size: 30,
                                    );
                                  } else {
                                    return const Icon(
                                      Icons.shuffle_rounded,
                                      color: Colors.white,
                                      size: 30,
                                    );
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            IconButton(
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        AddtoPlaylist(
                                          findex: currentIndex,
                                        )));
                              },
                              icon: const Icon(Icons.playlist_add),
                              color: Colors.white,
                              iconSize: 40,
                            ),
                            FavButMusicPlaying(
                                songFavoriteMusicPlaying:
                                    widget.songModelList[currentIndex]),
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void changeToSeconds(int seconds) {
    Duration duration = Duration(seconds: seconds);
    GetAllSongController.audioPlayer.seek(duration);
  }

  void playSong() {
    GetAllSongController.audioPlayer.durationStream.listen((eventd) {
      setState(() {
        _duration = eventd!;
      });
    });
    GetAllSongController.audioPlayer.positionStream.listen((eventp) {
      setState(() {
        _position = eventp;
      });
    });
  }
}
