import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Startup Name Generator',
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
        ),
      ),
      home: const RandomWords(),
    );
  }
}

class _RandomWordsState extends State<RandomWords> {
  final _suggestions = <WordPair>[];
  var _saved = <WordPair>{};
  var _selectedWords = <WordPair>{};
  final _biggerFont = const TextStyle(fontSize: 18.0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Startup Name Generator'),
        actions: [
          IconButton(
            icon: const Icon(Icons.list),
            onPressed: _pushSaved,
            tooltip: 'Saved Suggestions',
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemBuilder: /*1*/ (context, i) {
          if (i.isOdd) return const Divider(); /*2*/

          final index = i ~/ 2; /*3*/
          if (index >= _suggestions.length) {
            _suggestions.addAll(generateWordPairs().take(10)); /*4*/
          }

          final alreadySaved = _saved.contains(_suggestions[index]);

          return ListTile(
            title: Text(
              _suggestions[index].asPascalCase,
              style: _biggerFont,
            ),
            trailing: Icon(
              alreadySaved ? Icons.favorite : Icons.favorite_border,
              color: alreadySaved ? Colors.red : null,
              semanticLabel: alreadySaved ? 'Remove from saved' : 'Save',
            ),
            onTap: () {
              setState(() {
                if (alreadySaved) {
                  _saved.remove(_suggestions[index]);
                } else {
                  _saved.add(_suggestions[index]);
                }
              });
            },
          );
        },
      ),
    );
  }

  void _pushSaved() {
    setState(() {
      _selectedWords = <WordPair>{};
    });
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              dynamic tiles = _saved.map(
                    (pair) {
                  return ListTile(
                    onTap: () {
                      setState(() {
                        if (_selectedWords.contains(pair)) {
                          _selectedWords.remove(pair);
                        } else {
                          _selectedWords.add(pair);
                        }
                      });
                    },
                    trailing: _selectedWords.contains(pair)
                        ? Icon(
                      Icons.check,
                      color: Colors.green,
                    )
                        : null,
                    title: Text(
                      pair.asPascalCase,
                      style: _biggerFont,
                    ),
                  );
                },
              );
              final divided = tiles.isNotEmpty
                  ? ListTile.divideTiles(
                context: context,
                tiles: tiles,
              ).toList()
                  : <Widget>[];

              final _getSelectedWordsStr = () {
                List<String> words = [];
                for (WordPair pair in _selectedWords) {
                  words.add("\"" + pair.toString() + "\"");
                }
                return words.join(", ");
              };

              return Scaffold(
                appBar: AppBar(
                  title: const Text('Saved Suggestions'),
                  actions: [
                    IconButton(
                      onPressed: () {
                        if (_selectedWords.length > 0) {
                          showDialog<void>(
                            context: context,
                            barrierDismissible: false,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Would you like to remove ' +
                                    _getSelectedWordsStr()),
                                actions: <Widget>[
                                  TextButton(
                                    child: const Text('Yes'),
                                    onPressed: () {
                                      setState(() {
                                        _saved.removeWhere(
                                                (e) => _selectedWords.contains(e));
                                      });

                                      Navigator.of(context).pop();
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  TextButton(
                                    child: const Text('No'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('No Item Selected!'),
                            ),
                          );
                        }
                      },
                      icon: Icon(Icons.delete),
                    ),
                  ],
                ),
                body: ListView(children: divided),
              );
            },
          );
        },
      ),
    );
  }
}

class RandomWords extends StatefulWidget {
  const RandomWords({Key? key}) : super(key: key);

  @override
  State<RandomWords> createState() => _RandomWordsState();
}
