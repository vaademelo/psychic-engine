package intelligence.tools;

import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.util.typeLimit.OneOfTwo;

import mission.world.WorldMap;

import intelligence.HeroMind;
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

  public static function updateHeatMap(worldMap:WorldMap, mind:HeroMind, tilesWeights:Map<String, Float>) {
    var index = 0;

    if (Constants.debugAi) {
      for (tile in  tilesWeights.keys()) {
        var parsedTile = tile.substring(1, tile.length - 1).split(',');
        if (index < worldMap.heatMap.members.length) {
          worldMap.heatMap.members[index].revive();
          worldMap.heatMap.members[index].updateTileWeight(mind, Std.string(round(tilesWeights[tile])), Std.parseInt(parsedTile[0]), Std.parseInt(parsedTile[1]));
        } else {
          var tileWeight = new TileWeight(worldMap, mind, Std.string(round(tilesWeights[tile])), Std.parseInt(parsedTile[0]), Std.parseInt(parsedTile[1]));
          worldMap.heatMap.add(tileWeight);
        }

        index ++;
      }
    }
    // for (i in index...worldMap.heatMap.members.length) {
    //   worldMap.heatMap.members[i].kill();
    // }
  }

  public static function cleanHeatMap(worldMap:WorldMap) {
    for (i in 0...worldMap.heatMap.members.length) {
      worldMap.heatMap.members[i].kill();
    }
  }

  public static function round(number:Float, ?precision=1): Float{
    number *= Math.pow(10, precision);
    return Math.round(number) / Math.pow(10, precision);
  }

}
