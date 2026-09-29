import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:simple_ecommerce_app/models/user_model.dart';

class UserProvider with ChangeNotifier {
  UserModel? userModel;
  UserModel? get getUserModel => userModel;

  bool get isAdmin => userModel?.isAdmin ?? false;

  Future<UserModel?> fetchUserInfo() async {
    final auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    if (user == null) return null;
    String uid = user.uid;
    try {
      final userDoc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();

      final userDocDict = userDoc.data() as Map<String, dynamic>?;
      if (userDocDict == null) return null;

      userModel = UserModel(
        userId: userDoc.get('userId'),
        userName: userDoc.get('userName'),
        userImage: userDoc.get('userImage'),
        userEmail: userDoc.get('userEmail'),
        userCart:
            userDocDict.containsKey('userCart') ? userDoc.get('userCart') : [],
        userWish:
            userDocDict.containsKey('userWish') ? userDoc.get('userWish') : [],
        createdAt: userDoc.get('createdAt'),
        isAdmin: userDocDict.containsKey('isAdmin')
            ? (userDoc.get('isAdmin') as bool? ?? false)
            : false,
      );
      notifyListeners();
      return userModel;
    } on FirebaseException {
      rethrow;
    } catch (error) {
      rethrow;
    }
  }

  /// Refreshes admin status from Firestore (use after role changes).
  Future<bool> checkAdminStatus() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return false;
    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      final data = doc.data() as Map<String, dynamic>?;
      final admin = data?['isAdmin'] as bool? ?? false;
      if (userModel != null) {
        // Rebuild model with updated admin flag
        userModel = UserModel(
          userId: userModel!.userId,
          userName: userModel!.userName,
          userImage: userModel!.userImage,
          userEmail: userModel!.userEmail,
          userCart: userModel!.userCart,
          userWish: userModel!.userWish,
          createdAt: userModel!.createdAt,
          isAdmin: admin,
        );
        notifyListeners();
      }
      return admin;
    } catch (_) {
      return false;
    }
  }

  void clearUser() {
    userModel = null;
    notifyListeners();
  }
}