package intelligence.tools;

import flixel.group.FlxGroup;
import flixel.util.typeLimit.OneOfTwo;

import utils.Constants;
import mission.world.Unit;

import gameData.UserData;

class LootTool {

  /* f(x) = const   , x < foodGoal
     f(x) = -nx + a , x > foodGoal
       n = greed
       a = foodWeight
       x = numberOfCollectedFood
  */
  public static function needForFood(unit:Unit):Float {
    var numberOfCollectedFood:Int = unit.foodCollected.length;
    var foodWeight:Float = 1.0;
    var greed:Float = 0.25; // The bigger, less greedy is the character

    if (numberOfCollectedFood < UserData.foodGoal) {
      return foodWeight;
    }

    return (- (greed * numberOfCollectedFood) + foodWeight);

  }
}
