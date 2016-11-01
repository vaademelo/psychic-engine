package camping.missionMenu;

import flixel.FlxG;
import flixel.ui.FlxButton;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.group.FlxGroup;
import flixel.util.typeLimit.OneOfTwo;

import camping.missionMenu.ZoneHub;
import camping.CharacterDetailsState;
import camping.missionMenu.HeroDragButton;

import gameData.Character;

import utils.MyNameGenerator;

class HeroDiv extends FlxGroup {

  public var draggableButton:HeroDragButton;
  public var name:FlxText;
  public var moreButton:FlxButton;

  public function new(xx:Int, yy:Int, char:Character, spritesHolder:Array<OneOfTwo<ZoneHub, HeroDragButton>>) {
    super();

    draggableButton = new HeroDragButton(xx, yy, char, spritesHolder);
    spritesHolder.push(draggableButton);

    name = new FlxText(xx + 55, yy + 10);
    name.size = 20;
    name.text = MyNameGenerator.generateName();
    name.color = FlxColor.WHITE;

    moreButton = new FlxButton(xx + 60 + name.width, yy + 13, '', seeCharDetail);
    moreButton.loadGraphic("assets/images/menu/plusButton.png", true, 20, 20);

    add(draggableButton);
    add(name);
    add(moreButton);
  }

  private function seeCharDetail():Void {
    FlxG.switchState(new CharacterDetailsState());
  }

}
