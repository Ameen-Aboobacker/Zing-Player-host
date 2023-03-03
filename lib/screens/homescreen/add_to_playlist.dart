import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:music_app/db/functions/playlist_db.dart';
import 'package:music_app/db/model/muzic_model.dart';
import 'package:music_app/screens/homescreen/home_screen.dart';
import 'package:on_audio_query/on_audio_query.dart';

class AddtoPlaylist extends StatefulWidget {
  const AddtoPlaylist({
    super.key,
   required this.findex,
  });

  final int findex;

  @override
  State<AddtoPlaylist> createState() =>
      _AddtoPlaylistState();
}

TextEditingController nameController = TextEditingController();
final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

class _AddtoPlaylistState extends State<AddtoPlaylist> {
  @override
  void initState() {
    super.initState();
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
      child: ValueListenableBuilder(
        valueListenable: Hive.box<MuzicModel>('playlistDb').listenable(),
        builder:
            (BuildContext context, Box<MuzicModel> musicList, Widget? child) {
          return Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              title: const Text(
                'Playlist',
                style: TextStyle(
                  fontFamily: 'UbuntuCondensed',
                  color: Colors.white,
                  fontSize: 28,
                ),
              ),
              centerTitle: true,
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                nameController.clear();
                newplaylist(context, _formKey);
              },
              backgroundColor: const Color.fromARGB(255, 5, 64, 141),
              child: const Icon(
                Icons.playlist_add,
                color: Color.fromARGB(255, 255, 255, 255),
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    Hive.box<MuzicModel>('playlistDb').isEmpty
                        ? Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 100, horizontal: 50),
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(80.0),
                                child: Column(
                                  children: const [
                                    Text(
                                      'No Playlist',
                                      style: TextStyle(
                                        fontFamily: 'UbuntuCondensed',
                                        color:
                                            Color.fromARGB(255, 255, 255, 255),
                                        fontSize: 18,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        : GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2),
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: musicList.length,
                            itemBuilder: (context, index) {
                              final datas = musicList.values.toList()[index];
                              return GestureDetector(
                                onTap: () {
                                  songAddToPlaylist(
                                      startSong[widget.findex], datas);
                                  PlaylistDb.playlistNotifier.notifyListeners();
                                  Navigator.of(context).pop();
                                },
                                child: Column(
                                  children: [
                                    const Expanded(
                                        flex:2,
                                        child: Icon(
                                          Icons.folder,
                                          color:
                                              Color.fromARGB(234, 255, 217, 0),
                                          size: 145,
                                        )),
                                    Expanded(
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              datas.name,
                                              style: const TextStyle(
                                                  fontFamily: 'UbuntuCondensed',
                                                  color: Color.fromARGB(
                                                      255, 255, 255, 255),
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ],
                                        ))
                                  ],
                                ),
                              );
                            })
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Future newplaylist(BuildContext context, formKey) {
    return showDialog(
      context: context,
      builder: (ctx) => SimpleDialog(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(15))),
        backgroundColor: const Color.fromARGB(255, 45, 98, 243),
        children: [
          const SimpleDialogOption(
            child: Text(
              'New to Playlist',
              style: TextStyle(
                  fontFamily: 'UbuntuCondensed',
                  color: Color.fromARGB(255, 255, 255, 255),
                  fontSize: 18,
                  fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          SimpleDialogOption(
            child: Form(
              key: _formKey,
              child: TextFormField(
                controller: nameController,
                decoration: InputDecoration(
                    fillColor: Colors.white.withOpacity(0.7),
                    filled: true,
                    border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(30)),
                    contentPadding: const EdgeInsets.only(left: 15, top: 5)),
                style: const TextStyle(
                    fontFamily: 'UbuntuCondensed',
                    color: Color.fromARGB(255, 0, 0, 0),
                    fontSize: 16,
                    fontWeight: FontWeight.w600),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Enter your playlist name";
                  } else {
                    return null;
                  }
                },
              ),
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SimpleDialogOption(
                onPressed: () {
                  Navigator.of(context).pop();
                  playlistController.clear();
                },
                child: const Text(
                  'Cancel',
                  style: TextStyle(
                      fontFamily: 'UbuntuCondensed',
                      color: Color.fromARGB(255, 255, 255, 255),
                      fontSize: 16,
                      fontWeight: FontWeight.w600),
                ),
              ),
              SimpleDialogOption(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    saveButtonPressed(context);
                  }
                  Navigator.of(context).pop();
                },
                child: const Text(
                  'Create',
                  style: TextStyle(
                      fontFamily: 'UbuntuCondensed',
                      color: Color.fromARGB(255, 255, 255, 255),
                      fontSize: 16,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> saveButtonPressed(context) async {
    final name = nameController.text.trim();
    if (name.isEmpty) {
      return;
    } else {
      final music = MuzicModel(name: name, songId: []);
      PlaylistDb.addPlaylist(music);
    }
  }

  void songAddToPlaylist(SongModel song,MuzicModel datas) {
    
    if (!datas.isValueIn(song.id)) {
      datas.add(song.id);
      SnackBar snackbar1 = SnackBar(
          duration:const  Duration(milliseconds: 850),
          backgroundColor: Colors.black,
          content: Text(
            'Song added to ${datas.name} ',
            style: const TextStyle(color: Colors.white),
          ));
      ScaffoldMessenger.of(context).showSnackBar(snackbar1);
    } else {
      SnackBar snackbar2 = SnackBar(
          duration:const  Duration(milliseconds: 850),
          backgroundColor: Colors.black,
          content: Text(
            'Song already added to the  playlist ${datas.name}',
            style: const TextStyle(color: Colors.white),
          ));
      ScaffoldMessenger.of(context).showSnackBar(snackbar2);
    }
  }
}
