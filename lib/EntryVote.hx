package lib;

using lib.M;

/**
User vote on a game entry.
 */
class EntryVote {
  /**
Parses votes from a CSV file.
   */
  public static function csv(name:String):Array<EntryVote> {
    return [ for (f in CSV.get(name)) {
        var r = new EntryVote();
        r.id = Std.parseInt(f[0]);
        r.entry_id = Std.parseInt(f[1]);
        r.event_id = Std.parseInt(f[2]);
        r.user_id = Std.parseInt(f[3]);
        r.votes = [
             Std.parseInt(f[4])
            ,Std.parseInt(f[5])
            ,Std.parseInt(f[6])
            ,Std.parseInt(f[7])
            ,Std.parseInt(f[8])
            ,Std.parseInt(f[9])
          ];
        r.created_at = (f[10]:String).dateOf();
        r.updated_at = (f[11]:String).dateOf();
        r;
      } ];
  }
  
  public var id:Int;
  public var entry_id:Int;
  public var event_id:Int;
  public var user_id:Int;
  public var votes:Array<Int>;
  public var created_at:Date;
  public var updated_at:Date;
  
  public var voteDay(get, null):Int;
  private inline function get_voteDay():Int {
    if (this.voteDay == null) {
      this.voteDay = Std.int(
          (updated_at.getTime() - Main.JAM.phaseDates[Phase.EntryVoting].getTime())
            / (1000 * 60 * 60 * 24)
        );
    }
    return this.voteDay;
  }
  
  public var voteAvg(get, null):Float;
  private inline function get_voteAvg():Float {
    if (this.voteAvg == null) {
      this.voteAvg = votes.avg();
    }
    return this.voteAvg;
  }
  
  public function new() {}
}
