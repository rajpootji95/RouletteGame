import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart'as http;

import '../../Api Services/api_end_points.dart';
import '../../Helper_Constants/colors.dart';

class TermAndCondition extends StatefulWidget {
  const TermAndCondition({super.key});

  @override
  State<TermAndCondition> createState() => _TermAndConditionState();
}

class _TermAndConditionState extends State<TermAndCondition> {
  void initState() {
    // TODO: implement initState
    super.initState();
    getTermAndConditionApi();
  }
  String? termAndConditionData;
  Future<void>getTermAndConditionApi()async {
    var headers = {
      'Cookie': 'ci_session=rrit0el7bnv2ulfrrrrev8ktq5pl48ak'
    };
    var request = http.MultipartRequest('POST', Uri.parse('${Endpoints.baseUrl}${Endpoints.getTermsConditions}'));
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      var result  = await response.stream.bytesToString();
      var finalResult = jsonDecode(result);
      setState(() {
        termAndConditionData = finalResult['data']['description'];
      });
    }
    else {
      if (kDebugMode) {
        print(response.reasonPhrase);
      }
    }

  }
  @override
  Widget build(BuildContext context) {
    // SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

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
          "Terms & Conditions",
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
      body: ListView(
        children: [
          Center(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child:termAndConditionData == null? const Center(child: CupertinoActivityIndicator(color: colors.primary,)): termAndConditionData == ""? const Center(child: Text("No Data Found!!")): Text("$termAndConditionData", textAlign: TextAlign.justify,style: const TextStyle(),),
              )
          )
        ],
      ),
    );
  }
}
