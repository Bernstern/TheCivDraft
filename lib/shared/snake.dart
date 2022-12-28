class SnakeDraft {
  final int numPlayers;
  final int numGames;
  final Map<int, List<int>> order = {};

  SnakeDraft(this.numPlayers, this.numGames) {
    bool reverse = true;
    for (int game in Iterable<int>.generate(numGames)) {
      if (reverse) {
        order[game] = Iterable<int>.generate(numPlayers).toList().reversed.toList();
      } else {
        order[game] = Iterable<int>.generate(numPlayers).toList();
      }
      reverse = !reverse;
    }
  }

  int get activeGame {
    if (order.isEmpty) return -1;
    return order.keys.reduce((curr, next) => curr < next ? curr : next);
  }

  int get activePlayer {
    if (order.isEmpty) return -1;
    return order[activeGame]![0];
  }

  bool get isDone => order.isEmpty;

  @override
  String toString() {
    return "SnakeDraft: $order";
  }

  void advance() {
    order[activeGame]!.removeAt(0);
    if (order[activeGame]!.isEmpty) {
      order.remove(activeGame);
    }
  }
}
