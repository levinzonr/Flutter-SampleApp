import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';


void main() => runApp(new MyApp());

class RandomWords extends StatefulWidget {

  @override
  createState() => new RandomWordsState();
}

class RandomWordsState extends State<RandomWords> {

  final _suggestions = <WordPair>[];
  final _fontStyle = const TextStyle(fontSize: 18.0);
  final _favorites = <WordPair>[];

  bool isSaved(WordPair pair) =>  _favorites.contains(pair);

  @override
  Widget build(BuildContext context) {
    return new Scaffold (
      appBar: new AppBar(
        title: new Text('Startup Name Generator'),
        actions: <Widget>[
          new IconButton(icon: new Icon(Icons.favorite), onPressed: _pushSaved)
        ],
      ),
      body: _buildSuggestions(),

    );
  }

  void _pushSaved() {
    Navigator.of(context).push(
      new MaterialPageRoute(
        builder: (context) {
          final tiles = _favorites.map(
                (pair) {
              return new ListTile(
                title: new Text(
                  pair.asPascalCase,
                  style: _fontStyle,
                ),
              );
            },
          );
          final divided = ListTile
              .divideTiles(
            context: context,
            tiles: tiles,
          )
              .toList();

          return new Scaffold(
            appBar: new AppBar(
              title: new Text('Saved Suggestions'),
            ),
            body: new ListView(children: divided),
          );
        },
      ),
    );
  }



  Widget _buildRow(WordPair pair) {
    return new ListTile(
      title: new Text(
        pair.asPascalCase,
        style: _fontStyle,
      ),
      trailing: new Icon(
        isSaved(pair) ? Icons.favorite : Icons.favorite_border,
        color: isSaved(pair) ? Colors.red : null
      ),
      onTap: () {
        setState(() {
          if (isSaved(pair)) {
            _favorites.remove(pair);
          } else {
            _favorites.add(pair);
          }
        });
      },
    );
  }

  Widget _buildSuggestions() {
    return new ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemBuilder: (context, i) {
        if (i.isOdd) return new Divider();
        final index = i ~/ 2;
        // If you've reached the end of the available word pairings...
        if (index >= _suggestions.length) {
          // ...then generate 10 more and add them to the suggestions list.
          _suggestions.addAll(generateWordPairs().take(10));
        }
        return _buildRow(_suggestions[index]);
      }
    );
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final wordPair = new WordPair.random();
    return new MaterialApp(
      title: 'Welcome to Flutter',
      theme: new ThemeData(
        primaryColor: Colors.white,
      ),
      home: RandomWords()
      );
  }
}