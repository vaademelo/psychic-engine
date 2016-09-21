package day.engine;

import flixel.group.FlxGroup;

import day.engine.Effect;
import day.engine.Body;

import day.ai.BasicEnemyAi;
import day.ai.RationalAi;
import day.ai.Mind;

enum TeamSide {
  hero;
  enemy;
}

enum BodyArmor {
  fur;
  metal;
  ecto;
}

enum AtackType {
  crit;
  hit;
}

class Unit extends FlxGroup {

  public var team:TeamSide;
  public var armor:BodyArmor;

  public var mind:Mind;
  public var body:Body;

  public var maxHp:Int;
  public var hp:Int;
  public var injuryMax:Int;
  public var injury:Int = 0;
  public var turnsToHeal:Int;

  public var vision:Int;
  public var walkRange:Int;
  public var atackRange:Int;
  public var rawDistance:Int = 50;

  public var atacksChance:Map<BodyArmor, Map<AtackType, Int>>;
  public static var randomCorrector:Map<TeamSide, Int> = [
    hero => 0,
    enemy => 0
  ];

  private var _hpHeal:Int = 0;

  public function new(team:TeamSide, armor:BodyArmor) {
    super();

    this.team = team;
    this.armor = armor;

    createBody();
    createMind();
    createStat();
  }

  private function createBody() {
    body = new Body(team, armor);
    add(body);
  }

  private function createMind() {
    switch (team) {
      case hero:
      mind = new RationalAi();
      case enemy:
      mind = new BasicEnemyAi();
    }
  }

  private function createStat() {
    var armors = Type.allEnums(BodyArmor);
    if(team == hero) {
      maxHp       = 4;
      hp          = 4;
      injuryMax   = 4;
      walkRange   = 3;
      atackRange  = 4;
      vision      = 5;
      turnsToHeal = 2;
      atacksChance = new Map<BodyArmor, Map<AtackType, Int>>();
      var atackVantage = 20;
      while(armors.length > 0) {
        var armor = Random.fromArray(armors);
        atacksChance[armor] = [crit => atackVantage, hit => atackVantage + 50];
        atackVantage -= 10;
        armors.remove(armor);
      }
    } else {
      maxHp       = 2;
      hp          = 2;
      injuryMax   = 2;
      walkRange   = 2;
      atackRange  = 3;
      vision      = 4;
      turnsToHeal = 2;
      atacksChance = new Map<BodyArmor, Map<AtackType, Int>>();
      var atackVantage = 40;
      while(armors.length > 0) {
        var armor = Random.fromArray(armors);
        atacksChance[armor] = [crit => 0, hit => atackVantage + 30];
        atackVantage -= 20;
        armors.remove(armor);
      }
    }
  }

  public function atackToKill():Int {
    var damage:Int;
    var enemy  = this.mind.target;
    var random = Random.int(0,100);
    random += randomCorrector[this.team];
    if(random < atacksChance[enemy.armor][hit]){
      damage = 1;
      randomCorrector[this.team] += (this.team == hero) ? 0 : 10;
    } else if (random < atacksChance[enemy.armor][hit] + atacksChance[enemy.armor][crit]) {
      damage = 2;
      randomCorrector[this.team] += (this.team == hero) ? 10 : 20;
    } else {
      damage = 0;
      randomCorrector[this.team] += (this.team == hero) ? -10 : -10;
    }
    enemy.hp -= damage;
    var posX:Float = enemy.body.x;
    var posY:Float = enemy.body.y;
    if (enemy.hp <= 0) {
      enemy.kill();
      this.add(new Effect(atack, posX, posY + enemy.body.height/4, 3));
    } else {
      if(enemy.body.x < this.body.x || enemy.body.y < this.body.y) {
        enemy.add(new Effect(atack, posX - enemy.body.width/2, posY, damage));
      } else {
        enemy.add(new Effect(atack, posX + enemy.body.width/2, posY + enemy.body.height/2, damage));
      }
    }
    return damage;
  }

  public function calculateInjury() {
    var hurt = this.maxHp - this.hp;
    this.injury += hurt;
    if(this.injury > this.injuryMax) {
      this.injury = 0;
      this.turnsToHeal ++;
    }
    if(hurt > 0) {
      this._hpHeal ++;
      if(this._hpHeal == this.turnsToHeal) {
        this._hpHeal = 0;
        this.hp ++;
      }
    }

  }

}
