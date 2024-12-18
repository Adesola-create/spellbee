// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'home_page.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:google_sign_in/google_sign_in.dart';

// class SignupScreen extends StatefulWidget {
//   const SignupScreen({super.key});

//   @override
//   _SignupScreenState createState() => _SignupScreenState();
// }

// class _SignupScreenState extends State<SignupScreen> {
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   final TextEditingController _confirmPasswordController = TextEditingController();
//   final TextEditingController _verificationCodeController = TextEditingController();

//   bool _isLoading = false;
//   bool _isPasswordVisible = false;
//   bool _isVerificationStep = false;

//   final FirebaseAuth _auth = FirebaseAuth.instance;

//   // Send verification code logic (Simulated here)
//   Future<void> _signupWithEmail() async {
//   // Removed the unnecessary 'email' variable
//   final String password = _passwordController.text.trim();
//   final String confirmPassword = _confirmPasswordController.text.trim();

//   if (password != confirmPassword) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(
//         content: Text("Passwords do not match!"),
//         backgroundColor: Colors.black,
//       ),
//     );
//     return;
//   }

//   setState(() {
//     _isLoading = true;
//   });

//   try {
//     // Simulate sending a verification code (You can replace this with backend logic)
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(
//         content: Text("A 4-digit verification code has been sent to your email."),
//         backgroundColor: Colors.green,
//       ),
//     );
//     setState(() {
//       _isVerificationStep = true; // Move to the verification step
//     });
//   } catch (error) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(
//         content: Text("An error occurred. Please try again."),
//         backgroundColor: Colors.black,
//       ),
//     );
//   } finally {
//     setState(() {
//       _isLoading = false;
//     });
//   }
// }

//   // Verify the code and sign up the user
//   Future<void> _verifyCodeAndSignUp() async {
//     final String email = _emailController.text.trim();
//     final String password = _passwordController.text.trim();
//     final String verificationCode = _verificationCodeController.text.trim();

//     // Simulate verifying the code (Replace with your actual verification logic)
//     if (verificationCode == "1234") {
//       try {
//         // Firebase signup
//         await _auth.createUserWithEmailAndPassword(
//           email: email,
//           password: password,
//         );

//         // Save user data locally
//         final prefs = await SharedPreferences.getInstance();
//         await prefs.setString('userEmail', email);

//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(
//             builder: (context) => const HomePage(),
//           ),
//         );
//       } on FirebaseAuthException catch (e) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text(e.message ?? "An error occurred."),
//             backgroundColor: Colors.black,
//           ),
//         );
//       }
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text("Invalid verification code."),
//           backgroundColor: Colors.black,
//         ),
//       );
//     }
//   }

//   // Sign up with Google
//   Future<void> _signupWithGoogle() async {
//     try {
//       final GoogleSignIn googleSignIn = GoogleSignIn();
//       final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

//       if (googleUser != null) {
//         final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

//         final credential = GoogleAuthProvider.credential(
//           accessToken: googleAuth.accessToken,
//           idToken: googleAuth.idToken,
//         );

//         await _auth.signInWithCredential(credential);

//         // Save user info locally
//         final prefs = await SharedPreferences.getInstance();
//         await prefs.setString('userEmail', googleUser.email);

//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(
//             builder: (context) => const HomePage(),
//           ),
//         );
//       }
//     } catch (error) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text("Google Sign-In failed. Please try again."),
//           backgroundColor: Colors.black,
//         ),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const SizedBox(height: 75),
//               const Text(
//                 'Signup',
//                 style: TextStyle(
//                   fontSize: 38,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.purple,
//                 ),
//               ),
//               const SizedBox(height: 40),
//               if (!_isVerificationStep) ...[
//                 TextField(
//                   controller: _emailController,
//                   decoration: const InputDecoration(
//                     labelText: 'Email',
//                     border: OutlineInputBorder(),
//                   ),
//                   keyboardType: TextInputType.emailAddress,
//                 ),
//                 const SizedBox(height: 14),
//                 TextField(
//                   controller: _passwordController,
//                   decoration: InputDecoration(
//                     labelText: 'Password',
//                     border: const OutlineInputBorder(),
//                     suffixIcon: IconButton(
//                       icon: Icon(
//                         _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
//                       ),
//                       onPressed: () {
//                         setState(() {
//                           _isPasswordVisible = !_isPasswordVisible;
//                         });
//                       },
//                     ),
//                   ),
//                   obscureText: !_isPasswordVisible,
//                 ),
//                 const SizedBox(height: 14),
//                 TextField(
//                   controller: _confirmPasswordController,
//                   decoration: const InputDecoration(
//                     labelText: 'Confirm Password',
//                     border: OutlineInputBorder(),
//                   ),
//                   obscureText: true,
//                 ),
//                 const SizedBox(height: 30),
//                 ElevatedButton(
//                   onPressed: _isLoading ? null : _signupWithEmail,
//                   child: _isLoading
//                       ? const CircularProgressIndicator(color: Colors.white)
//                       : const Text("Send Verification Code"),
//                 ),
//               ] else ...[
//                 const Text("Enter the 4-digit code sent to your email."),
//                 const SizedBox(height: 14),
//                 TextField(
//                   controller: _verificationCodeController,
//                   decoration: const InputDecoration(
//                     labelText: 'Verification Code',
//                     border: OutlineInputBorder(),
//                   ),
//                   keyboardType: TextInputType.number,
//                 ),
//                 const SizedBox(height: 30),
//                 ElevatedButton(
//                   onPressed: _isLoading ? null : _verifyCodeAndSignUp,
//                   child: _isLoading
//                       ? const CircularProgressIndicator(color: Colors.white)
//                       : const Text("Verify and Sign Up"),
//                 ),
//               ],
//               const SizedBox(height: 30),
//               ElevatedButton.icon(
//                 onPressed: _signupWithGoogle,
//                 icon: const Icon(Icons.login),
//                 label: const Text("Sign Up with Google"),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'login_page.dart';
import 'home_page.dart';
import 'constants.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:device_info_plus/device_info_plus.dart';


class PhoneNumberInput extends StatelessWidget {
  final TextEditingController controller;
  const PhoneNumberInput({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return IntlPhoneField(
      decoration: const InputDecoration(
        labelText: 'Phone Number',
        labelStyle: TextStyle(color: Colors.grey),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: primaryColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: primaryColor, width: 2.0),
        ),
      ),
      initialCountryCode: 'NG',
      onChanged: (phone) {
        controller.text = phone.completeNumber;
      },
    );
  }
}

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _isLoading = false;
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;




Future<void> getDeviceInfo() async {
  final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();

  if (Theme.of(context).platform == TargetPlatform.android) {
    final androidInfo = await deviceInfoPlugin.androidInfo;
    print('Android Device Info:');
    print('ID: ${androidInfo.id}');
    print('Brand: ${androidInfo.brand}');
    print('Model: ${androidInfo.model}');
    print('Android Version: ${androidInfo.version.release}');
    print('SDK Level: ${androidInfo.version.sdkInt}');
  } else if (Theme.of(context).platform == TargetPlatform.iOS) {
    final iosInfo = await deviceInfoPlugin.iosInfo;
    print('iOS Device Info:');
    print('Name: ${iosInfo.name}');
    print('Model: ${iosInfo.model}');
    print('System Name: ${iosInfo.systemName}');
    print('System Version: ${iosInfo.systemVersion}');
    print('Identifier for Vendor: ${iosInfo.identifierForVendor}');
  }
}


  Future<void> _signup() async {
  final String firstName = _firstNameController.text.trim();
  final String lastName = _lastNameController.text.trim();
  final String phone = _phoneController.text.trim();
  final String email = _emailController.text.trim();
  final String password = _passwordController.text.trim();
  final String confirmPassword = _confirmPasswordController.text.trim();

  if (password != confirmPassword) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Passwords do not match!"),
        backgroundColor: Colors.black,
      ),
    );
    return;
  }

  setState(() {
    _isLoading = true;
  });

  // final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  // String? deviceName;
  // String? deviceId;
  // String? deviceBrand;

  // try {
  //   if (Theme.of(context).platform == TargetPlatform.android) {
  //     final androidInfo = await deviceInfoPlugin.androidInfo;
  //     deviceName = androidInfo.model;
  //     deviceId = androidInfo.id;
  //     deviceBrand = androidInfo.brand;
  //   } else if (Theme.of(context).platform == TargetPlatform.iOS) {
  //     final iosInfo = await deviceInfoPlugin.iosInfo;
  //     deviceName = iosInfo.name;
  //     deviceId = iosInfo.identifierForVendor; // unique ID on iOS
  //     deviceBrand = "Apple";
  //   }
  // } catch (e) {
  //   // Handle any error that occurs during device info retrieval
  //   print('Error fetching device info: $e');
  // }

  final Uri url = Uri.parse('https://api.braveiq.net/v1/signup');
  try {
    final response = await http.post(
      url,
      body: {
        'firstname': firstName,
        'lastname': lastName,
        'phone': phone,
        'email': email,
        'password': password,
        // 'device_name': deviceName ?? 'Unknown',
        // 'device_id': deviceId ?? 'Unknown',
        // 'device_brand': deviceBrand ?? 'Unknown',
      },
      headers: {
        'Authorization': 'Bearer 123456789Token',
      },
    );

    final Map<String, dynamic> responseBody = json.decode(response.body);

    if (responseBody['status'] == 'success') {
      final data = jsonDecode(response.body);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('userId', data['user']['id']);
      await prefs.setString('userName', data['user']['name']);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const HomePage(),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(responseBody['message']),
          backgroundColor: Colors.black,
        ),
      );
    }
  } catch (error) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("An error occurred. Please try again."),
        backgroundColor: Colors.black,
      ),
    );
  } finally {
    setState(() {
      _isLoading = false;
    });
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 75),
              const Text(
                'Signup',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 38,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
              const Text(
                'Signup to create your account',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 18, color: Colors.grey,
                ),
              ),
              const SizedBox(height: 40),
              TextField(
                controller: _firstNameController,
                decoration: const InputDecoration(
                  labelText: 'First Name',
                  labelStyle: TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: primaryColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: primaryColor, width: 2.0),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: _lastNameController,
                decoration: const InputDecoration(
                  labelText: 'Last Name',
                  labelStyle: TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: primaryColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: primaryColor, width: 2.0),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              PhoneNumberInput(controller: _phoneController),
              const SizedBox(height: 14),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  labelStyle: TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: primaryColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: primaryColor, width: 2.0),
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 14),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: const TextStyle(color: Colors.grey),
                  border: const OutlineInputBorder(
                    borderSide: BorderSide(color: primaryColor),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: primaryColor, width: 2.0),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ),
                ),
                obscureText: !_isPasswordVisible,
              ),
              const SizedBox(height: 14),
              TextField(
                controller: _confirmPasswordController,
                decoration: InputDecoration(
                  labelText: 'Confirm Password',
                  labelStyle: const TextStyle(color: Colors.grey),
                  border: const OutlineInputBorder(
                    borderSide: BorderSide(color: primaryColor),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: primaryColor, width: 2.0),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isConfirmPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        _isConfirmPasswordVisible =
                            !_isConfirmPasswordVisible;
                      });
                    },
                  ),
                ),
                obscureText: !_isConfirmPasswordVisible,
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _signup,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'Sign Up Now',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                ),
              ),
              TextButton(
                onPressed: _isLoading
                    ? null
                    : () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const LoginScreen()),
                        );
                      },
                child: const Text(
                  "Already have an account? Login",
                  style: TextStyle(color: primaryColor),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
