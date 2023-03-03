import 'package:flutter/material.dart';

class FolderCard extends StatefulWidget {
  const FolderCard(
      {Key? key, required this.title, required this.icon, required this.onTap,required this.color})
      : super(key: key);
  final String title;
  final IconData? icon;
  final Color? color;

  final Function()? onTap;

  @override
  State<FolderCard> createState() => _FolderCardState();
}

class _FolderCardState extends State<FolderCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Card(
        
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
          color:widget.color,
          margin: const EdgeInsets.only(
            left: 20,
            top: 30,
            right: 10,
          ),
          child: SizedBox(
              height: 130,
              width: 130,
              child:
                  Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                 Icon(
                  widget.icon,size: 30,
                ),
                Text(
                  widget.title,textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 20),
                ),
               
              ]))),
    );
  }
}
