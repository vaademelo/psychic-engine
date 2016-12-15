package;

import flixel.FlxGame;
import openfl.Lib;
import openfl.display.Sprite;

import camping.TitleState;

import utils.Constants;

class Main extends Sprite
{
	public function new()
	{
		super();

		Constants.setup();

		addChild(new FlxGame(0, 0, TitleState));
	}
}
