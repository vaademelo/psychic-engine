package gameData;

import Random;

enum TeamSide {
  heroes;
  monsters;
}

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

  public function new(team:TeamSide) {
    //TODO: create constructort

    if(team == heroes) {
      this.hpMax = Random.int(3, 4);
      this.injuryMax = Random.int(3, 5);
      this.movement = Random.int(3, 4);
      this.bodyKind = Random.enumConstructor(BodyKind);
      this.hitChance = new Map<BodyKind,Float>();
      this.critChance = new Map<BodyKind,Float>();
      this.vision = Random.int(5, 6);
      this.imageSource = "assets/images/bodies/h" + Std.string(bodyKind) + ".png";

      var bodyKinds = Type.allEnums(BodyKind);
      for(body in bodyKinds) {
        this.hitChance[body] = Random.float(0.3, 0.7);
        this.critChance[body] = Random.float(0.0, 0.3);
      }
    } else {

    }

  }

}
