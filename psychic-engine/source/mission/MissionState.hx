package mission;

import flixel.FlxG;
import flixel.FlxState;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.ui.FlxButton;

import utils.MapMaker;
import mission.world.WorldMap;
import mission.ui.Camera;

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
    add(cam);

    startTurn();
  }

  private function startTurn() {
    for (hero in worldMap.heroes) {
      var action:Array<Int> = hero.character.mind.analyseAction(worldMap);
      hero.executeAction(worldMap, action[0], action[1]);
    }
    for (monster in worldMap.monsters) {
      var action:Array<Int> = monster.character.mind.analyseAction(worldMap);
      monster.executeAction(worldMap, action[0], action[1]);
    }
    //TODO: verify if game ended, and startNewTurn or endGame
  }

}
