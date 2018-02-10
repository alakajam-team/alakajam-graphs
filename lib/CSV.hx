package lib;

/**
CSV (comma-separated values) reader. Actual format should use semicolons.
 */
class CSV {
  public static function get(name:String):Array<Array<String>> {
    return sys.io.File.getContent(name) // read file
      .split("\n") // split into lines
      .slice(1) // strip header
      .filter(l -> l != "") // remove empty lines
      .map(l -> l.split(";")); // split lines
  }
}
