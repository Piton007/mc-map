import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class FBAuth {

  final FacebookAuth _fb;
  final FirebaseAuth _firebaseAuth;

  FBAuth({FacebookAuth fb, FirebaseAuth firebase}): _fb = fb, _firebaseAuth = firebase;

  Future<UserCredential> signIn() async {

    final AccessToken result = await _fb.login();


    final FacebookAuthCredential facebookAuthCredential =
    FacebookAuthProvider.credential(result.token);


    return await _firebaseAuth.signInWithCredential(facebookAuthCredential);
  }

  Future<void> signOut() async {

    await _fb.logOut();
    
  }

}