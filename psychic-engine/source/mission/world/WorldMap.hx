package mission.world;

import flixel.tile.FlxBaseTilemap;
import flixel.tile.FlxTilemap;
import flixel.group.FlxGroup;
import flixel.math.FlxPoint;
import flixel.FlxObject;

import utils.Constants;
import mission.world.Unit;
import mission.world.Collectable;
import gameData.Character;

class WorldMap extends FlxTilemap {

  public var foods:FlxTypedGroup<Collectable>;
  public var treasures:FlxTypedGroup<Collectable>;
  public var monsters:FlxTypedGroup<Unit>;
  public var heroes:FlxTypedGroup<Unit>;

  public function new(tiles:Array<Array<Int>>) {
    super();

    this.loadMapFrom2DArray(tiles, "assets/images/tileset.png", Constants.TILESIZE, Constants.TILESIZE, 0, -1);
    setTileProperties(0, FlxObject.NONE);
    setTileProperties(1, FlxObject.ANY);
    setTileProperties(2, FlxObject.NONE);
    setTileProperties(3, FlxObject.NONE);
    setTileProperties(4, FlxObject.NONE);
    setTileProperties(5, FlxObject.ANY);
    setTileProperties(6, FlxObject.ANY);
    setTileProperties(7, FlxObject.ANY);

    foods = new FlxTypedGroup<Collectable>();
    treasures = new FlxTypedGroup<Collectable>();
    monsters = new FlxTypedGroup<Unit>();
    heroes = new FlxTypedGroup<Unit>();
    for (i in 0...tiles.length) {
      for (j in 0...tiles[i].length) {
        switch (tiles[i][j]) {
          case 3:
            var food = new Collectable(TreasureKind.food, i, j);
            foods.add(food);
          case 4:
            var treasure = new Collectable(TreasureKind.item, i, j);
            treasures.add(treasure);
          case 5:
            var monster = new Unit(new Character(TeamSide.monsters), i, j);
            monsters.add(monster);
          case 6:
            //TODO: get the real heroes, and not some random ones
            var hero = new Unit(new Character(TeamSide.heroes), i, j);
            heroes.add(hero);
        }
      }
    }
  }

  public function getPath(start:Array<Int>, destination:Array<Int>) {
    var startPt = new FlxPoint(start[0], start[1]);
    var endPt = new FlxPoint(destination[0], destination[1]);
    return this.findPath(startPt, endPt, false, false, FlxTilemapDiagonalPolicy.NONE);
	}

  public function isTileWalkable(i:Int, j:Int):Bool {
		return false;//return this.getTile(i, j).allowCollisions == FlxObject.ANY;
	}

  public function setTileAsWalkable(i:Int, j:Int, walkable = true) {
		var value = (walkable) ? 0 : 5;
		this.setTile(i, j, value, true);
	}

}
