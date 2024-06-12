import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:roullet_app/Helper_Constants/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Api Services/api_end_points.dart';
import '../../Api Services/requests.dart';
import '../../Widgets/button.dart';
import '../Model/get_profile_model.dart';
import '../Model/get_withdrawal_history.dart';

class WithdrawalScreen extends StatefulWidget {
  WithdrawalScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<WithdrawalScreen> createState() => _WithdrawalScreenState();
}

class _WithdrawalScreenState extends State<WithdrawalScreen> {
  @override
  void initState() {
    super.initState();
    getUserId();
    _razorpay = Razorpay();
    _razorpay?.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay?.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay?.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay?.clear();
  }

  Razorpay? _razorpay;
  int? priceRazorpay;

  void openCheckout(amount) async {
    double res = double.parse(amount.toString());
    priceRazorpay = int.parse(res.toStringAsFixed(0)) * 100;

    print("checking razorpay price ${priceRazorpay.toString()}");
    var options = {
      'key': 'rzp_test_1DP5mmOlF5G5ag',
      'amount': "$priceRazorpay",
      'name': 'Roulette',
      'image': 'assets/splash/splashimages.png',
      'description': 'Roulette',
    };
    try {
      _razorpay?.open(options);
    } catch (e) {
      debugPrint('Error: e');
    }
  }

  Future<void> _handlePaymentSuccess(PaymentSuccessResponse response) async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Transaction Successfully')),
    );
    addWalletApi();
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Transaction Failed')),
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {}

  /// add wallet
  Future<void> addWalletApi() async {
    var headers = {'Cookie': 'ci_session=id9orgbsmngbt3rcho9dof18o1g8ipkv'};
    var request = http.MultipartRequest(
        'POST', Uri.parse('${Endpoints.baseUrl}${Endpoints.addWallet}'));
    request.fields.addAll({
      'user_id': userId.toString(),
      'transaction_id': 'rzp_test_1DP5mmOlF5G5ag',
      'amount': addAmountController.text,
      'status': '1'
    });
    print("this is a ===>${request.fields}");
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      var result = await response.stream.bytesToString();
      var finalResult = jsonDecode(result);
      if (finalResult['error'] == false) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${finalResult['message']}')),
        );
        getProfile();
        addAmountController.clear();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${finalResult['message']}')),
        );
      }
    } else {
      print(response.reasonPhrase);
    }
  }


  Future<void> sendWithdrawalRequestApi(BuildContext context) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    userId = preferences.getString("userId");

    var headers = {
      'Cookie': 'ci_session=c7797mp92d9k6gmq38epdr8hm70h9vab'
    };
    var request = http.MultipartRequest('POST', Uri.parse("${Endpoints.baseUrl}${Endpoints.sendWithdrawalRequest}"));
    request.fields.addAll({
      'user_id':userId.toString(),
      'amount':amountController.text,
      "accountNumber":accountNumberController.text ,
      "ifscCode": ifscController.text,
      "bankName":bankNameController.text,
      "account_holder_name":accountHolderNameController.text,

    });
    print(request.fields);
    print(request);
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var result  = await response.stream.bytesToString();
      var finalResult  = jsonDecode(result);
      if(finalResult['error']== false){
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${finalResult['message']}')),
        );
       ifscController.clear();
       amountController.clear();
       amountController.clear();
       bankNameController.clear();
       accountHolderNameController.clear();
       accountNumberController.clear();
        // Navigator.push(context, MaterialPageRoute(builder: (context)=>HomeScreen()));

      }else{
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${finalResult['message']}')),
        );
      }
    }
    else {
      print(response.reasonPhrase);
    }

  }

  /// get profile
  GetProfileModel? getProfileModel;

  Future<void> getProfile() async {
    var headers = {'Cookie': 'ci_session=3s8dqkgvv46gsrpbcm2b10qpegedlr5e'};
    var request = http.MultipartRequest(
        'POST', Uri.parse('${Endpoints.baseUrl}${Endpoints.getProfile}'));
    request.fields.addAll({'user_id': userId.toString()});
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      var result = await response.stream.bytesToString();
      var finalResult = GetProfileModel.fromJson(json.decode(result));
      setState(() {
        getProfileModel = finalResult;
      });
    } else {
      print(response.reasonPhrase);
    }
  }

  String? userId;

  getUserId() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    userId = preferences.getString("userId");
    getWithdrawalHistory(context);
    getProfile();
  }

  // withdrawal_history api
  GetWithdrowalResponseModel? getWithdrowalResponseModel;

  Future<void> getWithdrawalHistory(BuildContext context) async {
    var headers = {'Cookie': 'ci_session=c7797mp92d9k6gmq38epdr8hm70h9vab'};
    var request = http.MultipartRequest('POST',
        Uri.parse("${Endpoints.baseUrl}${Endpoints.withdrawalHistory}"));
    request.fields.addAll({
      'user_id': userId.toString(),
    });
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var result = await response.stream.bytesToString();
      var finalResult =
          GetWithdrowalResponseModel.fromJson(json.decode(result));
      if (finalResult.error == false) {
        getWithdrowalResponseModel = finalResult;
        print("this is ss${getWithdrowalResponseModel!.data.length}");
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${finalResult.message}')),
        );
      }
    } else {
      print(response.reasonPhrase);
    }
  }

  String selectedOption = "Add Amount";
  String selectedRequest = "Winning History";
  String selected = "Withdrawal";
  TextEditingController upiController = TextEditingController();
  TextEditingController accountNumberController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  TextEditingController ifscController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController addAmountController = TextEditingController();
  TextEditingController bankNameController = TextEditingController();
  TextEditingController accountHolderNameController = TextEditingController();
  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

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
            title: const Text(
              "Withdrawal",
              style: TextStyle(fontSize: 17),
            ),
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10.0),
                  bottomRight: Radius.circular(10),
                ),
                gradient: RadialGradient(
                    center: Alignment.center,
                    radius: 1.1,
                    colors: <Color>[colors.primary, colors.secondary]),
              ),
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                tabTop(),
                _currentIndex == 1 ? withdrawal() : withdrawalRequest()
              ],
            ),
          )),
    );
  }

  int _currentIndex = 1;

  int _currentIndexList = 1;

  tabTop() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: () {
                setState(() {
                  _currentIndex = 1;
                  // getNewListApi(1);
                });
              },
              child: Container(
                decoration: BoxDecoration(
                    color: _currentIndex == 1
                        ? colors.primary
                        : colors.secondary.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10)),
                height: 45,
                child: Center(
                  child: Text("Withdrawal",
                      style: TextStyle(
                          color: _currentIndex == 1
                              ? colors.whiteTemp
                              : colors.blackTemp,
                          fontSize: 18)),
                ),
              ),
            ),
          ),
          const SizedBox(
            width: 5,
          ),
          Expanded(
            child: InkWell(
              onTap: () {
                setState(() {
                  _currentIndex = 2;
                  // getTransactionApi();
                });
              },
              child: Container(
                decoration: BoxDecoration(
                    color: _currentIndex == 2
                        ? colors.primary
                        : colors.secondary.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10)),
                // width: 120,
                height: 45,
                child: Center(
                  child: Text(
                    "Withdrawal List",
                    style: TextStyle(
                        color: _currentIndex == 2
                            ? colors.whiteTemp
                            : colors.blackTemp,
                        fontSize: 18),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  withdrawal() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          showContent(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Row(
                      children: [
                        Radio(
                          value: 'Add Amount',
                          groupValue: selectedOption,
                          onChanged: (value) {
                            setState(() {
                              selectedOption = value.toString();
                            });
                          },
                        ),
                        const Text('Add Amount'),
                      ],
                    ),
                    const SizedBox(width: 20),
                    Row(
                      children: [
                        Radio(
                          value: 'Withdraw Request',
                          groupValue: selectedOption,
                          onChanged: (value) {
                            setState(() {
                              selectedOption = value.toString();
                            });
                          },
                        ),
                        const Text('Withdraw Request'),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20.0),
                if (selectedOption == 'Add Amount')
                  Column(
                    children: [
                      TextFormField(
                        keyboardType: TextInputType.number,
                        controller: addAmountController,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Enter Amount'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter amount';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                if (selectedOption == 'Withdraw Request')
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        keyboardType: TextInputType.number,
                        controller: amountController,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Enter Amount'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter amount';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        controller: accountHolderNameController,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Account Holder Name'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter account holder';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        controller: accountNumberController,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Enter Account Number'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter account number';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        controller: bankNameController,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Enter Bank Name'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter bank name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        controller: ifscController,
                        decoration: const InputDecoration(
                          hintText: 'Enter IFSC Code',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter IFSC Code';
                          }
                          return null;
                        },
                      ),

                      // Add more TextFormField widgets for other bank details here
                    ],
                  ),
                const SizedBox(height: 20.0),
                AppButton1(
                  title: isLoading
                      ? "Please wait.."
                      : selectedOption == "Add Amount"
                          ? 'Add Amount'
                          : "Submit Request",
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      if (selectedOption == 'Add Amount') {
                        openCheckout(addAmountController.text);
                      } else if (selectedOption == 'Withdraw Request') {
                        setState(() {
                          isLoading = true;
                        });
                        sendWithdrawalRequestApi(context).then((value){
                         setState(() {
                           isLoading = false;
                         });
                        }) ;
                        // ApiRequests apiRequests = ApiRequests();
                        // apiRequests
                        //     .sendWithdrawalRequest(
                        //         amountController.text,
                        //         accountHolderNameController.text,
                        //         accountNumberController.text,
                        //         bankNameController.text,
                        //         ifscController.text,
                        //         context)
                        //     .then((value) {
                        //   setState(() {
                        //     isLoading = false;
                        //   });
                        // });

                        //getWithdrawApi();
                      }
                    } else {
                      // Fluttertoast.showToast(msg: "All field are required");
                    }
                  },
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  historyList() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: () {
                setState(() {
                  _currentIndexList = 1;
                  // getNewListApi(1);
                });
              },
              child: Container(
                decoration: BoxDecoration(
                    color: _currentIndexList == 1
                        ? colors.secondary
                        : colors.secondary.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10)),
                height: 30,
                child: Center(
                  child: Text("Winning History",
                      style: TextStyle(
                          color: _currentIndex == 1
                              ? colors.whiteTemp
                              : colors.primary,
                          fontSize: 18,
                          fontWeight: FontWeight.bold)),
                ),
              ),
            ),
          ),
          const SizedBox(
            width: 5,
          ),
          Expanded(
            child: InkWell(
              onTap: () {
                setState(() {
                  _currentIndexList = 2;
                  // getTransactionApi();
                });
              },
              child: Container(
                decoration: BoxDecoration(
                    color: _currentIndexList == 2
                        ? colors.secondary
                        : colors.secondary.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10)),
                // width: 120,
                height: 30,
                child: Center(
                  child: Text(
                    "Withdrawal History",
                    style: TextStyle(
                        color: _currentIndex == 2
                            ? colors.whiteTemp
                            : colors.blackTemp,
                        fontSize: 18),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  withdrawalRequest() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              children: [
                Radio(
                  value: 'Winning History',
                  groupValue: selectedRequest,
                  onChanged: (value) {
                    setState(() {
                      selectedRequest = value.toString();
                    });
                  },
                ),
                const Text('Winning History'),
              ],
            ),
            const SizedBox(width: 20),
            Row(
              children: [
                Radio(
                  value: 'Withdraw History',
                  groupValue: selectedRequest,
                  onChanged: (value) {
                    setState(() {
                      getWithdrawalHistory(context);
                      selectedRequest = value.toString();
                    });
                  },
                ),
                const Text('Withdraw History'),
              ],
            ),
          ],
        ),
        selectedRequest == "Winning History"
            ? SizedBox(
                height: MediaQuery.of(context).size.height / 1.25,
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: 100,
                    itemBuilder: (context, index) {
                      return Card(
                        child: Column(
                          children: const [Text("Surendra")],
                        ),
                      );
                    }),
              )
            : SizedBox(
                height: MediaQuery.of(context).size.height / 1.30,
                child: ListView.builder(
                    shrinkWrap: true,
                    reverse: true,
                    itemCount: getWithdrowalResponseModel?.data.length,
                    itemBuilder: (context, index) {
                      var withdrowaList =
                          getWithdrowalResponseModel?.data[index];
                      return getWithdrowalResponseModel?.data == null
                          ? const CircularProgressIndicator()
                          : getWithdrowalResponseModel?.data.length == "0"
                              ? const Text("No Withdrawal History..")
                              : Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Text("Amount :"),
                                            Text("₹ ${withdrowaList?.amount}")
                                          ],
                                        ),
                                        const SizedBox(height: 3),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Text("Account Holder Name :"),
                                            Text(
                                                "${withdrowaList?.accountHolderName}")
                                          ],
                                        ),
                                        const SizedBox(height: 3),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Text("Bank Name :"),
                                            Text("${withdrowaList?.bankName}")
                                          ],
                                        ),
                                        const SizedBox(height: 3),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Text("Status :"),
                                            withdrowaList?.status == "0"
                                                ? const Text(
                                                    "Pending",
                                                    style: TextStyle(
                                                        color: Colors.yellow),
                                                  )
                                                : withdrowaList?.status == "1"
                                                    ? const Text("Aprooved",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.green))
                                                    : const Text("Reject",
                                                        style: TextStyle(
                                                            color: Colors.red))
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                    }),
              )
      ],
    );
  }

  StateSetter? dialogState;
  TextEditingController amtC = TextEditingController();
  TextEditingController msgC = TextEditingController();
  ScrollController controller = new ScrollController();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();

  showContent() {
    return SingleChildScrollView(
      controller: controller,
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Padding(
          padding: const EdgeInsets.only(top: 5.0, left: 5, right: 5),
          child: Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(
                        Icons.account_balance_wallet,
                        color: colors.primary,
                      ),
                      Text(
                        " " + 'Current Balance',
                        style: TextStyle(
                            color: colors.blackTemp,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
                    ],
                  ),
                  getProfileModel?.data.first.wallet == null
                      ? Text("Loading..")
                      : Text(
                          "₹ ${getProfileModel?.data.first.wallet}",
                          style: const TextStyle(
                              color: colors.blackTemp,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
