package day.engine;

import flixel.math.FlxPoint;
import flixel.util.FlxPath;
import flixel.FlxSprite;

import day.engine.Dungeon;
import day.engine.Unit;

class Body extends FlxSprite {

  private var speed:Int;

  public function new(team:TeamSide, armor:BodyArmor) {
    super();
    loadAsset(team, armor);
    this.speed = (team == hero) ? 300 : 500;
  }

  override public function update(elapsed:Float) {
    super.update(elapsed);
  }

  public function loadAsset(team:TeamSide, armor:BodyArmor) {
    var teamSprite = (team==hero) ? "h" : "e";
    var sprite = "assets/images/bodies/"+teamSprite+Std.string(armor)+".png";
    loadGraphic(sprite, false, Dungeon.TILESIZE, Dungeon.TILESIZE);
  }

  public function gotoTile(path:Array<FlxPoint>) {
    this.path = new FlxPath().start(path);
    this.path.speed = speed;
  }

}
