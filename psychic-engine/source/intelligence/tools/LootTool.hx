package intelligence.tools;

import flixel.group.FlxGroup;
import flixel.util.typeLimit.OneOfTwo;

import utils.Constants;
import mission.world.Unit;

import gameData.UserData;

class LootTool {

  /* f(x) = const   , x < goldGoal
     f(x) = -nx + a , x > goldGoal
       n = greed
       a = goldWeight
       x = numberOfCollectedgold
  */
  public static function needForgold(unit:Unit):Float {
    var numberOfCollectedgold:Int = unit.goldCollected.length;
    var goldWeight:Float = 1.0;
    var greed:Float = 0.25; // The bigger, less greedy is the character

    if (numberOfCollectedgold < UserData.goldGoal) {
      return goldWeight;
    }

    return (- (greed * numberOfCollectedgold) + goldWeight);

  }
}
