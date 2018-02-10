package lib;

using lib.M;

class Graph {
  static function common(ret:StringBuf, param:Common):Void {
    var wide = (param.wide != null ? param.wide : false);
    var narrow = (param.narrow != null ? param.narrow : false);
    var w = (wide ? 470 : (narrow ? 430 : 450));
    if (param.axisX != null) {
      ret.add('<div class="axis-x${narrow ? " narrower" : ""}" style="top:270px;"><span>${param.axisX}</span></div>');
    }
    if (param.axisY != null) {
      ret.add('<div class="axis-y" style="left:${narrow ? 60 : 10}px;">${param.axisY}</div>');
    }
    if (param.axesX != null) {
      for (a in param.axesX) {
        ret.add('<div class="axis-x other" style="top:${a.pos}px;">${a.label}</div>');
      }
    }
    if (param.axesY != null) {
      for (a in param.axesY) {
        ret.add('<div class="axis-y other" style="left:${a.pos}px;">${a.label}</div>');
      }
    }
    if (param.ticksX != null) {
      for (i in 0...param.ticksX.length) {
        if (param.ticksX[i] == null) continue;
        var pos = Std.int(28 + (i / param.ticksX.length) * w);
        if (narrow) {
          pos = Std.int(78 + (i / param.ticksX.length) * w);
        }
        ret.add('<div class="tick-x" style="left:${pos}px;">${param.ticksX[i]}</div>');
      }
    }
    if (param.ticksY != null) {
      for (i in 0...param.ticksY.length) {
        if (param.ticksY[i] == null) continue;
        var pos = Std.int(28 + (i / param.ticksY.length) * 250);
        ret.add('<div class="tick-y" style="top:${pos}px;">${param.ticksY[i]}</div>');
      }
    }
  }
  
  static function html(ret:StringBuf, param:Common):HtmlGraph {
    return {
         name: param.name
        ,type: param.type + (param.addType != null ? ' ${param.addType}' : "")
        ,data: ret.toString()
      };
  }
  
  public static function scatter(param:{
     >Common
    ,values:Array<GraphPoint>
  }):HtmlGraph {
    param.type = "scatter";
    var wide = param.wide = param.axisX == null || param.axisX == "";
    var xs = param.values.map(v -> v.x);
    var ys = param.values.map(v -> v.y);
    var minX = xs.min();
    var maxX = xs.max();
    var minY = ys.min();
    var maxY = ys.max();
    if (param.minX == null) param.minX = 0;
    if (param.minY == null) param.minY = 0;
    if (minX > param.minX) minX = param.minX;
    if (minY > param.minY) minY = param.minY;
    if (param.maxX != null) maxX = param.maxX;
    if (param.maxY != null) maxY = param.maxY;
    var spreadX = maxX - minX;
    var spreadY = maxY - minY;
    var ret = new StringBuf();
    common(ret, param);
    ret.add('<div class="space${wide ? " wider" : ""}">');
    for (v in param.values) {
      ret.add('<div class="point" style="left:${((v.x - minX) / spreadX).pc()};top:${((v.y - minY) / spreadY).rpc()};">'
        + '<span>${v.label != null ? v.label : ""}</span></div>');
    }
    ret.add('</div>');
    return html(ret, param);
  }
  
  public static function bar(param:{
     >Common
    ,values:Array<Float>
    ,?valueLabels:Array<String>
  }):HtmlGraph {
    param.type = "bar";
    var wide = param.wide = param.axisX == null || param.axisX == "";
    var min = param.values.min();
    var max = param.values.max();
    if (min > 0) min = 0;
    var spread = max - min;
    var ret = new StringBuf();
    common(ret, param);
    var l = (param.valueLabels == null ? [ for (v in param.values) "" ] : param.valueLabels).iterator();
    ret.add('<table class="${wide ? "wider" : ""}">');
    ret.add('<tbody><tr><td>' + [ for (v in param.values)
        '<div style="height:${((v - min) / spread).pc()};"><span>${l.next()}</span></div>'
      ].join('</td><td>') + '</td></tr></tbody></table>');
    return html(ret, param);
  }
  
  public static function matrix(param:{
     >Common
    ,values:Array<Array<Float>>
    ,valueLabels:Array<Array<String>>
  }):HtmlGraph {
    param.type = "matrix";
    param.narrow = true;
    var min = param.values.map(r -> r.min()).min();
    var max = param.values.map(r -> r.max()).max();
    var spread = max - min;
    var ret = new StringBuf();
    common(ret, param);
    ret.add('<table class="narrower"><tbody>');
    for (y in 0...param.values.length) {
      ret.add('<tr><td>' + [ for (x in 0...param.values[y].length)
          '<div style="background-color:rgba(247, 81, 109, ${.2 + .8 * (param.values[y][x] - min) / spread});"><span>${param.valueLabels[y][x]}</span></div>'
        ].join('</td><td>') + '</td></tr>');
    }
    ret.add('</tbody></table>');
    return html(ret, param);
  }
}

typedef Common = {
     name:String
    ,?type:String
    ,?addType:String
    ,?axisX:String
    ,?axisY:String
    ,?axesX:Array<{label:String, pos:Int}>
    ,?axesY:Array<{label:String, pos:Int}>
    ,?ticksX:Array<String>
    ,?ticksY:Array<String>
    ,?minX:Float
    ,?minY:Float
    ,?maxX:Float
    ,?maxY:Float
    ,?wide:Bool
    ,?narrow:Bool
  };

typedef HtmlGraph = {
     name:String
    ,type:String
    ,data:String
  };
