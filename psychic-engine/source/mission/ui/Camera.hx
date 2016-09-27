package mission.ui;

import flixel.util.FlxColor;
import flixel.FlxCamera;
import flixel.FlxSprite;
import flixel.FlxG;

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
    FlxG.camera.setScrollBounds(0,w * Constants.TILESIZE,0, h * Constants.TILESIZE);
    FlxG.camera.follow(this, FlxCameraFollowStyle.LOCKON);
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
    if (this.x < FlxG.width / 2) {
			this.x = FlxG.width / 2;
		}
		if (this.x > w * Constants.TILESIZE - FlxG.width / 2) {
			this.x = w * Constants.TILESIZE - FlxG.width / 2;
		}
		if (this.y < FlxG.height / 2) {
			this.y = FlxG.height / 2;
		}
		if (this.y > h * Constants.TILESIZE - FlxG.height / 2) {
			this.y = h * Constants.TILESIZE - FlxG.height / 2;
		}
  }

}
