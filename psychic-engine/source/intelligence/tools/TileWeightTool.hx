package intelligence.tools;

import flixel.group.FlxGroup;
import flixel.util.typeLimit.OneOfTwo;

import mission.world.WorldMap;

import intelligence.tools.PositionTool;
import intelligence.debug.TileWeight;

import utils.Constants;
import mission.world.Unit;

class TileWeightTool {

  public static function setRadiusWeight(worldMap:WorldMap, centralPoint:Array<Int>, tilesWeights:Map<Int,Map<Int,Float>>, weightMultiplier:Float, radius:Int):Map<Int,Map<Int,Float>> {
    var tilesInRadius:Array<Array<Int>> = PositionTool.getValidTilesInRange(worldMap, centralPoint, radius);

    for (tile in tilesInRadius) {
      if (tilesWeights[tile[0]][tile[1]] != null) {
        tilesWeights[tile[0]][tile[1]] *= weightMultiplier;
      }
    }

    return tilesWeights;
  }

  public static function updateHeatMap(worldMap:WorldMap, tilesWeights:Map<String, Float>) {
    var index = 0;

    for (tile in  tilesWeights.keys()) {
      var parsedTile = tile.substring(1, tile.length - 1).split(',');
      if (index < worldMap.heatMap.members.length) {
        worldMap.heatMap.members[index].revive();
        worldMap.heatMap.members[index].updateTileWeight(Std.string(round(tilesWeights[tile])), Std.parseInt(parsedTile[0]), Std.parseInt(parsedTile[1]));
      } else {
        var tileWeight = new TileWeight(Std.string(round(tilesWeights[tile])), Std.parseInt(parsedTile[0]), Std.parseInt(parsedTile[1]));
        worldMap.heatMap.add(tileWeight);
      }

      index ++;
    }
    for (i in index...worldMap.heatMap.members.length) {
      worldMap.heatMap.members[i].kill();
    }
    //
    //
    //
    // var index = 0;
    // for (i in 0...worldMap.heatMap.members.length) {
    //   if (index >= tilesWeights.keys().length) {
    //     worldMap.heatMap.members[index].kill();
    //   } else {
    //     var tile = tilesWeights[index].key();
    //     var parsedTile = tile.substring(1, tile.length - 1).split(',');
    //
    //   }
    //   index ++;
    // }
    // var start = index;
    // for (i in start...tilesWeights.keys().length) {
    //   var tile = tilesWeights[index].key();
    //   var parsedTile = tile.substring(1, tile.length - 1).split(',');
    //   var tileWeight = new TileWeight("" + round(tilesWeights[tile]), Std.parseInt(parsedTile[0]), Std.parseInt(parsedTile[1]));
    //   worldMap.heatMap.add(tileWeight);
    //   index ++;
    // }

    // worldMap.heatMap.clear();
    // for(tile in tilesWeights.keys()) {
    //   var parsedTile = tile.substring(1, tile.length - 1).split(',');
    //   var tileWeight = new TileWeight("" + round(tilesWeights[tile]), Std.parseInt(parsedTile[0]), Std.parseInt(parsedTile[1]));
    //   worldMap.heatMap.add(tileWeight);
    // }
  }

  public static function round(number:Float, ?precision=1): Float{
    number *= Math.pow(10, precision);
    return Math.round(number) / Math.pow(10, precision);
  }

}
