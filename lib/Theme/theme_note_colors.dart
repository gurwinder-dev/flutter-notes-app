import 'package:flutter/material.dart';

class NoteColor {
  final Color light;
  final Color bold;

  const NoteColor({required this.light, required this.bold});
}

final List<NoteColor> noteColors = [
  NoteColor(light: Colors.red.shade100, bold: Colors.red.shade300),
  NoteColor(light: Colors.pink.shade100, bold: Colors.pink.shade300),
  NoteColor(light: Colors.purple.shade100, bold: Colors.purple.shade300),
  NoteColor(light: Colors.deepPurple.shade100, bold: Colors.deepPurple.shade300),
  NoteColor(light: Colors.indigo.shade100, bold: Colors.indigo.shade300),
  NoteColor(light: Colors.blue.shade100, bold: Colors.blue.shade300),
  NoteColor(light: Colors.lightBlue.shade100, bold: Colors.lightBlue.shade300),
  NoteColor(light: Colors.cyan.shade100, bold: Colors.cyan.shade300),
  NoteColor(light: Colors.teal.shade100, bold: Colors.teal.shade300),
  NoteColor(light: Colors.green.shade100, bold: Colors.green.shade300),
  NoteColor(light: Colors.yellow.shade100, bold: Colors.yellow.shade300),
  NoteColor(light: Colors.orange.shade100, bold: Colors.orange.shade300),
];

class ColorPickerDialog extends StatelessWidget {
  final Function(NoteColor) onColorSelected;

  const ColorPickerDialog({Key? key, required this.onColorSelected}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title:  Center(child: Text('Color Picker',style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),)),
      content: Container(
        height:MediaQuery.of(context).size.height/4,
        width: MediaQuery.of(context).size.width/4,
        child:

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Wrap(
                spacing: 10,
              runSpacing: 15,
                children: noteColors.map((noteColor) {
                  return GestureDetector(
                    onTap: () {
                      onColorSelected(noteColor);
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [noteColor.light, noteColor.bold],
                          // begin: Alignment.topLeft,
                          // end: Alignment.bottomRight,
                        ),
                         shape: BoxShape.circle,
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),


      ),
      actions: [
        TextButton(onPressed: (){
          Navigator.pop(context);
        }, child: Text('Cancel')),
        TextButton(onPressed: (){}, child: Text('Delete')),
        TextButton(onPressed: (){}, child: Text('Ok')),
      ],
    );
  }
}
