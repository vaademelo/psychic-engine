package gameData;

import Random;

import utils.Constants;

class Treasure {

  public var kind:TreasureKind;
  public var name:String;
  public var effectType:TreasureEffect;
  public var effectDetail:String;
  public var iconSource:String;
  public var rarity:Int;
  public var effect:Void->Void;

  public function new() {

    var rnd = Random.int(0,6);
    switch rnd {
      case 0:
        this.effectType = TreasureEffect.recruitment;
      case 1, 4:
        this.effectType = TreasureEffect.training;
        this.effectDetail = Std.string(Random.fromArray(Type.allEnums(TreasureTrainingDetail)));
      case 2, 5:
        this.effectType = TreasureEffect.behaviour;
        this.effectDetail = Std.string(Random.fromArray(Type.allEnums(TreasureBehaviouDetail)));
      case 3, 6:
        this.effectType = TreasureEffect.relation;
    }

  }

}
