import 'package:flutter/material.dart';

class MaruBatsu extends StatefulWidget {
  @override
  _MaruBatsuState createState() => _MaruBatsuState();
}

enum PlayerTern {
  Maru,
  Batsu,
}

class _MaruBatsuState extends State<MaruBatsu> {
  List<List<Cell>> cells;
  PlayerTern playerTern;

  @override
  initState() {
    super.initState();
    reset();
  }

  reset() {
    setState(() {
      this.playerTern = PlayerTern.Maru;
      this.cells = [
        [
          Cell.init(),
          Cell.init(),
          Cell.init(),
        ],
        [
          Cell.init(),
          Cell.init(),
          Cell.init(),
        ],
        [
          Cell.init(),
          Cell.init(),
          Cell.init(),
        ]
      ];
    });
  }

  selectCell(int r, int c) {
    setState(() {
      if (this.cells[r][c].status != CellStatus.None) return;
      if (this.playerTern == PlayerTern.Maru) {
        this.cells[r][c].status = CellStatus.Maru;
        this.playerTern = PlayerTern.Batsu;
      } else {
        this.cells[r][c].status = CellStatus.Batsu;
        this.playerTern = PlayerTern.Batsu;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("⭕️ ❌"),
        ),
        body: Column(children: [
          Center(
              child: Column(
            mainAxisSize: MainAxisSize.min,
            children: cells
                .asMap()
                .entries
                .map((rowEntry) => Row(
                    mainAxisSize: MainAxisSize.min,
                    children: rowEntry.value
                        .asMap()
                        .entries
                        .map((columnEntry) => GestureDetector(
                            onTap: () {
                              this.selectCell(rowEntry.key, columnEntry.key);
                            },
                            child: CellWidget(columnEntry.value)))
                        .toList()))
                .toList(),
          )),
          Container(
            margin: EdgeInsets.only(top: 10),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              RaisedButton(
                child: Text('CLEAR'),
                onPressed: () {
                  this.reset();
                },
              )
            ]),
          )
        ]));
  }
}

class CellWidget extends StatelessWidget {
  final Cell cell;

  CellWidget(this.cell);

  @override
  Widget build(BuildContext context) {
    Text text;
    switch (this.cell.status) {
      case CellStatus.Maru:
        text = Text('⭕️', style: TextStyle(fontSize: 50));
        break;
      case CellStatus.Batsu:
        text = Text('❌', style: TextStyle(fontSize: 50));
        break;
      default:
        text = Text('-', style: TextStyle(fontSize: 50));
        break;
    }

    return Container(width: 80, height: 80, child: Center(child: text));
  }
}

enum CellStatus {
  None,
  Maru,
  Batsu,
}

class Cell {
  CellStatus status;

  Cell(this.status);

  Cell.init() {
    this.status = CellStatus.None;
  }
}
