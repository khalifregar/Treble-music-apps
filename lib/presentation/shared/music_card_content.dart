import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:trebel/application/cubit/greetings/greetings_cubit.dart';

// Membuat komponen reusable untuk card musik
class MusicCardContent extends StatelessWidget {
  final String title;
  final String artist;
  final String imageUrl;
  final double imageSize;
  final double containerWidth;
  final EdgeInsets margin;

  const MusicCardContent({
    Key? key,
    required this.title,
    required this.artist,
    required this.imageUrl,
    required this.imageSize,
    required this.containerWidth,
    this.margin = EdgeInsets.zero,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: containerWidth,
      margin: margin,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: imageSize,
            width: imageSize,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.r),
              image: DecorationImage(
                image: AssetImage(imageUrl),
                fit: BoxFit.cover,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  spreadRadius: 2,
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              overflow: TextOverflow.ellipsis,
            ),
            maxLines: 1,
          ),
          Text(
            artist,
            style: TextStyle(
              color: Colors.grey,
              fontSize: 14.sp,
              overflow: TextOverflow.ellipsis,
            ),
            maxLines: 1,
          ),
        ],
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? lastPlayedTitle;
  String? lastPlayedArtist;
  String? lastPlayedImage;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GreetingCubit(),
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
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

                  // Menampilkan LastPlayedSection jika ada lagu yang dipilih
                  if (lastPlayedTitle != null) ...[
                    Text(
                      'Terakhir di dengar',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    Container(
                      padding: EdgeInsets.all(12.w),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: MusicCardContent(
                        title: lastPlayedTitle!,
                        artist: lastPlayedArtist!,
                        imageUrl: lastPlayedImage!,
                        imageSize: 60.w,
                        containerWidth: double.infinity,
                      ),
                    ),
                    SizedBox(height: 16.h),
                  ],

                  SizedBox(
                    height: 250.h,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _musicData.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              lastPlayedTitle = _musicData[index]['title'];
                              lastPlayedArtist = _musicData[index]['artist'];
                              lastPlayedImage = _musicData[index]['image'];
                            });
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
                ],
              ),
            ),
          ),
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
    'image': 'assets/images/dantareza.jpg'
  },
  {
    'title': 'Sampai Jumpa',
    'artist': 'Endank Soekamti',
    'image': 'assets/images/endank.jpg'
  },
  {
    'title': 'Cinta Terlarang',
    'artist': 'Melly Goeslaw',
    'image': 'assets/images/melly.jpg'
  },
  {
    'title': 'Bertaut',
    'artist': 'Nadin Amizah',
    'image': 'assets/images/nadin.jpg'
  },
  {'title': 'Aku Bisa', 'artist': 'Afgan', 'image': 'assets/images/afgan.jpg'},
  {
    'title': 'Tentang Seseorang',
    'artist': 'Yura Yunita',
    'image': 'assets/images/yura.jpg'
  },
  {
    'title': 'Pergi Hilang dan Lupakan',
    'artist': 'Marion Jola',
    'image': 'assets/images/marion.jpg'
  },
];
