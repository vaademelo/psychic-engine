package camping;

import flixel.FlxG;
import flixel.FlxState;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.ui.FlxButton;

import mission.MissionState;

class MissionMenuState extends FlxState {

  private var _playBtn:FlxButton;
  private var _resetBtn:FlxButton;

  override public function create():Void {
    super.create();

    _playBtn = new FlxButton(0, 0, "Play", clickPlay);
    _resetBtn = new FlxButton(100, 0, "Reset", clickReset);

    add(_playBtn);
    add(_resetBtn);
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
