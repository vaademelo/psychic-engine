package mission;

import Random;

import mission.world.Unit;
import mission.world.WorldMap;

import mission.visualFX.BattleFX;

import utils.Constants;

class BattleExecuter {

  public static function atackOpponent(worldMap:WorldMap, unit:Unit, opponent:Unit, callBack:Void->Bool):Bool {
    var damage = getAtackDamage(unit, opponent);
    return applyDamage(worldMap, opponent, damage, callBack);
  }

  public static function getAtackDamage(unit:Unit, opponent:Unit):Int {
    var damage = 0;

    var randomValue = Random.float(0,1);
    var hitChance = unit.character.hitChance[opponent.character.bodyKind];
    var critChance = unit.character.critChance[opponent.character.bodyKind];
    if (randomValue <= hitChance) {
      damage = 1;
    } else if (randomValue <= hitChance + critChance) {
      damage = 2;
    }

    return damage;
  }

  public static function applyDamage(worldMap:WorldMap, opponent:Unit, damage:Int, callBack:Void->Bool):Bool {
    opponent.hp -= damage;

    if (opponent.hp <= 0) {
      var func = function () {
        opponent.kill();
        callBack();
      }
      var effect = new BattleFX(BattleEffectKind.kill, opponent.x, opponent.y - opponent.height/2, func);
      worldMap.effects.add(effect);
    } else {
      var kind = BattleEffectKind.fail;
      if (damage == 1) kind = BattleEffectKind.hit;
      else if (damage == 2) kind = BattleEffectKind.crit;
      var func = function () {
        callBack();
      }
      var effect = new BattleFX(kind, opponent.x, opponent.y - opponent.height/2, func);
      worldMap.effects.add(effect);
    }
    return true;
  }
}
