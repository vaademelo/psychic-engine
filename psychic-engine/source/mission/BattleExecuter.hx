package mission;

import Random;

import mission.world.Unit;
import mission.world.WorldMap;

import utils.Constants;

class BattleExecuter {

  public static function atackOpponent(unit:Unit, opponent:Unit) {
    var damage = getAtackDamage(unit, opponent);
    trace('damage:' + damage);
    applyDamage(opponent, damage);
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

  public static function applyDamage(opponent:Unit, damage:Int) {
    opponent.hp -= damage;

    if (opponent.hp <= 0) {
      opponent.kill();
    }

  }
}
