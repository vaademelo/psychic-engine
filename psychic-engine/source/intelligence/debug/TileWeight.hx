package intelligence.debug;

import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.group.FlxSpriteGroup;
import flixel.input.mouse.FlxMouseEventManager;

import utils.Constants;

import mission.world.Unit;
import mission.world.WorldMap;

import intelligence.debug.TileAnalisys;

class TileWeight extends FlxSpriteGroup {

  private var _mind:HeroMind;
  private var _i:Int;
  private var _j:Int;

  private var label:FlxText;
  private var tileAnalisys:TileAnalisys;

  public function new(worldMap:WorldMap, mind:HeroMind, tileWeight:String, i:Int, j:Int) {
    super();
    this.x = (j + 1.0) * Constants.TILE_SIZE - (Constants.TILE_SIZE);
    this.y = (i + 1.0) * Constants.TILE_SIZE - (Constants.TILE_SIZE);

    var hoverArea = new FlxSprite();
    hoverArea.makeGraphic(Constants.TILE_SIZE, Constants.TILE_SIZE, 0x01000000);
    add(hoverArea);

    label = new FlxText();
    label.text = tileWeight;
    label.size = 18;
    var value = Math.max(Math.min(Std.parseFloat(tileWeight), 1), -1) + 0.5;
    label.color = FlxColor.fromRGB(Std.int((2 - value) * 255 / 2.0), Std.int(value  * 255 / 2.0), 0, 255);
    add(label);
    this.tileAnalisys = worldMap.tileAnalisys;

    _mind = mind;
    _i = i;
    _j = j;

    FlxMouseEventManager.add(this, null, null, mouseOver, mouseOut);
  }

  public function updateTileWeight(mind:HeroMind, tileWeight:String, i:Int, j:Int) {
    this.x = (j + 1.0) * Constants.TILE_SIZE - (Constants.TILE_SIZE);
    this.y = (i + 1.0) * Constants.TILE_SIZE - (Constants.TILE_SIZE);
    label.text = tileWeight;
    label.size = 18;
    var value = Math.max(Math.min(Std.parseFloat(tileWeight), 1), -1) + 0.5;
    label.color = FlxColor.fromRGB(Std.int((2 - value) * 255 / 2.0), Std.int(value  * 255 / 2.0), 0, 255);

    _mind = mind;
    _i = i;
    _j = j;
  }

  function mouseOver(sprite:FlxSprite) {
    if (tileAnalisys.visible && tileAnalisys.currentTile[0] == _i && tileAnalisys.currentTile[1] == _j) return;
    tileAnalisys.updateValues(_mind, _i, _j);
    tileAnalisys.x = this.x - tileAnalisys.width/2 + Constants.TILE_SIZE/2;
    tileAnalisys.y = this.y + Constants.TILE_SIZE;
    tileAnalisys.visible = true;
  }

  function mouseOut(sprite:FlxSprite) {
    if (tileAnalisys.visible && tileAnalisys.currentTile[0] == _i && tileAnalisys.currentTile[1] == _j) {
      tileAnalisys.visible = false;
    }
  }
}
