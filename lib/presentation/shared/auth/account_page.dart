import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:trebel/presentation/shared/form_reusable.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final _usernameEmailController = TextEditingController();
  final _passwordController = TextEditingController();

  // Add ScrollController to manage scroll behavior
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _usernameEmailController.dispose();
    _passwordController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _handleFormSubmit(List<String> values) {
    // Extract username/email and password from the form fields
    final usernameEmail = values[0].trim();
    final password = values[1].trim();

    // Here you would typically add your actual authentication logic
    // For now, we'll do a simple validation
    if (usernameEmail.isNotEmpty && password.isNotEmpty) {
      // Show processing snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Processing login')),
      );

      // Simulate a short delay to mimic authentication process
      Future.delayed(const Duration(seconds: 1), () {
        // Navigate to home page using Go Router
        context.go('/home');
      });
    } else {
      // Show error if fields are empty
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter both username/email and password'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  List<FormFieldConfig> get _formFields => [
        FormFieldConfig(
          label: 'Username/Email',
          controller: _usernameEmailController,
          keyboardType: TextInputType.text,
          validator: (value) {
            if (value?.isEmpty ?? true)
              return 'Please enter a username or email';

            // Validate email format if it looks like an email
            if (value!.contains('@')) {
              final emailRegex =
                  RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
              if (!emailRegex.hasMatch(value)) {
                return 'Please enter a valid email';
              }
            } else {
              // Username validation (example: 3-20 characters, alphanumeric)
              final usernameRegex = RegExp(r'^[a-zA-Z0-9_]{3,20}$');
              if (!usernameRegex.hasMatch(value)) {
                return 'Username must be 3-20 characters long and contain only letters, numbers, and underscores';
              }
            }
            return null;
          },
        ),
        FormFieldConfig(
          label: 'Password',
          controller: _passwordController,
          isPassword: true,
          validator: (value) {
            if (value?.isEmpty ?? true) return 'Please enter a password';
            if (value!.length < 6) {
              return 'Password must be at least 6 characters long';
            }
            return null;
          },
        ),
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      // Remove resizeToAvoidBottomInset to prevent automatic resizing
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Stack(
            children: [
              // Main content with custom scroll behavior
              SingleChildScrollView(
                controller: _scrollController,
                // Limit the scroll physics
                physics: const ClampingScrollPhysics(),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 40.h),
                      IconButton(
                        icon: Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: 24.sp,
                        ),
                        onPressed: () =>
                            context.pop(), // Use Go Router for back navigation
                      ),
                      SizedBox(height: 32.h),
                      Text(
                        'Login to Trebel',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 32.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      SizedBox(height: 16.h),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey[900],
                            padding: EdgeInsets.symmetric(vertical: 12.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                          ),
                          icon: FaIcon(
                            FontAwesomeIcons.google,
                            size: 24.sp,
                            color: Colors.white,
                          ),
                          label: Text(
                            'Google',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14.sp,
                            ),
                          ),
                          onPressed: () {},
                        ),
                      ),
                      SizedBox(height: 24.h),
                      ReusableForm(
                        fields: _formFields,
                        onSubmit: _handleFormSubmit,
                        submitButtonText: 'Login',
                        submitButtonColor: Colors.transparent,
                        submitButtonTextStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                        ),
                        textColor: Colors.white,
                        borderRadius: 12.r,
                        fieldSpacing: 11.h,
                        submitButtonPadding: EdgeInsets.symmetric(
                          vertical: 10.h,
                          horizontal: 20.w,
                        ),
                        submitButtonBorder: Border.all(
                          color: Colors.white,
                          width: 1.5,
                        ),
                      ),
                      SizedBox(height: 24.h),
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Don\'t have a Trebel account? ',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 14.sp,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                // TODO: Navigate to registration page
                                context.push('/register');
                              },
                              child: Text(
                                'Register',
                                style: TextStyle(
                                  color: Colors.green,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Add extra padding at bottom for scrolling space
                      SizedBox(height: 100.h),
                    ],
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
