package intelligence.tools;

import flixel.group.FlxGroup;
import flixel.util.typeLimit.OneOfTwo;

import utils.Constants;
import mission.world.WorldMap;

import gameData.UserData;

class LootTool {

  public static function needForgold(worldMap:WorldMap):Float {
    var numberOfCollectedgold:Int = UserData.goldTotal;
    for (unit in worldMap.heroes.members) {
      numberOfCollectedgold += unit.goldCollected.length * 2;
    }

    if (numberOfCollectedgold < UserData.goldGoal) {
      return 1.3;
    } else {
      return 0.7;
    }

  }
}
