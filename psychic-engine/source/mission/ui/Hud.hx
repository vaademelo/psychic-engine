package mission.ui;

import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.group.FlxGroup;
import flixel.group.FlxSpriteGroup;
import flixel.FlxG;
import flixel.input.mouse.FlxMouseEventManager;

import utils.Constants;

import mission.world.Unit;
import mission.world.WorldMap;

import mission.ui.CharHud;
import mission.ui.DebugMenu;

class Hud extends FlxSpriteGroup {

  private var heroes:Map<Unit, CharHud>;
  public var continueBtn:FlxSprite;

  public function new(worldMap:WorldMap, units:Array<Unit>) {
    super();
    this.scrollFactor.x = 0;
    this.scrollFactor.y = 0;

    var bg = new FlxSprite(10, 10, "assets/images/hud/scroll.png");
    bg.setGraphicSize(268, FlxG.height - 20);
    bg.updateHitbox();
    bg.centerOrigin();
    add(bg);

    updateHud(worldMap, units);

    var debugAiButton = new DebugMenu(worldMap, units, FlxG.width - 110, 10);
    add(debugAiButton);

    FlxMouseEventManager.add(bg, null, null, null, null, false);
  }

  public function updateHud(worldMap:WorldMap, units:Array<Unit>) {
    //clean info if have any
    if (heroes != null) {
      for (key in heroes.keys()) {
        remove(heroes[key]);
      }
    }
    heroes = new Map<Unit, CharHud>();

    if(Constants.debugAi && units.length == 1) {

      // debug hud
      var hero = new CharHud(40, 50, units[0], worldMap, true);
      heroes[units[0]] = hero;
      add(hero);
      this.continueBtn = hero.continueBtn;

    } else {

      // normal hud
      var yy:Int = 50;
      for (unit in units) {
        if (unit.hp <= 0) continue;
        yy += addUnitHud(worldMap, unit, yy);
      }

    }
  }

  public function addUnitHud(worldMap:WorldMap, unit:Unit, yPos:Int):Int {
    var hero = new CharHud(40, yPos, unit, worldMap, false);
    heroes[unit] = hero;
    add(hero);
    return Std.int(hero.height) + 30;
  }

  public function updateUnitHud(unit:Unit) {
    if(unit.character.team == TeamSide.monsters) return;
    if (unit.hp <= 0) {
      if (heroes[unit] != null) remove(heroes[unit]);
    }
    if (heroes[unit] != null) heroes[unit].updateCharacterHud();
  }
}
