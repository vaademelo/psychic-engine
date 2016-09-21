/*package day.ai;

import flixel.group.FlxGroup;
import flixel.FlxG;

import day.engine.Dungeon;
import day.engine.Unit;
import day.engine.Body;
import day.ai.Mind;

class ControllableHeroAi extends Mind {

  public function new() {
    super();
  }

  override public function chooseAction(dungeon:Dungeon, body:Body, units:FlxTypedGroup<Unit>):Bool {
    super.chooseAction(dungeon, body, units);
    if (FlxG.mouse.justReleased) {
      for(unit in units.members) {
        if(unit.alive &&
           FlxG.mouse.x > unit.body.x &&
           FlxG.mouse.y > unit.body.y &&
           FlxG.mouse.x < unit.body.x + Dungeon.TILESIZE &&
           FlxG.mouse.y < unit.body.y + Dungeon.TILESIZE)
        {
          var tileTarget:Array<Int> = Dungeon.getCordinateFromPixel(unit.body.x, unit.body.y);
          var attackTile:Array<Int> = body.getNearestTileInRange(dungeon, tileTarget[0], tileTarget[1]);
          if (attackTile!= null && body.canWalkThere(dungeon, attackTile[0], attackTile[1])){
            this.atackTarget = unit;
            body.gotoTile(dungeon, attackTile[0], attackTile[1]);
            return true;
          }
        }
      }
      var mouseTile = Dungeon.getCordinateFromPixel(FlxG.mouse.x, FlxG.mouse.y);
      if(body.canWalkThere(dungeon, mouseTile[0], mouseTile[1])){
        body.gotoTile(dungeon, mouseTile[0], mouseTile[1]);
        return true;
      }
    }
    return false;
  }

}*/
