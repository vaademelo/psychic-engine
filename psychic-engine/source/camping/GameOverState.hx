package camping;

import flixel.FlxG;
import flixel.FlxState;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;

import camping.TitleState;

import gameData.UserData;

import utils.Constants;

class GameOverState extends FlxState {
  override public function create():Void {
    super.create();

    var bg = new FlxSprite(0, 0, "assets/images/title/gameover.png");
    bg.setGraphicSize(FlxG.width, FlxG.height);
    bg.updateHitbox();
    bg.centerOrigin();
    add(bg);

    var playBtn = new FlxButton(FlxG.width - 95, FlxG.height - 99, '', clickPlay);
    playBtn.loadGraphic("assets/images/menu/botao.png", true, 75, 79);
    add(playBtn);

    var missions = new FlxText(20, FlxG.height - 40, 200);
    missions.size = 10;
    if (UserData.numberOfMissions == 1) {
      missions.text = 'survived only one mission';
    } else {
      missions.text = 'survived ' + Std.string(UserData.numberOfMissions) + ' consecutive missions';
    }
    missions.color = FlxColor.WHITE;
    add(missions);

    var record = new FlxText(20, FlxG.height - 20, 200);
    record.size = 10;

    if (UserData.numberOfMissions > Constants.GAME_MISSIONS_RECORD) {
      Constants.GAME_MISSIONS_RECORD = UserData.numberOfMissions;
      record.text = 'IT\' A NEW RECORD!';
    } else {
      if (Constants.GAME_MISSIONS_RECORD == 1) {
        record.text = 'RECORD: only one mission';
      } else {
        record.text = 'RECORD: ' + Std.string(Constants.GAME_MISSIONS_RECORD) + ' consecutive missions';
      }
    }

    record.color = FlxColor.WHITE;
    add(record);

    UserData.resetUserData();
  }

  private function clickPlay():Void {
    FlxG.camera.fade(FlxColor.BLACK,.33, false, function() {
      FlxG.switchState(new TitleState());
    });
  }

}
