import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:music_app/screens/homescreen/home_screen.dart';
import 'package:music_app/screens/library/mostly/mostly_played.dart';
import 'package:on_audio_query/on_audio_query.dart';

class GetMostlyPlayed {
  static ValueNotifier<List<SongModel>> mostlyPlayedNotifier =
      ValueNotifier([]);
  static List<dynamic> mostlyPlayed = [];

  static Future<void> addmostlyPlayed(item) async {
    final mostplayedDb = await Hive.openBox('mostlyPlayedNotifier');
    await mostplayedDb.add(item);
    mostlyPlayedNotifier.notifyListeners();
  }

  static Future<void> getMostlyPlayedSongs() async {
    final mostplayedDb = await Hive.openBox('mostlyPlayedNotifier');
    // ignore: non_constant_identifier_names
    final MostlyPlayedSongItems = mostplayedDb.values.toList();
    mostlyPlayedNotifier.value.clear();

    final List mostlyPlayedsongs = [];

    for (int i = 0; i < MostlyPlayedSongItems.length; i++) {
      int count = 0;
      for (int j = 0; j < MostlyPlayedSongItems.length; j++) {
        if (MostlyPlayedSongItems[i] == MostlyPlayedSongItems[j]) {
          count++;
        }
      }
      if (count >= 3) {
        mostlyPlayedsongs.add(MostlyPlayedSongItems[i]);
      }
    }
    final songs=itemsByFrequency(mostlyPlayedsongs);
        for(int k=0;k<songs.length;k++){
          for(int l=0;l<startSong.length;l++){
            if(songs[k]==startSong[l].id){
             mostlyPlayedNotifier.value.add(startSong[l]);
            }
          }
        }
  }
}

List<dynamic> itemsByFrequency(List<dynamic> input) => [
      ...(input
              .fold<Map<dynamic, int>>(
                  <dynamic, int>{},
                  (map, value) => map
                    ..update(value, (value) => value + 1, ifAbsent: () => 1))
              .entries
              .toList()
            ..sort((e1, e2) => e2.value.compareTo(e1.value)))
          .map((e) => e.key)
    ];
