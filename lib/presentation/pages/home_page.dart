import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:trebel/application/cubit/greetings/greetings_cubit.dart';
import 'package:trebel/presentation/shared/detail_page.dart';
import 'package:trebel/presentation/shared/menu_bar.dart';
import 'package:trebel/presentation/shared/music_card_content.dart';
import 'package:trebel/presentation/shared/play_card_music.dart';
import 'package:trebel/presentation/shared/player_music_buttom.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Map<String, String>> lastPlayedSongs = [];
  final int maxLastPlayed = 8;
  String? currentPlayingId;
  Map<String, String>? currentPlayingSong;
  int _selectedIndex = 0;

  void _togglePlay(Map<String, String> song) {
    setState(() {
      if (currentPlayingId == song['title']) {
        currentPlayingId = null;
        currentPlayingSong = null;
      } else {
        currentPlayingId = song['title'];
        currentPlayingSong = song;
        _addToLastPlayed(song);
      }
    });
  }

  void _addToLastPlayed(Map<String, String> song) {
    setState(() {
      List<Map<String, String>> updatedLastPlayedSongs =
          List.from(lastPlayedSongs);
      if (!updatedLastPlayedSongs.contains(song)) {
        updatedLastPlayedSongs.insert(0, song);
        if (updatedLastPlayedSongs.length > maxLastPlayed) {
          updatedLastPlayedSongs.removeLast();
        }
        lastPlayedSongs.clear();
        lastPlayedSongs.addAll(updatedLastPlayedSongs);
      }
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    // TODO: Navigate to the corresponding screen based on the selected index
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GreetingCubit(),
      child: Scaffold(
        backgroundColor: Colors.black,
        // Gunakan CustomBottomNavBar
        bottomNavigationBar: CustomBottomNavBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
        ),
        body: Stack(
          children: [
            SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 10.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Trebel',
                            style: TextStyle(
                              color: Colors.green,
                              fontSize: 32.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.account_circle_outlined,
                              color: Colors.white,
                              size: 40.sp,
                            ),
                            onPressed: () {
                              context.go('/account');
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: 16.h),
                      BlocBuilder<GreetingCubit, GreetingState>(
                        builder: (context, state) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                state.greeting,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 28.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 8.h),
                            ],
                          );
                        },
                      ),
                      SizedBox(height: 16.h),
                      if (lastPlayedSongs.isNotEmpty) ...[
                        Text(
                          'Terakhir di dengar',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 24.h),
                        SizedBox(
                          height: 250.h,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: lastPlayedSongs.length > maxLastPlayed
                                ? maxLastPlayed
                                : lastPlayedSongs.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => DetailPage(
                                        songData: lastPlayedSongs[index],
                                      ),
                                    ),
                                  );
                                },
                                child: Container(
                                  margin: EdgeInsets.only(right: 16.w),
                                  child: MusicCardContent(
                                    title: lastPlayedSongs[index]['title']!,
                                    artist: lastPlayedSongs[index]['artist']!,
                                    imageUrl: lastPlayedSongs[index]['image']!,
                                    imageSize: 180.w,
                                    containerWidth: 180.w,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        SizedBox(height: 16.h),
                      ],
                      Text(
                        'Weekend Santai',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 24.h),
                      SizedBox(
                        height: 250.h,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _musicData.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                _addToLastPlayed(_musicData[index]);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DetailPage(
                                      songData: _musicData[index],
                                    ),
                                  ),
                                );
                              },
                              child: MusicCardContent(
                                title: _musicData[index]['title']!,
                                artist: _musicData[index]['artist']!,
                                imageUrl: _musicData[index]['image']!,
                                imageSize: 180.w,
                                containerWidth: 180.w,
                                margin: EdgeInsets.only(right: 16.w),
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 24.h),
                      Text(
                        'Hari-hari Musik',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 24.h),
                      SizedBox(
                        height: 250.h,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _musicData.length,
                          itemBuilder: (context, index) {
                            return PlayCardMusic(
                              songData: _musicData[index],
                              isPlaying: currentPlayingId ==
                                  _musicData[index]['title'],
                              onTap: () => _togglePlay(_musicData[index]),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Tambahkan player musik di bottom stack
            if (currentPlayingSong != null)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: PlayerMusicBottom(
                  songData: currentPlayingSong!,
                  isPlaying: currentPlayingId == currentPlayingSong!['title'],
                  onPlayPause: () => _togglePlay(currentPlayingSong!),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

final List<Map<String, String>> _musicData = [
  {
    'title': 'Lost Love',
    'artist': 'Feby Putri',
    'image': 'assets/images/feby.jpg'
  },
  {
    'title': 'Selamat Tinggal',
    'artist': 'Dantareza',
    'image': 'assets/images/last_child.jpeg'
  },
  {
    'title': 'Sampai Jumpa',
    'artist': 'Endank Soekamti',
    'image': 'assets/images/endank_soekamti.jpeg'
  },
  {
    'title': 'Cinta Terlarang',
    'artist': 'Melly Goeslaw',
    'image': 'assets/images/melly_goeslaw.jpeg'
  },
  {
    'title': 'Bertaut',
    'artist': 'Nadin Amizah',
    'image': 'assets/images/nadin_amizah.jpeg'
  },
  {'title': 'Aku Bisa', 'artist': 'Afgan', 'image': 'assets/images/afgan.jpeg'},
  {
    'title': 'Tentang Seseorang',
    'artist': 'Yura Yunita',
    'image': 'assets/images/yura_yunita.jpeg'
  },
  {
    'title': 'Pergi Hilang dan Lupakan',
    'artist': 'Marion Jola',
    'image': 'assets/images/marion_jola.jpeg'
  },
];
