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
      var levelOfDanger = hitRelevance(opponent, unit);
      smallestLevelOfDanger = (levelOfDanger < smallestLevelOfDanger) ? levelOfDanger : smallestLevelOfDanger;
      weakestOponent = opponent;
    }

    return weakestOponent.getCoordinate();
  }

  public static function hitRelevance(atacker:Unit, defender:Unit):Float {
    var avarageDamage = atacker.character.hitChance[defender.character.bodyKind] + (2 * atacker.character.critChance[defender.character.bodyKind]);

    var hit = avarageDamage/defender.hp;

    return Math.max(0, Math.min(1, hit));
  }

  public static function chanceOfWinning(opponent:Unit, unit:Unit):Float {
    var unitHitRelevance = hitRelevance(unit, opponent);
    var opponentHitRelevance = hitRelevance(opponent, unit);

    if (opponentHitRelevance > unitHitRelevance) return 0;

    var turnsToKillOpponent:Int = Math.ceil(1/unitHitRelevance);
    var damageUnitWillTake = opponentHitRelevance * turnsToKillOpponent;
    var chanceOfWinning = Math.max(0, Math.min(1, 1 - damageUnitWillTake));

    // f(x) = 2 * (x - 0.5)
    return 2 * (chanceOfWinning - 0.5);
  }

}
