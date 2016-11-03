package mission.world;

import mission.world.WorldObject;

import utils.Constants;

class Collectable extends WorldObject {

  public var kind:TreasureKind;

  public function new(kind:TreasureKind, i:Int, j:Int) {
    super(i,j);
    this.kind = kind;
    switch (kind) {
    case TreasureKind.gold:
      this.loadGraphic('assets/images/gold.png');
    case TreasureKind.item:
      this.loadGraphic('assets/images/item.png');
    }
    this.setCoordinate(i,j);
  }

}
