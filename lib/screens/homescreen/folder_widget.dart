import 'package:flutter/material.dart';
import 'package:music_app/screens/homescreen/folder_card.dart';
import 'package:music_app/screens/library/favoritescreen/favorite_screen.dart';
import 'package:music_app/screens/library/mostly/mostly_played.dart';
import 'package:music_app/screens/library/playlist/playlist.dart';
import 'package:music_app/screens/library/recently/recently_played.dart';

class Folder extends StatelessWidget {
  const Folder({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            FolderCard(
              icon: Icons.library_music,
              title: 'Playlist',
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext cntxt) =>
                      const PlaylistScreen(),
                ),
              ),
              color: Colors.purple,
            ),
            FolderCard(
              icon: Icons.favorite,
              title: 'Favourites',
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext cntxt) =>
                      const FavoriteScreen(),
                ),
              ),
              color:const  Color.fromARGB(255, 233, 233, 233),
            ),
            FolderCard(
              icon: Icons.queue_music,
              title: 'Most Played',
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext cntxt) =>
                      const MostlyPlayed(),
                ),
              ),
              color: const  Color.fromARGB(255, 255, 187, 0),
            ),
            FolderCard(
              icon: Icons.recent_actors,
              title: 'Recently\tPlayed',
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext cntxt) =>
                      const RecentlyPlayed(),
                ),
              ),
              color: const Color.fromARGB(255, 2, 221, 9),
            ),
          ]),
    );
  }
}
