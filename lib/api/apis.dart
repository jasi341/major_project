import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:major_project/data/Collections.dart';
import 'package:major_project/data/chat_user.dart';

class APIs{
  static  FirebaseAuth auth = FirebaseAuth.instance;
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

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
        id: user!.uid!,
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
    return firestore.collection(CollectionsConst.userCollection).where("id",isNotEqualTo: user.uid).snapshots();
  }
}