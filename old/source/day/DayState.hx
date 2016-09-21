package day;

import flixel.FlxState;

import day.engine.TurnSystem;

class DayState extends FlxState {

  private var turnSystem:TurnSystem;

  override public function create():Void {
    super.create();
    turnSystem = new TurnSystem();
    add(turnSystem);
  }

  override public function update(elapsed:Float):Void {
    super.update(elapsed);
  }

}
