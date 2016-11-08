package intelligence;

import Random;

import intelligence.Mind;

import mission.world.Unit;
import mission.world.Collectable;
import mission.world.WorldMap;

import intelligence.tools.*;

import utils.Constants;

import gameData.UserData;

class HeroMind implements Mind {

  public var unit:Unit;

  public var currentEmotion:Emotion = Emotion.peaceful;
  public var emotionWeights:Map<Emotion, Float>;

  public var opponentsInRange:Array<Unit>;
  public var friendsInRange:Array<Unit>;
  public var goldsInRange:Array<Collectable>;
  public var treasuresInRange:Array<Collectable>;

  public var missedLastAtack:Bool = false;
  public var criticalLastAtack:Bool = false;
  public var wasAtackedLastTurn:Bool = false;
  public var enemyDiedLastTurn:Bool = false;
  public var friendDiedLastTurn:Bool = false;

  public function new(unit:Unit) {
    this.unit = unit;

    this.emotionWeights = EmotionTool.generateTokens();
  }

  private function getObjectsInRange(worldMap:WorldMap):Void {
    opponentsInRange = PositionTool.getObjectsInRange(worldMap.monsters, unit.getCoordinate(), unit.character.vision);
    friendsInRange   = PositionTool.getObjectsInRange(worldMap.heroes, unit.getCoordinate(), unit.character.vision);
    goldsInRange     = PositionTool.getObjectsInRange(worldMap.golds, unit.getCoordinate(), unit.character.vision);
    treasuresInRange = PositionTool.getObjectsInRange(worldMap.treasures, unit.getCoordinate(), unit.character.vision);
  }

  public function updateStatus(worldMap:WorldMap):Void {
    getObjectsInRange(worldMap);

    GoalTool.updateGoal(worldMap, unit);

    EmotionTool.amortizeTokens(this);
    TriggersTool.analyseTriggers(worldMap, unit, this);
    EmotionTool.defineCurrentEmotion(this);

    this.missedLastAtack = false;
    this.criticalLastAtack = false;
    this.wasAtackedLastTurn = false;
    this.enemyDiedLastTurn = false;
    this.friendDiedLastTurn = false;

    unit.emotionFX.updateEmotion(unit.mind.currentEmotion);
  }

  public function analyseAction(worldMap:WorldMap):Array<Int> {
    var tilesWeights    = createOptions(worldMap);
    var movingWeights   = movingAnalysis(worldMap);
    var survivorWeights = survivingAnalysis(worldMap);
    var lootWeights     = lootAnalysis(worldMap);
    var friendsWeights  = friendsAnalysis(worldMap);

    var tiles:Map<String, Float> = new Map<String, Float>();

    for (key in tilesWeights.keys()) {
      tiles[key.toString()] = tilesWeights[key];
    }

    for (key in movingWeights.keys()) {
      if(tiles[key.toString()] == null) continue;
      tiles[key.toString()] += movingWeights[key];
    }

    for (key in survivorWeights.keys()) {
      if(tiles[key.toString()] == null) continue;
      tiles[key.toString()] += survivorWeights[key];
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
    if (worldMap.isTheSameTile(destination, worldMap.homeTile) || (unit.character.goalChar != null)) {
      tilesWeights = weightsForDistance(worldMap);
    } else {
      var currentZone:Array<Int> = PositionTool.getZoneForTile(unit.getCoordinate());
      var desiredZone:Array<Int> = PositionTool.getZoneForTile(destination);
      if(worldMap.isTheSameTile(currentZone, desiredZone)) {
        tilesWeights = simpleWeights(worldMap);
      } else {
        tilesWeights = weightsForDistance(worldMap);
      }
    }

    return tilesWeights;
  }

  private function simpleWeights(worldMap:WorldMap):Map<Array<Int>, Float> {
    var tilesWeights = createOptions(worldMap);
    for (key in tilesWeights.keys()) {
      tilesWeights[key] = 0.5;
    }
    return tilesWeights;
  }

  private function weightsForDistance(worldMap:WorldMap):Map<Array<Int>, Float> {
    var tilesWeights = createOptions(worldMap);
    var destination = unit.character.goalTile;
    var wantToGoBackFactor = worldMap.isTheSameTile(destination, worldMap.homeTile) ? 3 : 1;
    if (destination == null) return tilesWeights;
    if (unit.character.goalChar != null) {
      worldMap.setTileAsWalkable(destination[0], destination[1], true);
    }
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
        tilesWeights[key] = (1 - tilesWeights[key]/maxDistance) * wantToGoBackFactor * EmotionTool.emotionFactor(unit, 'goToTarget');
      }
    }
    if (unit.character.goalChar != null) {
      worldMap.setTileAsWalkable(destination[0], destination[1], false);
    }

    return  tilesWeights;
  }

  public function survivingAnalysis(worldMap:WorldMap):Map<Array<Int>, Float> {
    var tilesWeights:Map<Array<Int>, Float> = new Map<Array<Int>, Float>();

    for(opponent in opponentsInRange) {

      var opponentTile = opponent.getCoordinate();
      var chanceOfWinning = BattleTool.chanceOfWinning(opponent, unit) * EmotionTool.emotionFactor(unit, 'atack');

      tilesWeights[opponentTile] = chanceOfWinning;

      if (chanceOfWinning < 0) {
        var opponentTilesInRange = PositionTool.getValidTilesInRange(worldMap, opponent.getCoordinate(), opponent.character.movement + opponent.character.atackRange);

        for (tile in opponentTilesInRange) {
          if (PositionTool.getDistance(worldMap, tile, unit.getCoordinate()) > unit.character.vision) continue;
          if (worldMap.getTileContentKind(tile) == TileContentKind.monster) continue;
          if (tilesWeights[tile] == null) {
            tilesWeights[tile] = chanceOfWinning * EmotionTool.emotionFactor(unit, 'danger');
          } else {
            tilesWeights[tile] += chanceOfWinning * EmotionTool.emotionFactor(unit, 'danger');
          }
        }
      }
    }
    return tilesWeights;
  }

  public function lootAnalysis(worldMap:WorldMap):Map<Array<Int>, Float> {

    var tilesWeights:Map<Array<Int>, Float> = new Map<Array<Int>, Float>();

    var currentZone:Array<Int> = PositionTool.getZoneForTile(unit.getCoordinate());
    var desiredZone:Array<Int> = PositionTool.getZoneForTile(unit.character.goalTile);
    var lootFactor = (worldMap.isTheSameTile(currentZone, desiredZone)) ? 3 * EmotionTool.emotionFactor(unit, 'lootOnZone') : 1;

    for(gold in goldsInRange) {
      tilesWeights[cast(gold, Collectable).getCoordinate()] = LootTool.needForgold(unit) * lootFactor * EmotionTool.emotionFactor(unit, 'loot');
    }

    for(treasure in treasuresInRange) {
      tilesWeights[cast(treasure, Collectable).getCoordinate()] = 1 * lootFactor * EmotionTool.emotionFactor(unit, 'loot');
    }

    return tilesWeights;
  }
  public function friendsAnalysis(worldMap:WorldMap):Map<Array<Int>, Float> {
    var tilesWeights:Map<Array<Int>, Float> = new Map<Array<Int>, Float>();

    var opponentTiles = new Array<Array<Int>>();
    for (friend in friendsInRange) {
      if (friend == unit) continue;
      for (opponent in opponentsInRange) {
        var distanceFriendOpponent = PositionTool.getDistance(worldMap, opponent.getCoordinate(), friend.getCoordinate());

        if (distanceFriendOpponent <= opponent.character.vision) {
          var protectObjective = (unit.goalUnit == friend) ? 3 * EmotionTool.emotionFactor(unit, 'lootOnZone') : 1;
          tilesWeights[opponent.getCoordinate()] = (1 + BattleTool.chanceOfWinning(opponent, friend) / distanceFriendOpponent) * protectObjective * EmotionTool.emotionFactor(unit, 'protection');
        }
      }

      var friendshipFactor = (unit.character.relationList[friend.character] - 3) * 0.2 * EmotionTool.emotionFactor(unit, 'friendship');
      var friendTilesInRange = PositionTool.getValidTilesInRange(worldMap, friend.getCoordinate(), friend.character.movement);

      for (tile in friendTilesInRange) {
        if (PositionTool.getDistance(worldMap, tile, unit.getCoordinate()) > unit.character.vision) continue;
        if (tilesWeights[tile] == null) {
          tilesWeights[tile] = friendshipFactor;
        } else {
          tilesWeights[tile] += friendshipFactor;
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
      } else if (tilesWeights[key] == bestOptionValue && Random.bool()) {
        bestOption = key;
      }
    }

    var tile = bestOption.substring(1, bestOption.length - 1).split(',');
    var destination:Array<Int> = [Std.parseInt(tile[0]), Std.parseInt(tile[1])];

    return destination;
  }

}
