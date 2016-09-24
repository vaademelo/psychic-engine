package camping;

import flixel.FlxG;
import flixel.FlxState;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.ui.FlxButton;

import gameData.UserData;
import mission.MissionState;

class MissionMenuState extends FlxState {

  private var _playBtn:FlxButton;
  private var _resetBtn:FlxButton;

  override public function create():Void {
    super.create();

    _playBtn = new FlxButton(0, 0, "Play", clickPlay);
    _resetBtn = new FlxButton(0, 0, "Reset", clickReset);

    _playBtn.x = _resetBtn.x = FlxG.width - 30 - _playBtn.width;
    _playBtn.y = FlxG.height - 30 - _playBtn.height;
    _resetBtn.y = FlxG.height - 60 - _resetBtn.height;

    add(_playBtn);
    add(_resetBtn);

    var i = 0;
    UserData.loadUserData();
    for (char in UserData.heroes) {
      trace(char.imageSource);
      var sprite = new FlxSprite(0, i, char.imageSource);
      i += 50;
      add(sprite);
    }
  }

  override public function update(elapsed:Float):Void {
    super.update(elapsed);
  }

  private function clickPlay():Void {
    FlxG.switchState(new MissionState());
  }

  private function clickReset():Void {
    //TODO: reset character goals
  }

}
