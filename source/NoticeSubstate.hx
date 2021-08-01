package;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSubState;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;

class NoticeSubstate extends FlxSubState
{

    private var controls(get, never):Controls;

	inline function get_controls():Controls
		return PlayerSettings.player1.controls;

    var notice:FlxSprite;
    var type:Int = 0;

    public static var opened:Bool = false;

	override function create()
    {
        super.create();
        notice = new FlxSprite().loadGraphic('assets/images/instruct0.png');
        notice.scrollFactor.x = 0;
        notice.scrollFactor.y = 0;
        add(notice);
    }

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (controls.ACCEPT || controls.BACK)
		{
            opened = true;
			FlxG.switchState(new MainMenuState());
		}

	}

}
