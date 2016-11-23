package intelligence.tools;

import Random;

import flixel.group.FlxGroup;
import flixel.util.typeLimit.OneOfTwo;

import utils.Constants;

import mission.world.Unit;
import mission.world.WorldMap;

import intelligence.tools.PositionTool;

class GoalTool {

  public static function updateGoal(worldMap:WorldMap, unit:Unit) {
    var shouldReturn = shouldReturnAnalisys(worldMap, unit);

    if (shouldReturn) {
      unit.character.goalTile = worldMap.homeTile;
      unit.character.goalChar = null;
    } else {
      if(unit.character.goalChar != null) {
        try {
          unit.character.goalTile = unit.goalUnit.getCoordinate();
        } catch(e:Dynamic) {
          unit.character.goalTile = unit.getCoordinate();
        }
      }
    }
  }

  public static function shouldReturnAnalisys(worldMap:WorldMap, unit:Unit):Bool {
    if (unit.character.goalTile != null && worldMap.isTheSameTile(unit.character.goalTile, worldMap.homeTile)) return true;
    var goalCompletion = calculateGoalCompletion(worldMap, unit);
    unit.goalCompletionRate = goalCompletion;
    var lifeLeft:Float = unit.hp / unit.character.hpMax;

    var flag = Random.float(0,0.4) > lifeLeft || (Random.float(0,0.5) > lifeLeft && goalCompletion > 0.5);
    var emotion = unit.mind.currentEmotion;
    if (emotion == Emotion.rage || emotion == Emotion.distraction || emotion == Emotion.trust) {
      flag = flag && Random.float(0,1) > 0.05;
    } else if (emotion == Emotion.fear) {
      flag = flag || Random.float(0,1) < 0.05;
    }
    flag = flag || goalCompletion >= 1;

    return flag;
  }

  public static function calculateGoalCompletion(worldMap:WorldMap, unit:Unit):Float {
    if (unit.character.goalChar != null) {
      if (unit.goalUnit == null || unit.goalUnit.hp <= 0) {
        return 1;
      } else {
        return unit.goalUnit.goalCompletionRate;
      }
    } else {
      var currentZone:Array<Int> = PositionTool.getZoneForTile(unit.getCoordinate());
      var desiredZone:Array<Int> = PositionTool.getZoneForTile(unit.character.goalTile);
      if(worldMap.isTheSameTile(currentZone, desiredZone)) {
        var percentageOfCollectablesRemaining = worldMap.percentageOfCollectablesRemainingInZone(currentZone);
        return (1 - percentageOfCollectablesRemaining) * 0.7 + 0.3;
      } else {
        try {
          var distance = PositionTool.getDistance(worldMap, unit.getCoordinate(), unit.character.goalTile);
          var maxDistance = Math.abs(unit.character.goalTile[0]) + Math.abs(unit.character.goalTile[1]);
          return (1 - (distance/maxDistance)) * 0.3;
        } catch(e:Dynamic) {
          return 0;
        }
      }
    }
  }

  public static function findGoalChar(worldMap:WorldMap, unit:Unit) {
    for(friend in worldMap.heroes.members) {
      if(friend.character == unit.character.goalChar) {
        unit.goalUnit = friend;
        return;
      }
    }
  }

}
