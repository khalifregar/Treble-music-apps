// player_music_bottom.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PlayerMusicBottom extends StatelessWidget {
  final Map<String, String>? songData;
  final bool isPlaying;
  final VoidCallback onPlayPause;

  const PlayerMusicBottom({
    Key? key,
    this.songData,
    required this.isPlaying,
    required this.onPlayPause,
    required bool isLoading,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0xFF282828),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
          child: Row(
            children: [
              // Song thumbnail
              ClipRRect(
                borderRadius: BorderRadius.circular(4.r),
                child: Container(
                  height: 60.h,
                  width: 80.w,
                  decoration: BoxDecoration(
                    image: songData?['image'] != null
                        ? DecorationImage(
                            image: AssetImage(songData!['image']!),
                            fit: BoxFit.cover,
                          )
                        : null,
                    color: const Color(0xFF404040),
                  ),
                  child: songData?['image'] == null
                      ? Icon(
                          Icons.music_note,
                          color: Colors.grey[600],
                          size: 20.w,
                        )
                      : null,
                ),
              ),
              SizedBox(width: 12.w),
              // Song info
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      songData?['title'] ?? 'No Title',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17.sp,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 3.h),
                    Text(
                      songData?['artist'] ?? 'Unknown Artist',
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 17.sp,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              // Control buttons
              Row(
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.devices_outlined,
                      color: Colors.white,
                      size: 24.w,
                    ),
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints(
                      minWidth: 40.w,
                      minHeight: 40.h,
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.add_circle_outline,
                      color: Colors.white,
                      size: 24.w,
                    ),
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints(
                      minWidth: 40.w,
                      minHeight: 40.h,
                    ),
                  ),
                  IconButton(
                    onPressed: onPlayPause,
                    icon: Icon(
                      isPlaying ? Icons.pause : Icons.play_arrow,
                      color: Colors.white,
                      size: 32.w,
                    ),
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints(
                      minWidth: 40.w,
                      minHeight: 40.h,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
