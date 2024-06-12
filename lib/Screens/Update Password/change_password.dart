import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../Api Services/requests.dart';
import '../../Helper_Constants/colors.dart';
import '../../Widgets/button.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  bool _oldPasswordVisible = false;
  bool _newPasswordVisible = false;
  bool _confirmPasswordVisible = false;

  final _oldPassC = TextEditingController();
  final _newPassC = TextEditingController();
  final _confirmPassC = TextEditingController();
  bool isLoading = false;

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
          "Change Password",
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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 200),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
            const SizedBox(height: 20),
            TextFormField(
              keyboardType: TextInputType.text,
              controller: _oldPassC,
              obscureText: !_oldPasswordVisible,
              //This will obscure text dynamically
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                hintText: "Old Password",
                hintStyle: const TextStyle(fontSize: 12),
                prefixIcon: const Icon(
                  Icons.lock_outlined,
                  size: 20,
                ),
                contentPadding: const EdgeInsets.only(top: 5),
                suffixIcon: IconButton(
                  icon: Icon(
                    // Based on passwordVisible state choose the icon
                    _oldPasswordVisible ? Icons.visibility : Icons.visibility_off,
                    color: Theme.of(context).primaryColorDark, size: 18,
                  ),
                  onPressed: () {
                    // Update the state i.e. toogle the state of passwordVisible variable
                    setState(() {
                      _oldPasswordVisible = !_oldPasswordVisible;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              keyboardType: TextInputType.text,
              controller: _newPassC,
              obscureText: !_newPasswordVisible,
              //This will obscure text dynamically
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                hintText: "New Password",
                hintStyle: const TextStyle(fontSize: 12),
                prefixIcon: const Icon(
                  Icons.lock_outlined,
                  size: 20,
                ),
                contentPadding: const EdgeInsets.only(top: 5),
                suffixIcon: IconButton(
                  icon: Icon(
                    // Based on passwordVisible state choose the icon
                    _newPasswordVisible ? Icons.visibility : Icons.visibility_off,
                    color: Theme.of(context).primaryColorDark, size: 18,
                  ),
                  onPressed: () {
                    // Update the state i.e. toogle the state of passwordVisible variable
                    setState(() {
                      _newPasswordVisible = !_newPasswordVisible;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              keyboardType: TextInputType.text,
              controller: _confirmPassC,
              obscureText: !_confirmPasswordVisible,
              //This will obscure text dynamically
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                hintText: "Confirm Password",
                hintStyle: const TextStyle(fontSize: 12),
                prefixIcon: const Icon(
                  Icons.lock_outlined,
                  size: 20,
                ),
                contentPadding: const EdgeInsets.only(top: 5),
                suffixIcon: IconButton(
                  icon: Icon(
                    // Based on passwordVisible state choose the icon
                    _confirmPasswordVisible
                        ? Icons.visibility
                        : Icons.visibility_off,
                    color: Theme.of(context).primaryColorDark, size: 18,
                  ),
                  onPressed: () {
                    // Update the state i.e. toogle the state of passwordVisible variable
                    setState(() {
                      _confirmPasswordVisible = !_confirmPasswordVisible;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),
            AppButton1(
              title: isLoading ? "Please wait.." : "Update Password",
              onTap: () {
                if (_oldPassC.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please Enter old password')),
                  );
                } else if (_oldPassC.text.length < 8) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please enter 8 digit number')),
                  );
                } else if (_newPassC.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please Enter new password')),
                  );
                } else if (_newPassC.text.length < 8) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please enter 8 digit number')),
                  );
                } else if (_confirmPassC.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Please Enter Confirm password')),
                  );
                } else if (_confirmPassC.text.length < 8) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please enter 8 digit number')),
                  );
                } else {
                  setState(() {
                    isLoading = true;
                  });
                  ApiRequests apiRequests = ApiRequests();
                  apiRequests
                      .changePasswordApi(_oldPassC.text, _newPassC.text,
                          _confirmPassC.text, context)
                      .then((value) {
                    setState(() {
                      isLoading = false;
                    });
                  });
                }
              },
            )
          ]),
        ),
      ),
    );
  }
}
