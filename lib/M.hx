package lib;

using StringTools;

/**
Utility maths and formatting functions.
 */
class M {
  public static function dateOf(f:String):Date {
    return Date.fromString(f.substr(0, 19));
  }
  
  public static function pc(v:Float):String {
    return '${v * 100}%';
  }
  
  public static function rpc(v:Float):String {
    return '${100 - v * 100}%';
  }
  
  public static function ord(i:Int):String {
    var s = '$i';
    return s + (switch (s) {
        case "0": "th";
        case [_.endsWith("11"), _.endsWith("1")] => [false, true]: "st";
        case [_.endsWith("12"), _.endsWith("2")] => [false, true]: "nd";
        case [_.endsWith("13"), _.endsWith("3")] => [false, true]: "rd";
        case _: "th";
      });
  }
  
  public static function prec(f:Float, d:Int):String {
    return '${Std.int(f * d) / d}';
  }
  
  public static function avg<T:Float>(a:Array<T>):Float {
    var count = 0;
    var sum = (cast 0:T);
    if (a.length == 0) {
      return sum;
    }
    for (e in a) {
      sum += e;
      count++;
    }
    return sum / count;
  }
  
  public static function nzavg<T:Float>(a:Array<T>):Float {
    var count = 0;
    var sum = (cast 0:T);
    for (e in a) {
      sum += e;
      if (e != (cast 0:T)) count++;
    }
    if (count == 0) return 0;
    return sum / count;
  }
  
  public static function nnavg<T:Float>(a:Array<T>):Float {
    var count = 0;
    var sum = (cast 0:T);
    for (e in a) {
      sum += e;
      if (e >= 0) count++;
    }
    if (count == 0) return 0;
    return sum / count;
  }
  
  public static function posavg<T:Float>(a:Array<T>):Float {
    var count = 0;
    var sum = (cast 0:T);
    for (e in a) {
      sum += e;
      if (e > 0) count++;
    }
    if (count == 0) return 0;
    return sum / count;
  }
  
  public static function min<T:Float>(a:Array<T>):T {
    var v = a[0];
    for (i in 1...a.length) {
      if (a[i] < v) {
        v = a[i];
      }
    }
    return v;
  }
  
  public static function max<T:Float>(a:Array<T>):T {
    var v = a[0];
    for (i in 1...a.length) {
      if (a[i] > v) {
        v = a[i];
      }
    }
    return v;
  }
  
  public static function minI<T:Float>(a:Array<T>):Int {
    var vi = 0;
    var v = a[0];
    for (i in 1...a.length) {
      if (a[i] < v) {
        vi = i;
        v = a[i];
      }
    }
    return vi;
  }
  
  public static function maxI<T:Float>(a:Array<T>):Int {
    var vi = 0;
    var v = a[0];
    for (i in 1...a.length) {
      if (a[i] > v) {
        vi = i;
        v = a[i];
      }
    }
    return vi;
  }
  
  public static function sel<T>(a:Array<Array<T>>, i:Int):Array<T> {
    return [ for (e in a) e[i] ];
  }
  
  public static function rev<T>(a:Array<T>):Array<T> {
    var a = a.copy();
    a.reverse();
    return a;
  }
  
  public static function sorted<T>(a:Array<T>, f:T->T->Int):Array<T> {
    var a = a.copy();
    a.sort(f);
    return a;
  }
  
  public static function abs<T:Float>(v:T):T {
    return (v < 0 ? -v : v);
  }
  
  public static function sim(x:Float, y:Float):Float {
    return 1 - abs(x - y);
  }
}
