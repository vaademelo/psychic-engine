package mission.ui;

import flixel.util.FlxColor;
import flixel.FlxCamera;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.math.FlxPoint;

import mission.world.Unit;

import utils.MapMaker;
import utils.Constants;

class Camera extends FlxSprite {

  private var speed:Int = 30;
  private var w:Int;
  private var h:Int;

  public function new() {
    super();
    makeGraphic(1, 1, FlxColor.TRANSPARENT);

    var _map = MapMaker.getMap();
    w = _map[0].length;
    h = _map.length;


    FlxG.camera.antialiasing = true;
    FlxG.camera.setScrollBounds(-220 + 4 * Constants.TILE_SIZE,w * Constants.TILE_SIZE - 4 * Constants.TILE_SIZE,0 + 4 * Constants.TILE_SIZE, h * Constants.TILE_SIZE - 4 * Constants.TILE_SIZE);
    FlxG.camera.follow(this, FlxCameraFollowStyle.LOCKON);

    var initialTile:Array<Int> = getStartTile(_map);
    trace(initialTile);
    this.setPosition(initialTile[1] * Constants.TILE_SIZE, initialTile[0] * Constants.TILE_SIZE);

  }

  override public function update(elapsed:Float) {
    super.update(elapsed);

    if (FlxG.keys.pressed.UP) {
      this.y -= speed;
    }
    if (FlxG.keys.pressed.DOWN) {
      this.y += speed;
    }
    if (FlxG.keys.pressed.LEFT) {
      this.x -= speed;
    }
    if (FlxG.keys.pressed.RIGHT) {
      this.x += speed;
    }
    if (this.x < (FlxG.width / 2) - 220) {
			this.x = (FlxG.width / 2) - 220;
		}
		if (this.x > w * Constants.TILE_SIZE - FlxG.width / 2) {
			this.x = w * Constants.TILE_SIZE - FlxG.width / 2;
		}
		if (this.y < FlxG.height / 2) {
			this.y = FlxG.height / 2;
		}
		if (this.y > h * Constants.TILE_SIZE - FlxG.height / 2) {
			this.y = h * Constants.TILE_SIZE - FlxG.height / 2;
		}
  }

  public function followUnit(unit:Unit):Void {
    FlxG.camera.follow(unit, FlxCameraFollowStyle.LOCKON, 1);
  }

  public function resetCamera():Void {
    FlxG.camera.follow(this, FlxCameraFollowStyle.LOCKON);
  }

  public function getStartTile(tiles:Array<Array<Int>>):Array<Int> {
    for (i in 0...tiles.length) {
      for (j in 0...tiles[i].length) {
        if (tiles[i][j] == 2) {
          return [i-1, j];
        }
      }
    }
    return [];
  }

}
