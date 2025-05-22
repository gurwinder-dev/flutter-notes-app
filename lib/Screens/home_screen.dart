import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:notrepad_free/DBHelper.dart';
import 'package:notrepad_free/Screens/AddNotes.dart';
import 'package:notrepad_free/Screens/Edit_categories.dart';
import 'package:notrepad_free/Screens/Settingsscreens/setting.dart';
import 'package:notrepad_free/Screens/backup.dart';
import 'package:notrepad_free/Screens/help.dart';
import 'package:notrepad_free/Screens/privacy_policy.dart';

import 'package:notrepad_free/Screens/trash.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';



class HomePage extends StatefulWidget {
  HomePage({super.key,});


// final DBHelper note;
  bool isSearching=false;


  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
/// for selection purpose
  Set<int> selectedNoteIds = {}; // To track selected notes by ID (s_no or whatever)
  bool isSelectionMode = false; // Toggle selection mode

  bool isRefresh = false;

  /// List to hold notes
  List<Map<String, dynamic>> allNotes = [];
  late Future<List<Map<String, dynamic>>> futureNotes;
  TextEditingController searchController = TextEditingController();
  String search = '';
  late Future<List<Map<String, dynamic>>> notesFuture;

  Future<List<Map<String, dynamic>>> fetchNotes() async {
    final db = DBHelper.getInstance;
    List<Note> noteList;

    switch (selectedSort) {
      case 'title_az':
        noteList = await db.getNotesSortedByTitleAZ();
        break;
      case 'title_za':
        noteList = await db.getNotesSortedByTitleZA();
        break;
      case 'date_newest':
        noteList = await db.getNotesSortedByDateNewest();
        break;
      case 'date_oldest':
        noteList = await db.getNotesSortedByOldest();
        break;
      default:
        noteList = await db.getNotesSortedByDateNewest();
        break;
    }

    // Convert Note objects to Map<String, dynamic>
    return noteList.map((note) => note.toMap()).toList();
  }

  List<Note> notes = []; // This is the missing piece
  @override
  void initState() {
    super.initState();
       notesFuture = fetchNotes();  // Use this in FutureBuilder

  }

  void onSortChanged(String newSort) {
    setState(() {
      selectedSort = newSort;
      notesFuture = fetchNotes();  // Refresh the future
    });
  }


  @override
  Widget build(BuildContext context) {
    final darkMode = Theme
        .of(context)
        .brightness == Brightness.dark;

    final GlobalKey more = GlobalKey();


    /// Fetch notes from the database
    Future<void> getNotes() async {
      /// It gets an instance of your database helper.
      DBHelper dbHelper = await DBHelper.getInstance;

      ///It fetches all notes from the database.
      var notes = await dbHelper.getAllNotes();

      ///It returns them as a list of maps.
      setState(() {
        allNotes = notes;
      });
    }
    PreferredSizeWidget _defualtAppBar(){
      return AppBar(

        title: isSearching ? TextField(
          controller: searchController,
          style: TextStyle(color: Colors.white),
          cursorColor: Colors.white,
          decoration: InputDecoration(
              hintText: 'Search notes....',
              hintStyle: TextStyle(color: Colors.grey),
              border: OutlineInputBorder(
                  borderSide: BorderSide.none
              )
          ),
          onChanged: (String? value) {
            print(value);
            setState(() {
              search = value.toString();
            });
          },

        ) : Text('Notes'),
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  isSearching = !isSearching;
                  if (!isSearching) {
                    searchController.clear();
                    // filteredNotes=allNotes; // Reset to full list
                  }
                });
                // showSearch(context: context, delegate: Search());

              },
              icon: isSearching ? Icon(Icons.close) : Icon(Icons.search,)),
          TextButton(
              onPressed: () {
                showAlertDialog();
              },
              child: Text(
                'SORT',
                style: TextStyle(
                    color: darkMode ? Colors.black : Colors.white,
                    fontSize: 16),
              )),
          InkWell(
            onTap: () {
              dynamic state = more.currentState;
              state.showButtonMenu();
            },
            child: PopupMenuButton(
              color: Colors.white,
              key: more,
              itemBuilder: (_) =>
              const <PopupMenuItem<int>>[
                PopupMenuItem(
                  child: Text('Select all notes'),
                  value: 1,
                ),
                PopupMenuItem(
                  child: Text('Import text files'),
                  value: 2,
                ),
                PopupMenuItem(
                  child: Text('Export notes to text files'),
                  value: 3,
                ),
              ],
              onSelected: (int index) {
                if (index == 2) {
                  importNotesToFile();
                }
                if (index == 3) {
                  exportNotes(context);
                }
              },
            ),
          ),
        ],
      );
    }
     PreferredSizeWidget _selectionAppBap(){
      return AppBar(
        title: Text('${selectedNoteIds.length}'),
        actions: [
          IconButton(
            onPressed: (){
              setState(() {
                selectedNoteIds.clear();
                isSelectionMode = false;
              });
            },
            icon: Icon(Icons.tab_unselected),
          ),
          IconButton(
       onPressed: () async {
       for (int id in selectedNoteIds) {
       await DBHelper.getInstance.moveNoteToTrash(id);
       }

       setState(() {
       selectedNoteIds.clear();
       isSelectionMode = false;
       notesFuture = fetchNotes(); // refresh
       });},

       icon: Icon(Icons.delete),
          ),
          IconButton(
            onPressed: () async{
              final db=DBHelper.getInstance;
              /// Get all selected notes
              List<String> noteTexts=[];
              for(int id in selectedNoteIds){
                Note?  note = await db.getNoteById(id);
                if(note!=null){
                  noteTexts.add("Title : ${note.title}\n ${note.description}");
                }
              }
              final combinedText=noteTexts.join('\n\n');
              if(combinedText.isNotEmpty){
                Share.share(combinedText);
              }else{
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("No notes share"))
                );
              }

            },
            icon: Icon(Icons.share),
          ),

        ],
      );
     }


    return Scaffold(

      drawer: Drawer(
        // backgroundColor: Colors.white,
        child: ListView(
          children: [
            DrawerHeader(
              child: Center(
                child: ListTile(
                  leading: Icon(Icons.note),
                  title: Text('Notes')),
                ),
              ),

            Visibility(
              visible: false,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text('Categories'),
              ),
            ),
            Visibility(
              visible: false
              ,
              child: ListTile(
                leading: Icon(Icons.edit),
                title: Text("Edit categories"),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => editCategories()));
                },
              ),
            ),
            // Divider(),
            ListTile(
              leading: Icon(Icons.backup),
              title: Text("Backup"),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => backUp()));
              },
            ),
            ListTile(
              leading: Icon(Icons.delete),
              title: Text("Trash"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Trash()),);
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text("Setting"),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => mainSetting()));
              },
            ),
            Visibility(
              visible: false,
              child: ListTile(
                leading: Icon(Icons.highlight_off_sharp),
                title: Text("Turn off ads"),
                onTap: () {},
              ),
            ),
            ListTile(
              leading: Icon(Icons.help_outline),
              title: Text("Help"),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => FAQScreen()));
              },
            ),
            ListTile(
              leading: Icon(Icons.privacy_tip),
              title: Text("Privacy policy"),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) =>privatePolicy('https://policies.google.com/privacy?hl=en-US')));


                // js.context.callMethod('open',['https://pub.dev/packages/url_launcher/versions/6.0.9/example']);
              },
            )
          ],
        ),
      ),

      appBar: isSelectionMode ? _selectionAppBap() : _defualtAppBar(),

      body: isRefresh == true ? bodyMeth()
          : bodyMeth(),


      floatingActionButton: FloatingActionButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        onPressed: () async {
          final result = await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddNotes(note: null,onSaved: fetchNotes,)));
          print(result);
          if (result == "refresh") {
            setState(() {
              notesFuture = fetchNotes(); // ✅ refresh UI
            });
          }
        },

        child: Text('Add',
          //   style: TextStyle(
          //   color: Theme.of(context).brightness == Brightness.dark
          //       ? Colors.white // Text color for dark theme
          //       : Colors.black, // Text color for light theme
          // ),
        ),
      )
      ,
    );
  }


  ///custom function

  String selectedSort = "title_az";

  void showAlertDialog() {
    showDialog(

        context: context,
        builder: (BuildContext context) =>
            Center(
              child: Container(
                height: MediaQuery
                    .of(context)
                    .size
                    .height / 1.50,
                child: AlertDialog(
                  contentPadding: EdgeInsets.zero,
                  scrollable: true,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(2),
                  ),
                  titleTextStyle: TextStyle(color: const Color(0xFF006E1C),
                      fontWeight: FontWeight.w500,
                      fontSize: 16),
                  title: Text('Sort by'),
                  content: Container(width: MediaQuery
                      .of(context)
                      .size
                      .width / 1,
                    child: StatefulBuilder(
                      builder: (BuildContext context, StateSetter setState) =>
                          Column(
                            children: [
                              RadioListTile<String>(
                                  activeColor: const Color(0xFF006E1C),
                                  title: Text('edit date: from newest'),
                                  value: 'date_newest',
                                  groupValue: selectedSort,
                                  onChanged: (String? value) {
                                     setState(() {
                                      selectedSort = value!;
                                      notesFuture = fetchNotes(); // ✅ re-fetch with new sort
                                    });
                                  }
                              ),


                              RadioListTile<String>(
                                  title: Text('edit date: from oldest'),
                                  activeColor: const Color(0xFF006E1C),
                                  value: 'date_oldest',
                                  groupValue: selectedSort,
                                  onChanged: (String? value) {

                                    setState(() {
                                      selectedSort = value!;
                                      notesFuture = fetchNotes(); // ✅ re-fetch with new sort
                                    });
                                  }

                              ),


                              RadioListTile<String>(
                                  activeColor: const Color(0xFF006E1C),
                                  title: Text('title: A to Z'),
                                  value: 'title_az',
                                  groupValue: selectedSort,
                                  onChanged: (String? value) async {
                                    setState(() {
                                      selectedSort = value!;
                                    });
                                    await fetchNotes();
                                  }
                                  ),


                              RadioListTile<String>(
                                  activeColor: const Color(0xFF006E1C),
                                  title: Text('title: Z to A'),
                                  value: 'title_za',
                                  groupValue: selectedSort,
                                  onChanged: (String? value) async {
                                    setState(() {
                                      selectedSort = value!;
                                    });
                                    await fetchNotes();
                                  }),
                            ],
                          ),
                    ),
                  ),
                  actions: <Widget>[
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context, "CANCEL");
                          //    print(_selectedvalue);
                          // openDb();
                        },
                        child: Text('CANCEL',
                          style: TextStyle(color: const Color(0xFF006E1C),),)),
                    TextButton(onPressed: () {
                      print("ggggggggggggggggggggggggggggggg");
                      print(notes);
                      // fetchNotes();
                      setState(() {

                      });
                      Navigator.pop(context);
                    },
                        child: Text('SORT',
                          style: TextStyle(color: const Color(0xFF006E1C),),))
                  ],
                ),
              ),
            )
    );
  }

  bodyMeth() {
    print('////////////////////////////////////////////');
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: notesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No Notes Available'));
        } else {
          final displayedNotes = snapshot.data!;
          return RefreshIndicator(
            onRefresh: () async {
              setState(() {
                notesFuture = fetchNotes();  // reassign future

                // DBHelper.getInstance.getAllNotes();
              });
            },

            /// Fetch notes from the database


            child: ListView.builder(
              itemCount: displayedNotes.length,
              itemBuilder: (context, index) {
                var note = displayedNotes[index];
                final nColor = Color(note['noteColor']);
                if (searchController.text.isEmpty) {
                  return GestureDetector(
                    onLongPress: (){
                     setState(() {
                     isSelectionMode=true;
                     selectedNoteIds.add(note['s_no']);
                     });
                    },
                    child: Card(
                      elevation: selectedNoteIds.contains(note['s_no']) ? 8 : 2 ,
                      color: selectedNoteIds.contains(note['s_no']) ? Colors.green.withOpacity(0.3) : nColor.withOpacity(0.5),

                      child: ListTile(
                        leading: isSelectionMode ? Checkbox(
                          side: BorderSide(color: Colors.black), // Border color
                          checkColor: Colors.white, // Checkmark color
                          activeColor: Colors.black, // Background when checked
                         // splashRadius: 20,

                          value: selectedNoteIds.contains(note['s_no']),
                          onChanged: (bool? value){
                            setState(() {
                              if(value==true){
                                selectedNoteIds.add(note['s_no']);
                              } else {
                                selectedNoteIds.remove(note['s_no']);
                              }

                              if (selectedNoteIds.isEmpty) {
                                isSelectionMode = false;
                              }
                            });
                          },
                        )
                              : null ,
                        tileColor: nColor.withOpacity(0.5),
                        title: Text(note['title'],

                        ),

                        onTap: () async {
                          String data = await Navigator.push(

                            context,  MaterialPageRoute(builder: (context) => AddNotes(note: Note.fromMap(note),onSaved: fetchNotes,)),
                               // 👈 convert map to model
                          );
                            // print(data);

                          if (data == "refresh") {
                            // print(
                            //     "____________________________________________________________________________________________________");
                            // String? result = await Navigator.push(
                            //   context,
                            //   MaterialPageRoute(builder: (context) => AddNotes(note: Note.fromMap(note),onSaved: fetchNotes,)),
                            // );

                            if (data == "refresh") {
                              setState(() {
                                notesFuture = fetchNotes(); // ✅ Refresh notes
                              });
                            }
                          } else {
                            print(
                                "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++$note");
                          }
                        },

                        trailing: Text(
                            '\n \n Last edit: ${displayedNotes[index]['created_at']}'),
                      ),
                    ),
                  );
                } else if (note['title'].toLowerCase().contains(
                    searchController.text.toLowerCase())) {
                  return Card(
                    child: ListTile(
                      tileColor: nColor,
                      title: Text(note['title'].toString(),
                        // style: TextStyle(color: noteColor),
                      ),


                      onTap: () async {
                        String data = await Navigator.push(
                          context, MaterialPageRoute(builder: (context) =>
                            AddNotes(note: Note.fromMap(
                                note),onSaved: fetchNotes,), // 👈 convert map to model
                        ),
                          // print(data);
                        );

                        if (data == "refresh") {
                          print(
                              "____________________________________________________________________________________________________");
                          setState(() {
                            notesFuture = fetchNotes(); // ✅ Refresh notes
                          });
                        } else {
                          print(
                              "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++");
                        }
                      },

                      trailing: Text(
                          '\n \n Last edit: ${displayedNotes[index]['created_at']}'),
                    ),
                  );
                } else {
                  return Container();
                }
              },
            ),
          );
        }
      },
    );
  }


  Future<void> importNotesToFile() async {
    if (await Permission.storage
        .request()
        .isGranted) {
      try {
        List<Map<String, dynamic>> notes = await DBHelper.getInstance
            .getAllNotes();

        if (notes.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Notes not Imported.')),
          );
          return;
        }

        String jsonContent = jsonEncode(notes); // ✅ Encode notes to JSON

        Directory? dir;
        if (Platform.isAndroid) {
          dir = Directory('/storage/emulated/0/Download');
        } else {
          dir = await getApplicationDocumentsDirectory();
        }

        final filePath = '${dir.path}/note_backup_${DateTime
            .now()
            .millisecondsSinceEpoch}.json';
        final file = File(filePath);
        await file.writeAsString(jsonContent); // ✅ Save as JSON

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Note Imported')),
        );

        print("Backup saved at: $filePath");
      } catch (e) {
        print("Error during backup: $e");
      }
    } else {
      print("Storage permission denied.");
    }
  }


  Future<void> exportNotes(BuildContext context) async {
    try {
      // Request permission to read storage (important on Android)
      if (!await Permission.storage
          .request()
          .isGranted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Storage permission denied')),
        );
        return;
      }

      // Let user pick the backup file
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json', 'db', 'txt'],
      );

      if (result != null && result.files.single.path != null) {
        File file = File(result.files.single.path!);
        String content = await file.readAsString();

        // Try to decode JSON
        final jsonData = jsonDecode(content);
        if (jsonData is! List) {
          throw FormatException('Invalid JSON format. Expected a List.');
        }


        // Insert each note into the database
        for (var note in jsonData) {
          await DBHelper.getInstance.addNote(
            mTitle: note['title'],
            mDesc: note['description'],
            mNoteColor: note['noteColor'] ?? 0xFF4CAF50, // fallback green
          );
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Notes Exported successfully!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Notes Not Export')),
        );
      }
    } catch (e) {
      print('Error restoring notes: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error restoring notes: $e')),
      );
    }
  }
  }




