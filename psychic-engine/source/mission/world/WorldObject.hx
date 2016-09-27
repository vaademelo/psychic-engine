package mission.world;

import flixel.FlxSprite;

import utils.Constants;

class WorldObject extends FlxSprite {

  public var i:Int; //Line
  public var j:Int; //Collumn

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
  public function setCoordinate(i:Int, j:Int) {
    this.i = i;
    this.j = j;
    this.x = (j + 0.5) * Constants.TILESIZE - this.width/2;
    this.y = (i + 0.5) * Constants.TILESIZE - this.height/2;
  }
  public function setPos(x:Float, y:Float) {
    this.x = x;
    this.y = y;
    this.i = Math.floor(this.y / Constants.TILESIZE);
    this.j = Math.floor(this.x / Constants.TILESIZE);
  }
  public function updateCoordinate() {
    this.i = Math.floor(this.y / Constants.TILESIZE);
    this.j = Math.floor(this.x / Constants.TILESIZE);
  }
}
