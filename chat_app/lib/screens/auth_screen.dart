import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

import '/widgets/auth/auth_form.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;
  var _isLoading = false;
  void _submitAuthForm(
    String email,
    String password,
    String userName,
    bool isLogin,
    File image,
  ) async {
    UserCredential authResult;
    try {
      setState(() {
        _isLoading = true;
      });
      if (isLogin) {
        authResult = await _auth.signInWithEmailAndPassword(
            email: email, password: password);
      } else {
        authResult = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
      }
      final ref = FirebaseStorage.instance
          .ref()
          .child('user_image')
          .child('${authResult.user!.uid}.jpg');
      await ref.putFile(image);
      final url = await ref.getDownloadURL();
      await FirebaseFirestore.instance
          .collection('user')
          .doc(authResult.user!.uid)
          .set({
        'username': userName,
        'email': email,
        'image_url': url,
      });
    } on PlatformException catch (e) {
      var messages = 'An error occurred, pelase check your credentials';
      if (e.message != null) {
        messages = e.message!;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(messages),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      print(e);
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body: AuthForm(
          submitFn: _submitAuthForm,
          isLoading: _isLoading,
        ));
  }
}
