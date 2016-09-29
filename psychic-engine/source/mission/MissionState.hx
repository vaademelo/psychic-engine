package mission;

import flixel.FlxG;
import flixel.FlxState;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.ui.FlxButton;

import utils.MapMaker;
import mission.ui.Camera;
import mission.world.Unit;
import mission.ActionExecuter;
import mission.world.WorldMap;

class MissionState extends FlxState {

  public var worldMap:WorldMap;
  public var cam:Camera;

  override public function create():Void {
    super.create();

    var _map = MapMaker.getMap();
    cam = new Camera();

    worldMap = new WorldMap(_map);
    add(worldMap);
    add(worldMap.foods);
    add(worldMap.treasures);
    add(worldMap.monsters);
    add(worldMap.heroes);
    add(worldMap.effects);
    add(cam);

    startNewTurn();
  }

  public function startNewTurn() {
    var list = worldMap.heroes.members.concat(worldMap.monsters.members);
    unitAction(list);
  }

  public function unitAction(list:Array<Unit>):Void {
    if (list.length == 0) {
      startNewTurn();
      return;
    }
    var unit = list.shift();
    if (!unit.alive) unitAction(list);
    //1st: heal unit if needed
    unit.healIfNeeded();
    //2nd: unit think next action
    var action:Array<Int> = unit.character.mind.analyseAction(worldMap, unit);
    //3rd: execute unit action
    ActionExecuter.executeAction(worldMap, unit, action, unitAction, list);
  }

}
