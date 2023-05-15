import "package:rhythm_practice_helper/stickings_settings.dart";
import "limb_settings.dart";
import "dart:math" show Random, min;

int maxBouncesInContext(StickingsSettings state, String partialSticking) {
  int subdivisionsLeft = state.rhythmicConstraint.active
      ? state.rhythmicConstraint
          .subdivisionsUntilNextHit(partialSticking.length)
      : state.stickingLength - partialSticking.length;
  return subdivisionsLeft;
}

bool rhythmicHitRequired(StickingsSettings state, String partialSticking) {
  return state.rhythmicConstraint.active
      ? state.rhythmicConstraint.rhythm[partialSticking.length]
      : false;
}

List<Stick> getPotentialSticks(
    StickingsSettings state, String partialSticking) {
  String lastUsed = partialSticking.isNotEmpty
      ? partialSticking[partialSticking.length - 1]
      : '';
  List<Stick> usingSticks = rhythmicHitRequired(state, partialSticking)
      ? state.rhythmicConstraint.limbs.usingSticks
      : state.limbs.usingSticks;
  List<Stick> potentialSticks = partialSticking.isEmpty
      ? usingSticks
      : usingSticks
          .where((stick) =>
              stick.symbol != lastUsed &&
              stick.minBounces <= maxBouncesInContext(state, partialSticking))
          .toList();
  return potentialSticks;
}

List<String> generateRandomStickings(StickingsSettings state) {
  List<String> stickings = [];
  final random = Random();
  int failures = 0;
  int maxFailures = 2000;
  while (stickings.length < state.maxNumberOfStickings) {
    String sticking = '';
    bool failure = false;
    while (sticking.length < state.stickingLength) {
      List<Stick> potentialSticks = getPotentialSticks(state, sticking);
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

List<String> generateStickings(StickingsSettings state,
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
          state.limbs.stickMap[partialSticking[0]]!.maxBounces) {
        return [];
      }
    }
    return [partialSticking];
  }
  if (partialSticking.length > state.stickingLength) {
    return [];
  }

  List<Stick> potentialSticks = getPotentialSticks(state, partialSticking);
  for (Stick stick in potentialSticks) {
    int maxBounces =
        min(stick.maxBounces, maxBouncesInContext(state, partialSticking));
    for (int bounces = stick.minBounces; bounces <= maxBounces; bounces++) {
      String sticking = partialSticking + stick.symbol * bounces;
      possibleStickings += generateStickings(state, sticking);
    }
  }

  if (partialSticking == '' && state.shuffle) {
    possibleStickings.shuffle();
  }
  return possibleStickings;
}
