import 'dart:io';

import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GDG Korea WebTech Online Lightning Talk - Flutter Web',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MainPage(),
    );
  }
}

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TextStyle _appBarTextStyle = TextStyle(
      fontSize:
          MediaQuery.of(context).orientation == Orientation.portrait ? 13 : 20,
    );

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
                MediaQuery.of(context).orientation == Orientation.portrait
                    ? 'GDG Korea WebTech Online Lightning Talk \n- Flutter Web'
                    : 'GDG Korea WebTech Online Lightning Talk - Flutter Web',
                style: _appBarTextStyle),
            Text(
              'CuroGom',
              style: _appBarTextStyle,
            )
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width * 0.8,
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  GdgWebTechLogo(),
                  Title(),
                  Content(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Content extends StatefulWidget {
  @override
  _ContentState createState() => _ContentState();
}

class _ContentState extends State<Content> {
  List<TodoItem> todoList = [];
  List<TodoItem> doneList = [];

  @override
  Widget build(BuildContext context) {
    TodoWidget _todoWidget = TodoWidget(todoList);
    DoneWidget _doneWidget = DoneWidget(doneList);
    int enterKeyId;
    try {
      enterKeyId = Platform.isAndroid ? 4295426088 : null;
    } catch (exception) {
      enterKeyId = 4295426277;
    }

    TextEditingController _controller = TextEditingController();

    void removeListItem(TodoCategory category, int index) {
      if (category == TodoCategory.Todo) {
        TodoItem doneItem = todoList[index];
        todoList.removeAt(index);
        doneItem.doneChange();
        doneList.add(doneItem);
      }

      if (category == TodoCategory.Done) {
        doneList.removeAt(index);
      }

      setState(() {
        _todoWidget = TodoWidget(todoList);
        _doneWidget = DoneWidget(doneList);
      });
    }

    return Column(
      children: <Widget>[
        RawKeyboardListener(
          focusNode: FocusNode(),
          onKey: (keyEvent) {
            print(keyEvent.logicalKey.keyId);
            print(_controller.text);
            if ((keyEvent.logicalKey.keyId == enterKeyId) &&
                _controller.text.length != 0) {
              todoList.add(TodoItem(
                _controller.text,
                index: todoList.length,
                removeFunction: removeListItem,
                category: TodoCategory.Todo,
              ));
              setState(() {
                _todoWidget = TodoWidget(todoList);
              });
            }
          },
          child: TextField(
            controller: _controller,
            textInputAction: TextInputAction.done,
            maxLines: 1,
            onSubmitted: (String text) {
              try {
                if (!Platform.isAndroid) return;
              } catch (exception) {
                return;
              }
              todoList.add(TodoItem(
                _controller.text,
                index: todoList.length,
                removeFunction: removeListItem,
                category: TodoCategory.Todo,
              ));
              _controller.clear();
            },
          ),
        ),
        SizedBox(
          height: 5,
        ),
        ListWidget(todoWidget: _todoWidget, doneWidget: _doneWidget)
      ],
    );
  }
}

class ListWidget extends StatelessWidget {
  ListWidget({
    Key key,
    @required TodoWidget todoWidget,
    @required DoneWidget doneWidget,
  })  : _todoWidget = todoWidget,
        _doneWidget = doneWidget,
        super(key: key);

  final TodoWidget _todoWidget;
  final DoneWidget _doneWidget;

  @override
  Widget build(BuildContext context) {
    var _children = <Widget>[
      _todoWidget,
      SizedBox(
        width: MediaQuery.of(context).size.width * 0.02,
        height: MediaQuery.of(context).size.height * 0.02,
      ),
      _doneWidget
    ];

    return MediaQuery.of(context).orientation == Orientation.portrait
        ? Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: _children,
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _children,
          );
  }
}

class TodoWidget extends StatefulWidget {
  final List<TodoItem> _todoList;

  TodoWidget(this._todoList);

  @override
  _TodoWidgetState createState() => _TodoWidgetState();
}

class _TodoWidgetState extends State<TodoWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).orientation == Orientation.portrait
          ? MediaQuery.of(context).size.width * 0.8
          : MediaQuery.of(context).size.width * 0.39,
      child: Stack(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(top: 20, bottom: 5, left: 15, right: 5),
            margin: EdgeInsets.only(top: 10),
            decoration: BoxDecoration(
                border: Border.all(), borderRadius: BorderRadius.circular(5)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: widget._todoList.length != 0
                  ? widget._todoList
                  : [Text('등록 된 사항이 없습니다.')],
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 10),
            padding: EdgeInsets.symmetric(vertical: 3, horizontal: 5),
            decoration: BoxDecoration(
                border: Border.all(),
                borderRadius: BorderRadius.circular(15),
                color: Colors.indigo),
            child: Text(
              'ToDo',
              style: TextStyle(color: Colors.white),
            ),
          )
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class TodoItem extends StatelessWidget {
  final String _todoTitle;
  final int index;
  TodoCategory category;
  Function removeFunction;

  TodoItem(this._todoTitle, {this.index, this.removeFunction, this.category});

  void doneChange() {
    this.category = TodoCategory.Done;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.play_arrow,
          size: 15,
        ),
        SizedBox(
          width: 3,
        ),
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Text(
              _todoTitle,
              style: TextStyle(fontSize: 18),
            ),
          ),
        ),
        GestureDetector(
          child: Icon(
            Icons.clear,
            size: 15,
          ),
          onTap: () {
            removeFunction(category, index);
          },
        )
      ],
    );
  }
}

class DoneWidget extends StatefulWidget {
  final List<TodoItem> _doneList;
  DoneWidget(this._doneList);

  @override
  _DoneWidgetState createState() => _DoneWidgetState();
}

class _DoneWidgetState extends State<DoneWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).orientation == Orientation.portrait
          ? MediaQuery.of(context).size.width * 0.8
          : MediaQuery.of(context).size.width * 0.39,
      child: Stack(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(top: 20, bottom: 5, left: 15, right: 5),
            margin: EdgeInsets.only(top: 10),
            decoration: BoxDecoration(
                border: Border.all(), borderRadius: BorderRadius.circular(5)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: widget._doneList.length != 0
                  ? widget._doneList
                  : [Text('등록 된 사항이 없습니다.')],
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 10),
            padding: EdgeInsets.symmetric(vertical: 3, horizontal: 5),
            decoration: BoxDecoration(
                border: Border.all(),
                borderRadius: BorderRadius.circular(15),
                color: Colors.green),
            child: Text(
              'Done',
              style: TextStyle(color: Colors.white),
            ),
          )
        ],
      ),
    );
  }
}

class Title extends StatelessWidget {
  const Title({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    _isPortrait() {
      return MediaQuery.of(context).orientation == Orientation.portrait;
    }

    bool _isAndroid;

    try {
      _isAndroid = Platform.isAndroid;
    } catch (e) {
      _isAndroid = false;
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Container(
          height: _isAndroid ? _isPortrait() ? 50 : 100 : 300,
          child: Image.asset('images/online_lightning_talk.png'),
        ),
        Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Text(
                'Flutter로 Todo App과 Web을\n하나의 코드로 만들어보았습니다.',
                style: TextStyle(
                    fontSize: _isPortrait() ? 13 : 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade700),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                '- 유병욱',
                style: TextStyle(
                  fontSize: _isPortrait() ? 8 : 20,
                  color: Colors.grey.shade700,
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}

class GdgWebTechLogo extends StatelessWidget {
  const GdgWebTechLogo({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Image.asset('images/gdg_korea_webtech.png'),
    );
  }
}

enum TodoCategory { Todo, Done }
