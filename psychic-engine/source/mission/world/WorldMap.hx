package mission.world;

import flixel.util.typeLimit.OneOfTwo;
import flixel.tile.FlxBaseTilemap;
import flixel.tile.FlxTilemap;
import flixel.group.FlxGroup;
import flixel.math.FlxPoint;
import flixel.FlxObject;
import mission.ui.Camera;

import utils.Constants;
import utils.MapMaker;

import gameData.Character;
import gameData.UserData;

import intelligence.tools.PositionTool;
import intelligence.debug.TileWeight;
import intelligence.debug.TileAnalisys;

import mission.world.Unit;
import mission.world.Collectable;

import mission.world.DecorativeObject;

import mission.ui.Hud;
import mission.visualFX.BattleFX;
import mission.visualFX.EmotionFX;

class WorldMap extends FlxTilemap {

  public var golds:FlxTypedGroup<Collectable>;
  public var treasures:FlxTypedGroup<Collectable>;
  public var monsters:FlxTypedGroup<Unit>;
  public var heroes:FlxTypedGroup<Unit>;
  public var effects:FlxTypedGroup<BattleFX>;
  public var emotions:FlxTypedGroup<EmotionFX>;
  public var cam:Camera;

  public var heatMap:FlxTypedGroup<TileWeight>;

  public var decorativeObjects:FlxTypedGroup<DecorativeObject>;

  public var tileAnalisys:TileAnalisys;
  public var hud:Hud;

  public static var homeTile:Array<Int> = [0, 0];

  public function new(tiles:Array<Array<Int>>, camera:Camera) {
    super();

    this.cam = camera;

    this.loadMapFrom2DArray(tiles, "assets/images/tileset.png", Constants.TILE_SIZE, Constants.TILE_SIZE, 0, -1);
    setTileProperties(0, FlxObject.NONE);
    setTileProperties(1, FlxObject.ANY);
    setTileProperties(2, FlxObject.NONE);
    setTileProperties(3, FlxObject.NONE);
    setTileProperties(4, FlxObject.NONE);
    setTileProperties(5, FlxObject.ANY);
    setTileProperties(6, FlxObject.ANY);
    setTileProperties(7, FlxObject.ANY);
    setTileProperties(8, FlxObject.ANY);
    setTileProperties(9, FlxObject.ANY);
    setTileProperties(10, FlxObject.ANY);
    setTileProperties(11, FlxObject.ANY);
    setTileProperties(12, FlxObject.ANY);
    setTileProperties(13, FlxObject.ANY);
    setTileProperties(14, FlxObject.ANY);
    setTileProperties(15, FlxObject.ANY);
    setTileProperties(16, FlxObject.ANY);
    setTileProperties(17, FlxObject.ANY);
    setTileProperties(18, FlxObject.ANY);
    setTileProperties(19, FlxObject.ANY);
    setTileProperties(20, FlxObject.ANY);
    setTileProperties(21, FlxObject.ANY);

    golds = new FlxTypedGroup<Collectable>();
    treasures = new FlxTypedGroup<Collectable>();
    monsters = new FlxTypedGroup<Unit>();
    heroes = new FlxTypedGroup<Unit>();
    effects = new FlxTypedGroup<BattleFX>();
    heatMap = new FlxTypedGroup<TileWeight>();
    emotions = new FlxTypedGroup<EmotionFX>();
    decorativeObjects = new FlxTypedGroup<DecorativeObject>();

    for (i in 0...tiles.length) {
      for (j in 0...tiles[i].length) {
        switch (tiles[i][j]) {
          case 10:
            var topWall = new DecorativeObject(DecorativeObjectKind.topWall, i, j);
            decorativeObjects.add(topWall);
          case 11:
            var rightWall = new DecorativeObject(DecorativeObjectKind.rightWall, i, j);
            decorativeObjects.add(rightWall);
          case 12:
            var bottomWall = new DecorativeObject(DecorativeObjectKind.bottomWall, i, j);
            decorativeObjects.add(bottomWall);
          case 13:
            var leftWall = new DecorativeObject(DecorativeObjectKind.leftWall, i, j);
            decorativeObjects.add(leftWall);
          case 14:
            var topRightWall = new DecorativeObject(DecorativeObjectKind.topRightWall, i, j);
            decorativeObjects.add(topRightWall);
          case 15:
            var bottomRightWall = new DecorativeObject(DecorativeObjectKind.bottomRightWall, i, j);
            decorativeObjects.add(bottomRightWall);
          case 16:
            var bottomLeftWall = new DecorativeObject(DecorativeObjectKind.bottomLeftWall, i, j);
            decorativeObjects.add(bottomLeftWall);
          case 17:
            var topLeftWall = new DecorativeObject(DecorativeObjectKind.topLeftWall, i, j);
            decorativeObjects.add(topLeftWall);
          case 18:
            var topRightInWall = new DecorativeObject(DecorativeObjectKind.topRightInWall, i, j);
            decorativeObjects.add(topRightInWall);
          case 19:
            var bottomRightInWall = new DecorativeObject(DecorativeObjectKind.bottomRightInWall, i, j);
            decorativeObjects.add(bottomRightInWall);
          case 20:
            var bottomLeftInWall = new DecorativeObject(DecorativeObjectKind.bottomLeftInWall, i, j);
            decorativeObjects.add(bottomLeftInWall);
          case 21:
            var topLeftInWall = new DecorativeObject(DecorativeObjectKind.topLeftInWall, i, j);
            decorativeObjects.add(topLeftInWall);
          case 1:
            var column = new DecorativeObject(DecorativeObjectKind.column, i, j);
            decorativeObjects.add(column);
          case 2:
            var exitDoor = new DecorativeObject(DecorativeObjectKind.exitDoor, i-1, j);
            decorativeObjects.add(exitDoor);
          case 3:
            var gold = new Collectable(TreasureKind.gold, i, j);
            golds.add(gold);
          case 4:
            var treasure = new Collectable(TreasureKind.item, i, j);
            treasures.add(treasure);
          case 5:
            var monster = new Unit(new Character(TeamSide.monsters), i, j);
            monsters.add(monster);
        }
      }
    }

    var i = 0;
    UserData.loadUserData();
    WorldMap.homeTile = getStartTile(tiles);
    for(char in UserData.heroes) {
      if (char.goalChar == null && char.goalTile == null) continue;
      var line = WorldMap.homeTile[0];
      var collumn = WorldMap.homeTile[1];
      var hero = new Unit(char, line, collumn);
      heroes.add(hero);
      this.setTile(collumn, line, 5);
      i++;
    }

    hud = new Hud(this, this.heroes.members);
    tileAnalisys = new TileAnalisys();
  }

  public function getPath(start:Array<Int>, destination:Array<Int>):Array<FlxPoint> {
    var startPt = this.getTileCoordsByIndex(start[1] + start[0] * this.widthInTiles);
    var endPt = this.getTileCoordsByIndex(destination[1] + destination[0] * this.widthInTiles);
    try{
      return this.findPath(startPt, endPt, false, false, FlxTilemapDiagonalPolicy.NONE);
    } catch(e:Dynamic) {
      return null;
    }
	}

  public function isTileWalkable(i:Int, j:Int):Bool {
    return this.getTileCollisions(this.getTile(j, i)) == FlxObject.NONE;
	}

  public function setTileAsWalkable(i:Int, j:Int, walkable = true) {
		var value = (walkable) ? 0 : isTheSameTile([i, j], WorldMap.homeTile) ? 2 : 5;
		this.setTile(j, i, value, false);
	}

  public function isTileValid(i:Int, j:Int):Bool {
    if(i < 0 || j< 0 || i >= this.heightInTiles || j >= this.widthInTiles) return false;
    var index = this.getTile(j, i);
    return index!= null && index != 1 && index < 7 && index >= 0;
  }

  public function isTheSameTile(tileOne:Array<Int>, tileTwo:Array<Int>):Bool {
    return tileOne[0] == tileTwo[0] && tileOne[1] == tileTwo[1];
  }

  public function getTileContentKind(tile:Array<Int>) {
    for(obj in heroes.members) {
      if (isTheSameTile(tile, obj.getCoordinate())) return TileContentKind.hero;
    }
    for(obj in monsters.members) {
      if (isTheSameTile(tile, obj.getCoordinate())) return TileContentKind.monster;
    }
    for(obj in golds.members) {
      if (isTheSameTile(tile, obj.getCoordinate())) return TileContentKind.gold;
    }
    for(obj in treasures.members) {
      if (isTheSameTile(tile, obj.getCoordinate())) return TileContentKind.treasure;
    }
    return TileContentKind.empty;
  }

  public function getTileUnit(tile:Array<Int>):Unit {
    for(obj in heroes.members) {
      if (isTheSameTile(tile, obj.getCoordinate())) return obj;
    }
    for(obj in monsters.members) {
      if (isTheSameTile(tile, obj.getCoordinate())) return obj;
    }
    return null;
  }

  public function getTileCollectable(tile:Array<Int>):Collectable {
    for(obj in golds.members) {
      if (isTheSameTile(tile, obj.getCoordinate())) return obj;
    }
    for(obj in treasures.members) {
      if (isTheSameTile(tile, obj.getCoordinate())) return obj;
    }
    return null;
  }

  public function percentageOfCollectablesRemainingInZone(zoneCoord:Array<Int>):Float {
    var collectablesInZoneCount = 0;

    var zones = MapMaker.getMapZones();
    var currentZone:Map<ZoneInfo, OneOfTwo<Int, ZoneKind>> = new Map<ZoneInfo, OneOfTwo<Int, ZoneKind>>();
    for (zone in zones) {
      if (cast(zone[ZoneInfo.coordX], Int) == zoneCoord[1] && cast(zone[ZoneInfo.coordY], Int) == zoneCoord[0]) {
        currentZone = zone;
        break;
      }
    }

    for (gold in golds.members) {
      var goldZone = PositionTool.getZoneForTile(gold.getCoordinate());
      if (isTheSameTile(zoneCoord, goldZone) && gold.alive) {
        collectablesInZoneCount ++;
      }
    }
    for (treasure in treasures.members) {
      var treasureZone = PositionTool.getZoneForTile(treasure.getCoordinate());
      if (isTheSameTile(zoneCoord, treasureZone) && treasure.alive) {
        collectablesInZoneCount ++;
      }
    }

    var nTreasures:Float = cast(currentZone[ZoneInfo.nTreasures], Int);
    var ngold:Float = cast(currentZone[ZoneInfo.ngold], Int);
    var originalCollectablesInZoneCount:Float = nTreasures + ngold;
    if (originalCollectablesInZoneCount <= 0) {
      return 0;
    } else {
      return collectablesInZoneCount/originalCollectablesInZoneCount;
    }
  }

  public function getZoneName(zoneCoord:Array<Int>) {
    var zones = MapMaker.getMapZones();
    var currentZone:Map<ZoneInfo, OneOfTwo<Int, ZoneKind>> = new Map<ZoneInfo, OneOfTwo<Int, ZoneKind>>();
    for (zone in zones) {
      if (cast(zone[ZoneInfo.coordX], Int) == zoneCoord[1] && cast(zone[ZoneInfo.coordY], Int) == zoneCoord[0]) {
        currentZone = zone;
        break;
      }
    }
    return currentZone[ZoneInfo.name];
  }

  public function getStartTile(tiles:Array<Array<Int>>):Array<Int> {
    for (i in 0...tiles.length) {
      for (j in 0...tiles[i].length) {
        if (tiles[i][j] == 2) {
          return [i-1, j];
        }
      }
    }
    return [];
  }

  public function fixHeroesGoals() {
    for (hero in heroes.members) {
      if (hero.character.goalTile != null) {
        hero.character.goalTile[0] += WorldMap.homeTile[0];
        hero.character.goalTile[1] += WorldMap.homeTile[1];
      }
    }
  }

}
