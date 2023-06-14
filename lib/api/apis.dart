import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:major_project/data/Collections.dart';
import 'package:major_project/data/chat_user.dart';
import 'package:major_project/data/message.dart';

class APIs {
  static FirebaseAuth auth = FirebaseAuth.instance;
  static FirebaseFirestore firestore = FirebaseFirestore.instance;
  static FirebaseStorage storage = FirebaseStorage.instance;

  static User get user => auth.currentUser!;
  static late ChatUser me;
  static FirebaseMessaging fMessaging = FirebaseMessaging.instance;

  static Future<void> getFirebaseMessagingToken() async {
    await fMessaging.requestPermission();
    fMessaging.getToken().then((token) {
      if (token != null) {
        me.pushToken = token;

        log('Token: $token');
      }
    });
    // FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    //   log('Got a message whilst in the foreground!');
    //   log('Message data: ${message.data}');
    //
    //   if (message.notification != null) {
    //     log('Message also contained a notification: ${message.notification}');
    //   }
    //});


  }

  static Future<bool> userExists() async {
    return (await firestore
        .collection(CollectionsConst.userCollection)
        .doc(auth.currentUser!.uid)
        .get())
        .exists;
  }

  static Future<void> getSelfInfo() async {
    firestore
        .collection(CollectionsConst.userCollection)
        .doc(user.uid)
        .get()
        .then((user) async {
      if (user.exists) {
        me = ChatUser.fromJson(user.data()!);
        await getFirebaseMessagingToken();
        APIs.updateActiveStatus(true);
      } else {
        await createUser().then((value) => getSelfInfo());
      }
    });
  }

  static Future<void> createUser() async {
    final time = DateTime
        .now()
        .millisecondsSinceEpoch
        .toString();

    final chatUser = ChatUser(
        id: user.uid,
        image: user.photoURL!,
        about: 'Hey there! I am using ChatHub',
        name: user.displayName!,
        createdAt: time,
        isOnline: false,
        lastActive: time,
        email: user.email!,
        pushToken: ""
    );
    return await firestore
        .collection(CollectionsConst.userCollection)
        .doc(user.uid).set(chatUser.toJson());
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUsers() {
    return firestore
        .collection(CollectionsConst.userCollection)
        .where("id", isNotEqualTo: user.uid)
        .snapshots();
  }

  static Future<void> updateUserInfo() async {
    await firestore
        .collection(CollectionsConst.userCollection)
        .doc(user.uid).update(
        {
          'name': me.name,
          'about': me.about
        }
    );
  }

  static Future<void> updateProfilePicture(File file) async {
    final ext = file.path
        .split(".")
        .last;
    log('Extension :$ext');
    final ref = storage.ref().child(
        'profile_pictures/${DateTime.timestamp()}.$ext');

    await ref.putFile(file, SettableMetadata(contentType: 'image/$ext')).then((
        p0) {
      log("Data Transferred: ${p0.bytesTransferred / 1000}kb");
    });
    me.image = await ref.getDownloadURL();
    await firestore
        .collection(CollectionsConst.userCollection)
        .doc(user.uid).update(
        {
          'image': me.image,
        }
    );
  }

  static String getConversationID(String id) =>
      user.uid.hashCode <= id.hashCode
          ? '${user.uid}_$id'
          : '${id}_${user.uid}';

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllMessages(
      ChatUser user) {
    return firestore
        .collection('chats/${getConversationID(user.id)}/messages')
        .orderBy('sent', descending: true)
        .snapshots();
  }

  static Future<void> sendMessage(ChatUser chatUser, String msg,
      Type type) async {
    final time = DateTime
        .now()
        .millisecondsSinceEpoch
        .toString();

    final Message message = Message(
        toId: chatUser.id,
        msg: msg,
        read: '',
        type: type,
        fromId: user.uid,
        sent: time
    );

    final ref = firestore
        .collection('chats/${getConversationID(chatUser.id)}/messages');

    try {
      await ref.doc(time).set(message.toJson()).then((value) =>

          sendPushNotification(chatUser,type ==Type.text? msg:type==Type.image? "Image":"Video"));
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }


  static Future<void> updateMessageReadStatus(Message message) async {
    firestore
        .collection('chats/${getConversationID(message.fromId)}/messages')
        .doc(message.sent)
        .update(
        {
          'read': DateTime
              .now()
              .millisecondsSinceEpoch
              .toString()
        });
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getLastMessages(
      ChatUser user) {
    return firestore
        .collection('chats/${getConversationID(user.id)}/messages')
        .orderBy('sent', descending: true)
        .limit(1)
        .snapshots();
  }

  static Future<void> sendChatImage(ChatUser chatUser, File file) async {
    final ext = file.path
        .split(".")
        .last;

    final ref = storage.ref().child(
        'images/${getConversationID(chatUser.id)}/${DateTime
            .now()
            .millisecondsSinceEpoch}.$ext');

    await ref.putFile(file, SettableMetadata(contentType: 'image/$ext')).then((
        p0) {
      log("Data Transferred: ${p0.bytesTransferred / 1000}kb");
    });
    final imageUrl = await ref.getDownloadURL();
    await sendMessage(chatUser, imageUrl, Type.image);
  }

  static Future<void> sendChatVideo(ChatUser chatUser, File file) async {
    final ext = file.path
        .split(".")
        .last;

    final ref = storage.ref().child(
        'videos/${getConversationID(chatUser.id)}/${DateTime
            .now()
            .millisecondsSinceEpoch}.$ext');

    await ref.putFile(file, SettableMetadata(contentType: 'video/$ext')).then((
        p0) {
      log("Data Transferred: ${p0.bytesTransferred / 1000}kb");
    });
    final videoUrl = await ref.getDownloadURL();
    await sendMessage(chatUser, videoUrl, Type.video);
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getUserInfo(
      ChatUser chatUser) {
    return firestore
        .collection(CollectionsConst.userCollection)
        .where("id", isEqualTo: chatUser.id)
        .snapshots();
  }

  static Future<void> updateActiveStatus(bool isOnline) async {
    firestore
        .collection(CollectionsConst.userCollection)
        .doc(user.uid).update({
      'is_online': isOnline,
      'last_active': DateTime
          .now()
          .millisecondsSinceEpoch
          .toString(),
      'push_token': me.pushToken
    });
  }

  static Future<void> sendPushNotification(ChatUser chatUser,
      String msg) async {
    try {
      var url = Uri.parse('https://fcm.googleapis.com/fcm/send');
      const serverKey = 'AAAAICNjDAE:APA91bFCDk5do6IQVjbqYQj1TKTWOc5HycyrkU9sr4WL_GFhoC4jVf5AggOaNhFB-edoqDzlHeUjdAQdQ-lnYXPy0c_BI8SSHrQ31mfTILnNmishSGlsALNQYSqJcBSLwfwUHCvvfVb2';
      final body = {
        "to": chatUser.pushToken,
        "notification": {
          "title": me.name,
          "body": msg,
          "mutable_content":true,
          "sound":"Tri-tone",
          "android_channel_id": "chats",
          //icon

        },
        "data": {
          "click_action": "FLUTTER_NOTIFICATION_CLICK",
          "status": "done",
          "sound":"Tri-tone",
          "screen": "chat",
          "user": me.id,
          "image": me.image,
          "name": me.name,
          "about": me.about,
          "time": DateTime.now().toString(),
        }

      };

      var res = await post(
          url,
          headers: {
            HttpHeaders.contentTypeHeader: 'application/json',
            HttpHeaders.authorizationHeader: 'key=$serverKey '
          },
          body: jsonEncode(body)
      );
    } catch (e) {
      log(e.toString());
    }
  }
  static Future<void> deleteMessage(Message message) async {
    await firestore
        .collection('chats/${getConversationID(message.toId)}/messages')
        .doc(message.sent)
        .delete();

    if(message.type == Type.image || message.type == Type.video) {
      await storage.refFromURL(message.msg).delete();
    }
  }

  static Future<void> updateMessage(Message message, String msg) async {
    await firestore
        .collection('chats/${getConversationID(message.toId)}/messages')
        .doc(message.sent)
        .update({
      'msg': msg,
    });
  }
}