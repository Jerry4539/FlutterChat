import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutterchat/api/apis.dart';
import 'package:flutterchat/helper/dialogs.dart';
import 'package:flutterchat/main.dart';
import 'package:flutterchat/models/chat_user.dart';

class SecurityScreen extends StatefulWidget {
  final ChatUser user;
  const SecurityScreen({super.key, required this.user});

  @override
  State<SecurityScreen> createState() => _SecurityScreenState();
}

class _SecurityScreenState extends State<SecurityScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _image;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // for hiding keyboard
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        //app bar
          appBar: AppBar(title: const Text('Security Screen'),
            actions: [
              Padding(
                padding: const EdgeInsets.only(top: 0, right: 10),
                child: IconButton(onPressed: () {},
                    icon: const Icon(Icons.lock, color: Colors.blueAccent,)),
              ),
            ],),

          //floating button to log out

          //body
          body: Form(
            key: _formKey,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: mq.width * .05),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // for adding some space
                    SizedBox(width: mq.width, height: mq.height * .03),

                    //user profile picture
                    Stack(
                      children: [
                        //profile picture
                        _image != null
                            ?

                        //local image
                        ClipRRect(
                            borderRadius:
                            BorderRadius.circular(mq.height * .1),
                            child: Image.file(File(_image!),
                                width: mq.height * .2,
                                height: mq.height * .2,
                                fit: BoxFit.cover))
                            :

                        //image from server
                        ClipRRect(
                          borderRadius:
                          BorderRadius.circular(mq.height * .1),
                          child: CachedNetworkImage(
                            width: mq.height * .2,
                            height: mq.height * .2,
                            fit: BoxFit.cover,
                            imageUrl: widget.user.image,
                            errorWidget: (context, url, error) =>
                            const CircleAvatar(
                                child: Icon(Icons.person_3_rounded)),
                          ),
                        ),

                        //edit image button
                      ],
                    ),

                    // for adding some space
                    SizedBox(height: mq.height * .03),

                    // user email label
                    Text(widget.user.email,
                        style: const TextStyle(
                            color: Colors.black54, fontSize: 16)),

                    // for adding some space
                    SizedBox(height: mq.height * .05),

                    // name input field
                    TextFormField(
                      initialValue: widget.user.security,
                      onSaved: (val) => APIs.me.security = val ?? '1234',
                      validator: (val) =>
                      val != null && val.isNotEmpty
                          ? null
                          : 'Required Field',
                      decoration: InputDecoration(
                          prefixIcon:
                          const Icon(
                              Icons.lock_reset, color: Colors.blue),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12)),
                          hintText: 'eg. 1234',
                          label: const Text('Security Password')),
                    ),

                    // for adding some space
                    SizedBox(height: mq.height * .05),
                    // update profile button
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                          shape: const StadiumBorder(),
                          minimumSize: Size(mq.width * .4, mq.height * .06)),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          APIs.updateUserSecurity().then((value) {
                            Dialogs.showSnackbar(
                                context, 'Security Password Updated!..🔐👍');
                          });
                        }
                      },
                      icon: const Icon(Icons.lock_outline, size: 28),
                      label:
                      const Text('Secure', style: TextStyle(fontSize: 16)),
                    )
                  ],
                ),
              ),
            ),
          )),
    );
  }
}
