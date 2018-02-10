package lib;

using lib.M;

/**
Game entry for a jam.
 */
class Entry {
  /**
Parses entries from a CSV file.
   */
  public static function csv(name:String):Array<Entry> {
    return [ for (f in CSV.get(name)) {
        var r = new Entry();
        r.id = Std.parseInt(f[0]);
        r.event_id = Std.parseInt(f[1]);
        r.event_name = f[2];
        r.name = f[3];
        r.title = f[4];
        r.description = f[5];
        r.links = null; // f[6];
        r.pictures = null; // f[7];
        r.published_at = (f[8]:String).dateOf();
        r.comment_count = Std.parseInt(f[9]);
        r.created_at = (f[10]:String).dateOf();
        r.updated_at = (f[11]:String).dateOf();
        r.platforms = null; // f[12];
        r.external_event = null; // f[13];
        r.feedback_score = Std.int(Std.parseFloat(f[14]));
        r.division = (switch (f[15]) {
            case "solo": Division.SOLO;
            case "team": Division.TEAM;
            case "unranked": Division.UNRANKED;
            case _: throw "invalid division";
          });
        r.allow_anonymous = f[16] == "t";
        r;
      } ];
  }
  
  public var id:Int;
  public var event_id:Int;
  public var event_name:String;
  public var name:String;
  public var title:String;
  public var description:String;
  public var links:Array<String>;
  public var pictures:Array<String>;
  public var published_at:Date;
  public var comment_count:Int;
  public var created_at:Date;
  public var updated_at:Date;
  public var platforms:Array<String>;
  public var external_event:String;
  public var feedback_score:Int;
  public var division:Division;
  public var allow_anonymous:Bool;
  
  public var placements:Array<Int>;
  
  public var votes(get, null):Array<EntryVote>;
  private inline function get_votes():Array<EntryVote> {
    if (this.votes == null) {
      this.votes = [ for (v in Main.JAM.entryVotes) if (v.entry_id == id) v ];
    }
    return this.votes;
  }
  
  public var results(get, null):Array<Float>;
  private function get_results():Array<Float> {
    if (this.results == null) {
      this.results = [ for (i in 0...Main.JAM.categories.length)
          [ for (v in votes) v.votes[i] ].posavg()
        ];
    }
    return this.results;
  }
  
  public function new() {}
}
