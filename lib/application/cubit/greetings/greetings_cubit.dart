import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

// Define the possible states for the greeting
class GreetingState {
  final String greeting;
  final String time;

  GreetingState({required this.greeting, required this.time});
}

class GreetingCubit extends Cubit<GreetingState> {
  GreetingCubit() : super(_getInitialGreeting()) {
    // Ensure timezone data is initialized
    _initializeTimezone();
  }

  // Method to initialize timezone data safely
  void _initializeTimezone() {
    try {
      tz.initializeTimeZones();
    } catch (e) {
      // Log the error or handle it appropriately
      print('Error initializing timezone: $e');
      // Fallback to system time if timezone initialization fails
      emit(_getFallbackGreeting());
    }
  }

  // Fallback method if timezone initialization fails
  static GreetingState _getFallbackGreeting() {
    final now = DateTime.now();
    final timeString = DateFormat('HH:mm').format(now);

    String greeting;
    if (now.hour < 11) {
      greeting = 'Good Morning';
    } else if (now.hour < 15) {
      greeting = 'Good Afternoon';
    } else if (now.hour < 18) {
      greeting = 'Good Evening';
    } else {
      greeting = 'Good Night';
    }

    return GreetingState(greeting: greeting, time: timeString);
  }

  // Method to generate the appropriate greeting based on the time in Jakarta
  static GreetingState _getInitialGreeting() {
    try {
      // Get the current time in Jakarta
      final jakartaTimeZone = tz.getLocation('Asia/Jakarta');
      final now = tz.TZDateTime.now(jakartaTimeZone);

      // Format the time for display
      final timeString = DateFormat('HH:mm').format(now);

      // Determine greeting based on time
      String greeting;
      if (now.hour < 11) {
        greeting = 'Good Morning';
      } else if (now.hour < 15) {
        greeting = 'Good Afternoon';
      } else if (now.hour < 18) {
        greeting = 'Good Evening';
      } else {
        greeting = 'Good Night';
      }

      return GreetingState(greeting: greeting, time: timeString);
    } catch (e) {
      // Fallback if Jakarta timezone can't be resolved
      print('Error getting Jakarta time: $e');
      return _getFallbackGreeting();
    }
  }

  // Method to update the greeting (can be called periodically)
  void updateGreeting() {
    emit(_getInitialGreeting());
  }
}
