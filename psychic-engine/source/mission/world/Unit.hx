package mission.world;

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

  public function executeAction(worldMap:WorldMap, i:Int, j:Int) {
    //TODO: execute action:
    // 1st: verify target tile
    // 2nd: walk to tile/closest tile available
    // 3rd: if possible, do the action on the tile
  }

}
