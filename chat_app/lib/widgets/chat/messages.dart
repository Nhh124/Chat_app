import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Messages extends StatelessWidget {
  const Messages({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('chat').snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> chatsnapshot) {
        if (chatsnapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        final chatDocs = chatsnapshot.data!.docs;
        return ListView.builder(
          shrinkWrap: true,
          itemCount: chatDocs.length,
          itemBuilder: (context, index) => Text(chatDocs[index]['text']),
        );
      },
    );
  }
}
