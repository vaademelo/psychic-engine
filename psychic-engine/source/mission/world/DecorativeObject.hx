package mission.world;

import mission.world.WorldObject;

import utils.Constants;

class DecorativeObject extends WorldObject {

  public var kind:DecorativeObjectKind;

  public function new(kind:DecorativeObjectKind, i:Int, j:Int) {
    super(i,j);
    this.kind = kind;
    switch (kind) {
      case DecorativeObjectKind.column:
        this.loadGraphic('assets/images/decorative/column.png');
        this.setCoordinate(i,j,2,1);
      case DecorativeObjectKind.exitDoor:
        this.loadGraphic('assets/images/decorative/base_door.png');
    }
    this.setCoordinate(i,j,1,1);

  }

}
