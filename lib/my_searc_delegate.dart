import 'package:flutter/material.dart';

class MySearchDelegate extends SearchDelegate {
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: const Icon(Icons.clear,color: Colors.black),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: Icon(Icons.arrow_back,color: Colors.black),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Center(
      child: Text('Search Results of $query', style: TextStyle(fontSize: 20)),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> suggestions = ["Nike", "Classic", "Sport", "Adidas"];
    final filterSuggestions = suggestions
        .where((element) => element.contains(query))
        .toList();
    return ListView.builder(
      itemCount: filterSuggestions.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(filterSuggestions[index]),
          onTap: () {
            query = filterSuggestions[index];
            showResults(context);
          },
        );
      },
    );
  }
}
