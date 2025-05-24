import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:notrepad_free/LoginWithFirebase/login_Page.dart';
import 'package:notrepad_free/Screens/Settingsscreens/note_editing.dart';
import 'package:notrepad_free/Screens/Settingsscreens/note_list.dart';
import 'package:notrepad_free/Screens/Settingsscreens/password_settings.dart';
import 'package:notrepad_free/Screens/Settingsscreens/privacy_settings.dart';


import 'package:notrepad_free/provider/theme_provider.dart';

import 'package:provider/provider.dart';


class mainSetting extends StatefulWidget {
  mainSetting({super.key});

  @override
  State<mainSetting> createState() => _mainSettingState();
}

class _mainSettingState extends State<mainSetting> {


  bool _isDeleted = false;
  bool _isAttach = false;
  bool _isHide = false;
  bool _isDevbackup = false;

  @override
  Widget build(BuildContext context) {
 final _isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // // Get the current theme from the ThemeProvider
    // final themeIndex = context.watch<ThemeProvider>().themeIndex;
    //
    // // Define colors for each theme index
    // Color radioTileColor = _getRadioColor(themeIndex);

    return Scaffold(
        appBar: AppBar(
          title: Text('Settings'),
        ),
        body: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return Center(
                                child: Container(

                                  height: MediaQuery.of(context).size.height / 1.70,
                                  child: AlertDialog(

                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                    scrollable: true,
                                    contentPadding: EdgeInsets.zero,

                                    title: Text('Theme',
                                       style: TextStyle(color: _isDarkMode ? Colors.white : Colors.black),
                                    ),
                                    content:  Container(
                                      width: MediaQuery.of(context).size.width / 1,
                                      child: StatefulBuilder(
                                        builder: (BuildContext context,
                                            StateSetter setState) {
                                          return Column(
                                            children: [

                                              RadioListTile(

                                                title: Text('Light'),
                                                  value: 1,
                                                  groupValue:context.watch<ThemeProvider>().themeIndex,
                                                  onChanged: (int? value){
                                                  context.read<ThemeProvider>().setTheme(value!);
                                                  },
                                                activeColor: Colors.green,
                                                  ),Visibility(
                                                visible:false,
                                                    child: RadioListTile(
                                                    title: Text('Solarized'),
                                                    value: 2,
                                                    groupValue: context.watch<ThemeProvider>().themeIndex,
                                                    onChanged: (int? value){
                                                      context.read<ThemeProvider>().setTheme(value!);
                                                    },


                                                    ),
                                                  ),
                                              RadioListTile(
                                                  title: Text('Dark'),
                                                  value: 3,
                                                  groupValue: context.watch<ThemeProvider>().themeIndex,
                                                  onChanged: (int? value){
                                                    context.read<ThemeProvider>().setTheme(value!);
                                                  },
                                                ),
                                              RadioListTile(
                                                  title: Text('White'),
                                                  value: 4,
                                                  groupValue: context.watch<ThemeProvider>().themeIndex,
                                                  onChanged: (int? value){
                                                    context.read<ThemeProvider>().setTheme(value!);
                                                  },

                                                  ),
                                              Visibility(
                                                visible:false,
                                                child: RadioListTile(
                                                    title: Text('Solarized Dark'),
                                                    value:5,
                                                    groupValue: context.watch<ThemeProvider>().themeIndex,
                                                    onChanged: (int? value){
                                                      context.read<ThemeProvider>().setTheme(value!);
                                                    },
                                                  activeColor: const Color(0xFF87CFFB),
                                                    ),
                                              ),
                                              RadioListTile(
                                                  title: Text('System'),
                                                  value: 6,
                                                  groupValue: context.watch<ThemeProvider>().themeIndex,
                                                  onChanged: (int? value){
                                                 context.read<ThemeProvider>().setTheme(value!);
                                                  },
                                                activeColor: const Color(0xFF004C6A),
                                                ),

                                            ],
                                          );
                                        },
                                      ),
                                    ),
                                    actions: [
                                      TextButton(onPressed: () {
                                        Navigator.pop(context);
                                      },
                                          child:Builder(
                              builder: (context) {
                                Color buttonColor;

                                if (context.watch<ThemeProvider>().themeIndex==1) {
                                  buttonColor = Colors.green; // Dark theme - red color for "CANCEL"
                                } else if(context.watch<ThemeProvider>().themeIndex==2){
                                  buttonColor=Colors.blue;
                                } else if (context.watch<ThemeProvider>().themeIndex == 3) {
                                  // Dark Theme
                                  buttonColor = Colors.purple.shade100;
                                } else if (context.watch<ThemeProvider>().themeIndex == 4) {
                                  // White Theme
                                  buttonColor = Colors.purple;
                                } else if (context.watch<ThemeProvider>().themeIndex == 5) {
                                  // Solarized Dark Theme
                                  buttonColor = const Color(0xFF87CFFB);
                                } else if (context.watch<ThemeProvider>().themeIndex == 6) {
                                  // System Theme
                                  buttonColor = const Color(0xFF004C6A);
                                } else {
                                  // Default case if no theme is selected
                                  buttonColor = Colors.grey;
                                }


                                return Text(
                                    'CANCEL',
                                    style: TextStyle(
                                      color: buttonColor,
                                    ));
                              }))],

                                  ),
                                ),
                              );
                            });
                      },
                      child: ListTile(

                          title: Text('Theme'),
                          subtitle: Text(
                              'Changes color theme of visible elements')
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18.0),
                      child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                                MaterialPageRoute(builder: (context) =>
                                    passwordSettings()));
                          },
                          child: Text('Password settings',
                          // style: TextStyle(color: Colors.black,)
                            )),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      child: InkWell(
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) =>
                                    note_List()));
                          },

                          child: Visibility(
                            visible: false,
                            child: Text('Note list',
                                                     //   style: TextStyle(color: Colors.black),
                            ),
                          )),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: GestureDetector(
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) =>
                                    note_Editing()));
                          },
                          child: Visibility(
                            visible: false,
                            child: Text('Note editing',
                            //  style: TextStyle(color: Colors.black),
                            ),
                          )),
                    ),

                    Visibility(
                      visible: false,
                      child: SwitchListTile(
                        title: Text('Move deleted notes to "Trash"',
                         // style: TextStyle(color: Colors.black),
                        ),
                        subtitle: Text(
                            'deleted notes will be attaced to e-mail message'),


                        activeColor: Colors.blue,
                        inactiveThumbColor: Colors.white,
                        value: _isDeleted,
                        onChanged: (bool value) {
                          setState(() {
                            _isDeleted = value;
                          });
                        },
                      ),
                    ),


                    Visibility(
                      visible: false,
                      child: SwitchListTile(
                        title: Text('Attach diagnostic info',
                          //style: TextStyle(color: Colors.black),
                        ),
                        subtitle: Text(
                            'Diagnostic info will be attached top e-mail messages'),

                        activeColor: Colors.blue,
                        inactiveThumbColor: Colors.white,
                        value: _isAttach,
                        onChanged: (bool value) {
                          setState(() {
                            _isAttach = value;
                          });
                        },
                      ),
                    ),

                    Visibility(
                      visible: false,
                      child: SwitchListTile(
                        title: Text('Hide note titles in diagnostic log ',
                        //  style: TextStyle(color: Colors.black),
                        ),
                        subtitle: Text(
                            'Hides note titlesin diagnostic info before sending it to the technicalsupport'),

                        activeColor: Colors.blue,
                        inactiveThumbColor: Colors.white,
                        value: _isHide,
                        onChanged: (bool value) {
                          setState(() {
                            _isHide = value;
                          });
                        },
                      ),
                    ),
                    Visibility(
                      visible: false,
                      child: SwitchListTile(
                        title: Text('Use the device backup',
                         // style: TextStyle(color: Colors.black),
                        ),
                        subtitle: Text(
                            'The device can save notes in its backup copy.Important: please read the "Help" section to get more information '),

                        activeColor: Colors.blue,
                        inactiveThumbColor: Colors.white,
                        value: _isDevbackup,
                        onChanged: (bool value) {
                          setState(() {
                            _isDevbackup = value;
                          });
                        },
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18.0),
                        child: GestureDetector(onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) =>
                                  privacySettings()));
                        },
                            child: Text('Privacy settings',
                               // style: TextStyle(color: Colors.black, fontSize: 16),
                            ),
                        )),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: TextButton(onPressed: ()async{
                        await FirebaseAuth.instance.signOut();
                        Navigator.pushAndRemoveUntil(context,MaterialPageRoute(builder: (context)=>loginPage()), (route) => false);
                      }, child:Text("LogOut")),
                    ),

                  ],
                ),


        ));
  }
// Helper function to get the active color based on the theme index
//   Color _getRadioColor(int themeIndex) {
//     switch (themeIndex) {
//       case 2:  // Solarized
//         return Colors.blue;
//       case 3:  // Dark
//         return Colors.red;
//       case 4:  // White
//         return Colors.green;
//       case 5:  // Solarized Dark
//         return Colors.orange;
//       case 6:  // System
//         return Colors.purple;
//       default: // Light
//         return Colors.blue;
//     }
//   }

}
