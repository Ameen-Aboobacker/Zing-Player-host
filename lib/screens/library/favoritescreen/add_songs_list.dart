import 'package:flutter/material.dart';
import 'package:music_app/db/functions/favorite_db.dart';
import 'package:on_audio_query/on_audio_query.dart';

class SongListPage extends StatefulWidget {
  const SongListPage({
    super.key,
  });

  @override
  State<SongListPage> createState() => _SongListPageState();
}

class _SongListPageState extends State<SongListPage> {
  bool isPlaying = true;
  final OnAudioQuery audioQuery = OnAudioQuery();
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
        body: SingleChildScrollView(
            child: Padding(
          padding: const EdgeInsets.fromLTRB(15, 5, 15, 1),
          child: SafeArea(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Add Songs',
                      style: TextStyle(
                        fontFamily: 'UbuntuCondensed',
                        color: Colors.white,
                        fontSize: 22,
                      ),
                    ),
                    IconButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                        ))
                  ],
                ),
                const SizedBox(height: 10),
                FutureBuilder<List<SongModel>>(
                  future: audioQuery.querySongs(
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
                    if (item.data!.isEmpty) {
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
                      itemBuilder: (context, index) {
                        return ListTile(
                          tileColor: const Color.fromARGB(255, 12, 12, 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          minVerticalPadding: 10.0,
                          contentPadding: const EdgeInsets.all(0),
                          leading: Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: QueryArtworkWidget(
                              id: item.data![index].id,
                              type: ArtworkType.AUDIO,
                              nullArtworkWidget: const Padding(
                                padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                                child: Icon(
                                  Icons.music_note,
                                  color: Colors.white,
                                  size: 32,
                                ),
                              ),
                            ),
                          ),
                          title: Text(
                            item.data![index].displayNameWOExt,
                            maxLines: 1,
                            style: const TextStyle(
                              fontFamily: 'UbuntuCondensed',
                              color: Color.fromARGB(255, 255, 255, 255),
                              fontSize: 18,
                            ),
                          ),
                          subtitle: Text(
                            '${item.data![index].artist == "<unknown>" ? "Unknown Artist" : item.data![index].artist}',
                            maxLines: 1,
                            style: const TextStyle(
                              fontFamily: 'UbuntuCondensed',
                              color: Color.fromARGB(255, 255, 255, 255),
                              fontSize: 11,
                            ),
                          ),
                          trailing: Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: Wrap(
                              children: [
                                !FavoriteDb.isFavor(item.data![index])
                                    ? IconButton(
                                        onPressed: () {
                                          setState(() {
                                            songAddToFav(item.data![index]);
                                            FavoriteDb.favoriteSongs
                                                .notifyListeners();
                                          });
                                        },
                                        icon: const Icon(
                                          Icons.add,
                                          color: Colors.white,
                                        ),
                                      )
                                    : IconButton(
                                        onPressed: () {
                                          setState(() {
                                            FavoriteDb.delete(
                                                item.data![index].id);
                                          });
                                          const snackBar = SnackBar(
                                            backgroundColor: Colors.black,
                                            content: Text(
                                              'Song deleted from Favourites',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                            duration:
                                                Duration(milliseconds: 1000),
                                          );
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(snackBar);
                                        },
                                        icon: const Padding(
                                          padding: EdgeInsets.only(bottom: 25),
                                          child: Icon(
                                            Icons.minimize,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                              ],
                            ),
                          ),
                        );
                      },
                      itemCount: item.data!.length,
                      separatorBuilder: (context, index) {
                        return const Divider(
                          height: 10.0,
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        )),
      ),
    );
  }

  void songAddToFav(SongModel data) {
    FavoriteDb.add(data);
    const snackbar1 = SnackBar(
        backgroundColor: Colors.black,
        content: Text(
          'Song added to Favourites',
          style: TextStyle(color: Colors.white),
          ),
          duration:Duration(seconds: 2) ,);
    ScaffoldMessenger.of(context).showSnackBar(snackbar1);
  }
}
