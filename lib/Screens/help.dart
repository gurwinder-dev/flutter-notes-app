
import 'package:flutter/material.dart';
class QuestionAnswer {
  final String question;
  final String answer;

  // Constructor
  QuestionAnswer({required this.question, required this.answer});
}

class FAQScreen extends StatefulWidget {
  @override
  State<FAQScreen> createState() => _FAQScreenState();
}

class _FAQScreenState extends State<FAQScreen> {
  bool customIcon=false;

  

  // Sample data
  final List<QuestionAnswer> faqList = [
    QuestionAnswer(
      question: 'How can i use the app?',
      answer: '•   A new note can be created by tapping the ADD '
          '\n    button located in the bottom right part of the \n    notes list.'
          '\n•   A note can be deleted with the "Delete" button\n    in the top right corner on the opened note\n    screen.'
          'Deleted notes will be move to "Trash" \n    folder bt default. '
          'To restore a notes open the \n    "Trash" folder from the main menu. '
          '\n•   Some operations like deleting, can be\n    performed on multiple notes.To select multiple\n    notes hold a finger'
          'for a few seconds on a note\n    list.This will turn on the  selection mode,\n    where it\'s possible to select notes by tapping\n    them on the '
          'list.Actions available for the\n    selected notes are shown in the top part of \n     the screen.',
    ),
    QuestionAnswer(
      question: 'I deleted notes.How can I restore it?',
      answer: 'Please tap on  the "Trash" folder from the app\'s main menu.To open the main menu ☰ button in the top left corner of the notes list screen.',
    ),
    QuestionAnswer(
      question: 'Where are the notes stored?',
      answer: 'All notes are stored in the app\'s internal space. That space is not accessible to any other app.It means that file manager apps won\'t see the notes and even '
          'connecting to a computer won\'t grant access to the notes.That\'s for securing the notes.Tne only way to access the notes is to use the app.'
    ),
    QuestionAnswer(
      question: 'I uninstalled the app.How can I recover my notes?',
      answer: 'Uninstalling the app will delete notes stored on the device. If there was a backup copy made, then the notes can be recovered.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Help'),
        //backgroundColor: Colors.black26,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
       Center(child: Text('Notes',
        // style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 18),
       )
       ),
       Center(child: Padding(
         padding: const EdgeInsets.only(bottom: 8.0),
         child: Text('Frequently asked questions',
         //  style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize:18),
         ),
       )),
          Expanded(
            child: ListView(
              children: faqList.map((item) {
                return Padding(
                  padding: const EdgeInsets.only(top: 4.0,bottom: 4,right: 8,left: 8),
                  child: Card(
                   // color: Colors.blueGrey,
                    child: Container(
                     // color: Colors.grey,
                      child: ExpansionTile(
                        title: Text(item.question),
                         children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(),
                            child: Container(
                                padding: const EdgeInsets.all(16.0),
                                decoration: BoxDecoration(
                                 // color: Colors.white,
                                  borderRadius: BorderRadius.circular(1.0),
                                  border: Border.all(width: 1),
                                ),
                                child: Text(item.answer)),
                          ),
                        ],
                        onExpansionChanged: (bool expanded) {
                          setState(() {
                            customIcon = expanded;
                          });
                        },),
                    ),
                    ),
                );

              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

