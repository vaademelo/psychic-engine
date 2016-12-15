package mission;

import Random;

import mission.world.Unit;
import mission.world.WorldMap;

import mission.ui.Hud;
import mission.visualFX.BattleFX;

import utils.Constants;

import intelligence.tools.PositionTool;

class BattleExecuter {

  public static function atackOpponent(worldMap:WorldMap, unit:Unit, opponent:Unit, callBack:Void->Bool):Bool {
    var damage = getAtackDamage(unit, opponent);
    saveOnMindBattleReport(unit, opponent, damage);
    return applyDamage(worldMap, opponent, damage, callBack);
  }

  public static function getAtackDamage(unit:Unit, opponent:Unit):Int {
    var damage = 0;

    var randomValue = Random.float(0,1);
    var hitChance = unit.character.hitChance[opponent.character.bodyKind] - unit.accuracyPenalty;
    hitChance = Math.max(hitChance, 0);
    var critChance = unit.character.critChance[opponent.character.bodyKind] - unit.critAccuracyPenalty;
    critChance = Math.max(critChance, 0);
    if (randomValue <= critChance) {
      damage = 2;
    } else if (randomValue <= hitChance + critChance) {
      damage = 1;
    }

    return damage;
  }

  public static function applyDamage(worldMap:WorldMap, opponent:Unit, damage:Int, callBack:Void->Bool):Bool {
    opponent.hp -= damage;
    worldMap.hud.updateUnitHud(opponent);

    if (opponent.hp <= 0) {
      var func = function () {
        worldMap.setTileAsWalkable(opponent.i, opponent.j, true);
        opponent.kill();
        if(opponent.emotionFX != null) opponent.emotionFX.kill();
        callBack();
      }
      var effect = new BattleFX(BattleEffectKind.kill, opponent.x, opponent.y - opponent.height/2, func);
      worldMap.effects.add(effect);
      unitsThatSawHisDeath(worldMap, opponent);
    } else {
      var kind = BattleEffectKind.fail;
      if (damage == 1) kind = BattleEffectKind.hit;
      else if (damage == 2) kind = BattleEffectKind.crit;
      var effect = new BattleFX(kind, opponent.x, opponent.y - opponent.height/2, callBack);
      worldMap.effects.add(effect);
    }
    return true;
  }

  public static function saveOnMindBattleReport(unit:Unit, opponent:Unit, damage:Int) {
    opponent.mind.wasAtackedLastTurn = true;
    if (damage == 0) {
      unit.mind.missedLastAtack = true;
    } else if (damage == 2) {
      unit.mind.criticalLastAtack = true;
    }
    if (opponent.hp <= damage) {
      unit.kills ++;
    }
  }

  public static function unitsThatSawHisDeath(worldMap:WorldMap, unit:Unit) {
    var friends = unit.character.team == TeamSide.heroes ? worldMap.heroes.members : worldMap.monsters.members;
    var enemies = unit.character.team == TeamSide.heroes ? worldMap.monsters.members : worldMap.heroes.members;

    for (friend in friends) {
      if(friend.getUnitVision() >= PositionTool.getDistance(worldMap, unit.getCoordinate(), friend.getCoordinate())) {
        friend.mind.friendDiedLastTurn = true;
      }
    }
    for (enemy in enemies) {
      if(enemy.getUnitVision() >= PositionTool.getDistance(worldMap, unit.getCoordinate(), enemy.getCoordinate())) {
        enemy.mind.enemyDiedLastTurn = true;
      }
    }
  }
}
