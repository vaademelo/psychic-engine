package camping;

import flixel.FlxG;
import flixel.FlxState;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;

import camping.MissionMenuState;

class IntroState extends FlxState {
  override public function create():Void {
    super.create();

    var bg = new FlxSprite(0, 0, "assets/images/menu/missionBG.png");
    bg.setGraphicSize(FlxG.width, FlxG.height);
    bg.updateHitbox();
    bg.centerOrigin();
    add(bg);

    var playBtn = new FlxButton(FlxG.width/2 + 185, 25, '', clickPlay);
    playBtn.loadGraphic("assets/images/menu/playBtn.png", true, 33, 58);

    add(playBtn);
  }

  private function clickPlay():Void {
    FlxG.camera.fade(FlxColor.BLACK,.33, false, function() {
      FlxG.switchState(new MissionMenuState());
    });
  }

}
