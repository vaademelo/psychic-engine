package camping;

import flixel.FlxG;
import flixel.ui.FlxButton;
import flixel.FlxSubState;
import flixel.FlxSprite;

import gameData.Character;

import camping.characterMenu.CharStatus;

class CharacterDetailsState extends FlxSubState {

  public var character:Character;

  public var status:CharStatus;
  public var backButton:FlxButton;
  public var bg:FlxSprite;

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

    status = new CharStatus(FlxG.width - 300, 20, character);
    add(status);

    backButton = new FlxButton(20, 20, '', goBackToMissionMenu);
    backButton.loadGraphic("assets/images/menu/backButton.png", true, 20, 20);
    add(backButton);
  }

  override public function update(elapsed:Float):Void {
    super.update(elapsed);
  }

  public function goBackToMissionMenu() {
    this.close();
  }

}
