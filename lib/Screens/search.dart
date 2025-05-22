import 'package:flutter/material.dart';

class Search extends SearchDelegate {
  final GlobalKey more = GlobalKey();
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.close),
        onPressed: () {
          query = '';
        },
      ),
      InkWell(
        onTap: () {
          dynamic state = more.currentState;
          state.showButtonMenu();
        },
        child: PopupMenuButton(
          //color: Colors.white,
          key: more,
          itemBuilder: (_) => <PopupMenuItem<String>>[
            PopupMenuItem<String>(
              child: Text("Sort "),
              value: 'Sort',
            ),
            PopupMenuItem(
              child: Text('Select all notes'),
              value: 'Test',
            ),
            PopupMenuItem(
              child: Text('Import text files'),
              value: 'Edit',
            ),
            PopupMenuItem(
              child: Text('Export notes to text files'),
              value: 'Edit',
            )
          ],
        ),
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Text('');
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Text('');
  }
}
