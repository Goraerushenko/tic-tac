import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';

class Board {
  List<Cell> board;

  Board() {
    board = [
      Cell(cell: 0),
      Cell(cell: 1),
      Cell(cell: 2),
      Cell(cell: 3),
      Cell(cell: 4),
      Cell(cell: 5),
      Cell(cell: 6),
      Cell(cell: 7),
      Cell(cell: 8),
    ];
  }
  int get boardLength => board.length;

  AudioCache _player = AudioCache();
  String currentPlayer;

  Future<AudioPlayer> get currentSound async => currentPlayer == 'x'
    ? await _player.play('x.mp3')
    : _player.play('o.mp3');

  Cell operator[](int index) {
    return board[index];
  }

  List<Cell> emptyIndices() {
    return board.where((c) => c.cell != "o" && c.cell != "x");
  }
  bool get isDraw => board.every((Cell cell) => cell.isNotEmptyCell);

  List<Offset> isWinner(String player) {
    List<int> _isWinner;
    if(board[0].cell == player && board[1].cell == player && board[2].cell == player) {
      _isWinner = [0, 2];
    }
    if (board[3].cell == player && board[4].cell == player && board[5].cell == player) {
      _isWinner = [3, 5];
    }
    if (board[6].cell == player && board[7].cell == player && board[8].cell == player) {
      _isWinner = [6, 8];
    }
    if (board[0].cell == player && board[3].cell == player && board[6].cell == player) {
      _isWinner = [0, 6];
    }
    if (board[1].cell == player && board[4].cell == player && board[7].cell == player) {
      _isWinner = [1, 7];
    }
    if (board[2].cell == player && board[5].cell == player && board[8].cell == player) {
      _isWinner = [2, 8];
    }
    if (board[0].cell == player && board[4].cell == player && board[8].cell == player) {
      _isWinner = [0, 8];
    }
    if (board[2].cell == player && board[4].cell == player && board[6].cell == player) {
      _isWinner = [2, 6];
    }

    if (_isWinner != null) {
      RenderBox _f = board[_isWinner[0]].key.currentContext.findRenderObject();
      RenderBox _s = board[_isWinner[1]].key.currentContext.findRenderObject();
      Offset _fOff = _f.localToGlobal(Offset.zero);
      Offset _sOff = _s.localToGlobal(Offset.zero);

      return [Offset(_fOff.dx + 2, _fOff.dy + 3), Offset(_sOff.dx + 2, _sOff.dy + 3) ];
    }
    return null;
  }

}

class Cell {
  Cell({
    this.cell,
  });

  final GlobalKey key = GlobalKey();
  dynamic cell;

  bool get isNotEmptyCell => cell.runtimeType.toString() == 'String';
  bool get isEmptyCell => cell.runtimeType.toString() == 'int';

}