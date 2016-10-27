package intelligence.tools;

import flixel.group.FlxGroup;
import flixel.util.typeLimit.OneOfTwo;

import utils.Constants;

import mission.world.Unit;
import mission.world.WorldMap;

class GoalTool {

  public static function updateGoal(worldMap:WorldMap, unit:Unit) {
    var shouldReturn = shouldReturnAnalisys(worldMap, unit);

    if (shouldReturn) {
      unit.character.goalTile = [0, 0];
    } else {
      if(unit.character.goalUnit != null) {
        followTarget(worldMap, unit);
      }
    }
  }

  public static function followTarget(worldMap:WorldMap, unit:Unit) {
    var tile = [0, 0];
    for(friend in unit.mind.friendsInRange) {
      if(friend.character == unit.character.goalUnit) {
        tile = friend.getCoordinate();
        break;
      }
    }
    unit.character.goalTile = tile;
  }

  public static function shouldReturnAnalisys(worldMap:WorldMap, unit:Unit):Bool {
    //TODO: COMEBACK ANALISYS
    return false;
  }

}
