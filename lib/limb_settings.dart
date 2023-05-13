class Stick {
  Stick(
      {required this.symbol,
      this.maxBounces = 2,
      this.minBounces = 1,
      this.inUse = true});
  String symbol;
  int maxBounces;
  int minBounces;
  bool inUse;

  @override
  bool operator ==(Object b) {
    return b is Stick && symbol == b.symbol;
  }

  @override
  int get hashCode => symbol.hashCode;
}

class Limbs {
  Stick right = Stick(symbol: 'R', maxBounces: 3, minBounces: 1, inUse: true);
  Stick left = Stick(symbol: 'L', maxBounces: 2, minBounces: 1, inUse: true);
  Stick kick = Stick(symbol: 'K', maxBounces: 2, minBounces: 1, inUse: false);
  Stick hat = Stick(symbol: 'H', maxBounces: 1, minBounces: 1, inUse: false);

  late List<Stick> availableSticks = [right, left, kick, hat];
  late List<Stick> usingSticks =
      availableSticks.where((element) => element.inUse).toList();
  late List<Stick> unusedSticks =
      availableSticks.where((element) => !element.inUse).toList();

  Map<String, Stick> get stickMap =>
      {for (Stick s in availableSticks) s.symbol: s};

  List<Stick> getSomeSticks(int numberOfSticks) {
    return availableSticks.sublist(0, numberOfSticks);
  }
}
