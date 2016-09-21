package day.engine;

import flixel.FlxSprite;

import day.engine.Dungeon;

enum TreasureSize {
  small;
  big;
}

class Treasure extends FlxSprite {

  public var size:TreasureSize;

  public function new(size:TreasureSize) {
    super();
    this.size = size;
    loadAsset();
  }

  public function loadAsset() {
    loadGraphic("assets/images/treasure.png", true, Dungeon.TILESIZE, Dungeon.TILESIZE);
    this.animation.add("small", [0]);
    this.animation.add("big", [1]);
    switch (size) {
        case small:
        this.animation.play("small");
        case big:
        this.animation.play("big");
    }
    this.animation.stop();
  }

}
