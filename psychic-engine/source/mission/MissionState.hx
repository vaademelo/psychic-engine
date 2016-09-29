package mission;

import flixel.FlxG;
import flixel.FlxState;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.ui.FlxButton;

import utils.MapMaker;

import mission.ui.Camera;

import mission.world.Unit;
import mission.world.WorldMap;

import mission.ActionExecuter;

class MissionState extends FlxState {

  public var worldMap:WorldMap;
  public var cam:Camera;

  override public function create():Void {
    super.create();

    var _map = MapMaker.getMap();

    worldMap = new WorldMap(_map);
    cam = new Camera();

    add(worldMap);
    add(worldMap.foods);
    add(worldMap.treasures);
    add(worldMap.monsters);
    add(worldMap.heroes);
    add(worldMap.effects);
    add(worldMap.hud);
    add(cam);

    startNewTurn();
  }

  public function startNewTurn() {
    var list = worldMap.heroes.members.concat(worldMap.monsters.members);
    unitAction(list);
  }

  public function unitAction(list:Array<Unit>):Void {
    var unit = list.shift();
    if (!unit.alive) unitAction(list);
    list.push(unit);
    //1st: heal unit if needed
    unit.healIfNeeded();
    //2nd: unit think next action
    var action:Array<Int> = unit.character.mind.analyseAction(worldMap, unit);
    //3rd: execute unit action
    ActionExecuter.executeAction(worldMap, unit, action, unitAction, list);
  }

}
