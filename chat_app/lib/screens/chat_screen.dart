import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('chats/2xIHKgTQ05k8GDNNjm4L/messages')
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> streamsnapshot) {
          if (streamsnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (streamsnapshot.data == null) {
            return const Center(child: CircularProgressIndicator());
          } else {
            final docs = streamsnapshot.data!.docs;
            return ListView.builder(
              itemCount: docs.length,
              itemBuilder: (context, index) => Container(
                padding: const EdgeInsets.all(10),
                child: Text(docs[index]['text']),
              ),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          FirebaseFirestore.instance
              .collection('chats/2xIHKgTQ05k8GDNNjm4L/messages')
              .add({
            'text': 'This was added by clicking the button',
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
