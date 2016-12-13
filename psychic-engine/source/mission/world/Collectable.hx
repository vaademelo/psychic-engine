package mission.world;

import mission.world.WorldObject;

import utils.Constants;

import gameData.Treasure;

class Collectable extends WorldObject {

  public var kind:TreasureKind;
  public var treasure:Treasure;

  public function new(kind:TreasureKind, i:Int, j:Int) {
    super(i,j);
    this.kind = kind;
    switch (kind) {
    case TreasureKind.gold:
      this.loadGraphic('assets/images/gold.png');
    case TreasureKind.item:
      this.loadGraphic('assets/images/item.png');
      this.treasure = new Treasure();
    }
    this.setCoordinate(i,j,1,0);
  }

}
