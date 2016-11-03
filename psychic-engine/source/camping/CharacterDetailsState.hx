package camping;

import flixel.FlxG;
import flixel.ui.FlxButton;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.FlxSubState;
import flixel.FlxSprite;

import gameData.Character;

import camping.characterMenu.FriendsDiv;
import camping.characterMenu.CharStatus;
import camping.characterMenu.PersonalityDiv;

class CharacterDetailsState extends FlxSubState {

  public var character:Character;

  public var status:CharStatus;
  public var personality:PersonalityDiv;
  public var relations:FriendsDiv;

  public var backButton:FlxButton;
  public var bg:FlxSprite;
  public var name:FlxText;

  public function new(character:Character) {
    super();
    this.character = character;
  }

  override public function create():Void {
    super.create();
    bg = new FlxSprite(0, 0, "assets/images/menu/guildBackground.png");
    bg.setGraphicSize(FlxG.width, FlxG.height);
    bg.updateHitbox();
    bg.centerOrigin();
    add(bg);

    backButton = new FlxButton(20, 20, '', goBackToMissionMenu);
    backButton.loadGraphic("assets/images/menu/backButton.png", true, 20, 20);
    add(backButton);

    name = new FlxText(50, 17);
    name.size = 20;
    name.text = character.name;
    name.color = FlxColor.YELLOW;
    add(name);

    status = new CharStatus(20, 50, character);
    add(status);

    personality = new PersonalityDiv(300, 50, character);
    add(personality);

    relations = new FriendsDiv(600, 50, character);
    add(relations);
  }

  override public function update(elapsed:Float):Void {
    super.update(elapsed);
  }

  public function goBackToMissionMenu() {
    this.close();
  }

}
