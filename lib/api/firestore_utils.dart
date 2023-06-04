import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:major_project/api/apis.dart';
import 'package:major_project/data/Collections.dart';
import '../data/User.dart';

class FireStoreUtils {
  static Future<void> uploadUserInfo(UserDetails userDetails,String path) async {
    try {
      final userDocRef = FirebaseFirestore.instance.collection(path).doc(APIs.auth.currentUser!.uid);
      await userDocRef.set(userDetails.toMap());
      Fluttertoast.showToast(
          msg: 'Data saved successfully',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 2,
      );
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Error uploading user info: $e',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 2,
      );
    }
  }

  static Future<void> uploadLastSeenTime(UserDetails userDetails, String lastSeenTime) async {
    try {
      final userDocRef = FirebaseFirestore.instance.collection(CollectionsConst.userCollection).doc(userDetails.email);
      await userDocRef.update({'lastSeen': lastSeenTime});
      print('Last seen time uploaded successfully');
    } catch (e) {
      print('Error uploading last seen time: $e');
    }
  }





}



