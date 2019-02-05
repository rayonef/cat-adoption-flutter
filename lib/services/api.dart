import 'dart:async';

// import 'dart:convert';
import 'package:cat_box/models/cat.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class CatApi {

  static FirebaseAuth _auth = FirebaseAuth.instance;
  static GoogleSignIn _googleSignIn = new GoogleSignIn();

  FirebaseUser firebaseUser;

  CatApi(FirebaseUser user) {
    this.firebaseUser = user;
  }

  static Future<CatApi> signInWithGogle() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    final FirebaseUser user = await _auth.signInWithGoogle(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken
    );
    assert(user.email != null);
    assert(user.displayName != null);
    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    final FirebaseUser currentUser = await _auth.currentUser();
    assert(user.uid == currentUser.uid);

    return new CatApi(user);
  }

  // static List<Cat> allCatsFromJson(String jsonData) {
  //   List<Cat> cats = [];
  //   json.decode(jsonData)['cats'].forEach((cat) => cats.add(_forMap(cat)));
  //   return cats;
  // }

  Future<List<Cat>> getAllCats() async {
    return (await Firestore.instance.collection('cats').getDocuments())
      .documents
      .map((snap) => _fromDocumentSnapshot(snap))
      .toList();
  }

  StreamSubscription watch(Cat cat, void onChange(Cat cat)) {
    return Firestore.instance.collection('cats')
      .document(cat.documentId)
      .snapshots
      .listen((snap) => onChange(_fromDocumentSnapshot(snap)));
  }

  Future likeCat(Cat cat) async {
    await Firestore.instance
      .collection('likes')
      .document('${cat.documentId}:${this.firebaseUser.uid}')
      .setData({});
  }

  Future unlikeCat(Cat cat) async {
    await Firestore.instance
      .collection('likes')
      .document('${cat.documentId}:${this.firebaseUser.uid}')
      .delete();
  }

  Future<bool> hasLikedCat(Cat cat) async {
    final like = await Firestore.instance
      .collection('likes')
      .document('${cat.documentId}:${this.firebaseUser.uid}')
      .get();
    
    return like.exists;
  }
  
  Cat _fromDocumentSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data;
    print(snapshot.data.toString());
    return new Cat(
      documentId: snapshot.documentID,
      externalId: data['id'],
      name: data['name'],
      description: data['description'],
      avatarUrl: data['image_url'],
      location: data['location'],
      likeCounter: data['like_counter'],
      isAdopted: data['adopted'],
      pictures: new List<String>.from(data['pictures']),
      cattributes: new List<String>.from(data['cattributes'])
    );
  }

  // static Cat _forMap(Map<String, dynamic> map) {
  //   return new Cat(
  //     externalId: map['id'],
  //     name: map['name'],
  //     description: map['description'],
  //     avatarUrl: map['image_url'],
  //     location: map['location'],
  //     likeCounter: map['like_counter'],
  //     isAdopted: map['adopted'],
  //     pictures: new List<String>.from(map['pictures']),
  //     cattributes: new List<String>.from(map['cattributes'])
  //   );
  // }
}