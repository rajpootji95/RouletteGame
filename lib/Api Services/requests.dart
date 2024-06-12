import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response;
import 'package:http/http.dart' as http;
import 'package:roullet_app/Api%20Services/api_end_points.dart';
import 'package:roullet_app/Helper_Constants/colors.dart';
import 'package:roullet_app/Screens/Home%20Screen/home_screen.dart';
import 'package:roullet_app/Screens/Splash/select_game_type.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Screens/Model/get_winning_history.dart';
import '../Screens/Model/get_withdrawal_history.dart';

class ApiRequests {
  final String baseUrl = Endpoints.baseUrl;
  final String login = Endpoints.login;
  final String placeBetRequest = Endpoints.placeBet;
  final String changePassword = Endpoints.changePasswordRequest;

  String? userId;
   ///show loader
  showLoader(context){
    showDialog(context: context,
        builder: (_){
          return Dialog(
            backgroundColor: Colors.transparent,
            child: SizedBox(
              child: const CupertinoActivityIndicator(
                color: colors.whiteTemp,
                radius: 20,
              ),
            ),
          );
        });

  }


  /// Get user data via email
  Future<void> getUser(String email) async {
    final response = await http.get(Uri.parse('$baseUrl/users/email/$email'));
    if (response.statusCode == 200) {
      // Handle successful response
      print(response.body);
    } else {
      // Handle error response
      print('Request failed with status: ${response.statusCode}.');
    }
  }

  /// login api
  Future<void> userLogin(
      String mobile, String password, BuildContext context,audioController) async {
    var headers = {'Cookie': 'ci_session=c7797mp92d9k6gmq38epdr8hm70h9vab'};
    var request = http.MultipartRequest('POST', Uri.parse("$baseUrl$login"));
    request.fields.addAll({'mobile': mobile, 'password': password});
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    debugPrint("status code : ${response.statusCode}");
    if (response.statusCode == 200) {

      var result = await response.stream.bytesToString();
      var finalResult = jsonDecode(result);
      if (finalResult['error'] == false) {
        SharedPreferences preferences = await SharedPreferences.getInstance();
        preferences.setBool("isLoggedIn", true);
        preferences.setString("userId", finalResult['data']['id'] ?? "");
        preferences.setString(
            "userName", finalResult['data']['username'] ?? "");
        preferences.setString("userEmail", finalResult['data']['email'] ?? "");
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(content: Text('${finalResult['message']}')),
        // );
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => SelectGame(audioController:audioController)));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${finalResult['message']}')),
        );
      }
    } else {
      print(response.reasonPhrase);
    }
  }

  /// change password api
  Future<void> changePasswordApi(String oldPassword, String newPassword,
      String confirmPassword, BuildContext context) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    userId = preferences.getString("userId");
    var headers = {'Cookie': 'ci_session=c7797mp92d9k6gmq38epdr8hm70h9vab'};
    var request =
        http.MultipartRequest('POST', Uri.parse("$baseUrl$changePassword"));
    request.fields.addAll({
      'user_id': userId.toString(),
      'old_password': oldPassword,
      'new_password': newPassword,
      'confirm_password': confirmPassword
    });
    print(request.fields);
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var result = await response.stream.bytesToString();
      var finalResult = jsonDecode(result);
      if (finalResult['error'] == false) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${finalResult['message']}')),
        );
        Navigator.pop(context);
        // Navigator.push(context, MaterialPageRoute(builder: (context)=>HomeScreen()));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${finalResult['message']}')),
        );
      }
    } else {
      print(response.reasonPhrase);
    }
  }

  /// place bet api
  Future<void> placeBetApi(

      int? amount, betType, number, BuildContext context) async {
    debugPrint("api called  => numbers : ${number}");
    SharedPreferences preferences = await SharedPreferences.getInstance();
    userId = preferences.getString("userId");

    var headers = {'Cookie': 'ci_session=c7797mp92d9k6gmq38epdr8hm70h9vab'};
    var request =
        http.MultipartRequest('POST', Uri.parse("$baseUrl$placeBetRequest"));
    request.fields.addAll({
      'user_id': userId.toString(),
      'bet_type_id': betType.toString(),
      'amount': amount.toString(),
      'number': number.join(','),

    });
    debugPrint(request.fields.toString());
     request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      debugPrint("api called response 200 => numbers : ${number}");
      var result = await response.stream.bytesToString();
      var finalResult = jsonDecode(result);
      if (finalResult['error'] == false){
        debugPrint(finalResult['message']);
      } else {

      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Something went wrong please try again!!')),
      );
      debugPrint(response.reasonPhrase);
    }
  }

  /// cancel bet api
  Future<void> cancelBetApi(
      String?type) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    userId = preferences.getString("userId");

    var headers = {'Cookie': 'ci_session=c7797mp92d9k6gmq38epdr8hm70h9vab'};
    var request =
        http.MultipartRequest('POST', Uri.parse("$baseUrl${Endpoints.cancelBet}"));
    request.fields.addAll({
      'user_id': userId??"",
      "type":type??""
    });
    debugPrint(request.fields.toString());
     request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var result = await response.stream.bytesToString();
      var finalResult = jsonDecode(result);
      debugPrint("cancel bet response: $finalResult");
    } else {
      debugPrint(response.reasonPhrase);
    }
  }

  /// add To Wallet Amount
  Future<(bool,String)> addToWalletAmountApi(BuildContext context) async {
    showLoader(context);
    SharedPreferences preferences = await SharedPreferences.getInstance();
    userId = preferences.getString("userId");

    var headers = {'Cookie': 'ci_session=c7797mp92d9k6gmq38epdr8hm70h9vab'};
    var request = http.MultipartRequest(
        'POST',
        Uri.parse("${Endpoints.baseUrl}${Endpoints.addToWalletAmount}"));
    request.fields.addAll({
      'user_id': userId.toString(),
    });
    debugPrint("this is a parameter--->${request.fields}");
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    (bool,String) errorMsg = (true,"");
    if (response.statusCode == 200) {
      Navigator.pop(context);
      var result = await response.stream.bytesToString();
      var finalResult = jsonDecode(result);
      errorMsg = (finalResult['error']??true,finalResult['message']??"");
      if (finalResult['error']??true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${finalResult['message']??"Something went wrong"}')),
        );
      }
    } else {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Something Went Wrong!!')),
      );
      debugPrint(response.reasonPhrase);
    }
   return errorMsg;
  }


/// last ten winner api
  Future<dynamic> getLastTenWinnerNumbersApi(BuildContext context) async {
    var headers = {'Cookie': 'ci_session=d32fl5jiqq17lamd73ho05s1kmri534r'};
    var request = http.MultipartRequest(
        'GET', Uri.parse("${Endpoints.baseUrl}${Endpoints.lastTenWinningNumbers}"));
    // request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    dynamic winnersData;
    if (response.statusCode == 200) {
      var result = await response.stream.bytesToString();
      var finalResult = jsonDecode(result);
      if (finalResult['error'] == false) {
        winnersData = finalResult['data'];
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Something wrong please logout and login again')),
        );
      }
    } else {
      debugPrint(response.reasonPhrase);
    }
    return winnersData;
  }

  /// get primary wallet Amount
  Future<String?> getPrimaryWalletAmountApi(BuildContext context) async {
    String? primaryWalletAmount;
    SharedPreferences preferences = await SharedPreferences.getInstance();
    userId = preferences.getString("userId");

    var headers = {'Cookie': 'ci_session=c7797mp92d9k6gmq38epdr8hm70h9vab'};
    var request = http.MultipartRequest(
        'POST',
        Uri.parse("${Endpoints.baseUrl}${Endpoints.getPrimaryWallet}"));
    request.fields.addAll({
      'user_id': userId.toString(),
    });
    debugPrint("this is a parameter--->${request.fields}");
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var result = await response.stream.bytesToString();
      var finalResult = jsonDecode(result);
      if (finalResult['error'] == false) {
        primaryWalletAmount = finalResult['data'];
        // Navigator.push(context, MaterialPageRoute(builder: (context)=>HomeScreen()));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${finalResult['message']}')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Something went wrong please login again!')),
      );
      debugPrint(response.reasonPhrase);
    }
    return primaryWalletAmount;
  }
// get user Data via email
  Future<Map<String, dynamic>?> checkPassword(String email) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/users/email/$email'));
      if (response.statusCode == 200) {
        // Handle successful response
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        return responseData;
      } else {
        // Handle error response
        debugPrint('Request failed with status: ${response.statusCode}.');
        return null;
      }
    } catch (e) {
      debugPrint('Error: $e');
      return null;
    }
  }

// get active user data via user id
  Future<Map<String, dynamic>?> checkUserActive(String userId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/users/active/$userId'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      if (response.statusCode == 200) {
        // Handle successful response
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        return responseData;
      } else {
        // Handle error response
        debugPrint('Request failed with status: ${response.statusCode}.');
        return null;
      }
    } catch (e) {
      debugPrint('Error: $e');
      return null;
    }
  }

// create active user via user id, last active date, last active time
  Future<bool> makeUserActive(
      String userId, String lastActiveDate, String lastActiveTime) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/users/active'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'user_id': userId,
          'last_active_date': lastActiveDate,
          'last_active_time': lastActiveTime,
        }),
      );
      if (response.statusCode == 201) {
        // Handle successful response
        debugPrint(response.body);
        return true;
      } else {
        debugPrint("object");
        // Handle error response
        debugPrint('Request failed with status: ${response.statusCode}.');
        return false;
      }
    } catch (e) {
      debugPrint('Error: $e');
      return false;
    }
  }

  // Update Active User via user id, last active date, last active time
  Future<bool> updateActiveUser(
      String userId, String lastActiveDate, String lastActiveTime) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/users/active/$userId'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'last_active_date': lastActiveDate,
          'last_active_time': lastActiveTime,
        }),
      );
      if (response.statusCode == 204) {
        // Handle successful response
        print(response.body);
        return true;
      } else {
        // Handle error response
        print('Request failed with status: ${response.statusCode}.');
        return false;
      }
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }

  // Delete Active User before logout
  Future<bool> deleteActiveUser(String userId) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/users/active/$userId'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      if (response.statusCode == 204) {
        // Handle successful response
        print(response.body);
        return true;
      } else {
        // Handle error response
        print('Request failed with status: ${response.statusCode}.');
        return false;
      }
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }

// create user dashboard via user id
  Future<bool> createUserDashboard(String userId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/users/dashboard'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'user_id': userId,
        }),
      );
      if (response.statusCode == 201) {
        // Handle successful response
        print(response.body);
        return true;
      } else {
        // Handle error response
        print('Request failed with status: ${response.statusCode}.');
        return false;
      }
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }

  Future<bool> addBalanceToUserDashboard(
      String userId, String depositAmount, String newUserBalance) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/users/dashboard/deposit/$userId'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'deposit_amount': depositAmount,
          'current_balance': newUserBalance,
        }),
      );
      if (response.statusCode == 204) {
        // Handle successful response
        print(response.body);

        return true;
      } else {
        // Handle error response
        print('Request failed with status: ${response.statusCode}.');
        return false;
      }
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }

  // Start new game via user id, move num, game status, last bet amount, last bet won lost
  Future<bool> startGame(String userId, String moveNum, String gameStatus,
      String last_bet_amount, String last_bet_won_lost) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/users/$userId/game'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'user_id': userId,
          'move_num': moveNum,
          'game_status': gameStatus,
          'last_bet_amount': last_bet_amount,
          'last_bet_won_lost': last_bet_won_lost,
        }),
      );
      if (response.statusCode == 201) {
        // Handle successful response
        print(response.body);
        return true;
      } else {
        // Handle error response
        print('Request failed with status: ${response.statusCode}.');
        return false;
      }
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }

  // Get game of user via user id
  Future<Map<String, dynamic>?> getGameOfUser(String userId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/users/$userId/game'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      if (response.statusCode == 200) {
        // Handle successful response
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        return responseData;
      } else {
        // Handle error response
        print('Request failed with status: ${response.statusCode}.');
        return null;
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  // Update a game via user id, move num, game status, last bet amount, last bet won lost
  Future<Map<String, dynamic>?> updateGame(
      String gameId,
      String userId,
      String gameStatus,
      String moveNum,
      String last_bet_amount,
      String last_bet_win_amount,
      String last_bet_won_lost) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/users/$userId/game'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'game_id': gameId,
          'user_id': userId,
          'game_status': gameStatus,
          'move_num': moveNum,
          'last_bet_amount': last_bet_amount,
          'last_bet_win_amount': last_bet_win_amount,
          'last_bet_won_lost': last_bet_won_lost,
        }),
      );
      if (response.statusCode == 201) {
        // Handle successful response
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        return responseData;
      } else {
        // Handle error response
        print('Request failed with status: ${response.statusCode}.');
        return null;
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  // Get number of games
  Future<Map<String, dynamic>?> getNumberOfGames() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/games/number'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      if (response.statusCode == 200) {
        // Handle successful response
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        return responseData;
      } else {
        // Handle error response
        print('Request failed with status: ${response.statusCode}.');
        return null;
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  // Update user balance
  Future<bool> updateUserBalance(String userId, String currentBalance) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/users/dashboard/balance/$userId'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{'current_balance': currentBalance}),
      );
      if (response.statusCode == 204) {
        // Handle successful response
        print(response.body);

        return true;
      } else {
        // Handle error response
        print('Request failed with status: ${response.statusCode}.');
        return false;
      }
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }

  // Check role of user
  Future<Map<String, dynamic>?> checkRole(String userId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/users/role/$userId'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      if (response.statusCode == 200) {
        // Handle successful response
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        return responseData;
      } else {
        // Handle error response
        print('Request failed with status: ${response.statusCode}.');
        return null;
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }
}
