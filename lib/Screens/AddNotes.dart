


import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:notrepad_free/DBHelper.dart';
import 'package:notrepad_free/Screens/home_screen.dart';
import 'package:notrepad_free/undo_redo_controller_class.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import '../Theme/theme_note_colors.dart';

bool isTextNotEmpty=false;
bool isSearching = false;
late Color selectedColor;

class AddNotes extends StatefulWidget {
  final Note? note;
  final VoidCallback? onSaved;  //  callback type

   AddNotes({super.key,
     required this.note,
     required this.onSaved
   });

  @override
  State<AddNotes> createState() => _AddNotesState();
}

class _AddNotesState extends State<AddNotes> {
  /// search options
 late  TextEditingController searchController=TextEditingController();
 List<int>   matchPositions = [];
 int currentMatchIndex = 0;
  late TextEditingController  titleController=TextEditingController();

  late TextEditingController  descriptionController = TextEditingController();
   Note? _note;


 Future<void> saveNoteToTxtFile(String title, String description) async {
   try {
     // Request permission
     var status = await Permission.storage.request();
     if (!status.isGranted) {
       print('Storage permission not granted');
       return;
     }

     // Use Downloads directory (Android)
     Directory? dir;
     if (Platform.isAndroid) {
       dir = Directory('/storage/emulated/0/Download');
     } else {
       dir = await getApplicationDocumentsDirectory();
     }

     if (!await dir.exists()) {
       await dir.create(recursive: true);
     }

     final String filename = '$title.txt';
     final file = File('${dir.path}/$filename');

     // Save content
     await file.writeAsString('Title: $title\n\n$description');
     print('Saved note at: ${file.path}');
   } catch (e) {
     print('Error saving file: $e');
   }
 }



 @override
  void initState() {
    super.initState();

    titleController = TextEditingController(text: widget.note?.title ?? '');
    descriptionController = TextEditingController(text: widget.note?.description ?? '');
    selectedColor = widget.note?.color ?? Colors.green.shade800;


    _note = widget.note;
    descriptionController.addListener(() {
     setState(() {
       isTextNotEmpty=descriptionController.text.isNotEmpty;
     });
    });
 }
  Color _getUndoTextColor(BuildContext context){
    if(isTextNotEmpty){
      return Colors.white; ///  When text is present
    }else{
      return Theme.of(context).disabledColor; ///Default grey from theme
    }
  }
  Color _getRedoTextColor(BuildContext context){
    if(isTextNotEmpty){
      return Colors.white;
    }else{
      return Theme.of(context).disabledColor;
    }
  }
  @override
  void dispose() {
    descriptionController.dispose();
    super.dispose();
  }

  void shareNotes(){
    String text=' ${titleController.text},\n  ${descriptionController.text}';
    Share.share(text);
  }
 ///when user types in the search bar
 void searchInNotes(String query){

    final text=descriptionController.text.toLowerCase();

    final search=query.toLowerCase();
    matchPositions.clear();

    currentMatchIndex=0;

    if (search.isNotEmpty) {
      int index = text.indexOf(search);
      while (index != -1) {
        matchPositions.add(index);
        index = text.indexOf(search, index + search.length); // 💡 Fix this line
      }
    }

    if(matchPositions.isNotEmpty){
      highlightCurrentMatch();
    }

    setState(() {

    });
 }
 void highlightCurrentMatch(){
    int  start =matchPositions[currentMatchIndex];
    int end = start + searchController.text.length;
    descriptionController.selection=TextSelection(baseOffset: start, extentOffset: end);
 }
 void goToNextMatch(){
    if(matchPositions.isEmpty)return;
    currentMatchIndex=(currentMatchIndex+1)%matchPositions.length;
    highlightCurrentMatch();
 }
 void goToPreviousMatch(){
    if(matchPositions.isEmpty)return;
    currentMatchIndex= (currentMatchIndex-1+matchPositions.length)%matchPositions.length;
    highlightCurrentMatch();
 }



  void showDeleteDialog(BuildContext context){
    showDialog(context: context,
        builder:(BuildContext context)=>AlertDialog(
          content: Text('The note will be deleted permanently! \nAre you sure that you want to delete the "${titleController.text}" note?'),
          actions: [
            TextButton(onPressed: (){
              Navigator.pop(context);
            },
                child: Text('CANCEL')),
            TextButton(onPressed: () async{

              final sr=widget.note?.s_no;
              if(_note!=null && sr!=null){
               // DBHelper.getInstance.delete(_note!.s_no);
               var move= DBHelper.getInstance.moveNoteToTrash(sr);
               if(move!=null){
                 Navigator.pop(context,"refresh"); // closes the AddNotes screen and triggers refresh

               }
               Navigator.pop(context,"refresh"); // closes the AddNotes screen and triggers refresh

              }
            },
                child: Text('DELETE')),
          ],
        ));
  }

   void showColorPicker(BuildContext context){
      showDialog(
       context: context,
       builder: (context) => ColorPickerDialog(
         onColorSelected: (selectedColor) {
           // Save to your note model or state
           print("Selected color: ${selectedColor.light}");
         },
       ),
     );
   }
  @override
  Widget build(BuildContext context) {
    final _themeIndex = Theme.of(context).brightness == Brightness.dark;
   print('mmmmmmmmmmmmmmmm${selectedColor.value}');

     final undoRedo=Provider.of<UndoRedoController>(context);
    // /// Make sure text field reflects the current state
    // descriptionController.text=undoRedo.present;
    // descriptionController.selection=TextSelection.fromPosition(
    //   TextPosition(offset: descriptionController.text.length)
    // );

    return Material(
       child:Scaffold(

        backgroundColor: selectedColor.withOpacity(0.4),
        appBar: AppBar(
        backgroundColor:selectedColor.withOpacity(1.0),
          title: isSearching ? TextField(
            controller: searchController,
               style: TextStyle(color: Colors.white,fontSize: 16),
             cursorColor: Colors.white,

            decoration: InputDecoration(

              hintText: 'Search.......... ',
                    hintStyle: TextStyle(color: Colors.grey),
                    suffixIcon: IconButton(
                  icon:Icon(Icons.close,color: Colors.white,),

                  onPressed: (){
                    setState((){
                      isSearching=false;
                      searchController.clear();
                      matchPositions.clear();
                    });
                  }
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide.none
              )

            ),onChanged: searchInNotes,
          ): Text('Add Notes'),
          actions: isSearching?[
            IconButton(
              icon: Icon(Icons.arrow_upward),
              onPressed: goToPreviousMatch,
            ),

            IconButton(
              icon:const Icon(Icons.arrow_downward),
        onPressed: goToNextMatch,
            ),
            PopupMenuButton(


              icon: const Icon(
                Icons.more_vert,
              ),
              onSelected: (index){
                if(index==1){

             final sr = widget.note?.s_no;

              if(_note != null) {

             DBHelper.getInstance.updateNote(
                 sr!.toInt(),
                 addTitle(),
                 descriptionController.text,
             selectedColor.value);
               }else{
            /// Add new note
           DBHelper.getInstance.addNote(
            mTitle: addTitle(),
            mDesc: descriptionController.text,
             mNoteColor: selectedColor.value,

      );
      }


      /// Pop back to the previous screen
      Navigator.pop(context,"refresh");
                  print('clicked 1');
                }else if(index==2){

                  return showDeleteDialog(context);

                  print('clicked2');
                }else if(index==3){
                  shareNotes();

                  print('clicked3');
                }

              },//use this icon
              itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                PopupMenuItem(
                  value: 1,
                  child: ListTile(title: Text('Save'),
                  trailing: Icon(Icons.save),),
                ),
                const PopupMenuItem(
                  value:2,
                  child: ListTile(title: Text('Delete'),
                  trailing: Icon(Icons.delete),),
                ),
                const PopupMenuItem(
                  value: 3,
                  child: ListTile(title: Text("Share"),
                  trailing: Icon(Icons.share),),
                ),


              ],


            )

          ]
          : [
            TextButton(

             onPressed: () async{
               final sr = widget.note?.s_no;

               if(_note != null) {

                 DBHelper.getInstance.updateNote(
                    sr!.toInt() ,
                    addTitle(),
                     descriptionController.text,
                    selectedColor.value,
                 );
               }else{
                 /// Add new note
                 DBHelper.getInstance.addNote(
                   mTitle: addTitle(),
                   mDesc: descriptionController.text,
                   mNoteColor: selectedColor.value,
                 );

               }
               widget.onSaved?.call(); // 👈 this refreshes the home screen

               /// Pop back to the previous screen
               Navigator.pop(context,"refresh");


               },
             child: Text('SAVE',style: TextStyle(color: _themeIndex? Colors.white:Colors.white)),
           ),

            TextButton(
                onPressed: (){
                 // isTextNotEmpty ? undoRedo.undo():null; // Disable the button when there's nothing to undo

               descriptionController.clear();

                },
                child: Text('UNDO',style: TextStyle(color: _getRedoTextColor(context)))),
                  //(color: _themeIndex? Colors.white:Colors.white ))),
            PopupMenuButton(


              icon: const Icon(
                Icons.more_vert,
              ),
              onSelected: (index){
                if(index==1){
                 return isTextNotEmpty ? undoRedo.redo():null;
                  print('clicked 1');
                }else if(index==2){
                  print('clicked2');
                }else if(index==3){
                shareNotes();

                  print('clicked3');
                }else if(index==4){

                  showDeleteDialog(context);


                }else if(index==5){
                 setState((){
                   isSearching=true;
                 });
                  print('clicked5');
                }else if(index==6){

                  //print('clicked6');
                }else if(index==7){
                  print('clicked7');
                }else if(index==8){
                 // print('clicked8');
                  return showNoteColorPicker(
                      context: context,
                  currentColor: selectedColor,
                  onColorSelected: (color){
                        setState((){
                          selectedColor=color;
                        });
                  });
                    //showColorPicker(context);
                }else if(index==9){
                  print('clicked9');
                }else if(index==10){
                  print('clicked10');
                }

              },//use this icon
              itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                //  PopupMenuItem(
                //   value: 1,
                //   child: Text('Redo', style: TextStyle(color:
                //   _getUndoTextColor(context))),
                // ),
                // const PopupMenuItem(
                //   value:2,
                //   child: Text('Undo all'),
                // ),
                const PopupMenuItem(
                  value: 3,
                  child: Text("Share"),
                ),
               const  PopupMenuItem(
                  value: 4,
                  child: Text('Delete'),
                ),
                const PopupMenuItem(
                  value: 5,
                    child:Text('Search')),
                //  PopupMenuItem(
                //   value: 6,
                //     child: Text('Export to a text file')),
                // const PopupMenuItem(
                //   value: 7,
                //     child: Text('Categorize')),
                const PopupMenuItem(
                  value: 8,
                    child: Text('Colorize')),
                // const PopupMenuItem(
                //   value: 9,
                //     child: Text('Convert to checklist')),
                // const PopupMenuItem(
                //   value: 10,
                //     child: Text('Switch to read mode')),

              ],


            )

          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10)
            ),
            child: Column(
              children: [
                /// custom widget
                // customTextField('Title',titleController),
                // customTextField('Description', descriptionController),

                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: TextField(
                    cursorColor: Colors.black,
                    controller: titleController,
                    decoration: InputDecoration(

                      label: Text("Enter Title"),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),

                      )
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(

                    cursorColor: Colors.black,
                    maxLines: 10,
                    controller: descriptionController,
                    onChanged: (text)=>undoRedo.settext(text),
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),


                        )
                    )
                    ),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }

  addTitle(){
    var title = titleController.text.toString();
    if(title == null || title.isEmpty){
      title = "Untitled";
    }
    return title.toString();
  }




}



void showNoteColorPicker({
  required BuildContext context,
  required Color currentColor,
  required ValueChanged<Color> onColorSelected,
}) {
  Color tempColor = currentColor;/// This holds the selected color temporarily

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Pick a note color'),
        content: SingleChildScrollView(
          child: ColorPicker(
            pickerColor: currentColor,
            onColorChanged: (color) => tempColor = color,
            enableAlpha: false, /// disable transparency
            labelTypes: const [],/// hide labels
            pickerAreaHeightPercent: 0.7,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(onPressed: (){

          }, child: Text('Delete')),

              Container(
                child: StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState){
                     return TextButton(
                     child: Text('Ok'),
                     onPressed: (){

                 onColorSelected(tempColor);/// Sends color back
                 setState((){
                   selectedColor=tempColor; /// Update UI with the selected color
      });
            Navigator.pop(context);

      },
                     );
                  },


                ),
              )




        ],
      );
    },
  );



}

