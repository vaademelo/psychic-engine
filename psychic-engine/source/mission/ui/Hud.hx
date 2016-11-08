package mission.ui;

import flixel.group.FlxSpriteGroup;
import flixel.group.FlxGroup;
import flixel.FlxSprite;
import flixel.FlxG;

import utils.Constants;

import mission.world.Unit;
import mission.world.WorldMap;

import mission.ui.CharHud;

class Hud extends FlxSpriteGroup {

  private var border:Int = Constants.HUD_BORDER;
  private var heroes:Map<Unit, CharHud>;

  public function new(worldMap:WorldMap, units:Array<Unit>) {
    super();
    this.scrollFactor.x = 0;
    this.scrollFactor.y = 0;

    var bg = new FlxSprite(0, 0, "assets/images/hud/scroll.png");
    bg.setGraphicSize(220, FlxG.height);
    bg.updateHitbox();
    bg.centerOrigin();
    add(bg);

    var yy:Int = 5;
    heroes = new Map<Unit, CharHud>();
    for (unit in units) {
      yy += addUnitHud(worldMap, unit, yy);
    }
  }

  public function addUnitHud(worldMap:WorldMap, unit:Unit, yPos:Int) {
    var hero = new CharHud(5, yPos, unit, worldMap);
    heroes[unit] = hero;
    add(hero);
    return Std.int(hero.height) + 10;
  }

  public function updateUnitHud(unit:Unit) {
    if(unit.character.team == TeamSide.monsters) return;
    if (unit.hp <= 0) {
      remove(heroes[unit]);
    }
    heroes[unit].updateCharacterHud();
  }
}
