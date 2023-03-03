import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:on_audio_query/on_audio_query.dart';

class GetAllSongController {
  static AudioPlayer audioPlayer = AudioPlayer();
  static List<SongModel> songscopy = [];
  static List<SongModel> playingSong = [];
  static int currentIndexes = -1;
  static ConcatenatingAudioSource createSongList(List<SongModel> songs) {
    List<AudioSource> songList = [];
    playingSong = songs;
    for (var song in songs) {
      songList.add(
        AudioSource.uri(
          Uri.parse(song.uri!),
          tag: MediaItem(
            id: song.id.toString(),
            album: song.album ?? "No Album",
            title: song.title,
            artist: song.artist,
            artUri: Uri.parse(song.id.toString()),
          ),
        ),
      );
    }
    return ConcatenatingAudioSource(children: songList);
  }
}
