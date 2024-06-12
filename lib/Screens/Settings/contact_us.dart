import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart'as http;
import 'package:roullet_app/Api%20Services/api_end_points.dart';

import '../../Helper_Constants/colors.dart';

class ContactUs extends StatefulWidget {
  const ContactUs({super.key});

  @override
  State<ContactUs> createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    return Scaffold(
      appBar: AppBar(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(50.0),
            bottomRight: Radius.circular(50),
          ),
        ),
        toolbarHeight: 60,
        centerTitle: true,
        iconTheme:const  IconThemeData(
            color: colors.whiteTemp
        ),
        title: const Text(
          "Contact Us",
          style: TextStyle(fontSize: 17,color: colors.whiteTemp),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(10.0),
              bottomRight: Radius.circular(10),
            ),
            gradient:  LinearGradient(

                colors: <Color>[colors.primary, colors.secondary]),
          ),
        ),
      ),
      body: const SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children:  [

          ],
        ),
      ),
    );
  }
  void _sendEmail() async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'example@example.com',
      queryParameters: {
        'subject': 'Example Subject',
        'body': 'Hello! This is an example email.'
      },
    );

    // Check if the device can launch the URL
    // if (await canLaunch(emailLaunchUri.toString())) {
    //   await launch(emailLaunchUri.toString());
    // } else {
    //   throw 'Could not launch $emailLaunchUri';
    // }
  }
}
