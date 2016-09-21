package day.engine;

import flixel.group.FlxGroup;
import flixel.util.FlxColor;
import flixel.FlxCamera;
import flixel.FlxSprite;
import flixel.FlxG;

import day.engine.Dungeon;
import day.engine.Unit;
import day.engine.Body;

class Camera extends FlxSprite {

  private var speed:Int = 30;

  public function new() {
    super();
    makeGraphic(1, 1, FlxColor.TRANSPARENT);
  }

  public function settings() {
    FlxG.camera.antialiasing = true;
    FlxG.camera.setScrollBounds(0,Dungeon.TILESIZE*Dungeon.LEVELSIZE,0,Dungeon.TILESIZE*Dungeon.LEVELSIZE);
    FlxG.camera.follow(this, FlxCameraFollowStyle.LOCKON);
  }

  public function changeFocusToBody(body:Body, team:TeamSide) {
    if (team == hero) {
      this.x = body.x;
      this.y = body.y;
    }
  }

  public function zoomForUnits(dungeon:Dungeon, units:FlxTypedGroup<Unit>) {
    var midleX:Float = 0;
    var midleY:Float = 0;
    for (unit in units.members) {
      midleX += unit.body.x;
      midleY += unit.body.y;
    }
    midleX /= units.members.length;
    midleY /= units.members.length;
    this.x = midleX;
    this.y = midleY;
    //FlxG.camera.zoom = 1;
    /*var zoom:Float = 1;
    FlxG.camera.setScale(zoom, zoom);
    dungeon.updateBuffers();
    for(unit in units.members) {
      while(!unit.body.isOnScreen() && zoom > 0.5){
        zoom -= 0.1;
        FlxG.camera.setScale(zoom,zoom);
        dungeon.update(0.01);
      }
    }*/
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
		if (this.x > Dungeon.LEVELSIZE * Dungeon.TILESIZE - FlxG.width / 2) {
			this.x = Dungeon.LEVELSIZE * Dungeon.TILESIZE - FlxG.width / 2;
		}
		if (this.y < FlxG.height / 2) {
			this.y = FlxG.height / 2;
		}
		if (this.y > Dungeon.LEVELSIZE * Dungeon.TILESIZE - FlxG.height / 2) {
			this.y = Dungeon.LEVELSIZE * Dungeon.TILESIZE - FlxG.height / 2;
		}
  }

}
