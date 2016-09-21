package day.ai;

import flixel.group.FlxGroup;

import day.engine.Treasure;
import day.engine.Dungeon;
import day.engine.Unit;

import day.ai.analysis.ActionAnalysis;

interface Mind {

  public var action:ActionKind;
  public var walkTo:Int;
  public var target:Dynamic;

  public function chooseAction(dungeon:Dungeon, unit:Unit, heroes:FlxTypedGroup<Unit>, enemies:FlxTypedGroup<Unit>, treasures:FlxTypedGroup<Treasure>):Void;

}
