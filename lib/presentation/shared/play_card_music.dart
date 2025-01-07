import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trebel/presentation/shared/music_card_content.dart';

class PlayCardMusic extends StatelessWidget {
  final Map<String, String> songData;
  final VoidCallback onTap;
  final bool isPlaying;

  const PlayCardMusic({
    Key? key,
    required this.songData,
    required this.onTap,
    this.isPlaying = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          MusicCardContent(
            title: songData['title']!,
            artist: songData['artist']!,
            imageUrl: songData['image']!,
            imageSize: 180.w,
            containerWidth: 180.w,
            margin: EdgeInsets.only(right: 16.w),
          ),
          if (isPlaying)
            Positioned(
              top: 65.w, // Tengah dari height imageSize (180.w/2 - iconSize/2)
              left: 65
                  .w, // Tengah dari width containerWidth (180.w/2 - iconSize/2)
              child: Icon(
                Icons.pause_circle_filled,
                color: Colors.green,
                size: 50.w,
              ),
            ),
        ],
      ),
    );
  }
}
