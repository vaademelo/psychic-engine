package day.engine;

import flixel.group.FlxSpriteGroup;
import flixel.group.FlxGroup;
import flixel.util.FlxColor;
import flixel.text.FlxText;
import flixel.FlxSprite;
import flixel.FlxG;

class Hud extends FlxSpriteGroup {

  private var border:Int = 15;
  private var treasureText:FlxText;
  private var treasureCount:Int = 0;
  private var heroes:Map<Unit, FlxSpriteGroup>;

  public function new() {
    super();
    this.scrollFactor.x = 0;
    this.scrollFactor.y = 0;

    addTreasureHud();
  }

  private function addTreasureHud() {
    var treasureHud = new FlxSpriteGroup();
    this.add(treasureHud);

    var boxUnderIcon = new FlxSprite();
    var color = new FlxColor();
    boxUnderIcon.makeGraphic(72, 36, color.setRGB(0, 0, 0, 200));

    treasureText = new FlxText(0, 4, 42);
    treasureText.setFormat("assets/fonts/squeakyChalkSound.ttf", 16, FlxColor.WHITE, FlxTextAlign.RIGHT);
    treasureText.text = Std.string(treasureCount);

    var treasureIcon:FlxSprite = new FlxSprite(42, 6);
    treasureIcon.loadGraphic("assets/images/hud/treasure.png", false, 24, 24);

    treasureHud.add(boxUnderIcon);
    treasureHud.add(treasureText);
    treasureHud.add(treasureIcon);

    treasureHud.x = FlxG.width - treasureHud.width - border;
    treasureHud.y = FlxG.height - treasureHud.height - border;
  }

  public function addUnitsHud(units:FlxTypedGroup<Unit>) {
    var heroesCount:Int = 0;
    heroes = new Map<Unit, FlxSpriteGroup>();
    for(unit in units.members) {
      var heroHud = new FlxSpriteGroup();
      this.add(heroHud);

      var heroIcon:FlxSprite = new FlxSprite();
      heroIcon.loadGraphic("assets/images/hud/h"+unit.armor+".png", false, 24, 24);
      heroHud.add(heroIcon);

      var nHearts:Int = unit.maxHp;
      for (i in 0 ... nHearts) {
        var heart:FlxSprite = new FlxSprite(heroIcon.height + 5 + (i * 29), 3);
        heart.loadGraphic("assets/images/hud/heart.png", true, 18, 18);
        heart.animation.add("full", [0]);
        heart.animation.add("empty", [1]);
        heart.animation.play("full");
        heart.animation.stop();
        heroHud.add(heart);
      }
      var nInjuries:Int = unit.injuryMax;
      for (i in 0 ... nInjuries) {
        var injury:FlxSprite = new FlxSprite(heroIcon.height + 5 + (i * 29), 22);
        injury.loadGraphic("assets/images/hud/injury.png", true, 28, 18);
        injury.animation.add("full", [0]);
        injury.animation.add("empty", [1]);
        injury.animation.play("empty");
        injury.animation.stop();
        heroHud.add(injury);
      }

      heroHud.x = border;
      heroHud.y = border + heroesCount * (heroHud.height + 5);

      heroes.set(unit, heroHud);
      heroesCount++;
    }
  }

  public function setTreasureCounter(value:Int) {
    treasureCount += value;
    treasureText.text = Std.string(treasureCount);
  }

  public function updateUnitHud(unit:Unit) {
    var heroHud = heroes.get(unit);
    var nHearts:Int = unit.maxHp;
    for (i in 0 ... nHearts) {
      if(i < unit.hp) {
        heroHud.members[1 + i].animation.play("full");
        heroHud.members[1 + i].animation.stop();
      } else {
        heroHud.members[1 + i].animation.play("empty");
        heroHud.members[1 + i].animation.stop();
      }
    }
    var nInjuries:Int = unit.injuryMax;
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
