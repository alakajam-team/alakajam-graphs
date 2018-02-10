package lib;

using lib.M;

class Jam {
  /**
Parses a jam from a JSON file.
   */
  public static function json(name:String):Jam {
    var d:haxe.DynamicAccess<Dynamic> = haxe.Json.parse(sys.io.File.getContent(name));
    var r = new Jam();
    r.name = name;
    var phases:haxe.DynamicAccess<String> = d["phases"];
    r.phaseDates = [
         ThemeVoting => (phases["themeVoting"] != null ? Date.fromString(phases["themeVoting"]) : null)
        ,ThemeShortlist => (phases["themeShortlist"] != null ? Date.fromString(phases["themeShortlist"]) : null)
        ,CompoStart => (phases["compoStart"] != null ? Date.fromString(phases["compoStart"]) : null)
        ,CompoEnd => (phases["compoEnd"] != null ? Date.fromString(phases["compoEnd"]) : null)
        ,EntryVoting => (phases["entryVoting"] != null ? Date.fromString(phases["entryVoting"]) : null)
        ,Results => (phases["results"] != null ? Date.fromString(phases["results"]) : null)
      ];
    r.categories = d["categories"];
    var files:haxe.DynamicAccess<String> = d["files"];
    r.entries = files["entries"] != null ? Entry.csv(files["entries"]) : null;
    r.entryVotes = files["entryVotes"] != null ? EntryVote.csv(files["entryVotes"]) : null;
    return r;
  }
  
  public var name:String;
  public var phaseDates:Map<Phase, Date>;
  public var categories:Array<String>;
  public var entries:Array<Entry>;
  public var entryVotes:Array<EntryVote>;
  
  // entries in ranked categories (solo, team), but not necessarily with votes
  public var ranked:Array<Entry>;
  
  // ranked division entries, with at least 10 votes
  public var rankedDivs:Map<Division, Array<Entry>>;
  
  // sorted result ladders for each ranked division and category
  public var ladders:Map<Division, Map<String, Array<Entry>>>;
  
  // highest number of comments on an entry
  public var maxCommentCount:Int;
  
  // highest number of ratings on an entry
  public var maxRatingCount:Int;
  
  // number of times any given category rating is the best for an entry
  public var bestCategoryRating:Array<Int>;
  
  // number of times any given category rating is the worst for an entry
  public var worstCategoryRating:Array<Int>;
  
  // number of times any given category ranking is the best for an entry
  public var bestCategoryRanking:Array<Int>;
  
  // number of times any given category ranking is the worst for an entry
  public var worstCategoryRanking:Array<Int>;
  
  // average category rating
  public var categoryRatingAvg:Array<Float>;
  
  // vote spread (highest category stars - lowest)
  public var spread:Array<Int>;
  
  // category correlation (degree of rating similarity of any two categories)
  public var categoryCorrelation:Array<Array<Float>>;
  
  // category correlation (degree of ranking similarity of any two categories)
  public var categoryCorrelationRanking:Array<Array<Float>>;
  
  // scatter plot (votes given / rating)
  public var ratingRes:Array<GraphPoint>;
  
  // scatter plot (comments received / rating)
  public var commentRes:Array<GraphPoint>;
  
  // scatter plot (votes given / ranking)
  public var ratingPlc:Array<GraphPoint>;
  
  // scatter plot (comments received / ranking)
  public var commentPlc:Array<GraphPoint>;
  
  // average vote on day
  public var dayAvg:Array<Float>;
  
  // number of votes on day
  public var dayVotes:Array<Int>;
  
  // times each vote value (1 - 10) was used
  public var voteFreq:Array<Int>;
  
  public function new() {}
  
  public function stats():Void {
    ranked = entries.filter(e -> e.division != UNRANKED);
    rankedDivs = [ for (div in [Division.SOLO, Division.TEAM])
        div => entries.filter(e -> e.division == div && e.votes.length >= 10)
      ];
    ladders = [ for (div in [Division.SOLO, Division.TEAM]) div => [ for (i in 0...categories.length)
        categories[i] => rankedDivs[div]
          .filter(e -> e.results[i] > 0)
          .sorted((a, b) -> (a.results[i] > b.results[i] ? -1 : (a.results[i] < b.results[i] ? 1 : 0)))
      ] ];
    
    maxCommentCount = ranked.map(e -> e.comment_count).max();
    maxRatingCount = ranked.map(e -> e.votes.length).max();
    bestCategoryRating = [ for (c in categories) 0 ];
    worstCategoryRating = [ for (c in categories) 0 ];
    bestCategoryRanking = [ for (c in categories) 0 ];
    worstCategoryRanking = [ for (c in categories) 0 ];
    ranked = [for (e in ranked) {
        e.placements = [ for (c in categories) ladders[e.division][c].indexOf(e) ];
        if (e.placements.filter(p -> p == -1).length == 6) {
          // remove games not ranked in any category
          continue;
        }
        bestCategoryRating[e.results.maxI()]++;
        worstCategoryRating[e.results.minI()]++;
        bestCategoryRanking[e.placements.maxI()]++;
        worstCategoryRanking[e.placements.minI()]++;
        e;
      } ];
    
    categoryRatingAvg = [ for (i in 0...categories.length) [ for (e in ranked) e.results[i] ].posavg() ];
    
    spread = [ for (i in 0...10) 0 ];
    for (v in entryVotes) {
      var nonZero = v.votes.filter(v -> v > 0);
      spread[nonZero.max() - nonZero.min()]++;
    }
    
    categoryCorrelation = [ for (i in 0...categories.length) [ for (j in 0...categories.length)
        [ for (e in ranked) if (e.results[5 - i] != 0 && e.results[j] != 0)
          M.sim(e.results[5 - i] / 10, e.results[j] / 10) ].nzavg()
        ]
      ];
    categoryCorrelationRanking = [ for (i in 0...categories.length) [ for (j in 0...categories.length)
        [ for (e in ranked) if (e.placements[5 - i] != -1 && e.placements[j] != -1)
          M.sim(1 - e.placements[5 - i] / rankedDivs[e.division].length, 1 - e.placements[j] / rankedDivs[e.division].length) ].nzavg()
        ]
      ];
    
    ratingRes = [ for (e in ranked) {x: (cast e.votes.length:Float), y: e.results.nzavg()} ];
    commentRes = [ for (e in ranked) {x: (cast e.comment_count:Float), y: e.results.nzavg()} ];
    
    ratingPlc = [ for (e in ranked) {x: (cast e.votes.length:Float), y: 1 - e.placements.nnavg() / rankedDivs[e.division].length} ];
    commentPlc = [ for (e in ranked) {x: (cast e.comment_count:Float), y: 1 - e.placements.nnavg() / rankedDivs[e.division].length} ];
    
    dayAvg = [ for (i in 0...14) entryVotes.filter(v -> v.voteDay == i).map(v -> v.votes.nzavg()).avg() ];
    dayVotes = [ for (i in 0...14) 0 ];
    voteFreq = [ for (i in 1...11) 0 ];
    for (v in entryVotes) {
      dayVotes[v.voteDay]++;
      for (vv in v.votes) if (vv != 0) voteFreq[vv - 1]++;
    }
  }
}
