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
        this.setCoordinate(i,j,1,0);
      case DecorativeObjectKind.exitDoor:
        this.loadGraphic('assets/images/decorative/base_door.png');
        this.setCoordinate(i,j,1,1);

      case DecorativeObjectKind.topWall:
        this.loadGraphic('assets/images/decorative/top_wall.png');
        this.setCoordinate(i,j,1,0);
      case DecorativeObjectKind.rightWall:
        this.loadGraphic('assets/images/decorative/right_wall.png');
        this.setCoordinate(i,j,0,0);
      case DecorativeObjectKind.leftWall:
        this.loadGraphic('assets/images/decorative/left_wall.png');
        this.setCoordinate(i,j,0,1);
      case DecorativeObjectKind.bottomWall:
        this.loadGraphic('assets/images/decorative/bottom_wall.png');
        this.setCoordinate(i,j,0,0);

      case DecorativeObjectKind.topLeftWall:
        this.loadGraphic('assets/images/decorative/top_left_wall.png');
        this.setCoordinate(i,j,1,1);
      case DecorativeObjectKind.topRightWall:
        this.loadGraphic('assets/images/decorative/top_right_wall.png');
        this.setCoordinate(i,j,1,0);
      case DecorativeObjectKind.bottomRightWall:
        this.loadGraphic('assets/images/decorative/bottom_right_wall.png');
        this.setCoordinate(i,j,0,0);
      case DecorativeObjectKind.bottomLeftWall:
        this.loadGraphic('assets/images/decorative/bottom_left_wall.png');
        this.setCoordinate(i,j,0,1);

      case DecorativeObjectKind.topLeftInWall:
        this.loadGraphic('assets/images/decorative/top_left_in_wall.png');
        this.setCoordinate(i,j,0,0);
      case DecorativeObjectKind.topRightInWall:
        this.loadGraphic('assets/images/decorative/top_right_in_wall.png');
        this.setCoordinate(i,j,0,1);
      case DecorativeObjectKind.bottomRightInWall:
        this.loadGraphic('assets/images/decorative/bottom_right_in_wall.png');
        this.setCoordinate(i,j,1,1);
      case DecorativeObjectKind.bottomLeftInWall:
        this.loadGraphic('assets/images/decorative/bottom_left_in_wall.png');
        this.setCoordinate(i,j,1,0);

      default:
    }


  }

}
