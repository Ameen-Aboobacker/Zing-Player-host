import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:music_app/db/model/muzic_model.dart';
import 'package:music_app/screens/library/playlist/playlist_songs.dart';
import 'package:music_app/screens/library/playlist/update_dialogue.dart';

class PlaylistView extends StatefulWidget {
  const PlaylistView({
    Key? key,
    required this.musicList,
  }) : super(key: key);
  final Box<MuzicModel> musicList;

  @override
  State<PlaylistView> createState() => _PlaylistViewState();
}

class _PlaylistViewState extends State<PlaylistView> {
  final TextEditingController controller = TextEditingController();
  GlobalKey<FormState> formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: widget.musicList.length,
        itemBuilder: (context, index) {
          final data = widget.musicList.values.toList()[index];
          controller.text = data.name;
          return ValueListenableBuilder(
            valueListenable: Hive.box<MuzicModel>('playlistDb').listenable(),
            builder: (BuildContext context, Box<MuzicModel> musicList,
                Widget? child) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return PlaylistSongs(
                      findex: index,
                      playlist: data,
                    );
                  }));
                },
                child: Column(
                  children: [
                    const Expanded(
                        flex: 2,
                        child: Icon(
                          Icons.folder_rounded,
                          color: Color.fromARGB(234, 255, 217, 0),
                          size: 145,
                        )),
                    Expanded(
                        child: Container(
                      padding: const EdgeInsets.only(
                        left: 50,
                        right: 20,
                        top: 0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            data.name,
                            style: const TextStyle(
                                fontFamily: 'UbuntuCondensed',
                                color: Color.fromARGB(255, 255, 255, 255),
                                fontSize: 23,
                                fontWeight: FontWeight.w600),
                          ),
                          IconButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (ctx) => UpdateDialogue(controller: controller, formkey: formkey, index: index, musicList: musicList,),
                                );
                              },
                              icon: const Icon(
                                Icons.more_vert,
                                color: Colors.white,
                                size: 30,
                              ))
                        ],
                      ),
                    ))
                  ],
                ),
              );
            },
          );
        });
  }
}


