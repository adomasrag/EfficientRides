import 'package:firebase_auth/firebase_auth.dart';
import 'package:loginuicolors/models/userModel.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  UserModel? _userModelFromFirebase(User? user) {
    if (user != null) {
      return UserModel(uid: user.uid);
    } else {
      return null;
    }
  }

  Future signInAnonymously() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      User? user = result.user;
      return _userModelFromFirebase(user);
    } catch (e) {
      return null;
    }
  }
}
