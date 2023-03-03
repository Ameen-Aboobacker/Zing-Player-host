import 'package:flutter/material.dart';
import 'package:music_app/db/functions/favorite_db.dart';
import 'package:music_app/screens/drawer/drawers.dart';
import 'package:music_app/screens/homescreen/folder_widget.dart';
import 'package:music_app/screens/search/search_screen.dart';
import 'package:music_app/screens/homescreen/song_list_widget.dart';
import 'package:music_app/screens/miniplayer/mini_player.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../controller/get_all_song_controller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}
TextEditingController playlistController = TextEditingController();
List<SongModel> startSong = [];

class _HomeScreenState extends State<HomeScreen> {
  final OnAudioQuery _audioQuery = OnAudioQuery();
  List<SongModel> allSongs = [];

  int counter = 0;

  @override
  void initState() {
    requestPermission();
    super.initState();
  }

  void requestPermission() async {
    bool permissionStatus = await _audioQuery.permissionsStatus();
    if (!permissionStatus) {
      await _audioQuery.permissionsRequest();
    }
    setState(() {});

    Permission.storage.request();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/images/bg.jpg'), fit: BoxFit.cover),
      ),
      child: Scaffold(
        drawer: const SafeArea(child: Drawer(child: HomescreenDrawers(),)),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
            centerTitle: true,
            title: const Text(
              ' !!ZING-PLAYER!!',
              style: TextStyle(
                  fontFamily: 'UbuntuCondensed',
                  color: Colors.white,
                  fontSize: 35,
                  fontWeight: FontWeight.w600),
              textAlign: TextAlign.start,
            ),
          actions: [IconButton(onPressed: (){
            Navigator.of(context).push(MaterialPageRoute(builder: (cntxt)=> const SearchScreen( )));
          }, icon: const Icon(Icons.search))],
        ),
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Folder(),
                SongList(audioQuery: _audioQuery, allSongs: allSongs),
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
                 const  MiniPlayer()  
              ],
            ),
          );
        },
      ),
      ),
    );
  }
}


