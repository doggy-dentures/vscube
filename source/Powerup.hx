package;

import flixel.tweens.FlxTween;
import flixel.math.FlxRandom;
import flixel.math.FlxPoint;
import flixel.math.FlxAngle;
import flixel.FlxG;
import flixel.math.FlxVelocity;
import flixel.FlxSprite;

class Powerup extends FlxSprite
{
	public var powerType:Int = 0;
	public static var maxIndex:Int = 4;
	public static var freezeProjTime:Int = 7;

	override public function new(type:Int = 0)
	{
		super();
		powerType = type;
		loadGraphic('assets/images/powerup' + powerType + '.png');
		scale.x = scale.y = 2.0;
		antialiasing = true;
		updateHitbox();
	}

	public function disarm()
	{
		FlxG.sound.play('assets/sounds/powerup' + TitleState.soundExt);
		alive = false;
		FlxTween.tween(this, {alpha: 0}, 0.2, {
			onComplete: function(_)
			{
				this.kill();
			}
		});
	}
}
