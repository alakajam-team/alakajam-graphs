package lib;

/**
Possible divisions in Alakajams.
 */
@:enum
abstract Division(Int) from Int to Int {
  var SOLO = 0;
  var TEAM = 1;
  var UNRANKED = 2;
}
