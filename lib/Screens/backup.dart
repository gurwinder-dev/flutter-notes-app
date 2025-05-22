import "dart:convert";
import "dart:io";

import "package:file_picker/file_picker.dart";
import"package:flutter/material.dart";
import "package:flutter/rendering.dart";
import "package:notrepad_free/Screens/show_instruction.dart";
import "package:path_provider/path_provider.dart";
import "package:permission_handler/permission_handler.dart";

import "../DBHelper.dart";
class backUp extends StatelessWidget {
  const backUp({super.key});

   @override
  Widget build(BuildContext context) {

     Future<void> backupNotesToFile() async {
       if (await Permission.storage.request().isGranted) {
         try {
           List<Map<String, dynamic>> notes = await DBHelper.getInstance.getAllNotes();

           if (notes.isEmpty) {
             ScaffoldMessenger.of(context).showSnackBar(
               SnackBar(content: Text('No notes to back up.')),
             );
             return;
           }

           String jsonContent = jsonEncode(notes);  // ✅ Encode notes to JSON

           Directory? dir;
           if (Platform.isAndroid) {
             dir = Directory('/storage/emulated/0/Download');
           } else {
             dir = await getApplicationDocumentsDirectory();
           }

           final filePath = '${dir.path}/note_backup_${DateTime.now().millisecondsSinceEpoch}.json';
           final file = File(filePath);
           await file.writeAsString(jsonContent);  // ✅ Save as JSON

           ScaffoldMessenger.of(context).showSnackBar(
             SnackBar(content: Text('Note backup saved to Downloads folder')),
           );

           print("Backup saved at: $filePath");
         } catch (e) {
           print("Error during backup: $e");
         }
       } else {
         print("Storage permission denied.");
       }
     }
     Future<void> restoreNotesFromBackup(BuildContext context) async {
       try {
         // Request permission to read storage (important on Android)
         if (!await Permission.storage.request().isGranted) {
           ScaffoldMessenger.of(context).showSnackBar(
             SnackBar(content: Text('Storage permission denied')),
           );
           return;
         }

         // Let user pick the backup file
         FilePickerResult? result = await FilePicker.platform.pickFiles(
           type: FileType.custom,
           allowedExtensions: ['json','db','txt'],
         );

         if (result != null && result.files.single.path != null) {
           File file = File(result.files.single.path!);
           String content = await file.readAsString();

           // Decode JSON
           List<dynamic> jsonData = jsonDecode(content);

           // Insert each note into the database
           for (var note in jsonData) {
             await DBHelper.getInstance.addNote(
               mTitle: note['title'],
               mDesc: note['description'],
               mNoteColor: note['noteColor'] ?? 0xFF4CAF50, // fallback green
             );
           }

           ScaffoldMessenger.of(context).showSnackBar(
             SnackBar(content: Text('Notes restored from backup successfully!')),
           );
         } else {
           ScaffoldMessenger.of(context).showSnackBar(
             SnackBar(content: Text('No backup file selected')),
           );
         }
       } catch (e) {
         print('Error restoring notes: $e');
         ScaffoldMessenger.of(context).showSnackBar(
           SnackBar(content: Text('Error restoring notes: $e')),
         );
       }
     }


     // Get the screen width using MediaQuery
     double screenWidth = MediaQuery.of(context).size.width;

     // Set the button width to 80% of the screen width
     double buttonWidth = screenWidth *1;
     return Scaffold(
       appBar: AppBar(
         title: Text('Backup'),
       ),
       body: Column(
         children: [
           Padding(
             padding: const EdgeInsets.all(8.0),
             child: ElevatedButton(onPressed: () {},
               child: GestureDetector(
                 onTap: (){
                   Navigator.push( context,
                     MaterialPageRoute(builder: (context)=>InstructionsScreen())
                   );
                 },
                   child: Text('SHOW INSTRUCTIONS')),
               style: ElevatedButton.styleFrom(
              minimumSize: Size(buttonWidth, 45),
                   shape: RoundedRectangleBorder(
                       borderRadius: BorderRadius.circular(1)
                   )
               ),),
           ),
           Padding(
             padding: const EdgeInsets.all(8.0),
             child: Container(
               height: MediaQuery.of(context).size.height / 3,
               decoration: BoxDecoration(
                   border: Border.all( width: 1)
               ),

               child: Column(
                 children: [
                   Padding(
                     padding: const EdgeInsets.all(8.0),
                     child: Container(
                       width: MediaQuery
                           .of(context)
                           .size
                           .width,
                       child: Text(
                         'A backup copy is a file containing copy of each note'
                             '(except deleted notes in the "Trash" folder).It can be used'
                             'to make copy of outside the device, or to transfer notes to another '
                             'device.Categories are not included in a backup copy file.'
                         , textAlign: TextAlign.justify,),
                     ),
                   ),
                   Padding(
                     padding: const EdgeInsets.all(8.0),
                     child: ElevatedButton(
                       onPressed: () {
                        backupNotesToFile();

                       },
                       child: Text('SAVE BACKUP TO A FILE'),
                       style: ElevatedButton.styleFrom(
                         minimumSize: Size(buttonWidth, 45),
                           shape: RoundedRectangleBorder(
                               borderRadius: BorderRadius.circular(1)
                           )
                       ),
                     ),
                   ),
                   Padding(
                     padding: const EdgeInsets.all(8.0),
                     child: ElevatedButton(onPressed: () {},
                       child: GestureDetector(
                         onTap: (){
                           restoreNotesFromBackup(context);

                         },
                           child: Text('LOAD NOTES FROM A BACKUP FILE')),
                       style: ElevatedButton.styleFrom(
                         minimumSize: Size(buttonWidth,45),
                           shape: RoundedRectangleBorder(
                               borderRadius: BorderRadius.circular(1)
                           )
                       ),),
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
