package mission.world;

import flixel.FlxSprite;

import utils.Constants;

class WorldObject extends FlxSprite {

  public var i:Int; //Line
  public var j:Int; //Collumn

  public var lastPosition:Array<Int>;

  public function new(i:Int, j:Int) {
    super();
    this.setCoordinate(i,j);
  }

  public function getCoordinate():Array<Int> {
    return [this.i, this.j];
  }
  public function getPos():Array<Float> {
    return [this.x, this.y];
  }
  public function setCoordinate(i:Int, j:Int, ?baseI:Int = 0, ?baseJ:Int = 0) {
    this.i = i;
    this.j = j;

    if (this.height >= 2 * Constants.TILE_SIZE) {
      this.y = ((i + ((this.height / Constants.TILE_SIZE) - baseI))) * Constants.TILE_SIZE - this.height;
      /*this.y = (i + (((this.height / Constants.TILE_SIZE) - baseI) * 0.5)) * Constants.TILE_SIZE - this.height/2;*/
    } else {
      this.y = (i + 0.5) * Constants.TILE_SIZE - this.height/2;
    }

    if (this.width >= 2 * Constants.TILE_SIZE) {
      this.x = ((j + ((this.width / Constants.TILE_SIZE) - baseJ))) * Constants.TILE_SIZE - this.width;
    } else {
      this.x = (j + 0.5) * Constants.TILE_SIZE - this.width/2;
    }
  }
  public function setPos(x:Float, y:Float) {
    this.x = x;
    this.y = y;
    this.i = Math.floor(this.y / Constants.TILE_SIZE);
    this.j = Math.floor(this.x / Constants.TILE_SIZE);
  }
  public function updateCoordinate() {
    this.i = Math.floor(this.y / Constants.TILE_SIZE);
    this.j = Math.floor(this.x / Constants.TILE_SIZE);
  }
  public function updateLastPosition() {
    this.lastPosition = [this.i, this.j];
  }
}
