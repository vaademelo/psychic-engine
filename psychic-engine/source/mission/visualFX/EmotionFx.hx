package mission.visualFX;

import flixel.FlxSprite;

import mission.world.WorldObject;

import utils.Constants;

class EmotionFX extends FlxSprite {

  public var follow:WorldObject;

  public function new(follow:WorldObject) {
    super();
    this.follow = follow;
  }

  override public function update(elapsed:Float) {
    super.update(elapsed);
    this.x = follow.x + Constants.TILE_SIZE - 15;
    this.y = follow.y - 10;
  }

  public function updateEmotion(emotion:Emotion) {
    if (emotion == Emotion.peaceful || emotion == null) {
      this.kill();
    } else {
      this.revive();
      loadGraphic("assets/images/emotion/" + Std.string(emotion) + ".png");
      setGraphicSize(30, 30);
      updateHitbox();
      centerOrigin();
    }
  }
}
