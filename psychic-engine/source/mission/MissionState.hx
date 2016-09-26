package mission;

import flixel.FlxG;
import flixel.FlxState;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.ui.FlxButton;

import utils.MapMaker;
import mission.WorldMap;

class MissionState extends FlxState {

  public var worldMap:WorldMap;

  override public function create():Void {
    super.create();

    var _map = MapMaker.getMap();

    worldMap = new WorldMap(_map);
    add(worldMap);
    add(worldMap.foods);
    add(worldMap.treasures);
    add(worldMap.monsters);
    add(worldMap.heroes);
  }

  override public function update(elapsed:Float):Void {
    super.update(elapsed);
  }

}
