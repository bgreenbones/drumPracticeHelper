import "possible_stickings.dart";
import "dart:math";

class Stick {
  Stick({required this.symbol, this.maxBounces = 2, this.minBounces = 1});
  String symbol;
  int maxBounces;
  int minBounces;
}

int maxBouncesInContext(PossibleStickingsState state, String partialSticking) {
  int subdivisionsLeft = state.applyRhythmicConstraint
      ? state.rhythmicConstraint
          .subdivisionsUntilNextHit(partialSticking.length)
      : state.stickingLength - partialSticking.length;
  return subdivisionsLeft;
}

bool rhythmicHitRequired(PossibleStickingsState state, String partialSticking) {
  return state.applyRhythmicConstraint
      ? state.rhythmicConstraint.rhythm[partialSticking.length]
      : false;
}

List<String> generateRandomStickings(PossibleStickingsState state) {
  List<String> stickings = [];
  final random = Random();
  int failures = 0;
  int maxFailures = 2000;
  while (stickings.length < state.maxNumberOfStickings) {
    String sticking = '';
    bool failure = false;
    while (sticking.length < state.stickingLength) {
      String lastUsed = '';
      List<Stick> potentialSticks = sticking.isEmpty
          ? state.sticks.values.toList()
          : state.sticks.values
              .toList()
              .where((stick) =>
                  stick.symbol != lastUsed &&
                  stick.minBounces <= maxBouncesInContext(state, sticking))
              .toList();
      if (potentialSticks.isEmpty) {
        failure = true;
        break;
      }
      Stick stick = potentialSticks[random.nextInt(potentialSticks.length)];
      int maxBounces =
          min(stick.maxBounces, maxBouncesInContext(state, sticking));
      int bounces =
          random.nextInt(maxBounces - stick.minBounces + 1) + stick.minBounces;
      sticking = sticking + stick.symbol * bounces;
    }
    if (stickings.contains(sticking)) {
      failure = true;
    }
    if (failure) {
      failures++;
      if (failures > maxFailures) {
        break;
      }
    } else {
      stickings.add(sticking);
      failures = 0;
    }
  }
  return stickings;
}

List<String> generateStickings(PossibleStickingsState state,
    [String partialSticking = '']) {
  if (state.maxNumberOfStickings > -1) {
    return generateRandomStickings(state);
  }
  List<String> possibleStickings = [];

  if (partialSticking.length == state.stickingLength) {
    if (state.avoidNecessaryAlternation &&
        partialSticking[0] == partialSticking[partialSticking.length - 1]) {
      int beginningBounceLength = 1;
      int endingBounceLength = 1;

      while (beginningBounceLength < partialSticking.length &&
          partialSticking[beginningBounceLength] == partialSticking[0]) {
        beginningBounceLength++;
      }
      while (endingBounceLength < partialSticking.length &&
          partialSticking[partialSticking.length - 1 - endingBounceLength] ==
              partialSticking[partialSticking.length - 1]) {
        endingBounceLength++;
      }

      if (beginningBounceLength + endingBounceLength >
          state.sticks[partialSticking[0]]!.maxBounces) {
        return [];
      }
    }
    return [partialSticking];
  }
  if (partialSticking.length > state.stickingLength) {
    return [];
  }

  List<Stick> potentialSticks = partialSticking.isEmpty
      ? state.sticks.values.toList()
      : state.sticks.values
          .toList()
          .where((stick) =>
              stick.symbol != partialSticking[partialSticking.length - 1])
          .toList();
  for (Stick stick in potentialSticks) {
    for (int bounces = stick.minBounces;
        bounces <= stick.maxBounces;
        bounces++) {
      String sticking = partialSticking + stick.symbol * bounces;
      possibleStickings += generateStickings(state, sticking);
    }
  }

  if (partialSticking == '' && state.shuffle) {
    possibleStickings.shuffle();
  }
  return possibleStickings;
}
