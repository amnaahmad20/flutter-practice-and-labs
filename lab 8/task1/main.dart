import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Demo',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CounterWidget(
      child: Scaffold(
        appBar: AppBar(
          title: const Center(
            child: Text("Home"),
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Builder(builder: (context) {
              final value = CounterWidget.of(context).count;
              return Column(
                children: [
                  Text(
                    'You have pushed the button $value times',
                  ),
                  Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Text(
                      '$value',
                      style: const TextStyle(fontSize: 48),
                    ),
                  ),
                ],
              );
            }),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Builder(builder: (context) {
                  return Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: TextButton(
                      style: TextButton.styleFrom(
                        fixedSize: const Size(60, 60),
                        backgroundColor:
                            CounterWidget.of(context).isDecrementButtonEnabled
                                ? Colors.red
                                : Colors.grey,
                        shape: const CircleBorder(),
                      ),
                      onPressed: () =>
                          CounterWidget.of(context).isDecrementButtonEnabled
                              ? CounterWidget.of(context).decrementCount()
                              : null,
                      child: const Icon(
                        Icons.remove,
                        color: Colors.white,
                      ),
                    ),
                  );
                }),
                Builder(builder: (context) {
                  return Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: TextButton(
                      style: TextButton.styleFrom(
                        fixedSize: const Size(60, 60),
                        backgroundColor:
                            CounterWidget.of(context).isIncrementButtonEnabled
                                ? Colors.green
                                : Colors.grey,
                        shape: const CircleBorder(),
                      ),
                      onPressed: () =>
                          CounterWidget.of(context).isIncrementButtonEnabled
                              ? CounterWidget.of(context).incrementCount()
                              : null,
                      child: const Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                    ),
                  );
                }),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class CounterWidget extends StatefulWidget {
  const CounterWidget({Key? key, required this.child}) : super(key: key);

  final Widget child;
  static _CounterState of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_InheritedCount>()!.data;
  }

  @override
  _CounterState createState() => _CounterState();
}

class _CounterState extends State<CounterWidget> {
  int count = 0;
  bool isDecrementButtonEnabled = false;
  bool isIncrementButtonEnabled = true;

  showAlertDialog(String content) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Alert'),
        content: Text(content),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('DISMISS'))
        ],
      ),
    );
  }

  void incrementCount() {
    setState(() {
      isDecrementButtonEnabled = true;
      if (count == 10) {
        isIncrementButtonEnabled = false;
        showAlertDialog('Cannot increment beyond 10');
      } else {
        ++count;
      }
    });
  }

  void decrementCount() {
    setState(() {
      if (count == 1) {
        isDecrementButtonEnabled = false;
        showAlertDialog('Cannot decrement beyond 1');
      } else {
        --count;
        if (count == 9) {
          isIncrementButtonEnabled = true;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return _InheritedCount(
      data: this,
      child: widget.child,
    );
  }
}

class _InheritedCount extends InheritedWidget {
  final _CounterState data;

  const _InheritedCount({
    required Widget child,
    required this.data,
  }) : super(child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return true;
  }
}
