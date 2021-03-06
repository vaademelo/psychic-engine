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

  public var analyzeWeights:Map<String, Map<String, Float>>;
  public var lastEmotion:Emotion;
  public var emotionsLastTurn:Map<Emotion, Float>;
  public var emotionsAmortization:Map<Emotion, Float>;
  public var triggersEffectOnEmotions:Map<Emotion, Map<String, Float>>;

  public var debugMe:Bool = true;

  public function new(unit:Unit) {
    this.unit = unit;

    this.emotionWeights = EmotionTool.generateTokens();
  }

  private function getObjectsInRange(worldMap:WorldMap):Void {
    opponentsInRange = PositionTool.getObjectsInRange(worldMap.monsters, unit.getCoordinate(), unit.getUnitVision());
    friendsInRange   = PositionTool.getObjectsInRange(worldMap.heroes, unit.getCoordinate(), unit.getUnitVision());
    friendsInRange.remove(this.unit);
    goldsInRange     = PositionTool.getObjectsInRange(worldMap.golds, unit.getCoordinate(), unit.getUnitVision());
    treasuresInRange = PositionTool.getObjectsInRange(worldMap.treasures, unit.getCoordinate(), unit.getUnitVision());
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

    analyzeWeights = new Map<String, Map<String, Float>>();
  }

  public function analyseAction(worldMap:WorldMap):Array<Int> {
    var tilesWeights    = createOptions(worldMap);
    var movingWeights   = movingAnalysis(worldMap);
    var survivorWeights = survivingAnalysis(worldMap);
    var lootWeights     = lootAnalysis(worldMap);
    var friendsWeights  = friendsAnalysis(worldMap);

    var tiles:Map<String, Float> = new Map<String, Float>();

    for (key in tilesWeights.keys()) {
      tiles[key] = tilesWeights[key];
    }

    for (key in movingWeights.keys()) {
      if(tiles[key] == null) continue;
      tiles[key] += movingWeights[key];
    }

    for (key in survivorWeights.keys()) {
      if(tiles[key] == null) continue;
      tiles[key] += survivorWeights[key];
    }

    for (key in lootWeights.keys()) {
      if(tiles[key] == null) continue;
      tiles[key] += lootWeights[key];
    }

    for (key in friendsWeights.keys()) {
      if(tiles[key] == null) continue;
      tiles[key] += friendsWeights[key];
    }


    if (this.debugMe && Constants.debugAi) {
      TileWeightTool.updateHeatMap(worldMap, this, tiles);
    }
    return getBestOption(tiles);
  }

  public function createOptions(worldMap:WorldMap):Map<String, Float> {
    var validTiles:Array<Array<Int>> = PositionTool.getValidTilesInRange(worldMap, unit.getCoordinate(), unit.getUnitVision());
    var tilesWeights:Map<String, Float> = new Map<String, Float>();
    for (tile in validTiles) {
      tilesWeights.set(tile.toString(), 0);
    }
    return tilesWeights;
  }

  public function movingAnalysis(worldMap:WorldMap):Map<String, Float> {
    var tilesWeights = createOptions(worldMap);
    var destination = unit.character.goalTile;
    if (destination == null) return tilesWeights;
    if (unit.goalToReturnHome || (unit.character.goalChar != null)) {
      tilesWeights = weightsForDistance(worldMap);
    } else {
      var currentZone:Array<Int> = PositionTool.getZoneForTile(unit.getCoordinate());
      var desiredZone:Array<Int> = PositionTool.getZoneForTile(destination);
      if(worldMap.isTheSameTile(currentZone, desiredZone)) {
        tilesWeights = exploreZone(worldMap);
      } else {
        tilesWeights = weightsForDistance(worldMap);
      }
    }

    analyzeWeights['goToTarget'] = tilesWeights;
    tilesWeights = EmotionTool.applyEmotion(unit, 'goToTarget', tilesWeights);

    return tilesWeights;
  }

  private function exploreZone(worldMap:WorldMap):Map<String, Float> {
    var tilesWeights = createOptions(worldMap);

    var desiredZone = PositionTool.getZoneForTile(unit.character.goalTile);
    for (key in tilesWeights.keys()) {
      var tileZone = PositionTool.getZoneForTile(tileStringToArray(key));
      if (worldMap.isTheSameTile(tileZone, desiredZone)) {
        tilesWeights[key] = 0.5;
      } else {
        tilesWeights[key] = 0;
      }
    }
    return tilesWeights;
  }

  private function weightsForDistance(worldMap:WorldMap):Map<String, Float> {
    var tilesWeights = createOptions(worldMap);
    var destination = unit.character.goalTile;
    var wantToGoBackFactor = (unit.goalToReturnHome) ? 3 : 1;
    if (destination == null) return tilesWeights;
    var flag = false;
    if (!worldMap.isTileWalkable(destination[0], destination[1])) {
      flag = true;
      worldMap.setTileAsWalkable(destination[0], destination[1], true);
    }
    var minDistance = 300;
    var maxDistance = 0;
    for (key in tilesWeights.keys()) {
      var distance = PositionTool.getDistance(worldMap, tileStringToArray(key), destination);
      tilesWeights[key] = distance;
      if (distance == -1) continue;
      if (distance > maxDistance) {
        maxDistance = distance;
      }
      if (distance < minDistance) {
        minDistance = distance;
      }
    }
    for (key in tilesWeights.keys()) {
      if (tilesWeights[key] == -1) {
        tilesWeights[key] = 0;
        continue;
      }
      if (maxDistance <= minDistance) {
        tilesWeights[key] = 0.5;
      } else {
        tilesWeights[key] = (1 - ((tilesWeights[key] - minDistance)/(maxDistance - minDistance))) * wantToGoBackFactor;
      }
    }
    if (flag) worldMap.setTileAsWalkable(destination[0], destination[1], false);

    return  tilesWeights;
  }

  public function survivingAnalysis(worldMap:WorldMap):Map<String, Float> {
    var dangerWeights:Map<String, Float> = new Map<String, Float>();
    var atackWeights:Map<String, Float> = new Map<String, Float>();

    for(opponent in opponentsInRange) {

      var opponentTile = opponent.getCoordinate().toString();
      var chanceOfWinning = BattleTool.chanceOfWinning(opponent, unit);

      atackWeights[opponentTile] = chanceOfWinning * 1.3;

      var opponentTilesInRange = PositionTool.getValidTilesInRange(worldMap, opponent.getCoordinate(), opponent.character.movement + opponent.character.atackRange);
      for (tile in opponentTilesInRange) {
        var distance = PositionTool.getDumbDistance(tile, unit.getCoordinate());
        if (distance > unit.getUnitVision() || worldMap.isTheSameTile(tile, opponent.getCoordinate())) continue;
        if (dangerWeights[tile.toString()] == null) {
          dangerWeights[tile.toString()] = (chanceOfWinning - 1)/3;
        } else {
          dangerWeights[tile.toString()] += (chanceOfWinning - 1)/3;
        }
      }
    }

    analyzeWeights['atack'] = atackWeights;
    atackWeights = EmotionTool.applyEmotion(unit, 'atack', atackWeights);
    analyzeWeights['danger'] = dangerWeights;
    dangerWeights = EmotionTool.applyEmotion(unit, 'danger', dangerWeights);

    var tilesWeights = createOptions(worldMap);
    for (tile in tilesWeights.keys()) {
      if (atackWeights[tile] != null) {
        tilesWeights[tile] += atackWeights[tile];
      }
      if (dangerWeights[tile] != null) {
        tilesWeights[tile] += dangerWeights[tile];
      }
    }

    return tilesWeights;
  }

  public function lootAnalysis(worldMap:WorldMap):Map<String, Float> {

    var tilesWeights:Map<String, Float> = new Map<String, Float>();

    var desiredZone:Array<Int> = PositionTool.getZoneForTile(unit.character.goalTile);

    var currentZone:Array<Int>;
    var lootFactor:Float;
    for(gold in goldsInRange) {
      currentZone = PositionTool.getZoneForTile(gold.getCoordinate());
      lootFactor = (worldMap.isTheSameTile(currentZone, desiredZone) && !unit.goalToReturnHome) ? EmotionTool.emotionFactor(unit, 'lootOnZone') * 3 : 1;
      tilesWeights[cast(gold, Collectable).getCoordinate().toString()] = LootTool.needForgold(worldMap) * lootFactor;
    }

    for(treasure in treasuresInRange) {
      currentZone = PositionTool.getZoneForTile(treasure.getCoordinate());
      lootFactor = (worldMap.isTheSameTile(currentZone, desiredZone) && !unit.goalToReturnHome) ? EmotionTool.emotionFactor(unit, 'lootOnZone') * 3 : 1;
      tilesWeights[cast(treasure, Collectable).getCoordinate().toString()] = 1 * lootFactor;
    }

    analyzeWeights['loot'] = tilesWeights;
    tilesWeights = EmotionTool.applyEmotion(unit, 'loot', tilesWeights);

    return tilesWeights;
  }
  public function friendsAnalysis(worldMap:WorldMap):Map<String, Float> {
    var protectionWeights:Map<String, Float> = new Map<String, Float>();
    var friendshipWeights:Map<String, Float> = new Map<String, Float>();

    var opponentTiles = new Array<Array<Int>>();
    for (friend in friendsInRange) {
      if (friend == unit) continue;

      var friendshipFactor = (unit.character.relationList[friend.character] - .25) * 0.25;
      var friendTilesInRange = PositionTool.getValidTilesInRange(worldMap, friend.getCoordinate(), friend.character.movement);

      for (tile in friendTilesInRange) {
        if (PositionTool.getDumbDistance(tile, unit.getCoordinate()) > unit.getUnitVision()) continue;
        if (friendshipWeights[tile.toString()] == null) {
          friendshipWeights[tile.toString()] = friendshipFactor;
        } else {
          friendshipWeights[tile.toString()] += friendshipFactor;
        }
      }

      for (opponent in opponentsInRange) {
        var distanceFriendOpponent = PositionTool.getDumbDistance(opponent.getCoordinate(), friend.getCoordinate());

        if (distanceFriendOpponent <= opponent.character.movement + opponent.character.atackRange) {
          var protectObjective = (unit.goalUnit == friend) ? 3 : 1;
          var objectivePlus = (unit.goalUnit == friend) ? friendshipFactor + 0.5 : friendshipFactor;
          var protectionValue = ((objectivePlus + BattleTool.chanceOfWinning(opponent, unit) - BattleTool.chanceOfWinning(opponent, friend)) / 2) * protectObjective;
          var opponentTile = opponent.getCoordinate().toString();
          if (protectionWeights[opponentTile] == null) {
            protectionWeights[opponentTile] = protectionValue;
          } else {
            protectionWeights[opponentTile] += protectionValue;
          }
        }
      }

    }

    analyzeWeights['friendship'] = friendshipWeights;
    friendshipWeights = EmotionTool.applyEmotion(unit, 'friendship', friendshipWeights);
    analyzeWeights['protection'] = protectionWeights;
    protectionWeights = EmotionTool.applyEmotion(unit, 'protection', protectionWeights);
    if (unit.goalUnit != null) {
      for (friend in friendsInRange) {
        if (friend != unit.goalUnit) continue;
        for (opponent in opponentsInRange) {
          var distanceFriendOpponent = PositionTool.getDistance(worldMap, opponent.getCoordinate(), friend.getCoordinate());

          if (distanceFriendOpponent <= opponent.getUnitVision()) {
            var opponentTile = opponent.getCoordinate().toString();
            if (protectionWeights[opponentTile] == null) continue;
            var protectObjective = (unit.goalUnit == friend) ? 3 : 1;
            var protectionValue = (1 + BattleTool.chanceOfWinning(opponent, friend) / distanceFriendOpponent) * protectObjective;
            protectionWeights[opponentTile] += protectionValue * (EmotionTool.emotionFactor(unit, 'lootOnZone') - 1);
          }
        }
      }
    }

    var tilesWeights = createOptions(worldMap);
    for (tile in tilesWeights.keys()) {
      if (friendshipWeights[tile] != null) {
        tilesWeights[tile] += friendshipWeights[tile];
      }
      if (protectionWeights[tile] != null) {
        tilesWeights[tile] += protectionWeights[tile];
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

    return tileStringToArray(bestOption);
  }

  public function tileStringToArray(tileString:String):Array<Int> {
    var temp = tileString.substring(1, tileString.length - 1).split(',');
    var tile:Array<Int> = [Std.parseInt(temp[0]), Std.parseInt(temp[1])];
    return tile;
  }

}
