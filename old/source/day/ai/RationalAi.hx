package day.ai;

import flixel.group.FlxGroup;

import day.engine.Treasure;
import day.engine.Dungeon;
import day.engine.Unit;

import day.ai.Mind;
import day.ai.analysis.PositionAnalysis;
import day.ai.analysis.ActionAnalysis;

class RationalAi implements Mind {

  public var action:ActionKind;
  public var walkTo:Int;
  public var target:Dynamic;

  public function new() {
  }

  public function chooseAction(dungeon:Dungeon, unit:Unit, heroes:FlxTypedGroup<Unit>, enemies:FlxTypedGroup<Unit>, treasures:FlxTypedGroup<Treasure>) {
    var actionValue = 0;
    var possibleActionValues:Map<ActionKind, Dynamic> = ActionAnalysis.calculateActions(dungeon, unit, heroes, enemies, treasures);
    for( option in possibleActionValues.keys() ) {
      trace( option, possibleActionValues[option] );
      if(possibleActionValues[option] != null && possibleActionValues[option][0] > actionValue) {
        actionValue = possibleActionValues[option][0];
        this.walkTo = possibleActionValues[option][1];
        this.target = possibleActionValues[option][2];
        this.action = option;
      }
    }
    if(walkTo != null) {
      var path = PositionAnalysis.getPath(dungeon, unit, walkTo);
      if(path != null) {
        unit.body.gotoTile(path);
      }
    }
  }
}
