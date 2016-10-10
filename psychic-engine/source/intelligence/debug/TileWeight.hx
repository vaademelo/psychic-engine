package intelligence.debug;

import flixel.text.FlxText;
import flixel.util.FlxColor;
import utils.Constants;

import mission.world.Unit;

class TileWeight extends FlxText{

  public function new(tileWeight:String, i:Int, j:Int) {
    super((j + 1.0) * Constants.TILE_SIZE - (Constants.TILE_SIZE), (i + 1.0) * Constants.TILE_SIZE - (Constants.TILE_SIZE));
    text = tileWeight;
    size = 18;
    color = FlxColor.YELLOW;
  }

  override public function update(elapsed:Float) {
    super.update(elapsed);
  }

  public function remove() : Void {
    this.kill();
  }
}
