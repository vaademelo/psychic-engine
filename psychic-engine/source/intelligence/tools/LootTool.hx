package intelligence.tools;

import flixel.group.FlxGroup;
import flixel.util.typeLimit.OneOfTwo;

import utils.Constants;
import mission.world.Unit;

import gameData.UserData;

class LootTool {

  public static function needForFood(unit:Unit):Float {
    if (unit.foodCollected.length < UserData.foodGoal) {
      return 1.0;
    }
    return 0.5;
  }
}
