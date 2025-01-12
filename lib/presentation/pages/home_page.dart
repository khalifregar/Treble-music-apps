import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
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
  final AudioPlayer _audioPlayer = AudioPlayer();
  final List<Map<String, String>> lastPlayedSongs = [];
  final int maxLastPlayed = 8;
  String? currentPlayingId;
  Map<String, String>? currentPlayingSong;
  bool isPlaying = false;
  int _selectedIndex = 0;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _clearAudioCache();
    _initAudioPlayer();
  }

  void _initAudioPlayer() {
    _audioPlayer.setLoopMode(LoopMode.off);

    // Listen to player state changes
    _audioPlayer.playerStateStream.listen((playerState) {
      setState(() {
        if (playerState.processingState == ProcessingState.completed) {
          currentPlayingId = null;
          currentPlayingSong = null;
          isPlaying = false;
        }
      });
    });

    // Listen to playing state changes
    _audioPlayer.playingStream.listen((playing) {
      setState(() {
        isPlaying = playing;
        debugPrint('Playing state changed: $isPlaying');
      });
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
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

  Future<void> _togglePlay(Map<String, String> song) async {
    try {
      if (currentPlayingId == song['title']) {
        if (_audioPlayer.playing) {
          await _audioPlayer.pause();
        } else {
          await _audioPlayer.play();
        }
      } else {
        if (_audioPlayer.playing) {
          await _audioPlayer.stop();
        }

        setState(() {
          currentPlayingId = song['title'];
          currentPlayingSong = song;
        });

        await _playSong(song);
      }
    } catch (e) {
      debugPrint('Error in _togglePlay: $e');
    }
  }

  Future<void> _playSong(Map<String, String> song) async {
    setState(() {
      isLoading = true;
    });

    try {
      final assetPath =
          'assets/audio/${song['title']!.toLowerCase().replaceAll(' ', '_')}.mp3';
      debugPrint('📂 Asset path: $assetPath');

      final manifestContent =
          await DefaultAssetBundle.of(context).loadString('AssetManifest.json');
      final Map<String, dynamic> manifestMap = json.decode(manifestContent);
      debugPrint('📝 Available assets: ${manifestMap.keys.toString()}');

      if (!manifestMap.keys.contains(assetPath)) {
        throw Exception('Asset not found in manifest: $assetPath');
      }

      final appDir = await getApplicationDocumentsDirectory();
      final audioPath =
          '${appDir.path}/audio/${song['title']!.toLowerCase().replaceAll(' ', '_')}.mp3';

      final byteData = await rootBundle.load(assetPath);
      final buffer = byteData.buffer;
      await File(audioPath).create(recursive: true);
      await File(audioPath).writeAsBytes(
          buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

      await _audioPlayer.setFilePath(audioPath);

      // Tambahkan listener untuk status pemutaran
      _audioPlayer.playerStateStream.listen((playerState) {
        if (mounted && playerState.processingState == ProcessingState.ready) {
          setState(() {
            isLoading = false;
          });
        }
      });

      await _audioPlayer.play();
      debugPrint('▶️ Playback started');
    } catch (e, stackTrace) {
      debugPrint('❌ Error: $e');
      debugPrint('📋 Stack trace: $stackTrace');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to play: ${song['title']}'),
            backgroundColor: Colors.red,
          ),
        );
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> _clearAudioCache() async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final audioDir = Directory('${appDir.path}/audio');

      if (await audioDir.exists()) {
        await audioDir.delete(recursive: true);
        debugPrint('🗑️ Audio cache cleared');
      }

      await audioDir.create();
    } catch (e) {
      debugPrint('❌ Error clearing cache: $e');
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GreetingCubit(),
      child: Scaffold(
        backgroundColor: Colors.black,
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
                                      _musicData[index]['title'] &&
                                  isPlaying,
                              isLoading: isLoading &&
                                  currentPlayingId ==
                                      _musicData[index]
                                          ['title'], // Tambahkan ini
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
            if (currentPlayingSong != null)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: PlayerMusicBottom(
                  songData: currentPlayingSong!,
                  isPlaying: currentPlayingId == currentPlayingSong!['title'] &&
                      isPlaying,
                  isLoading: isLoading, // Add this
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
