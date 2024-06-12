import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart'as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../Api Services/api_end_points.dart';
import '../../Helper_Constants/colors.dart';
import '../Model/get_winning_history.dart';

class WinningList extends StatefulWidget {
  const WinningList({super.key});

  @override
  State<WinningList> createState() => _WinningListState();
}

class _WinningListState extends State<WinningList> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserId();
  }
  @override
  Widget build(BuildContext context) {
    // SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    return SafeArea(
      child: Scaffold(
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
              "Winning Numbers",
              style: TextStyle(fontSize: 17,color: colors.whiteTemp),
            ),
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10.0),
                  bottomRight: Radius.circular(10),
                ),
                gradient: LinearGradient(

                    colors: <Color>[colors.primary, colors.secondary]),
              ),
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height / 1.1,
                  child:getWinningHistoryModel?.data == null
                      ? const Center(child:  CircularProgressIndicator())
                      : getWinningHistoryModel?.data.length == 0
                      ? const Text("No Winning History..")
                      : ListView.builder(
                      shrinkWrap: true,
                      itemCount: getWinningHistoryModel?.data.length != null && getWinningHistoryModel!.data.length >= 10
                          ? 10
                          : getWinningHistoryModel?.data.length,
                      itemBuilder: (context, index) {
                        var winningList = getWinningHistoryModel?.data[index];
                        return  Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text("Winning Amount :"),
                                    Text("₹ ${winningList?.winningAmount}")
                                  ],
                                ),
                                const SizedBox(height: 3),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text("Bet Number :"),
                                    Text("${winningList?.betNumber}")
                                  ],
                                ),
                                const SizedBox(height: 3),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text("Bet Type :"),
                                    Text("${winningList?.betType}")
                                  ],
                                ),
                               
                              ],
                            ),
                          ),
                        );
                      }
                  ),

                )
              ],
            ),
          )),
    );
  }

  String? userId;

  getUserId() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    userId = preferences.getString("userId");
    getWinningHistory(context);

  }
  GetWinningHistoryModel? getWinningHistoryModel;
  Future<void> getWinningHistory(BuildContext context) async {
    var headers = {'Cookie': 'ci_session=c7797mp92d9k6gmq38epdr8hm70h9vab'};
    var request = http.MultipartRequest('POST',
        Uri.parse("${Endpoints.baseUrl}${Endpoints.getWinning}"));
    request.fields.addAll({
      'user_id': userId.toString(),
    });
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var result = await response.stream.bytesToString();
      var finalResult =
      GetWinningHistoryModel.fromJson(json.decode(result));
      if (finalResult.error == false) {
        setState(() {
          getWinningHistoryModel = finalResult;

        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${finalResult.message}')),
        );
      }
    } else {
      print(response.reasonPhrase);
    }
  }
}
