import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:music_app/screens/homescreen/home_screen.dart';
import 'package:music_app/screens/search/search_list.dart';
import 'package:on_audio_query/on_audio_query.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({
    super.key,
  });

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

late List<SongModel> allSong;
List<SongModel> foundSongs = [];
final audioPlayer = AudioPlayer();
final audiQuery = OnAudioQuery();

class _SearchScreenState extends State<SearchScreen> {
  void songsLoading() {
    foundSongs = startSong;
  }

  @override
  void initState() {
    songsLoading();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/bg.jpg')),
            ),
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          actions: [
                  Container(
                        padding: const EdgeInsets.fromLTRB(5, 2, 4, 2),
                        height: 50,
                        width: 350,
                        child: CupertinoSearchTextField(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(25)),
                          style: const TextStyle(
                            fontFamily: 'UbuntuCondensed',
                            color: Color.fromARGB(255, 0, 0, 0),
                            fontSize: 18,
                          ),
                          prefixIcon: const Icon(
                            Icons.search,
                          ),
                          backgroundColor: Colors.white,
                          onChanged: (value) => search(value),
                        ))
          ],
        ),
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.transparent,
        body: SearchList(foundSongs:foundSongs),
      ),
    );
  }

  void search(String enteredKeyword) {
    List<SongModel> results = [];
    String name=enteredKeyword.trim();
    if (name.isEmpty) {
      results = startSong;
    } else {
      results = startSong
          .where((element) => element.displayNameWOExt
              .contains(name))
          .toList();
    }
    setState(() {
      foundSongs = results;
    });
  }
}


