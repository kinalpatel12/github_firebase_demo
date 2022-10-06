import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class FaceBookAuthService {
  static facebookLogin() async {
    try {
      final result =
          await FacebookAuth.i.login(permissions: ['public_profile', 'email']);
      if (result.status == LoginStatus.success) {
        final AuthCredential facebookCredential =
            FacebookAuthProvider.credential(result.accessToken!.token);
        await FirebaseAuth.instance.signInWithCredential(facebookCredential);
        final userData = await FacebookAuth.i.getUserData();
        log(userData.toString());
        log(userData['name']);
        log(userData['email']);
        log(userData['url']);
      }
    } catch (error) {
      log('ERROR===>>${error.toString()}');
    }
  }
}
