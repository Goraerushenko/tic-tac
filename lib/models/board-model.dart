class Board {
  Board(){
    for(int i=0; i < length; i++) {
      for(int j=0; j < boardLines.length; j++) {

      }
    }
  };

  List<BoardLine> boardLines;
  int get length => 3;
  bool get isDraw => boardLines.every((BoardLine item) => item.isLineNotEmpty);

}

class BoardLine {
  BoardLine({
    this.line
  });
  final List<Cell> line;
  int get length => 3;
  bool get isLineNotEmpty => line.every((Cell item) => item.isNotEmpty);
}

class Cell {
  Cell({
    this.cell = "",
    this.xc,
    this.yc,
  });
  final String cell;
  final int xc;
  final int yc;
  bool get isNotEmpty => cell != null && cell != "";
}