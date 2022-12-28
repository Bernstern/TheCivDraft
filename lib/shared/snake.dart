List<int> createReverseSnakeOrder(int numPlayers, int numGames) {
  List<int> order = [];
  bool reverse = true;
  for (int _ in Iterable<int>.generate(numGames)) {
    if (reverse) {
      order.addAll(Iterable<int>.generate(numPlayers).toList().reversed);
    } else {
      order.addAll(Iterable<int>.generate(numPlayers).toList());
    }
    reverse = !reverse;
  }
  return order;
}
