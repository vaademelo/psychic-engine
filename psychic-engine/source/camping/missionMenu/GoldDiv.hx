package camping.missionMenu;

import flixel.FlxG;
import flixel.ui.FlxButton;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.group.FlxGroup;
import flixel.FlxSprite;

import gameData.UserData;

class GoldDiv extends FlxGroup {

  public var moneyLbl:FlxText;
  public var restLbl:FlxText;

  public function new(xx:Int, yy:Int) {
    super();

    var icon = new FlxSprite(xx, yy, "assets/images/gold.png");
    add(icon);

    moneyLbl = new FlxText(xx - 105, yy + 5, 100);
    moneyLbl.size = 14;
    moneyLbl.text = Std.string(UserData.goldTotal);
    moneyLbl.color = FlxColor.BROWN;
    moneyLbl.alignment = FlxTextAlign.RIGHT;
    add(moneyLbl);

    calcUsedGold();
  }

  public function calcUsedGold() {
    var goldUsage = UserData.heroes.length * 2;
    for (hero in UserData.heroes) {
      if (hero.goalTile != null || hero.goalChar != null) {
        goldUsage += 3;
      }
    }
    moneyLbl.text = UserData.goldTotal + " - " + goldUsage + " = " + (UserData.goldTotal - goldUsage);
  }

}
