import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:slicing_1/components/bottom_navigation.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isLoading = false;

Future<UserCredential> signInWithGoogle() async {
  setState(() {
    _isLoading = true;
  });
  try {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) {
        setState(() {
          _isLoading = false; // Stop loading if user cancels sign in
        });
        return Future.error("Sign in aborted by user");
      }
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    final UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context)=> BottomNavigation(isLoggedIn: true,))
    );
    return userCredential;
  } catch (e) {
     ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    return Future.error(e);
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8,vertical: 16),
        child: Center(
          child: _isLoading
              ? const CircularProgressIndicator()
              : ElevatedButton(
                  onPressed: () {
                    signInWithGoogle();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.network(
                        'http://pngimg.com/uploads/google/google_PNG19635.png',
                        width: 30,
                        height: 30,
                      ),
                      const Text("Sign In With Google")
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}