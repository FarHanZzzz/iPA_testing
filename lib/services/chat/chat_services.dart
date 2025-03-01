import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_chatt_app/models/message.dart';


class ChatService {


  // get instance of firestore & auth
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;



  /*
  List<Map<String,dynamic> =
  {
  'email' :test@gmail.com
  'id'  : .....
  }


  {
  'email' :t@gmail.com
  'id'  : .....
  }

  */




  Stream<List<Map<String, dynamic>>> getUsersStream() {
    // Get the current user's ID
    final String currentUserID = _auth.currentUser!.uid;

    return _firestore.collection("Users").snapshots().map((snapshot) {
      // Filter out the current user's profile
      return snapshot.docs
          .where((doc) => doc.id != currentUserID)  // Exclude the current user's profile
          .map((doc) {
        final user = doc.data();
        return user;
      }).toList();
    });
  }



  // send message

  Future<void> sendMessage(String receiverID , message) async{

    // get current user info
    final String currentUserID = _auth.currentUser!.uid;
    final String currentUserEmail = _auth.currentUser!.email!;
    final Timestamp timestamp = Timestamp.now();

    // create a new message
    Message newMessage = Message(
        senderID: currentUserID,
        senderEmail: currentUserEmail,
        receiverID: receiverID,
        message: message,
        timestamp: timestamp,

    );



    // construct chat room ID for the two users (sorted to ensure uniqueness)
    List<String> ids = [currentUserID, receiverID];
    ids.sort();// sort the ids (this ensure the chatroomID is the same for any 2 people)
    String chatRoomID = ids.join('_');

    // add new to message to database

    await _firestore
        .collection('chat_rooms')
        .doc(chatRoomID)
        .collection("messages")
        .add(newMessage.toMap());

  }


  // get messages

  Stream<QuerySnapshot<Map<String, dynamic>>> getMessages(String userID, String otherUserID) {
    // construct a chatroom ID for the two users
    List<String> ids = [userID, otherUserID];
    ids.sort();
    String chatRoomID =ids.join('_');

    return _firestore
        .collection('chat_rooms')
        .doc(chatRoomID)
        .collection("messages")
        .orderBy("timestamp",descending: false)
        .snapshots();

  }



}
