import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:trebel/presentation/shared/music_card_content.dart';

class PlayCardMusic extends StatelessWidget {
  final Map<String, String> songData;
  final VoidCallback onTap;
  final bool isPlaying;
  final bool isLoading;

  const PlayCardMusic({
    Key? key,
    required this.songData,
    required this.onTap,
    this.isPlaying = false,
    this.isLoading = false,
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
          if (isLoading)
            Positioned(
              top: 65.w,
              left: 65.w,
              child: SizedBox(
                width: 50.w,
                height: 50.w,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                  strokeWidth: 4.w,
                ),
              ),
            )
          else if (isPlaying)
            Positioned(
              top: 65.w,
              left: 65.w,
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
