package day.engine;

import flixel.group.FlxGroup;

import flixel.tile.FlxBaseTilemap;

import day.engine.Treasure;
import day.engine.Dungeon;
import day.engine.Camera;
import day.engine.Unit;
import day.engine.Hud;

enum TurnPhase {
  startingTurn;
  startingUnitTurn;
  choosingAction;
  walking;
  doingAction;
}


class TurnSystem extends FlxGroup {
  private var turnPhase:TurnPhase;
  private var unitsWithTurn:Array<Unit>;
  private var unit:Unit;

  private var dungeon:Dungeon;
  private var treasures:FlxTypedGroup<Treasure>;
  private var heroes:FlxTypedGroup<Unit>;
  private var enemies:FlxTypedGroup<Unit>;
  private var hud:Hud;
  private var cam:Camera;

  private var treasuresGoal:Int = 10;

  public function new():Void {
    super();

    dungeon   = new Dungeon();
    treasures = new FlxTypedGroup<Treasure>();
    enemies   = new FlxTypedGroup<Unit>();
    heroes    = new FlxTypedGroup<Unit>();
    hud       = new Hud();
    cam       = new Camera();

    dungeon.populateWorld(heroes, enemies, treasures);

    hud.addUnitsHud(heroes);

    add(dungeon);
    add(treasures);
    add(enemies);
    add(heroes);
    add(hud);
    add(cam);

    turnPhase = startingTurn;
    for(hero in heroes.members){
        dungeon.cleanFog(hero, heroes, enemies, treasures);
    }
    dungeon.loadWorld();
    cam.settings();
  }

  override public function update(elapsed:Float):Void {
    super.update(elapsed);
    switch (turnPhase) {
    case startingTurn:
      startTurn();
    case startingUnitTurn:
      startUnitTurn();
    case choosingAction:
      chooseAction();
    case walking:
      walk();
    case doingAction:
      doAction();
    }
  }

  private function startTurn() {
    unitsWithTurn = [];
    for(hero in heroes.members){
      if(hero.alive){
        unitsWithTurn.push(hero);
      }
    }
    for(enemy in enemies.members){
      if(enemy.alive){
        unitsWithTurn.push(enemy);
      }
    }
    //cam.zoomForUnits(dungeon, heroes);
    changeTurn();
  }

  private function startUnitTurn() {
    unit.calculateInjury();
    if(unit.team == hero) {
      hud.updateUnitHud(unit);
    }
    turnPhase = choosingAction;
    dungeon.setTileAsWalkable(unit, true);
  }

  private function chooseAction() {
    var units = (unit.team == hero) ? enemies : heroes;
    unit.mind.chooseAction(dungeon, unit, heroes, enemies, treasures);
    if (unit.mind.action != null) {
      turnPhase = walking;
    }
  }

  private function walk() {
    if (unit.body.path == null || unit.body.path.finished) {
      turnPhase = doingAction;
    }
  }

  private function doAction() {
    if (unit.mind.target != null) {
      if(unit.mind.action == getTreasure) {
        var value = (unit.mind.target.size == big) ? 3 : 1;
        hud.setTreasureCounter(value);
        unit.mind.target.kill();
      }
      if(unit.mind.action == atackOponent){
        unit.atackToKill();
        if(unit.team == enemy) {
          hud.updateUnitHud(unit.mind.target);
        }
      }
    }
    if(unit.team == hero) {
      dungeon.cleanFog(unit, heroes, enemies, treasures);
      dungeon.loadWorld();
    }
    unit.mind.target = null;
    unit.mind.action = null;
    unit.mind.walkTo = null;
    dungeon.setTileAsWalkable(unit, false);
    changeTurn();
  }

  private function changeTurn() {
    if (unitsWithTurn.length > 0) {
      this.unit = unitsWithTurn[0];
      unitsWithTurn.shift();
      turnPhase = startingUnitTurn;
      if(!unit.alive){
        changeTurn();
      }
    } else {
      turnPhase = startingTurn;
    }
  }
}
