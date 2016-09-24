package gameData;

enum TreasureKind {
  food;
  item;
}

class Treasure {

  public var kind:TreasureKind;
  public var name:String;
  public var effectDescription:String;
  public var iconSource:String;
  public var rarity:int;
  public var effect:Void->Void;

  public function new() {
    
    //TODO:0 Set Data from kind
  }

}
