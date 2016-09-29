package mission.world;

import flixel.tile.FlxBaseTilemap;
import flixel.tile.FlxTilemap;
import flixel.group.FlxGroup;
import flixel.math.FlxPoint;
import flixel.FlxObject;

import utils.Constants;

import gameData.Character;
import gameData.UserData;

import mission.world.Unit;
import mission.world.Collectable;

import mission.ui.Hud;
import mission.visualFX.BattleFX;

class WorldMap extends FlxTilemap {

  public var foods:FlxTypedGroup<Collectable>;
  public var treasures:FlxTypedGroup<Collectable>;
  public var monsters:FlxTypedGroup<Unit>;
  public var heroes:FlxTypedGroup<Unit>;
  public var effects:FlxTypedGroup<BattleFX>;
  public var hud:Hud;

  public function new(tiles:Array<Array<Int>>) {
    super();

    this.loadMapFrom2DArray(tiles, "assets/images/tileset.png", Constants.TILE_SIZE, Constants.TILE_SIZE, 0, -1);
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
    effects = new FlxTypedGroup<BattleFX>();

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
        }
      }
    }

    UserData.loadUserData();
    for(i in 0...UserData.heroes.length) {
      var line = (i + 1) % this.heightInTiles;
      var collumn = Math.floor((i + 1)/this.heightInTiles);
      var hero = new Unit(UserData.heroes[i], line, collumn);
      heroes.add(hero);
      this.setTile(collumn, line, 6, true);
    }

    hud = new Hud(this.heroes.members);
  }

  public function getPath(start:Array<Int>, destination:Array<Int>):Array<FlxPoint> {
    var startPt = this.getTileCoordsByIndex(start[1] + start[0] * this.widthInTiles);
    var endPt = this.getTileCoordsByIndex(destination[1] + destination[0] * this.widthInTiles);
    return this.findPath(startPt, endPt, false, false, FlxTilemapDiagonalPolicy.NONE);
	}

  public function isTileWalkable(i:Int, j:Int):Bool {
    return this.getTileCollisions(this.getTile(j, i)) == FlxObject.NONE;
	}

  public function setTileAsWalkable(i:Int, j:Int, walkable = true) {
		var value = (walkable) ? 0 : 5;
		this.setTile(j, i, value, false);
	}

  public function isTileValid(i:Int, j:Int):Bool {
    if(i < 0 || j< 0 || i >= this.heightInTiles || j >= this.widthInTiles) return false;
    var index = this.getTile(j, i);
    return index!= null && index != 1 && index < 7 && index >= 0;
  }

}
