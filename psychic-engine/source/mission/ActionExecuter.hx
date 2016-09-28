package mission;

import flixel.util.FlxPath;
import flixel.group.FlxGroup;
import flixel.util.typeLimit.OneOfTwo;

import utils.Constants;

import mission.world.Unit;
import mission.world.Collectable;
import mission.world.WorldMap;

import intelligence.tools.PositionTool;

class ActionExecuter {

  private static var _callBack:Array<Unit>->Void;
  private static var _list:Array<Unit>;
  private static var _unit:Unit;
  private static var _targetObject:OneOfTwo<Unit, Collectable>;
  private static var _worldMap:WorldMap;

  public static function executeAction(worldMap:WorldMap, unit:Unit, target:Array<Int>, callBack:Array<Unit>->Void, list:Array<Unit>):Bool {
    _unit = unit;
    _list = list;
    _callBack = callBack;
    _worldMap = worldMap;
    _targetObject = null;

    if (!worldMap.isTileValid(target[0],target[1])) return endAction();

    setTargetObject(target);

    worldMap.setTileAsWalkable(_unit.i, _unit.j, true);

    target = setTargetTile(target);

    return goToTargetTile(target);
  }

  public static function atackAction(opponent:Unit) {
    trace(_unit.character.team == opponent.character.team, _unit.character.team, opponent.character.team);
    if (_unit.character.team == opponent.character.team) return;
    trace('atack');
  }

  public static function collectAction(collectable:Collectable) {
    //TODO: Collect!
  }

  public static function setTargetTile(target:Array<Int>):Array<Int> {
    if (_worldMap.isTileWalkable(target[0],target[1])) return target;

    var tiles = PositionTool.getValidTilesInRange(_worldMap, target, _unit.character.atackRange);
    var closestDistance:Int = null;
    var closestTile:Array<Int> = null;
    for (tile in tiles) {
      if (tile == target) continue;
      var distance = PositionTool.getDistance(_worldMap, _unit.getCoordinate(), tile);
      if (closestDistance == null || closestDistance > distance) {
        closestDistance = distance;
        closestTile = tile;
      }
    }
    return closestTile;
  }

  public static function goToTargetTile(target:Array<Int>):Bool {
    var nodes = _worldMap.getPath(_unit.getCoordinate(), target);

    if (nodes == null || nodes.length == 0) {
      if (target != _unit.getCoordinate()) trace('fail');
      return endAction();
    }

    if (nodes.length > _unit.character.movement) {
      nodes = nodes.slice(0, _unit.character.movement + 1);
    }

    var path = new FlxPath();
    path.onComplete = function (path:FlxPath) {
      endAction();
    };
    _unit.path = path;
    _unit.path.start(nodes, Constants.UNITSPEED);
    return true;
  }

  public static function setTargetObject(target:Array<Int>) {
    var obs = PositionTool.getObjectsInRange(_worldMap.heroes, target, 0);
    if (obs.length > 0) {
      _targetObject = obs[0];
      return;
    }
    obs = PositionTool.getObjectsInRange(_worldMap.monsters, target, 0);
    if (obs.length > 0) {
      _targetObject = obs[0];
      return;
    }
    obs = PositionTool.getObjectsInRange(_worldMap.foods, target, 0);
    if (obs.length > 0) {
      _targetObject = obs[0];
      return;
    }
    obs = PositionTool.getObjectsInRange(_worldMap.treasures, target, 0);
    if (obs.length > 0) {
      _targetObject = obs[0];
      return;
    }
  }

  public static function endAction():Bool {
    _unit.updateCoordinate();

    if (_targetObject != null) {
      if (Type.getClass(_targetObject) == Unit) {
        var targetUnit:Unit = cast(_targetObject, Unit);
        atackAction(targetUnit);
      } else {
        var targetCollectable:Collectable = cast(_targetObject, Collectable);
        collectAction(targetCollectable);
      }
    }

    _worldMap.setTileAsWalkable(_unit.i, _unit.j, false);
    _callBack(_list);
    return true;
  }

}
