package mission;

import flixel.tile.FlxTilemap;
import flixel.group.FlxGroup;
import flixel.FlxObject;

import utils.Constants;
import mission.Unit;
import mission.Collectable;
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
            var hero = new Unit(new Character(TeamSide.heroes), i, j);
            heroes.add(hero);
        }

      }
    }
  }

}
