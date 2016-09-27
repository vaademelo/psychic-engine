package mission.world;

import flixel.util.FlxPath;

import utils.Constants;
import mission.world.WorldMap;
import mission.world.WorldObject;
import gameData.Character;

class Unit extends WorldObject {

  public var character:Character;

  public function new(character:Character, i:Int, j:Int) {
    super(i,j);
    this.character = character;
    this.loadGraphic(character.imageSource);
    this.setCoordinate(i,j);
  }

  public function executeAction(worldMap:WorldMap, i:Int, j:Int, callBack:Array<Unit>->Void, list:Array<Unit>) {
    var tile = worldMap.getTile(j, i);
    if (!worldMap.isTileValid(i,j)) {
      callBack(list);
      return;
    }
    worldMap.setTileAsWalkable(this.i, this.j, true);

    var destination:Array<Int> = [i,j];
    if (!worldMap.isTileWalkable(i,j)) {
      //TODO: Go To nearest Tile
      worldMap.setTileAsWalkable(this.i, this.j, false);
      callBack(list);
      return; //REMOVE THIS!
    }

    var nodes = worldMap.getPath(this.getCoordinate(), destination);
    if (nodes == null || nodes.length == 0) {
      worldMap.setTileAsWalkable(this.i, this.j, false);
      callBack(list);
      return;
    }
    if (nodes.length > this.character.movement) {
      nodes = nodes.slice(0, this.character.movement + 1);
    }
    var path = new FlxPath();
    path.onComplete = function (path:FlxPath) {
      this.updateCoordinate();
      worldMap.setTileAsWalkable(this.i, this.j, false);
      callBack(list);
      return;
    };
    this.path = path;
    this.path.start(nodes, Constants.UNITSPEED);
    // 3rd: if possible, do the action on the tile
  }

}
