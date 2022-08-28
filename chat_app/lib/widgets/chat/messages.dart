import '/widgets/chat/messages_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Messages extends StatelessWidget {
  const Messages({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future<User>.value(FirebaseAuth.instance.currentUser),
      builder: (context, AsyncSnapshot<User> usersnapshot) {
        if (usersnapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        final user = FirebaseAuth.instance.currentUser;
        return StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('chat')
              .orderBy('createAt', descending: true)
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> chatsnapshot) {
            if (chatsnapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            final chatDocs = chatsnapshot.data!.docs;
            return ListView.builder(
              shrinkWrap: true,
              reverse: true,
              itemCount: chatDocs.length,
              itemBuilder: (context, index) => MessageBubble(
                message: chatDocs[index]['text'],
                userName: chatDocs[index]['username'],
                userImage: chatDocs[index]['userImage'],
                isMe: chatDocs[index]['userId'] == user!.uid,
                key: ValueKey(chatDocs[index].id),
              ),
            );
          },
        );
      },
    );
  }
}
