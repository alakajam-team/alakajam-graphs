package lib;

@:enum
abstract Phase(Int) from Int to Int {
  var ThemeVoting = 1;
  var ThemeShortlist = 2;
  var CompoStart = 3;
  var CompoEnd = 4;
  var EntryVoting = 5;
  var Results = 6;
}
