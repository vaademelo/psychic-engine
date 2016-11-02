package camping;

import flixel.FlxState;

import gameData.Character;

class CharacterDetailsState extends FlxState {

  public var character:Character;

  public function new(character:Character) {
    super();
    this.character = character;
    trace(character);
  }

  override public function create():Void {
    super.create();
  }

  override public function update(elapsed:Float):Void {
    super.update(elapsed);
  }

}
