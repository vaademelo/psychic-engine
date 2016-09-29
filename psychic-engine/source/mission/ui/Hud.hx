package mission.ui;

import flixel.group.FlxSpriteGroup;
import flixel.group.FlxGroup;
import flixel.FlxSprite;

import utils.Constants;

import mission.world.Unit;

class Hud extends FlxSpriteGroup {

  private var border:Int = Constants.HUD_BORDER;
  private var unitsHud:FlxSpriteGroup;
  private var heroes:Map<Unit, FlxSpriteGroup>;

  public function new(units:Array<Unit>) {
    super();
    this.scrollFactor.x = 0;
    this.scrollFactor.y = 0;

    unitsHud = new FlxSpriteGroup();
    unitsHud.x = border;
    unitsHud.y = border;
    heroes = new Map<Unit, FlxSpriteGroup>();
    for (unit in units) {
      addUnitHud(unit);
    }
    add(unitsHud);
  }

  public function addUnitHud(unit:Unit) {
    var heroHud = new FlxSpriteGroup();
    unitsHud.add(heroHud);
    heroHud.y = unitsHud.height + Constants.HUD_BORDER;

    var heroIcon:FlxSprite = new FlxSprite();
    heroIcon.loadGraphic("assets/images/hud/h"+unit.character.bodyKind+".png");
    heroHud.add(heroIcon);

    var nHearts:Int = unit.character.hpMax;
    for (i in 0 ... nHearts) {
      var heart:FlxSprite = new FlxSprite(heroIcon.height + 5 + (i * 29), 3);
      heart.loadGraphic("assets/images/hud/heart.png", true, 18, 18);
      heart.animation.add("full", [0]);
      heart.animation.add("empty", [1]);
      heart.animation.play("full");
      heart.animation.stop();
      heroHud.add(heart);
    }

    var nInjuries:Int = unit.character.injuryMax;
    for (i in 0 ... nInjuries) {
      var injury:FlxSprite = new FlxSprite(heroIcon.height + 5 + (i * 29), 22);
      injury.loadGraphic("assets/images/hud/injury.png", true, 28, 18);
      injury.animation.add("full", [0]);
      injury.animation.add("empty", [1]);
      injury.animation.play("empty");
      injury.animation.stop();
      heroHud.add(injury);
    }

    heroes.set(unit, heroHud);
  }

  public function updateUnitHud(unit:Unit) {
    var heroHud = heroes.get(unit);
    var nHearts:Int = unit.character.hpMax;
    for (i in 0 ... nHearts) {
      if(i < unit.hp) {
        heroHud.members[1 + i].animation.play("full");
        heroHud.members[1 + i].animation.stop();
      } else {
        heroHud.members[1 + i].animation.play("empty");
        heroHud.members[1 + i].animation.stop();
      }
    }
    var nInjuries:Int = unit.character.injuryMax;
    for (i in 0 ... nInjuries) {
      if(i >= unit.injury) {
        heroHud.members[1 + nHearts + i].animation.play("empty");
        heroHud.members[1 + nHearts + i].animation.stop();
      } else {
        heroHud.members[1 + nHearts + i].animation.play("full");
        heroHud.members[1 + nHearts + i].animation.stop();
      }
    }
  }
}
