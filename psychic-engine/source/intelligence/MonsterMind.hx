package intelligence;

import Random;

import flixel.group.FlxGroup;

import intelligence.Mind;
import intelligence.tools.PositionTool;
import intelligence.tools.BattleTool;

import mission.world.Unit;
import mission.world.Collectable;
import mission.world.WorldMap;
import mission.world.WorldObject;

import utils.Constants;

class MonsterMind implements Mind {

  public var unit:Unit;
  public var currentEmotion:Emotion;

  public var missedLastAtack:Bool = false;
  public var criticalLastAtack:Bool = false;
  public var wasAtackedLastTurn:Bool = false;
  public var enemyDiedLastTurn:Bool = false;
  public var friendDiedLastTurn:Bool = false;
  public var opponentsInRange:Array<Unit>;
  public var friendsInRange:Array<Unit>;
  public var goldsInRange:Array<Collectable>;
  public var treasuresInRange:Array<Collectable>;

  public var debugMe:Bool = false;

  public function new(unit:Unit) {
      this.unit = unit;
  }

  public function analyseAction(worldMap:WorldMap):Array<Int> {
    var opponents = (this.unit.character.team == TeamSide.heroes) ? worldMap.monsters : worldMap.heroes;
    var opponentsInRange = PositionTool.getObjectsInRange(opponents, this.unit.getCoordinate(), this.unit.getUnitVision());

    this.missedLastAtack = false;
    this.criticalLastAtack = false;
    this.wasAtackedLastTurn = false;
    this.enemyDiedLastTurn = false;
    this.friendDiedLastTurn = false;

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
    var validTiles:Array<Array<Int>> = PositionTool.getValidTilesInRange(worldMap, unit.getCoordinate(), unit.getUnitVision());
    var tile = Random.fromArray(validTiles);
    return tile;
  }
}
