package mission;

import utils.Constants;
import mission.WorldObject;
import gameData.Character;

class Unit extends WorldObject {

  public var character:Character;

  public function new(character:Character, i:Int, j:Int) {
    super(i,j);
    this.character = character;
    this.loadGraphic(character.imageSource);
    this.setCoordinate(i,j);
  }

}
