package intelligence;

import Random;

import flixel.group.FlxGroup;

import intelligence.Mind;
import intelligence.tools.PositionTool;
import intelligence.tools.BattleTool;

import mission.world.Unit;
import mission.world.WorldMap;
import mission.world.WorldObject;

import utils.Constants;

class MonsterMind implements Mind {

  public var unit:Unit;
  public var currentEmotion:Emotion;

  public var missedLastAtack:Bool = false;
  public var criticalLastAtack:Bool = false;
  public var wasAtackedLastTurn:Bool = false;

  public function new(unit:Unit) {
      this.unit = unit;
  }

  public function analyseAction(worldMap:WorldMap):Array<Int> {
    var opponents = (this.unit.character.team == TeamSide.heroes) ? worldMap.monsters : worldMap.heroes;
    var opponentsInRange = PositionTool.getObjectsInRange(opponents, this.unit.getCoordinate(), this.unit.character.vision);

    this.missedLastAtack = false;
    this.criticalLastAtack = false;
    this.wasAtackedLastTurn = false;

    if (opponentsInRange.length > 0) {
      return BattleTool.getWeakestOpponent(opponentsInRange, this.unit);
    } else {
      return chooseRandomTileToWalk(worldMap, this.unit);
    }
  }

  public function updateStatus(worldMap:WorldMap):Void {
    //ENEMY DOESNT HAVE NOTHING TO UPDATE
  }

  public function chooseRandomTileToWalk(worldMap:WorldMap, unit:Unit):Array<Int> {
    var validTiles:Array<Array<Int>> = PositionTool.getValidTilesInRange(worldMap, unit.getCoordinate(), unit.character.vision);
    var tile = Random.fromArray(validTiles);
    return tile;
  }
}
