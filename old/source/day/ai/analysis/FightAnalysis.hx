package day.ai.analysis;

import flixel.group.FlxGroup;

import day.engine.Dungeon;
import day.engine.Unit;

import day.ai.analysis.PositionAnalysis;

class FightAnalysis {

  public static function getEasiestEnemy(dungeon:Dungeon, unit:Unit, enemies:Array<Unit>, factor:Int = 0):Array<Dynamic> {
    var easiestEnemy:Unit = null;
    var bestRatio:Float = null;
    for(enemy in enemies) {
      var ratio = winRatio(unit, enemy);
      if(bestRatio == null || ratio > bestRatio) {
        easiestEnemy = enemy;
        bestRatio = ratio;
      }
    }
    var atackTile = PositionAnalysis.getTileForAtack(dungeon, unit, easiestEnemy);
    return [bestRatio - factor, atackTile, easiestEnemy];
  }

  private static function winRatio(unit:Unit, enemy:Unit):Float {
    var unitAtackChances = unit.atacksChance[enemy.armor];
    var enemyAtackChances = enemy.atacksChance[unit.armor];

    var unitDamageRatio = (unitAtackChances[crit] * 2 + unitAtackChances[hit])/100;
    var enemyDamageRatio = (enemyAtackChances[crit] * 2 + enemyAtackChances[hit])/100;

    var unitKillTurnProb = enemy.hp / unitDamageRatio;
    var enemyKillTurnProb = unit.hp / enemyDamageRatio;

    var ratio = (unitKillTurnProb > enemyKillTurnProb) ? 3 : (unitKillTurnProb == enemyKillTurnProb) ? 2 : 1;

    return ratio;
  }

}
