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

class HeroDiv extends FlxGroup {

  public var draggableButton:HeroDragButton;
  public var moreButton:FlxButton;
  public var name:FlxText;
  public var action:FlxText;

  public function new(xx:Int, yy:Int, char:Character, spritesHolder:Array<OneOfTwo<ZoneHub, HeroDragButton>>) {
    super();


    action = new FlxText();
    draggableButton = new HeroDragButton(xx, yy, char, spritesHolder, action);
    spritesHolder.push(draggableButton);

    xx += Std.int(draggableButton.width) + 5;

    name = new FlxText(xx, yy);
    name.size = 15;
    name.text = char.name;
    name.color = FlxColor.BROWN;

    action.x = xx;
    action.y = yy + 22;
    action.size = 15;
    action.text = "is not going";
    action.color = FlxColor.GRAY;

    xx += Std.int(name.width);

    moreButton = new FlxButton(xx, yy, '', seeCharDetail);
    moreButton.loadGraphic("assets/images/menu/plusButton.png", true, 20, 20);

    add(draggableButton);
    add(moreButton);
    add(name);
    add(action);
  }

  private function seeCharDetail():Void {
    FlxG.state.openSubState(new CharacterDetailsState(draggableButton.character));
  }

}
