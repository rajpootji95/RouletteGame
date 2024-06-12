import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:roullet_app/Helper_Constants/colors.dart';

import '../../Api Services/requests.dart';
import '../../Helper_Constants/Images_path.dart';
import '../../audio_controller.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key, required this.audioController}) : super(key: key);
  final AudioController audioController;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    widget.audioController.dispose();
  }

  bool _passwordVisible = false;
  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
   // WidgetsFlutterBinding.ensureInitialized();

   // SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);

    // SystemChrome.setSystemUIOverlayStyle(
    //   const SystemUiOverlayStyle(
    //     statusBarColor: Colors.transparent,
    //   ),
    // );
    // SystemChrome.setEnabledSystemUIMode(
    //   SystemUiMode.manual,
    //   overlays: [SystemUiOverlay.bottom],
    // );
    Size size = MediaQuery.of(context).size;
    double h = size.height;
    double w = size.width;
    return PopScope(
      canPop: false,
      onPopInvoked: (val){
        showExitPopup(context);
      },
      child: Scaffold(
        body: Container(
            height: h,
            width: w,
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    colors.secondary,
                    colors.primary,
                    colors.secondary,
                  ],
                ),
                image: DecorationImage(
                    image: AssetImage(ImagesPath.backGroundImage),
                    fit: BoxFit.fill)),
            child: Row(
              children: [
                const SizedBox(width: 20),
                Container(

                  // width: 200,
                  // height: 200,
                  decoration: const BoxDecoration(boxShadow: [
                    BoxShadow
                      (blurRadius: 100,
                        color: colors.black54,
                        offset: Offset(-1, 20)
                    )

                  ]),
                  child: Image.asset(ImagesPath.animationGif,scale: 2,),
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.30,
                        height: 40,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: colors.whiteTemp,
                            boxShadow: const [
                              BoxShadow(
                                  color: colors.borderColorLight,
                                  spreadRadius: 1,
                                  blurRadius: 3)
                            ]),
                        child: TextFormField(
                          controller: _mobileController,
                          keyboardType: TextInputType.text,
                          decoration: const InputDecoration(
                              hintText: "Enter User Id",
                              hintStyle: TextStyle(fontSize: 12),
                              prefixIcon: Icon(
                                Icons.person_outline,
                                size: 20,
                              ),
                              counterText: "",
                              contentPadding: EdgeInsets.only(top: 2),
                              border: InputBorder.none),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.30,
                        height: 40,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: colors.whiteTemp,
                            boxShadow: const [
                              BoxShadow(
                                  color: colors.borderColorLight,
                                  spreadRadius: 1,
                                  blurRadius: 3)
                            ]),
                        child: TextFormField(
                          keyboardType: TextInputType.text,
                          controller: _passwordController,
                          obscureText: !_passwordVisible,
                          //This will obscure text dynamically
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Enter Password",
                            hintStyle: const TextStyle(fontSize: 12),
                            prefixIcon: const Icon(
                              Icons.lock_outlined,
                              size: 20,
                            ),
                            contentPadding: const EdgeInsets.only(bottom: 10),
                            suffixIcon: IconButton(
                              icon: Icon(
                                // Based on passwordVisible state choose the icon
                                _passwordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Theme.of(context).primaryColorDark,
                                size: 18,
                              ),
                              onPressed: () {
                                // Update the state i.e. toogle the state of passwordVisible variable
                                setState(() {
                                  _passwordVisible = !_passwordVisible;
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      InkWell(
                        onTap: () {
                          // ApiRequests apiRequests = ApiRequests();
                          // apiRequests.userLogin(_mobileController.text, _passwordController.text,context).then((value) {
                          //   setState(() {
                          //     isLoading = false;
                          //   });
                          // });
                          if (_mobileController.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Please Enter User Id')),
                            );
                          }  else if (_passwordController.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Please Enter password')),
                            );
                          } else {
                            setState(() {
                              isLoading = true;
                            });
                            ApiRequests apiRequests = ApiRequests();
                            apiRequests
                                .userLogin(_mobileController.text,
                                _passwordController.text, context,widget.audioController)
                                .then((value) {
                              setState(() {
                                isLoading = false;
                              });
                            });
                          }
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          elevation: 5,
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.30,
                            height: 40,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: colors.primary,
                                gradient: LinearGradient(colors: [
                                  colors.primary,
                                  colors.secondary.withOpacity(0.9),
                                  colors.primary,
                                ]),
                                boxShadow: const [
                                  BoxShadow(
                                      color: colors.borderColorLight,
                                      spreadRadius: 1,
                                      blurRadius: 5)
                                ]),
                            child: isLoading
                                ? const CupertinoActivityIndicator(
                              color: colors.whiteTemp,
                            )
                                : const Center(
                                child: Text(
                                  'Submit',
                                  style: TextStyle(
                                      color: colors.whiteTemp, fontSize: 16),
                                )),
                          ),
                        ),
                      ),
                      // Padding(
                      //   padding: const EdgeInsets.symmetric(vertical: 16.0),
                      //   child: ElevatedButton(
                      //
                      //     onPressed: () async {
                      //       ApiRequests apiRequests = ApiRequests();
                      //       apiRequests.userLogin(_mobileController.text, _passwordController.text,context).then((value) {
                      //         setState(() {
                      //           isLoading = false;
                      //         });
                      //       });
                      //        //  if(_mobileController.text.isEmpty){
                      //        //    ScaffoldMessenger.of(context).showSnackBar(
                      //        //      const SnackBar(content: Text('Please Enter mobile number')),
                      //        //    );
                      //        //  }
                      //        //  else if(_mobileController.text.length < 10){
                      //        //    ScaffoldMessenger.of(context).showSnackBar(
                      //        //      const SnackBar(content: Text('Please enter 10 digit number')),
                      //        //    );
                      //        //  }
                      //        //  else if(_passwordController.text.isEmpty){
                      //        //    ScaffoldMessenger.of(context).showSnackBar(
                      //        //      const SnackBar(content: Text('Please Enter password')),
                      //        //    );
                      //        //  }
                      //        // else{
                      //        //   setState(() {
                      //        //     isLoading = true;
                      //        //   });
                      //        //    ApiRequests apiRequests = ApiRequests();
                      //        //    apiRequests.userLogin(_mobileController.text, _passwordController.text,context).then((value) {
                      //        //      setState(() {
                      //        //        isLoading = false;
                      //        //      });
                      //        //    });
                      //        //
                      //        //  }
                      //
                      //     },
                      //
                      //     child:isLoading? const CupertinoActivityIndicator(color: colors.whiteTemp,)  :Text('Submit'),
                      //   ),
                      // ),
                    ],
                  ),
                )
              ],
            )),
      ),
    );;
  }
  Future<bool> showExitPopup(context) async {
    return await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: SizedBox(
              height: 90,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Do you want to exit?"),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            exit(0);
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: colors.whiteTemp),
                          child: const Text("Yes",
                              style: TextStyle(color: Colors.black)),
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: colors.primary,
                            ),
                            child: const Text("No",
                                style: TextStyle(color: Colors.white)),
                          ))
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }


}
