package mission;

import flixel.FlxG;
import flixel.FlxState;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import flixel.input.mouse.FlxMouseEventManager;

import utils.MapMaker;
import utils.Constants;

import mission.ui.Camera;

import intelligence.debug.TileWeight;
import intelligence.tools.GoalTool;
import intelligence.tools.TileWeightTool;

import mission.world.Unit;
import mission.world.WorldMap;

import mission.ActionExecuter;

import camping.MissionReportState;

class MissionState extends FlxState {

  public var worldMap:WorldMap;
  public var cam:Camera;

  public var turn:Int = 0;

  public static var nextCallBack:FlxSprite->Void;

  override public function create():Void {
    super.create();

    var _map = MapMaker.getMap();

    cam = new Camera();
    worldMap = new WorldMap(_map, cam);

    add(worldMap);
    add(worldMap.golds);
    add(worldMap.treasures);
    add(worldMap.monsters);
    add(worldMap.heroes);
    add(worldMap.decorativeObjects);
    add(worldMap.effects);
    add(worldMap.emotions);
    add(worldMap.heatMap);
    add(worldMap.tileAnalisys);
    add(worldMap.hud);
    add(cam);

    for (hero in worldMap.heroes) {
      worldMap.emotions.add(hero.emotionFX);

      if (hero.character.goalChar != null) {
        GoalTool.findGoalChar(worldMap, hero);
      }
    }

    worldMap.fixHeroesGoals();

    FlxG.sound.playMusic("assets/sounds/mission_track.ogg");

    startNewTurn();
  }

  public function startNewTurn() {
    var list = worldMap.heroes.members.concat(worldMap.monsters.members);
    unitAction(list);
  }

  public function unitAction(list:Array<Unit>):Bool {
    // verify if mission ended
    if (worldMap.heroes.countLiving() <= 0) return endMission();

    // get next unit from list
    turn = (turn + 1) % list.length;
    var unit = list.shift();

    //remove dead units from list
    if (!unit.alive) return unitAction(list);
    list.push(unit);

    //1st: heal unit if needed
    unit.healIfNeeded(worldMap);

    //2nd: update unit mindStatus
    unit.mind.updateStatus(worldMap);

    //3rd: unit think next action
    var action:Array<Int> = unit.mind.analyseAction(worldMap);

    //4rd: execute unit action or wait if on debug mode
    if (Constants.debugAi && unit.mind.debugMe) {
      worldMap.hud.updateHud(worldMap, [unit]);
      MissionState.nextCallBack = function (sprite:FlxSprite) {
        TileWeightTool.cleanHeatMap(worldMap);
        ActionExecuter.executeAction(worldMap, unit, action, unitAction, list);
        FlxMouseEventManager.remove(worldMap.hud.continueBtn);
      }
      FlxMouseEventManager.add(worldMap.hud.continueBtn, null, MissionState.nextCallBack, null, null);
    } else {
      ActionExecuter.executeAction(worldMap, unit, action, unitAction, list);
    }

    return true;
  }


  public function endMission():Bool {
    FlxG.camera.fade(FlxColor.BLACK,.33, false, function() {
      FlxG.switchState(new MissionReportState(worldMap.heroes.members));
    });
    return true;
  }

}
