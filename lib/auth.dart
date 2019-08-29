import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';

class AuthService {

  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore _db = Firestore.instance;

  Observable<FirebaseUser> user;
  Observable<Map<String, dynamic>> profile;
  PublishSubject loading = PublishSubject();

  AuthService() {
    user = Observable(_auth.onAuthStateChanged);
    profile = user.switchMap((FirebaseUser user) {
      if (user != null) {
        return _db
          .collection('users')
          .document(user.uid)
          .snapshots()
          .map((snap) => snap.data);
      } else {
        print('fuck this');
        return Observable.just({});
      }
    });
  }

  Future<FirebaseUser> googleSignIn() async {
    //Start  
    loading.add(true);

    //Sign in to google
    GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    
    //Authenticate and sign into firebase
    GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken:  googleAuth.idToken,
    );
    FirebaseUser user = (await _auth.signInWithCredential(credential)).user;

    //End
    loading.add(false);
    print("signed in " + user.displayName);
    return user;
  }

  void updateUserData(FirebaseUser user) async {
    //Find user in database to update
    DocumentReference ref = _db.collection('users').document(user.uid);

    return ref.setData({
      'uid': user.uid,
      'email': user.email,
      'photoURL': user.photoUrl,
      'displayName': user.displayName,
      'lastSeen': DateTime.now()
    }, merge: true);
  }

  void signOut() {
    _auth.signOut();
  }

}

final AuthService authService = AuthService();