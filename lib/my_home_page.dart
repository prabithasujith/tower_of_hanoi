import 'dart:async';
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  ListQueue<int> source = new ListQueue();
  ListQueue<int> auxOrdes1 = new ListQueue();
  ListQueue<int> auxOrdes2 = new ListQueue();
  int noOfdisks = 3;
  int noOfSteps = 0;
  String errorMessage = 'Cheer up!';

  ListQueue<int> selecetedNode;
  ListQueue<int> destinationNOde;

  bool win = false;

  Timer _timer;
  int _start = 10;

  @override
  void initState() {
    for (int i = noOfdisks; i > 0; i--) {
      source.add(i);
    }

    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) => setState(
        () {
          if (_start < 1) {
            timer.cancel();
          } else {
            _start = _start - 1;
          }
          setState(() {});
        },
      ),
    );
    super.initState();
  }

  void error() {
    errorMessage = 'That move is not allowed';
    setState(() {});
  }

  void cheer() {
    errorMessage = 'Cheer Up!';
  }

  Widget push(int noOfdisks, ListQueue<int> destination, int position) {
    return Container(
      child: Text(
        destination.elementAt((destination.length - 1) - position).toString(),
        textAlign: TextAlign.center,
      ),
    );
  }

  void popAndPush(ListQueue<int> sour, ListQueue<int> des) {
    selecetedNode = null;
    destinationNOde = null;
    int value = sour.last;
    noOfSteps = noOfSteps + 1;
    if (sour == des) {
      error();
    } else if (des.isNotEmpty && des.last < value) {
      error();

      return;
    } else {
      cheer();

      sour.removeLast();
      des.addLast(value);
      print('no of moves ' + noOfSteps.toString());
      if (des.length == noOfdisks) win = true;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tower of Hanoi'),
      ),
      body: _timer.isActive
          ? Center(
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Text('Timer ' + _start.toString()),
              ),
            )
          : Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Text('No of moves: ' + noOfSteps.toString()),
                ),
                AbsorbPointer(
                  absorbing: win,
                  child: Container(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            if (selecetedNode == null) {
                              selecetedNode = source;
                            } else {
                              destinationNOde = source;
                              setState(() {});
                              popAndPush(selecetedNode, destinationNOde);
                            }
                            errorMessage = 'Cheer Up!';
                            setState(() {});
                          },
                          child: buildContainer(source, Colors.red),
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            cheer();
                            if (selecetedNode == null) {
                              selecetedNode = auxOrdes1;
                            } else {
                              destinationNOde = auxOrdes1;
                              popAndPush(selecetedNode, destinationNOde);
                            }
                          },
                          child: buildContainer(auxOrdes1, Colors.yellow),
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            errorMessage = 'Cheer Up!';
                            setState(() {});
                            if (selecetedNode == null) {
                              selecetedNode = auxOrdes2;
                            } else {
                              destinationNOde = auxOrdes2;
                              popAndPush(selecetedNode, destinationNOde);
                            }
                          },
                          child: buildContainer(auxOrdes2, Colors.blue),
                        ),
                      )
                    ],
                  )),
                ),
                win
                    ? Padding(
                        padding: EdgeInsets.all(10),
                        child: Text('You Win!'),
                      )
                    : Text(errorMessage)
              ],
            ),
    );
  }

  Widget buildContainer(ListQueue<int> listQueue, MaterialColor color) {
    return Container(
      margin: EdgeInsets.all(10),
      height: 200,
      width: 100,
      decoration: BoxDecoration(
          color: Colors.blueAccent,
          boxShadow: [
            new BoxShadow(
                color: (selecetedNode == listQueue)
                    ? Colors.green[200]
                    : (destinationNOde == listQueue)
                        ? Colors.red[200]
                        : Colors.black,
                blurRadius: 7.0,
                spreadRadius: 2),
          ],
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
      alignment: Alignment.bottomCenter,
      child: ListView.builder(
        shrinkWrap: true,
        itemBuilder: (ctx, i) {
          return ListTile(
            leading: Container(
                width: listQueue.elementAt((listQueue.length - 1) - i) * 20.0,
                height: 30.0,
                child: Card(child: push(noOfdisks, listQueue, i))),
          );
        },
        itemCount: listQueue.length,
      ),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    source.clear();
    destinationNOde.clear();
    selecetedNode.clear();
    auxOrdes1.clear();
    auxOrdes2.clear();
    super.dispose();
  }
}
