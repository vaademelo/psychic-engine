package mission;

import flixel.util.FlxPath;
import flixel.group.FlxGroup;
import flixel.math.FlxPoint;

import utils.Constants;

import mission.world.Unit;
import mission.world.Collectable;
import mission.world.WorldMap;

import intelligence.tools.PositionTool;
import mission.BattleExecuter;

class ActionExecuter {

  private static var _callBack:Array<Unit>->Void;
  private static var _list:Array<Unit>;
  private static var _unit:Unit;
  private static var _targetUnit:Unit;
  private static var _worldMap:WorldMap;
  private static var _atackedThisTurn:Bool;

  public static function executeAction(worldMap:WorldMap, unit:Unit, target:Array<Int>, callBack:Array<Unit>->Void, list:Array<Unit>):Bool {
    _unit = unit;
    _list = list;
    _callBack = callBack;
    _worldMap = worldMap;
    _atackedThisTurn = false;
    _targetUnit = null;

    if (!worldMap.isTileValid(target[0],target[1])) return endAction();

    _targetUnit = worldMap.getTileUnit(target);

    worldMap.setTileAsWalkable(_unit.i, _unit.j, true);

    target = setTargetTile(target);

    return goToTargetTile(target);
  }

  public static function setTargetTile(target:Array<Int>):Array<Int> {
    if (_worldMap.isTileWalkable(target[0],target[1])) return target;
    var tiles = PositionTool.getValidTilesInRange(_worldMap, target, _unit.character.atackRange);
    var closestDistance:Int = null;
    var closestTile:Array<Int> = null;
    for (tile in tiles) {
      if (tile[0] == target[0] && tile[1] == target[1]) continue;
      if (!_worldMap.isTileWalkable(tile[0], tile[1])) continue;
      var distance = PositionTool.getDistance(_worldMap, _unit.getCoordinate(), tile);
      if (closestDistance == null || closestDistance > distance) {
        closestDistance = distance;
        closestTile = tile;
      }
    }
    return closestTile;
  }

  public static function goToTargetTile(target:Array<Int>):Bool {
    if (target == null) return endAction();
    var nodes = _worldMap.getPath(_unit.getCoordinate(), target);

    if (nodes == null || nodes.length == 0) {
      verifyIfThereIsAnEnemyToAtack(_unit.origin);
      return endAction();
    }

    if (nodes.length > _unit.character.movement) {
      nodes = nodes.slice(0, _unit.character.movement + 1);
    }

    if (_targetUnit == null) {
      verifyIfThereIsAnEnemyToAtack(nodes[nodes.length - 1]);
    }

    var path = new FlxPath();
    path.onComplete = function (path:FlxPath) {
      endAction();
    };
    _unit.path = path;
    _unit.path.start(nodes, Constants.UNIT_SPEED);
    return true;
  }

  public static function endAction():Bool {
    _unit.updateCoordinate();
    _worldMap.setTileAsWalkable(_unit.i, _unit.j, false);

    var collectableOnTile = _worldMap.getTileCollectable(_unit.getCoordinate());
    if (collectableOnTile != null) {
      collectAction(collectableOnTile);
    }

    if (_targetUnit != null) {
      var targetUnit:Unit = cast(_targetUnit, Unit);
      return atackAction(targetUnit, nextUnit);
    } else {
      return nextUnit();
    }
  }

  public static function atackAction(opponent:Unit, callbackAfterAtack:Void->Bool):Bool {
    if (_unit.character.team == opponent.character.team) return callbackAfterAtack();
    if (PositionTool.getDistanceFromObject(_targetUnit, _unit.getCoordinate()) <= _unit.character.atackRange) {
      _atackedThisTurn = true;
      return BattleExecuter.atackOpponent(_worldMap, _unit, opponent, callbackAfterAtack);
    } else {
      return callbackAfterAtack();
    }
  }

  public static function collectAction(collectable:Collectable) {
    if(_unit.character.team == TeamSide.monsters) return;

    if (collectable.kind == TreasureKind.gold) {
      _unit.givegold(collectable);
    } else {
      _unit.giveTreasure(collectable);
    }
    collectable.kill();
  }

  public static function nextUnit():Bool {
    if(_unit.character.team == TeamSide.heroes &&
       _worldMap.isTheSameTile(_unit.character.goalTile, WorldMap.homeTile) &&
       _worldMap.isTheSameTile(_unit.getCoordinate(), WorldMap.homeTile)) {
         _unit.gotBackSafelly = true;
         _unit.kill();
         if(_unit.emotionFX != null) _unit.emotionFX.kill();
    }
    _worldMap.hud.updateUnitHud(_unit);
    _callBack(_list);
    return true;
  }

  public static function verifyIfThereIsAnEnemyToAtack(destinationPoint:FlxPoint) {
    var destination = new Array<Int>();
    destination[0] = Math.floor(destinationPoint.y / Constants.TILE_SIZE);
    destination[1] = Math.floor(destinationPoint.x / Constants.TILE_SIZE);

    var enemies = _unit.character.team == TeamSide.heroes ? _worldMap.monsters : _worldMap.heroes;
    for (enemy in enemies.members) {
      if (PositionTool.getDistanceFromObject(enemy, destination) <= _unit.character.atackRange) {
        _targetUnit = enemy;
        return;
      }
    }
  }


}
