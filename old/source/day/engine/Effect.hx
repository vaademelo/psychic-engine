package day.engine;

import flixel.FlxSprite;

enum EffectKind {
  atack;
}

class Effect extends FlxSprite {

  private var timeAliveLeft:Float;
  private var kind:EffectKind;

  public function new(kind:EffectKind, PosX:Float, PosY:Float, ?kindExtra:Int) {
    super(PosX, PosY);
    this.kind = kind;
    var sprite:String = "assets/images/";
    switch (kind) {
      case atack:
      sprite += "fight/";
      switch kindExtra {
        case 1:
        sprite += "hit.png";
        case 2:
        sprite += "crit.png";
        case 3:
        sprite += "kill.png";
        default:
        sprite += "fail.png";
      }

    }
    loadGraphic(sprite, false);
    timeAliveLeft = 1;
  }

  override public function update(elapsed:Float) {
    super.update(elapsed);
    timeAliveLeft -= elapsed;
    if(timeAliveLeft<0){
      this.kill();
    }
  }

}
