package;

import flixel.FlxGame;
import openfl.Lib;
import openfl.display.Sprite;

import camping.MissionMenuState;

class Main extends Sprite
{
	public function new()
	{
		super();
		addChild(new FlxGame(0, 0, MissionMenuState));
	}
}