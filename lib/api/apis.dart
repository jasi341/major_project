import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:major_project/data/Collections.dart';
import 'package:major_project/data/chat_user.dart';
import 'package:major_project/data/message.dart';

class APIs{
  static  FirebaseAuth auth = FirebaseAuth.instance;
  static FirebaseFirestore firestore = FirebaseFirestore.instance;
  static FirebaseStorage storage = FirebaseStorage.instance;
  static User get user => auth.currentUser!;
  static late ChatUser me;

  static Future<bool> userExists()async{
    return (await firestore
        .collection(CollectionsConst.userCollection)
        .doc(auth.currentUser!.uid)
        .get())
        .exists;
  }

  static Future<void> getSelfInfo()async{
    firestore
        .collection(CollectionsConst.userCollection)
        .doc(user.uid)
        .get()
        .then((user)  async {
      if(user.exists){
        me = ChatUser.fromJson(user.data()!);
      }else{
        await createUser().then((value) => getSelfInfo());
      }
    });

  }

  static Future<void> createUser()async{

    final time = DateTime.now().millisecondsSinceEpoch.toString();

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

  static Stream<QuerySnapshot<Map<String, dynamic>>>  getAllUsers(){
    return firestore
        .collection(CollectionsConst.userCollection)
        .where("id",isNotEqualTo: user.uid)
        .snapshots();
  }

  static Future<void> updateUserInfo()async{
    await firestore
        .collection(CollectionsConst.userCollection)
        .doc(user.uid).update(
        {
          'name':me.name,
          'about':me.about
        }
    );
  }

  static Future<void> updateProfilePicture(File file)async{
    final ext = file.path.split(".").last;
    log('Extension :$ext');
    final ref = storage.ref().child('profile_pictures/${DateTime.timestamp()}.$ext');

    await ref.putFile(file,SettableMetadata(contentType:'image/$ext' )).then((p0){
      log("Data Transferred: ${p0.bytesTransferred/1000}kb");

    });
    me.image = await ref.getDownloadURL();
    await firestore
        .collection(CollectionsConst.userCollection)
        .doc(user.uid).update(
        {
          'image':me.image,
        }
    );

  }
  static String getConversationID (String id) =>user.uid.hashCode <= id.hashCode
      ? '${user.uid}_$id'
      :'${id}_${user.uid}';

  static Stream<QuerySnapshot<Map<String, dynamic>>>  getAllMessages(ChatUser user){
    return firestore
        .collection('chats/${getConversationID(user.id)}/messages')
        .orderBy('sent',descending: true)
        .snapshots();
  }

  static Future<void> sendMessage(ChatUser chatUser , String msg,Type type) async{

    final time = DateTime.now().millisecondsSinceEpoch.toString();

    final Message message = Message(
        toId: chatUser.id,
        msg: msg,
        read: '',
        type: type,
        fromId:user.uid ,
        sent: time
    );

    final ref = firestore
        .collection('chats/${getConversationID(chatUser.id)}/messages');

    await ref.doc(time).set(message.toJson());


  }

  static Future<void> updateMessageReadStatus(Message message) async{
    firestore
        .collection('chats/${getConversationID(message.fromId)}/messages')
        .doc(message.sent)
        .update(
        {
          'read':DateTime.now().millisecondsSinceEpoch.toString()
        });

  }

  static Stream<QuerySnapshot<Map<String, dynamic>>>  getLastMessages(ChatUser user){
    return firestore
        .collection('chats/${getConversationID(user.id)}/messages')
        .orderBy('sent',descending: true)
        .limit(1)
        .snapshots();
  }

  // static Future<void> sendChatVideo(ChatUser chatUser,File file){
  //
  // }

  static Future<void> sendChatImage(ChatUser chatUser,File file) async {

    final ext = file.path.split(".").last;

    final ref = storage.ref().child('images/${getConversationID(chatUser.id)}/${DateTime.now().millisecondsSinceEpoch}.$ext');

    await ref.putFile(file,SettableMetadata(contentType:'image/$ext' )).then((p0){
      log("Data Transferred: ${p0.bytesTransferred/1000}kb");

    });
    final imageUrl  = await ref.getDownloadURL();
    await sendMessage(chatUser, imageUrl, Type.image);

  }
  static Future<void> sendChatVideo(ChatUser chatUser,File file) async {

    final ext = file.path.split(".").last;

    final ref = storage.ref().child('videos/${getConversationID(chatUser.id)}/${DateTime.now().millisecondsSinceEpoch}.$ext');

    await ref.putFile(file,SettableMetadata(contentType:'video/$ext' )).then((p0){
      log("Data Transferred: ${p0.bytesTransferred/1000}kb");

    });
    final videoUrl  = await ref.getDownloadURL();
    await sendMessage(chatUser, videoUrl, Type.video);

  }
}