package camping;

import flixel.FlxG;
import flixel.FlxState;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;

import camping.IntroState;

import utils.Constants;

class TitleState extends FlxState {
  override public function create():Void {
    super.create();

    var bg = new FlxSprite(0, 0, "assets/images/title/cover_background.png");
    bg.setGraphicSize(FlxG.width, FlxG.height);
    bg.updateHitbox();
    bg.centerOrigin();
    add(bg);

    var playBtn = new FlxButton(FlxG.width - 95, FlxG.height - 99, '', clickPlay);
    playBtn.loadGraphic("assets/images/menu/botao.png", true, 75, 79);

    add(playBtn);

    if (Constants.GAME_MISSIONS_RECORD > 0) {
      var record = new FlxText(20, FlxG.height - 20, 200);
      record.size = 10;

      if (Constants.GAME_MISSIONS_RECORD == 1) {
        record.text = 'RECORD: only one mission';
      } else {
        record.text = 'RECORD: ' + Std.string(Constants.GAME_MISSIONS_RECORD) + ' consecutive missions';
      }

      record.color = FlxColor.WHITE;
      add(record);
    }
  }

  private function clickPlay():Void {
    FlxG.camera.fade(FlxColor.BLACK,.33, false, function() {
      FlxG.switchState(new IntroState());
    });
  }

}
