import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:timezone/data/latest.dart' as tz;

// Import necessary pages and cubits
import 'package:trebel/application/cubit/greetings/greetings_cubit.dart';
import 'package:trebel/presentation/shared/auth/account_page.dart';
import 'package:trebel/presentation/pages/home_page.dart';

void main() async {
  // Ensure Flutter bindings are initialized before running the app
  WidgetsFlutterBinding.ensureInitialized();

  // Lock the app in portrait orientation
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  // Initialize timezone data before running the app
  try {
    tz.initializeTimeZones();
  } catch (e) {
    print('Error initializing timezone: $e');
  }

  // Ensure screen utilities are configured before app runs
  await ScreenUtil.ensureScreenSize();

  // Run the app with screen utilities and multi-bloc providers
  runApp(const TrebelApp());
}

class TrebelApp extends StatefulWidget {
  const TrebelApp({super.key});

  @override
  State<TrebelApp> createState() => _TrebelAppState();
}

class _TrebelAppState extends State<TrebelApp> {
  late GoRouter _router;

  @override
  void initState() {
    super.initState();
    // Initialize the router in initState for better performance
    _router = GoRouter(
      initialLocation: '/welcome',
      routes: [
        GoRoute(
          path: '/welcome',
          builder: (context, state) => const WelcomePage(),
        ),
        GoRoute(
          path: '/account',
          builder: (context, state) => const AccountPage(),
        ),
        GoRoute(
          path: '/home',
          builder: (context, state) => const HomePage(),
        ),
      ],
      // Custom error page for undefined routes
      errorBuilder: (context, state) => Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Oops! Page Not Found',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16.h),
              Text(
                'The page you are looking for does not exist.',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 16.sp,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(475, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) => MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => GreetingCubit(),
          ),
        ],
        child: MaterialApp.router(
          title: 'Trebel',
          debugShowCheckedModeBanner: false,

          // Configure light theme
          theme: ThemeData(
            brightness: Brightness.light,
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.green,
              brightness: Brightness.light,
            ),
            // Apply text scaling to the entire app
            textTheme: Typography.englishLike2018.apply(fontSizeFactor: 1.sp),

            // Customize elevated button theme for consistency
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 24.w),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
            ),
          ),

          // Dark theme for alternative modes
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.green,
              brightness: Brightness.dark,
            ),

            // Matching dark theme button style
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade700,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 24.w),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
            ),
          ),

          // Default theme mode
          themeMode: ThemeMode.dark,

          // Use Go Router for navigation
          routerConfig: _router,
        ),
      ),
    );
  }
}

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Welcome',
          style: TextStyle(fontSize: 20.sp), // Responsive font size
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          // Responsive padding
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Welcome to Trebel',
                style: TextStyle(
                  fontSize: 24.sp, // Responsive font size
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20.h), // Responsive vertical spacing
              SizedBox(
                // Responsive button width
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Use Go Router for navigation
                    context.go('/account');
                  },
                  child: Text(
                    'Create Account',
                    style: TextStyle(
                      fontSize: 16.sp, // Responsive font size
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
