import "dart:ffi";

import "stickings.dart";

class RhythmicConstraint {
  List<Stick> playRhythmWith = [];
  List<bool> rhythm = [];
  int subdivisionsUntilNextHit(int currentSubdivision) {
    if (currentSubdivision >= rhythm.length) {
      return -1;
    }
    for (int i = 0; i < rhythm.length; i++) {
      if (rhythm[i] && i >= currentSubdivision) {
        return i - currentSubdivision;
      }
    }
    return rhythm.length - currentSubdivision;
  }
}
