package mission.visualFX;

import flixel.FlxSprite;

import utils.Constants;

class BattleFX extends FlxSprite {

  private var timeAliveLeft:Float;
  private var kind:BattleEffectKind;
  private var callBack:Void->Void;

  public function new(kind:BattleEffectKind, PosX:Float, PosY:Float, callBack:Void->Void) {
    super(PosX, PosY);
    this.kind = kind;
    this.callBack = callBack;
    var sprite:String = "assets/images/fight/";
    switch (kind) {
      case BattleEffectKind.hit:
      sprite += "hit.png";
      case BattleEffectKind.crit:
      sprite += "crit.png";
      case BattleEffectKind.kill:
      sprite += "kill.png";
      case BattleEffectKind.fail:
      sprite += "fail.png";
    }
    loadGraphic(sprite, false);
    timeAliveLeft = Constants.BATTLE_EFFECT_TIME;
  }

  override public function update(elapsed:Float) {
    super.update(elapsed);
    timeAliveLeft -= elapsed;
    if(timeAliveLeft<0){
      this.kill();
      this.callBack();
    }
  }
}
