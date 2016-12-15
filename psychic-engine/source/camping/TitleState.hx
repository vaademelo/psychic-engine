package camping;

import flixel.FlxG;
import flixel.FlxState;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;

import camping.IntroState;

class TitleState extends FlxState {
  override public function create():Void {
    super.create();

    var bg = new FlxSprite(0, 0, "assets/images/menu/missionBG.png");
    bg.setGraphicSize(FlxG.width, FlxG.height);
    bg.updateHitbox();
    bg.centerOrigin();
    add(bg);

    var playBtn = new FlxButton(FlxG.width - 95, FlxG.height - 99, '', clickPlay);
    playBtn.loadGraphic("assets/images/menu/botao.png", true, 75, 79);

    add(playBtn);
  }

  private function clickPlay():Void {
    FlxG.camera.fade(FlxColor.BLACK,.33, false, function() {
      FlxG.switchState(new IntroState());
    });
  }

}
