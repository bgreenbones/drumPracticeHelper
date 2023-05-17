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

bool stickingRequiresAlternating(String sticking, StickingsSettings state) {
  if (sticking[0] == sticking[sticking.length - 1]) {
    int beginningBounceLength = 1;
    int endingBounceLength = 1;

    while (beginningBounceLength < sticking.length &&
        sticking[beginningBounceLength] == sticking[0]) {
      beginningBounceLength++;
    }
    while (endingBounceLength < sticking.length &&
        sticking[sticking.length - 1 - endingBounceLength] ==
            sticking[sticking.length - 1]) {
      endingBounceLength++;
    }

    if (beginningBounceLength + endingBounceLength >
        state.limbs.stickMap[sticking[0]]!.maxBounces) {
      return true;
    }
  }
  return false;
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
    if (state.avoidNecessaryAlternation &&
        stickingRequiresAlternating(sticking, state)) {
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
  if (state.generateRandomStickings) {
    return generateRandomStickings(state);
  }
  List<String> possibleStickings = [];

  if (partialSticking.length == state.stickingLength) {
    if (state.avoidNecessaryAlternation &&
        stickingRequiresAlternating(partialSticking, state)) {
      return [];
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

  return possibleStickings;
}
