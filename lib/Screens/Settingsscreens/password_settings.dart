import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:notrepad_free/LoginWithFirebase/login_Page.dart';
import 'package:notrepad_free/LoginWithFirebase/ui_helper.dart';

class passwordSettings extends StatefulWidget {
  const passwordSettings({super.key});

  @override
  State<passwordSettings> createState() => _passwordSettingsState();
}

class _passwordSettingsState extends State<passwordSettings> {
  /// Switch button onChnage value
  bool _showLock = false;
  bool _biometrics = false;

  /// to Track if second container is visible or hidden
  bool _isContainervisible = false;

  /// create controller for text field contoller
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  // void dispose() {
  //   // Dispose of the controllers when the widget is disposed
  //   _emailController.dispose();
  //   _passwordController.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Password settings'),
        // backgroundColor: Colors.brown,
      ),
      body: Column(
        children: [
          Column(
            children: [
              GestureDetector(
                onTap: () {
                  showDialog(
                      context: context,
                      barrierDismissible: false,

                      /// Prevent closing by tapping outside
                      builder: (BuildContext context) => AlertDialog(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(2)),
                            title: Text(
                              'Enter old password , new password and e-mail.',
                              style: TextStyle(
                                  fontSize: 14, color: Colors.blueGrey),
                            ),
                            content: Container(
                              height: MediaQuery.of(context).size.height / 4,
                              width: MediaQuery.of(context).size.width * 3,
                              child: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    uiHelper.CustomPasswordTextField(
                                        _oldPasswordController,
                                        "enter old password",
                                        true),
                                    uiHelper.CustomPasswordTextField(
                                        _newPasswordController,
                                        "enter new password",
                                        true),
                                    uiHelper.CustomPasswordTextField(
                                        _emailController,
                                        "enter e-mail",
                                        false),
                                  ],
                                ),
                              ),
                            ),
                            actionsPadding: EdgeInsets.only(bottom: 8),
                            actions: [
                              TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text('CANCEL')),

                              TextButton(
                                  onPressed: () async {
                                    String email=_emailController.text.trim();
                                    String oldpassword=_oldPasswordController.text.trim();
                                    String newpassword=_newPasswordController.text.trim();

                                    try {
                                      /// Re-authenticate user
                                      User? user = FirebaseAuth.instance.currentUser;
                                      AuthCredential? credential=EmailAuthProvider.credential(
                                          email: email, password: oldpassword);
                                      await user?.reauthenticateWithCredential(credential);
                                      ///change password
                                      await user?.updatePassword(newpassword);
                                      Navigator.push(context,MaterialPageRoute(builder: (context)=>loginPage()));
                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Password change successfully")));
                                    } on FirebaseAuthException  catch(e){
                                       showDialog(context: context, builder:(BuildContext context)=>AlertDialog(
                                         shape: RoundedRectangleBorder(
                                             borderRadius: BorderRadius.circular(2)),
                                         content: Text(e.code),
                                       ));
                                    }

                                  }, child: Text('OK')),
                            ],
                          ));
                },
                child: ListTile(
                  title: Text(
                    'Set password',
                    // style: TextStyle(color: Colors.black),
                  ),
                  subtitle: Text(
                    'Sets password needed to unlock the app',
                    //style: TextStyle(color: Colors.blueGrey),
                  ),
                ),
              ),
            ],
          ),
          if (!_isContainervisible)
            Visibility(
              visible: false,
              child: Container(
                // color: _isFormvalid ? Colors.transparent : Colors.blueGrey.withOpacity(0.3),
                /// container 2
                child: Column(
                  children: [
                    ListTile(
                      title: Text('Remove password'),
                      subtitle: Text(
                        'App will no longer require password to unlock',
                        //style: TextStyle(color: Colors.blueGrey),
                      ),
                    ),
                    ListTile(
                      title: Text('Unlock time'),
                      subtitle: Text(
                        'During this time the app would not ask for the password after unlocking the app',
                        // style: TextStyle(color: Colors.blueGrey),
                      ),
                    ),
                    SwitchListTile(
                      title: Text('Show lock app button'),
                      subtitle: Text(
                        'Shows the button for immediate app lock',
                        // style: TextStyle(color: Colors.blueGrey),
                      ),
                      onChanged: (bool value) {
                        setState(() {
                          _showLock = value;
                        });
                      },
                      value: _showLock,
                    ),
                    SwitchListTile(
                      title: Text('Use biometrics to unlock the app'),
                      subtitle: Text(
                        'Use biometrics check (e.g fingerprint, face detection), if available',
                        //style: TextStyle(color: Colors.blueGrey),
                      ),
                      value: _biometrics,
                      onChanged: (bool value) {
                        setState(() {
                          _biometrics = value;
                        });
                      },
                    ),

                  ],
                ),
              ),
            )
        ],
      ),
    );
  }
}
