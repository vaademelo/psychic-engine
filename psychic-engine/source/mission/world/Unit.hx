package mission.world;

import Random;

import mission.world.WorldMap;
import mission.world.WorldObject;
import utils.Constants;
import mission.world.Collectable;
import gameData.Character;

import intelligence.Mind;
import intelligence.HeroMind;
import intelligence.MonsterMind;

import mission.visualFX.EmotionFX;

class Unit extends WorldObject {

  public var character:Character;
  public var hp:Int;
  public var injury:Int;
  public var recoverHealthEveryXTurns:Int = 2;
  public var turnsHurtedCount:Int = 0;
  public var injuriesCount:Int = 0;

  public var kills:Int = 0;
  public var goldCollected:Array<Collectable> = [];
  public var treasureCollected:Array<Collectable> = [];
  public var gotBackSafelly:Bool = false;

  public var mind:Mind;
  public var emotionFX:EmotionFX;

  public var goalUnit:Unit;
  public var goalCompletionRate:Float = 0;
  public var goalToReturnHome:Bool = false;

  public var accuracyPenalty:Float = 0;
  public var critAccuracyPenalty:Float = 0;
  public var visionPenalty:Int = 0;

  public function new(character:Character, i:Int, j:Int) {
    super(i,j);
    this.character = character;
    this.loadGraphic(character.imageSource);
    this.setCoordinate(i,j);
    this.hp = this.character.hpMax;
    this.injury = 0;

    if (this.character.team == TeamSide.heroes) {
      this.mind = new HeroMind(this);
      this.emotionFX = new EmotionFX(this);
    } else {
      this.mind = new MonsterMind(this);
    }
  }

  public function healIfNeeded(worldMap:WorldMap) {
    var hurt = this.character.hpMax - this.hp;
    this.injury += hurt;
    if(this.injury > this.character.injuryMax) {
      this.injury = 0;
      applyInjuryEffect();
    }
    if(hurt > 0) {
      this.turnsHurtedCount ++;
      if(this.turnsHurtedCount == this.recoverHealthEveryXTurns) {
        this.turnsHurtedCount = 0;
        this.hp ++;
      }
    }

    worldMap.hud.updateUnitHud(this);
  }

  public function applyInjuryEffect() {
    var rnd = Random.int(0,3);
    switch rnd {
      case 0:
        this.recoverHealthEveryXTurns ++;
      case 1:
        this.accuracyPenalty += .05;
      case 2:
        this.critAccuracyPenalty += .1;
      case 3:
        if (this.character.vision > this.visionPenalty + 1) {
          this.visionPenalty ++;
        } else {
          this.recoverHealthEveryXTurns ++;
        }
    }

    injuriesCount ++;
  }

  public function givegold(collectable:Collectable) {
    this.goldCollected.push(collectable);
  }

  public function giveTreasure(collectable:Collectable) {
    this.treasureCollected.push(collectable);
  }

  public function getUnitVision() {
    return this.character.vision - this.visionPenalty;
  }

}
