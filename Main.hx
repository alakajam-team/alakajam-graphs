import lib.*;

using lib.M;

class Main {
  public static var JAM:Jam;
  
  public static function main() {
    inline function usage(?exitCode:Int = 1) {
      Sys.println("usage: neko graph.n <jamFile.json> <outFile.html>");
      Sys.exit(exitCode);
    }
    switch (Sys.args()) {
      case ["-?"] | ["-h"] | ["--help"]: usage(0);
      case [jamFile, outFile]:
      JAM = Jam.json(jamFile);
      JAM.stats();
      var t = new haxe.Template(sys.io.File.getContent("assets/templ.html"));
      sys.io.File.saveContent(outFile, t.execute({graphs: [
          Graph.bar({
               name: "Category average"
              ,axisX: ""
              ,axisY: "games"
              ,values: cast JAM.categoryRatingAvg
              ,valueLabels: JAM.categoryRatingAvg.map(M.prec.bind(_, 100))
              ,ticksX: JAM.categories
            })
          ,Graph.scatter({
               name: "Popularity / rating"
              ,axisX: "ratings received"
              ,axisY: "rating"
              ,minX: 10
              ,maxY: 10
              ,values: JAM.ratingRes
              ,ticksX: [ for (i in 10...JAM.maxRatingCount + 1) (i % 5 == 0 || i == JAM.maxRatingCount ? '$i' : null) ]
              ,axesX: [{pos: 20, label: "10.0"}, {pos: 145, label: "5.0"}]
            })
          ,Graph.scatter({
               name: "Popularity / placement"
              ,axisX: "ratings received"
              ,axisY: "placement percentile"
              ,minX: 10
              ,values: JAM.ratingPlc
              ,ticksX: [ for (i in 10...JAM.maxRatingCount + 1) (i % 5 == 0 || i == JAM.maxRatingCount ? '$i' : null) ]
              ,axesX: [{pos: 20, label: "100%"}, {pos: 145, label: "50%"}]
            })
          ,Graph.bar({
               name: "Vote spread"
              ,addType: "axis-x-bottom"
              ,axisX: "spread"
              ,axisY: "votes"
              ,values: cast JAM.spread
              ,valueLabels: JAM.spread.map(Std.string)
              ,ticksX: [ for (i in 0...10) '$i' ]
            })
          ,Graph.matrix({
               name: "Category correlation"
              ,axisX: ""
              ,axisY: ""
              ,values: JAM.categoryCorrelation
              ,valueLabels: JAM.categoryCorrelation.map(r -> r.map(M.prec.bind(_, 100)))
              ,ticksX: JAM.categories
              ,ticksY: JAM.categories.rev()
            })
          ,Graph.matrix({
               name: "Category correlation 2"
              ,axisX: ""
              ,axisY: ""
              ,values: JAM.categoryCorrelationRanking
              ,valueLabels: JAM.categoryCorrelationRanking.map(r -> r.map(M.prec.bind(_, 100)))
              ,ticksX: JAM.categories
              ,ticksY: JAM.categories.rev()
            })
          ,Graph.bar({
               name: "Best category by rating"
              ,axisX: ""
              ,axisY: "games"
              // .slice(1) because 0 games have Overall best / worst rating
              ,values: cast JAM.bestCategoryRating.slice(1)
              ,valueLabels: JAM.bestCategoryRating.slice(1).map(Std.string)
              ,ticksX: JAM.categories.slice(1)
            })
          ,Graph.bar({
               name: "Worst category by rating"
              ,axisX: ""
              ,axisY: "games"
              // .slice(1) because 0 games have Overall best / worst rating
              ,values: cast JAM.worstCategoryRating.slice(1)
              ,valueLabels: JAM.worstCategoryRating.slice(1).map(Std.string)
              ,ticksX: JAM.categories.slice(1)
            })
          ,Graph.bar({
               name: "Best category by rank"
              ,axisX: ""
              ,axisY: "games"
              ,values: cast JAM.bestCategoryRanking
              ,valueLabels: JAM.bestCategoryRanking.map(Std.string)
              ,ticksX: JAM.categories
            })
          ,Graph.bar({
               name: "Worst category by rank"
              ,axisX: ""
              ,axisY: "games"
              ,values: cast JAM.worstCategoryRanking
              ,valueLabels: JAM.worstCategoryRanking.map(Std.string)
              ,ticksX: JAM.categories
            })
          ,Graph.scatter({
               name: "Comments / rating"
              ,axisX: "comments received"
              ,axisY: "rating"
              ,values: JAM.commentRes
              ,minX: 5
              ,maxY: 10
              ,ticksX: [ for (i in 5...JAM.maxCommentCount + 1) (i % 5 == 0 || i == JAM.maxCommentCount ? '$i' : null) ]
              ,axesX: [{pos: 20, label: "10.0"}, {pos: 145, label: "5.0"}]
            })
          ,Graph.scatter({
               name: "Comments / placement"
              ,axisX: "comments received"
              ,axisY: "placement percentile"
              ,values: JAM.commentPlc
              ,minX: 5
              ,ticksX: [ for (i in 5...JAM.maxCommentCount + 1) (i % 5 == 0 || i == JAM.maxCommentCount ? '$i' : null) ]
              ,axesX: [{pos: 20, label: "100%"}, {pos: 145, label: "50%"}]
            })
          ,Graph.bar({
               name: "Average rating given by day"
              ,addType: "small-nums"
              ,axisX: "day"
              ,axisY: "average"
              ,values: JAM.dayAvg
              ,valueLabels: JAM.dayAvg.map(M.prec.bind(_, 100))
              ,ticksX: [ for (i in 1...15) i.ord() ]
            })
          ,Graph.bar({
               name: "Day voted"
              ,addType: "small-nums"
              ,axisX: "day"
              ,axisY: "votes"
              ,values: cast JAM.dayVotes
              ,valueLabels: JAM.dayVotes.map(Std.string)
              ,ticksX: [ for (i in 1...15) i.ord() ]
            })
          ,Graph.bar({
               name: "Vote values"
              ,addType: "small-nums"
              ,axisX: "vote"
              ,axisY: "frequency"
              ,values: cast JAM.voteFreq
              ,valueLabels: JAM.voteFreq.map(Std.string)
              ,ticksX: [ for (i in 1...11) '$i' ]
            })
        ]}));
      case _: usage();
    }
  }
}
