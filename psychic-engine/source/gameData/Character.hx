package gameData;

enum BodyKind {
  fur;
  metal;
  ecto;
}

class Character {

  public var hpMax:Int;
  public var injuryMax:Int;
  public var movement:Int;
  public var bodyKind:BodyKind;
  public var hitChance:Map<BodyKind, Float>;
  public var critChance:Map<BodyKind, Float>;
  public var vision:Int;

  public var imageSource:String;
  public var relationList:Map<Character, Int>;
  public var personality:Array<PersonalityTrait>;

  public function new() {
    //TODO: create constructort
  }

}
