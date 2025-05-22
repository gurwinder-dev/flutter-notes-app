import 'package:flutter/material.dart';

class InstructionsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Instructions'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text(
              'Welcome to the Notes App!',
              style: Theme.of(context).textTheme.headline5,
            ),
            SizedBox(height: 16),
            Text(
              'Here are some instructions to help you use the app:',
              style: Theme.of(context).textTheme.subtitle1,
            ),
            SizedBox(height: 16),
            Text(
              '1. **Create Notes**: To create a new note, tap the "+" button located at the bottom right of the screen. Enter your note title and description, then hit "Save".',
              style: Theme.of(context).textTheme.bodyText2,
            ),
            SizedBox(height: 16),
            Text(
              '2. **Edit Notes**: To edit a note, simply tap on the note you want to modify. You can update the title, description, and category.',
              style: Theme.of(context).textTheme.bodyText2,
            ),
            SizedBox(height: 16),
            Text(
              '3. **Delete Notes**: To delete a note, swipe left on a note from the list view and tap "Delete".',
              style: Theme.of(context).textTheme.bodyText2,
            ),
            SizedBox(height: 16),
            Text(
              '4. **View Notes**: All of your notes are stored in the list, where you can scroll through and tap any note to view or edit it.',
              style: Theme.of(context).textTheme.bodyText2,
            ),
            SizedBox(height: 16),
            Text(
              'Feel free to explore and start adding your notes!',
              style: Theme.of(context).textTheme.bodyText2,
            ),
          ],
        ),
      ),
    );
  }
}
