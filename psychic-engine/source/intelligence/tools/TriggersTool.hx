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
    var hasAnyEnemyOnSight = mind.opponentsInRange.length > 0;
    PersonalityTool.enemyOnSightTrigger(mind, hasAnyEnemyOnSight);

    var strongEnemyOnSight = false;
    for (enemy in mind.opponentsInRange) {
      var chanceOfWinning = BattleTool.chanceOfWinning(enemy, unit);
      if (chanceOfWinning < -0.5) {
        strongEnemyOnSight = true;
        break;
      }
    }
    PersonalityTool.strongEnemyTrigger(mind, strongEnemyOnSight);
  }

  public static function analyseLoot(worldMap:WorldMap, unit:Unit, mind:HeroMind) {
    var collectablesOnSight = mind.goldsInRange.length + mind.treasuresInRange.length > 0;
    PersonalityTool.collectablesOnSightTrigger(mind, collectablesOnSight);

    var holdingCollectables = unit.goldCollected.length + unit.treasureCollected.length > 0;
    PersonalityTool.holdingCollectablesTrigger(mind, holdingCollectables);
  }

  public static function analyseFriends(worldMap:WorldMap, unit:Unit, mind:HeroMind) {
    var hasAlliesNearBy = mind.friendsInRange.length > 0;
    PersonalityTool.alliesNearByTrigger(mind, hasAlliesNearBy);

    var friendInDanger = false;
    for (friend in mind.friendsInRange) {
      if (friend.hp > Math.ceil(0.5 * friend.character.hpMax)) continue;
      for (enemy in mind.opponentsInRange) {
        var chanceOfWinning = BattleTool.chanceOfWinning(enemy, friend);
        if (chanceOfWinning < -0.5) {
          friendInDanger = true;
          break;
        }
      }
      if (friendInDanger) break;
    }
    PersonalityTool.friendInDangerTrigger(mind, friendInDanger);
  }

  public static function analyseMyLastActions(worldMap:WorldMap, unit:Unit, mind:HeroMind) {
    PersonalityTool.missedLastAtackTrigger(mind, mind.missedLastAtack);
    PersonalityTool.doneACriticalTrigger(mind, mind.criticalLastAtack);
    PersonalityTool.wasAtackedTrigger(mind, mind.wasAtackedLastTurn);
  }

  public static function analyseLastTurn(worldMap:WorldMap, unit:Unit, mind:HeroMind) {
    PersonalityTool.enemyDiedLastTurnTrigger(mind, mind.enemyDiedLastTurn);
    PersonalityTool.friendDiedLastTurnTrigger(mind, mind.friendDiedLastTurn);
  }

}
