package intelligence.hero;

import intelligence.Mind;

import mission.world.Unit;
import mission.world.Collectable;
import mission.world.WorldMap;

import intelligence.tools.BattleTool;
import intelligence.tools.PositionTool;
import intelligence.tools.EmotionTool;
import intelligence.tools.LootTool;
import intelligence.tools.TileWeightTool;

import utils.Constants;

import gameData.UserData;

class HeroMind implements Mind {

  private var unit:Unit;

  public var emotionWeights:Map<Constants.Emotion, Float>;

  public function new() {
    emotionWeights = new Map<Constants.Emotion, Float>();
    for (emotion in Type.allEnums(Constants.Emotion)) {
      emotionWeights[emotion] = 0;
    }
  }

  public function updateStatus(worldMap:WorldMap, unit:Unit):Void {
    if (this.unit == null) this.unit = unit;
    //TODO: UPDATE EMOTION, ANALYSE TRIGGERS
    if(unit.character.goalUnit != null) {
      var tile = [0, 0];
      for(hero in worldMap.heroes.members) {
        if(hero.character == unit.character.goalUnit) {
          tile = hero.getCoordinate();
          break;
        }
      }
      unit.character.goalTile = tile;
    }
  }

  public function analyseAction(worldMap:WorldMap, unit:Unit):Array<Int> {
    if (this.unit == null) this.unit = unit;

    var tilesWeights    = createOptions(worldMap);
    var movingWeights   = movingAnalysis(worldMap);
    var survivorWeights = survivorAnalysis(worldMap);
    var lootWeights     = lootAnalysis(worldMap);
    var friendsWeights  = friendsAnalysis(worldMap);

    var tiles:Map<String, Float> = new Map<String, Float>();

    for (key in tilesWeights.keys()) {
      tiles[key.toString()] = tilesWeights[key];
    }

    for (key in movingWeights.keys()) {
      if(tiles[key.toString()] == null) continue;
      tiles[key.toString()] *= movingWeights[key];
    }

    for (key in survivorWeights.keys()) {
      if(tiles[key.toString()] == null) continue;
      tiles[key.toString()] *= survivorWeights[key];
    }

    for (key in lootWeights.keys()) {
      if(tiles[key.toString()] == null) continue;
      tiles[key.toString()] += lootWeights[key];
    }

    for (key in friendsWeights.keys()) {
      if(tiles[key.toString()] == null) continue;
      tiles[key.toString()] += friendsWeights[key];
    }

    TileWeightTool.updateHeatMap(worldMap, tiles);
    return getBestOption(tiles);

  }

  public function createOptions(worldMap:WorldMap):Map<Array<Int>, Float> {
    var validTiles:Array<Array<Int>> = PositionTool.getValidTilesInRange(worldMap, unit.getCoordinate(), unit.character.vision);
    var tilesWeights:Map<Array<Int>, Float> = new Map<Array<Int>, Float>();
    for (tile in validTiles) {
      tilesWeights.set(tile, 0);
    }
    return tilesWeights;
  }

  public function movingAnalysis(worldMap:WorldMap):Map<Array<Int>, Float> {
    var tilesWeights = createOptions(worldMap);
    var destination = unit.character.goalTile;
    if (destination == null) return tilesWeights;
    if (worldMap.isTheSameTile(destination, [0,0]) || (unit.character.goalUnit != null)) {
      tilesWeights = weightsForDistance(worldMap);
    } else {
      var currentZone:Array<Int> = PositionTool.getZoneForTile(unit.getCoordinate());
      var desiredZone:Array<Int> = PositionTool.getZoneForTile(destination);
      if(worldMap.isTheSameTile(currentZone, desiredZone)) {
        //SAME ZONE
      } else {
        tilesWeights = weightsForDistance(worldMap);
      }
    }

    return tilesWeights;
  }

  private function weightsForDistance(worldMap:WorldMap):Map<Array<Int>, Float> {
    var tilesWeights = createOptions(worldMap);
    var destination = unit.character.goalTile;
    if (destination == null) return tilesWeights;

    var maxDistance = 1;
    for (key in tilesWeights.keys()) {
      var distance = PositionTool.getDistance(worldMap, key, destination);
      tilesWeights[key] = distance;
      if (distance > maxDistance) {
        maxDistance = distance;
      }
    }
    for (key in tilesWeights.keys()) {
      if (tilesWeights[key] < 0) {
        if (worldMap.getTileContentKind(key) == TileContentKind.hero) {
          tilesWeights[key] = 0;
        } else {
          tilesWeights.remove(key);
        }
      } else {
        tilesWeights[key] = 1 - tilesWeights[key]/maxDistance;
      }
    }

    return  tilesWeights;
  }

  public function survivorAnalysis(worldMap:WorldMap):Map<Array<Int>, Float> {
    var tilesWeights:Map<Array<Int>, Float> = new Map<Array<Int>, Float>();

    var opponents = PositionTool.getObjectsInRange(worldMap.monsters, unit.getCoordinate(), unit.character.vision);

    var opponentTiles = new Array<Array<Int>>();
    for(opp in opponents) {
      //CHANCE OF WINNING
      var opponent = cast(opp, Unit);
      var opponentTile = opponent.getCoordinate();
      var chanceOfWinning = BattleTool.chanceOfWinning(opponent, unit) * EmotionTool.battleMultiplier(unit);

      if (chanceOfWinning > 0) {
        tilesWeights[opponentTile] = chanceOfWinning;

      } else {

        tilesWeights[opponentTile] = chanceOfWinning;
        //LEVEL OF DANGER
        var tiles = PositionTool.getValidTilesInRange(worldMap, opponent.getCoordinate(), opponent.character.movement + opponent.character.atackRange);

        for (tile in tiles) {
          if(PositionTool.getDistance(worldMap, tile, unit.getCoordinate()) > unit.character.vision) continue;
          if(worldMap.getTileContentKind(tile) == TileContentKind.monster) continue;
          if(tilesWeights[tile] == null) {
            tilesWeights[tile] = chanceOfWinning;
          } else {
            tilesWeights[tile] += chanceOfWinning;
          }
        }
      }
    }
    return tilesWeights;
  }

  public function lootAnalysis(worldMap:WorldMap):Map<Array<Int>, Float> {

    var tilesWeights:Map<Array<Int>, Float> = new Map<Array<Int>, Float>();

    var foods = PositionTool.getObjectsInRange(worldMap.foods, unit.getCoordinate(), unit.character.vision);
    var treasures = PositionTool.getObjectsInRange(worldMap.treasures, unit.getCoordinate(), unit.character.vision);


    for(food in foods) {
      tilesWeights[cast(food, Collectable).getCoordinate()] = LootTool.needForFood(unit) * EmotionTool.lootMultiplier(unit);
    }


    for(treasure in treasures) {
      tilesWeights[cast(treasure, Collectable).getCoordinate()] = 1 * EmotionTool.lootMultiplier(unit);
    }


    return tilesWeights;
  }
  public function friendsAnalysis(worldMap:WorldMap):Map<Array<Int>, Float> {
    /* TODO:
    - Peso gradiente que irradia de outro personagem (dentro do campo de visão) diretamente proporcional a distância e ao grau de afinidade
    */
    var tilesWeights:Map<Array<Int>, Float> = new Map<Array<Int>, Float>();

    var opponents = PositionTool.getObjectsInRange(worldMap.monsters, unit.getCoordinate(), unit.character.vision);
    var friends   = PositionTool.getObjectsInRange(worldMap.heroes, unit.getCoordinate(), unit.character.vision);

    var opponentTiles = new Array<Array<Int>>();
    for (opponent in opponents) {
      for (friend in friends) {
        var distanceFriendOpponent = PositionTool.getDistance(worldMap, cast(opponent, Unit).getCoordinate(), cast(friend, Unit).getCoordinate());

        if (distanceFriendOpponent <= cast(opponent, Unit).character.vision) {
          tilesWeights[cast(opponent, Unit).getCoordinate()] = 1 + BattleTool.chanceOfWinning(opponent, friend) / distanceFriendOpponent;
        }
      }
    }
    return tilesWeights;
  }

  public function getBestOption(tilesWeights:Map<String, Float>):Array<Int> {
    var bestOption:String = unit.getCoordinate().toString();
    var bestOptionValue:Float = 0;

    for(key in tilesWeights.keys()) {
      if(tilesWeights[key] > bestOptionValue) {
        bestOptionValue = tilesWeights[key];
        bestOption = key;
      }
    }

    var tile = bestOption.substring(1, bestOption.length - 1).split(',');
    var destination:Array<Int> = [Std.parseInt(tile[0]), Std.parseInt(tile[1])];

    return destination;
  }

}
