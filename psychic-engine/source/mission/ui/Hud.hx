package mission.ui;

import flixel.group.FlxSpriteGroup;
import flixel.group.FlxGroup;
import flixel.FlxSprite;
import flixel.FlxG;

import utils.Constants;

import mission.world.Unit;
import mission.world.WorldMap;

import mission.ui.CharHud;
import mission.ui.DebugButton;

class Hud extends FlxSpriteGroup {

  private var heroes:Map<Unit, CharHud>;

  public function new(worldMap:WorldMap, units:Array<Unit>) {
    super();
    this.scrollFactor.x = 0;
    this.scrollFactor.y = 0;

    var bg = new FlxSprite(10, 10, "assets/images/hud/scroll.png");
    bg.setGraphicSize(268, FlxG.height - 20);
    bg.updateHitbox();
    bg.centerOrigin();
    add(bg);

    var yy:Int = 50;
    heroes = new Map<Unit, CharHud>();
    for (unit in units) {
      yy += addUnitHud(worldMap, unit, yy);
    }

    var debugAiButton = new DebugButton(FlxG.width - 110, 10);
    add(debugAiButton);
  }

  public function addUnitHud(worldMap:WorldMap, unit:Unit, yPos:Int) {
    var hero = new CharHud(40, yPos, unit, worldMap);
    heroes[unit] = hero;
    add(hero);
    return Std.int(hero.height) + 30;
  }

  public function updateUnitHud(unit:Unit) {
    if(unit.character.team == TeamSide.monsters) return;
    if (unit.hp <= 0) {
      remove(heroes[unit]);
    }
    heroes[unit].updateCharacterHud();
  }
}
