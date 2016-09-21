package day.engine;

import flixel.tile.FlxBaseTilemap;
import flixel.system.FlxAssets;
import flixel.tile.FlxTilemap;
import flixel.group.FlxGroup;
import flixel.math.FlxPoint;
import flixel.FlxObject;

import day.engine.Treasure;
import day.engine.Unit;

enum ZoneKind {
  starter;
  near;
  middle;
  intense;
  utopia;
}

enum TileKind {
  blank;
  wall;
  enemy;
  treasure;
  home;
  hero;
}

class Dungeon extends FlxTilemap {

	public static var TILESIZE:Int = 48;
	public static var LEVELSIZE:Int = 45;

	public var tilesValues:Array<Int>;
	public var tilesKinds:Array<TileKind>;

  public function new() {
    super();
  }

	public function populateWorld(heroes:FlxTypedGroup<Unit>, enemies:FlxTypedGroup<Unit>, treasures:FlxTypedGroup<Treasure>) {
		tilesKinds = makeMap();
		tilesKinds[0] = home;
		tilesKinds[1] = hero;
		tilesKinds[LEVELSIZE] = hero;
		tilesValues = new Array<Int>();
		for(i in 0...LEVELSIZE * LEVELSIZE){
			createInvisibleTile(i);
		}
		loadWorld();
		for(j in 0...2) {
			for(i in 0...2) {
				showTile(i + j * LEVELSIZE, heroes, enemies, treasures);
			}
		}
	}

	public function cleanFog(unit:Unit, heroes:FlxTypedGroup<Unit>, enemies:FlxTypedGroup<Unit>, treasures:FlxTypedGroup<Treasure>) {
		var index = getTileIndexByCoords(unit.body.getMidpoint());
		var tiles = propagateOnTiles(index, unit.vision);
		for(tile in tiles) {
			if(tilesValues[tile] == 1 || tilesValues[tile] == 2) {
				showTile(tile, heroes, enemies, treasures);
			}
		}
	}

	public function propagateOnTiles(currentIndex:Int, distance:Int = 1):Array<Int> {
		var tiles = [currentIndex];
		if(distance > 0) {
			var left = currentIndex % widthInTiles > 0;
			var right = currentIndex % widthInTiles < widthInTiles - 1;
			var up = Math.floor(currentIndex / widthInTiles) > 0;
			var down = Math.floor(currentIndex / widthInTiles) < heightInTiles - 1;
			var index:Int;
			if (up) {
				index = currentIndex - widthInTiles;
				tiles = tiles.concat(propagateOnTiles(index, distance-1));
			}
			if (right) {
				index = currentIndex + 1;
				tiles = tiles.concat(propagateOnTiles(index, distance-1));
			}
			if (down) {
				index = currentIndex + widthInTiles;
				tiles = tiles.concat(propagateOnTiles(index, distance-1));
			}
			if (left) {
				index = currentIndex - 1;
				tiles = tiles.concat(propagateOnTiles(index, distance-1));
			}
		}
		return tiles;
	}

	public function loadWorld() {
		this.loadMapFromArray(tilesValues, LEVELSIZE, LEVELSIZE, "assets/images/tileset.png", TILESIZE, TILESIZE, null, 1);
		setTileProperties(1, FlxObject.ANY);
		setTileProperties(2, FlxObject.NONE);
		setTileProperties(3, FlxObject.NONE);
		setTileProperties(4, FlxObject.ANY);
		setTileProperties(5, FlxObject.ANY);
		setTileProperties(6, FlxObject.NONE);
	}

	public function getPath(start:FlxPoint, destination:Int) {
    var fn = getTileCoordsByIndex(destination);
		return this.findPath(start, fn, false, false, FlxTilemapDiagonalPolicy.NONE);
	}

	public function isTileWalkable(index:Int):Bool {
		var tile = getTileByIndex(index);
		return _tileObjects[tile].allowCollisions == FlxObject.ANY;
	}

	public function setTileAsWalkable(unit:Unit, walkable = true) {
		var index = getTileIndexByCoords(unit.body.getMidpoint());
		var value = (walkable) ? 3 : 4;
		this.setTileByIndex(index, value, true);
		tilesValues[index] = value;
	}

	// =================== PRIVATES =================== //

	private function createInvisibleTile(index:Int) {
		switch (tilesKinds[index]) {
			case enemy:
			tilesValues[index] = 2;
			case hero:
			tilesValues[index] = 2;
			case treasure:
			tilesValues[index] = 2;
			case blank:
			tilesValues[index] = 2;
			case wall:
			tilesValues[index] = 1;
			case home:
			tilesValues[index] = 2;
		}
	}

	private function showTile(index:Int, heroes:FlxTypedGroup<Unit>, enemies:FlxTypedGroup<Unit>, treasures:FlxTypedGroup<Treasure>) {
		var value:Int = 0;
		var position:FlxPoint = getTileCoordsByIndex(index);
		switch (tilesKinds[index]) {
			case enemy:
			value = 4;
			var armor = Random.fromArray(Type.allEnums(BodyArmor));
			var enemy = new Unit(enemy, armor);
			enemies.add(enemy);
			enemy.body.setPosition(position.x - TILESIZE/2, position.y - TILESIZE/2);
			case hero:
			value = 4;
			var armor = Random.fromArray(Type.allEnums(BodyArmor));
			var hero = new Unit(hero, armor);
			heroes.add(hero);
			hero.body.setPosition(position.x - TILESIZE/2, position.y - TILESIZE/2);
			case treasure:
			value = 3;
			var size:TreasureSize = (Math.random() < 0.2) ? big : small;
			var treasure = new Treasure(size);
			treasures.add(treasure);
			treasure.setPosition(position.x - TILESIZE/2, position.y - TILESIZE/2);
			case blank:
			value = 3;
			case wall:
			value = 5;
			case home:
			value = 6;
		}
		tilesValues[index] = value;
		this.setTileByIndex(index, value, true);
	}

	private function makeMap():Array<TileKind> {
    var tilesMap:Array<TileKind> = new Array<TileKind>();
    for (i in 0...LEVELSIZE*LEVELSIZE){
      tilesMap.push(null);
    }
    var zones:Array<Array<Dynamic>> = [
    [starter, [0,0],    [5,5]  ],
    [near,    [5,0],    [45,5] ],
    [near,    [0,5],    [5,45] ],
    [middle,  [5,5],    [40,40]],
    [intense, [40,5],   [45,40]],
    [intense, [5,40],   [40,45]],
    [utopia,  [40,40],  [45,45]]
    ];
    for (i in 0...zones.length){
      var zone = zones[i];
      var size = Math.floor((zone[2][0] - zone[1][0]) * (zone[2][1] - zone[1][1]));
      var tiles:Array<TileKind>  = makeZone(zone[0], size);
      var i = zone[1][0];
      var j = zone[1][1];
      for (tile in tiles) {
        tilesMap[i + j * LEVELSIZE] = tile;
        i++;
        if (i == zone[2][0]){
          i = zone[1][0];
          j ++;
        }
      }
    }
    return tilesMap;
  }

  private function makeZone(zone:ZoneKind, size:Int):Array<TileKind> {
    var tilesProb:Array<Float> = [0,0,0];
    switch (zone) {
      case starter:
      tilesProb = [0, 1/size, 2/size];
      case near:
      tilesProb = [0.05, 0.05, 0.05];
      case middle:
      tilesProb = [0.05, 0.1, 0.05];
      case intense:
      tilesProb = [0.025, 0.15, 0.01];
      case utopia:
      tilesProb = [0, 0.05, 0.4];
    }
    var nWalls = Math.floor(tilesProb[0]*size);
    var nEnemies = Math.floor(tilesProb[1]*size);
    var nTreasures = Math.floor(tilesProb[2]*size);
    var array = new Array<TileKind>();
    array = array.concat(addTilesOnArray(wall,nWalls));
    array = array.concat(addTilesOnArray(enemy,nEnemies));
    array = array.concat(addTilesOnArray(treasure,nTreasures));
		array = array.concat(addTilesOnArray(blank,size-array.length));
    Random.shuffle(array);
    return array;
  }

  private function addTilesOnArray(kind:TileKind, num:Int):Array<TileKind> {
    var array = new Array<TileKind>();
    while( num > 0 ) {
      array.push(kind);
      num --;
    }
    return array;
  }

}
