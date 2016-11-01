package intelligence.debug;

import flixel.text.FlxText;
import flixel.util.FlxColor;
import utils.Constants;

import mission.world.Unit;

class TileWeight extends FlxText{

  public function new(tileWeight:String, i:Int, j:Int) {
    super();
    this.x = (j + 1.0) * Constants.TILE_SIZE - (Constants.TILE_SIZE);
    this.y = (i + 1.0) * Constants.TILE_SIZE - (Constants.TILE_SIZE);
    text = tileWeight;
    size = 18;
    var value = Math.max(Math.min(Std.parseFloat(tileWeight), 1), -1) + 0.5;
    color = FlxColor.fromRGB(Std.int((2 - value) * 255 / 2.0), Std.int(value  * 255 / 2.0), 0, 255);
  }

  public function updateTileWeight(tileWeight:String, i:Int, j:Int) {
    this.x = (j + 1.0) * Constants.TILE_SIZE - (Constants.TILE_SIZE);
    this.y = (i + 1.0) * Constants.TILE_SIZE - (Constants.TILE_SIZE);
    text = tileWeight;
    size = 18;
    var value = Math.max(Math.min(Std.parseFloat(tileWeight), 1), -1) + 0.5;
    color = FlxColor.fromRGB(Std.int((2 - value) * 255 / 2.0), Std.int(value  * 255 / 2.0), 0, 255);
  }
}
