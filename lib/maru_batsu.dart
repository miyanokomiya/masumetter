import 'package:flutter/material.dart';
import 'cells.dart';

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
        this.playerTern = PlayerTern.Maru;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    GameStatus gameStatus = getGameStatus(this.cells);

    return Scaffold(
        appBar: AppBar(
          title: Text("⭕️ ❌"),
        ),
        body: Column(children: [
          StatusWidget(gameStatus),
          Container(
            margin: EdgeInsets.only(bottom: 40),
            child: Center(
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
                              behavior: HitTestBehavior.opaque,
                              onTap: () {
                                if (gameStatus == GameStatus.Playing)
                                  this.selectCell(
                                      rowEntry.key, columnEntry.key);
                              },
                              child: CellWidget(columnEntry.value)))
                          .toList()))
                  .toList(),
            )),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 40),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              RaisedButton(
                child: Text('CLEAR', style: TextStyle(fontSize: 30)),
                onPressed: () {
                  this.reset();
                },
              )
            ]),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 20),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              RaisedButton(
                child: Text('BACK', style: TextStyle(fontSize: 20)),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ]),
          )
        ]));
  }
}

class StatusWidget extends StatelessWidget {
  final GameStatus gameStatus;

  StatusWidget(this.gameStatus);

  @override
  Widget build(BuildContext context) {
    Text text;
    switch (this.gameStatus) {
      case GameStatus.WinMaru:
        text = Text('Win ⭕️', style: TextStyle(fontSize: 50));
        break;
      case GameStatus.WinBatsu:
        text = Text('Win ❌', style: TextStyle(fontSize: 50));
        break;
      case GameStatus.Draw:
        text = Text('Draw', style: TextStyle(fontSize: 50));
        break;
      default:
        text = Text('Playing', style: TextStyle(fontSize: 50));
        break;
    }

    return Container(
        height: 80,
        margin: EdgeInsets.only(bottom: 10),
        child: Center(child: text));
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

    return Container(width: 100, height: 100, child: Center(child: text));
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

enum GameStatus {
  Playing,
  WinMaru,
  WinBatsu,
  Draw,
}

GameStatus getGameStatus(List<List<Cell>> cells) {
  if (isSeries3(cells, CellStatus.Maru)) return GameStatus.WinMaru;
  if (isSeries3(cells, CellStatus.Batsu)) return GameStatus.WinBatsu;
  if (cells.every((row) => row.every((cell) => cell.status != CellStatus.None)))
    return GameStatus.Draw;
  return GameStatus.Playing;
}

bool isSeries3(List<List<Cell>> cells, CellStatus cellStatus) {
  return isMatrixSeriesN(cells, 3, (Cell cell) {
    return cell.status == cellStatus;
  });
}
