package;

import lime.media.FlashAudioContext;
import flixel.FlxCamera;
import flixel.tweens.FlxTween;
import flixel.math.FlxRandom;
import flixel.math.FlxPoint;
import flixel.math.FlxAngle;
import flixel.FlxG;
import flixel.math.FlxVelocity;
import flixel.FlxSprite;

class Helper extends FlxSprite
{
    public var target:FlxSprite;

	override public function new()
	{
		super();
		loadGraphic('assets/images/crosshairhelper.png');
		scale.x = scale.y = 2.5;
		antialiasing = true;
		updateHitbox();
	}

}
