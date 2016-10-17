package intelligence.tools;

import flixel.group.FlxGroup;
import flixel.util.typeLimit.OneOfTwo;

import utils.Constants;
import mission.world.Unit;
import intelligence.hero.HeroMind;

import intelligence.tools.PositionTool;
import intelligence.tools.PersonalityTool;

class TriggersTool {

  public static function applyTriggers(worldMap:WorldMap, unit:Unit, mind:HeroMind) {

    analyseSelfStatus(worldMap, unit, mind);
    analyseEnemies(worldMap, unit, mind);
    analyseLoot(worldMap, unit, mind);
    analyseFriends(worldMap, unit, mind);
    analyseObjective(worldMap, unit, mind);
    analyseLastActions(worldMap, unit, mind);
    analyseLastTurn(worldMap, unit, mind);
  }

  public static function analyseSelfStatus(worldMap:WorldMap, unit:Unit, mind:HeroMind) {

    var runningLowOnHealth = unit.hp <= Math.ceil(0.5 * unit.character.hpMax);
    PersonalityTool.lowHealthTrigger(mind, runningLowOnHealth);

    var hasAnyInjuries = unit.injuriesCount > 0 ?
    PersonalityTool.injuriesTrigger(mind, hasAnyInjuries);
  }

  public static function analyseEnemies(worldMap:WorldMap, unit:Unit, mind:HeroMind) {
    var enemyTeam = (unit.team == TeamSide.heroes) ? worldMap.monsters : worldMap.heroes;
    var enemiesOnSight = PositionTool.getObjectsInRange(enemyTeam, unit.getCoordinate(), unit.character.vision);

    var hasAnyEnemyOnSight = enemiesOnSight.length > 0;
    PersonalityTool.enemyOnSightTrigger(mind, hasAnyEnemyOnSight);

    // Any strong enemy on sight?
    var strongEnemyOnSight = false;
    for (enemy in enemiesOnSight) {
      var chanceOfWinning = BattleTool.chanceOfWinning(enemy, unit);

    }

    // Any big danger tile?
  }

  public static function analyseLoot(worldMap:WorldMap, unit:Unit, mind:HeroMind) {
    // Are there lots of collectables here?

    // Is there any good loot here?

    // Holding lots of collectables?
  }

  public static function analyseFriends(worldMap:WorldMap, unit:Unit, mind:HeroMind) {
    // Is there any friends near by?

    // Am I alone here?

    // Is there a friend in danger?

  }

  public static function analyseObjective(worldMap:WorldMap, unit:Unit, mind:HeroMind) {
    //
  }

  public static function analyseLastActions(worldMap:WorldMap, unit:Unit, mind:HeroMind) {
    // Have I missed last atack?

    // Have I done a critical?

    // Was I attacked last turn?

  }

  public static function analyseLastTurn(worldMap:WorldMap, unit:Unit, mind:HeroMind) {
    // Has a enemy died last turn?

    // Has a friend died last turn?

  }

}
