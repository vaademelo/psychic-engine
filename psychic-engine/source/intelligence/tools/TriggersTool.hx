package intelligence.tools;

import flixel.group.FlxGroup;
import flixel.util.typeLimit.OneOfTwo;

import utils.Constants;
import mission.world.Unit;
import mission.world.WorldMap;
import intelligence.HeroMind;

import intelligence.tools.PositionTool;
import intelligence.tools.PersonalityTool;

class TriggersTool {

  public static function analyseTriggers(worldMap:WorldMap, unit:Unit, mind:HeroMind) {
    analyseSelfStatus(worldMap, unit, mind);
    analyseEnemies(worldMap, unit, mind);
    analyseLoot(worldMap, unit, mind);
    analyseFriends(worldMap, unit, mind);
    analyseMyLastActions(worldMap, unit, mind);
    analyseLastTurn(worldMap, unit, mind);
  }

  public static function analyseSelfStatus(worldMap:WorldMap, unit:Unit, mind:HeroMind) {

    var runningLowOnHealth = unit.hp <= Math.ceil(0.5 * unit.character.hpMax);
    PersonalityTool.lowHealthTrigger(mind, runningLowOnHealth);

    var hasAnyInjuries = unit.injuriesCount > 0;
    PersonalityTool.injuriesTrigger(mind, hasAnyInjuries);
  }

  public static function analyseEnemies(worldMap:WorldMap, unit:Unit, mind:HeroMind) {
    var enemyTeam = (unit.character.team == TeamSide.heroes) ? worldMap.monsters : worldMap.heroes;
    var enemiesOnSight = PositionTool.getObjectsInRange(enemyTeam, unit.getCoordinate(), unit.character.vision);

    var hasAnyEnemyOnSight = enemiesOnSight.length > 0;
    PersonalityTool.enemyOnSightTrigger(mind, hasAnyEnemyOnSight);

    var strongEnemyOnSight = false;
    for (enemy in enemiesOnSight) {
      var chanceOfWinning = BattleTool.chanceOfWinning(enemy, unit);
      if (chanceOfWinning < -0.5) {
        strongEnemyOnSight = true;
        break;
      }
    }
    PersonalityTool.strongEnemyTrigger(mind, strongEnemyOnSight);
  }

  public static function analyseLoot(worldMap:WorldMap, unit:Unit, mind:HeroMind) {
    var foodOnSight = PositionTool.getObjectsInRange(worldMap.foods, unit.getCoordinate(), unit.character.vision);
    var treasuresOnSight = PositionTool.getObjectsInRange(worldMap.treasures, unit.getCoordinate(), unit.character.vision);

    var lotsOfCollectablesOnSight = foodOnSight.length + treasuresOnSight.length > 3;
    PersonalityTool.collectablesOnSightTrigger(mind, lotsOfCollectablesOnSight);

    var holdingLotsOfCollectables = unit.foodCollected.length + unit.treasureCollected.length > 3;
    PersonalityTool.holdingCollectablesTrigger(mind, holdingLotsOfCollectables);
  }

  public static function analyseFriends(worldMap:WorldMap, unit:Unit, mind:HeroMind) {
    var myTeam = (unit.character.team == TeamSide.heroes) ? worldMap.heroes : worldMap.monsters;
    var alliesOnSight = PositionTool.getObjectsInRange(myTeam, unit.getCoordinate(), unit.character.vision);

    var hasAlliesNearBy = alliesOnSight.length > 0;
    PersonalityTool.alliesNearByTrigger(mind, hasAlliesNearBy);

    // Is there a friend in danger?
    var friendInDanger = false;

  }

  public static function analyseMyLastActions(worldMap:WorldMap, unit:Unit, mind:HeroMind) {
    // Have I missed last atack?

    // Have I done a critical?

    // Was I attacked last turn?

  }

  public static function analyseLastTurn(worldMap:WorldMap, unit:Unit, mind:HeroMind) {
    // Has a enemy died last turn?

    // Has a friend died last turn?

  }

}
