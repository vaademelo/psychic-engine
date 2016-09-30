package intelligence.tools;

import flixel.group.FlxGroup;
import flixel.util.typeLimit.OneOfTwo;

import utils.Constants;
import mission.world.Unit;

class BattleTool {

  public static function getWeakestOpponent(opponents:Array<Unit>, unit:Unit):Array<Int> {
    var weakestOponent:Unit = opponents[0];
    var smallestLevelOfDanger:Float = 1000.0;

    for (opponent in opponents) {
      var levelOfDanger = opponent.character.hitChance[unit.character.bodyKind] + opponent.character.critChance[unit.character.bodyKind];
      smallestLevelOfDanger = (levelOfDanger < smallestLevelOfDanger) ? levelOfDanger : smallestLevelOfDanger;
      weakestOponent = opponent;
    }

    return weakestOponent.getCoordinate();
  }

}
