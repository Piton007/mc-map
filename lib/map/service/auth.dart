import 'package:firebase_auth/firebase_auth.dart';

class Auth {
  final FirebaseAuth service;

  Auth({this.service});

  subscribeToAuthChanges(){
    return service.authStateChanges();
  }

  signInAnonymously() async {
    String msg =   "Successful registration";
    var user =  await service.signInAnonymously();
    return AuthResponse(user: user,msg: msg);
  }

  signUpWithEmailAndPassword({String email, String password}) async {
    UserCredential user;
    String msg = "Successful registration";

    try{
      user = await this.service.createUserWithEmailAndPassword(email: email , password: password);

    } on FirebaseAuthException catch(e) {
          msg = e.code;
    }

    return AuthResponse(user: user,msg:msg);
  }

  signInWithEmailAndPassword({String email, String password}) async {
    UserCredential user;
    String msg = "Successful login";

    try{
      user = await this.service.signInWithEmailAndPassword(email: email, password: password);


    } on FirebaseAuthException catch(e) {
      msg = e.code;
    }

    return AuthResponse(user: user,msg:msg);
  }
}


class AuthResponse {
  final UserCredential user;
  final String msg;

  AuthResponse({this.user,this.msg =  "Successful registration"});
}