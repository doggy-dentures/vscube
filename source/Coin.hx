package;

import flixel.FlxObject;
import flixel.util.FlxDestroyUtil;
import flixel.tweens.FlxTween;
import flixel.math.FlxRandom;
import flixel.math.FlxPoint;
import flixel.math.FlxAngle;
import flixel.FlxG;
import flixel.math.FlxVelocity;
import flixel.FlxSprite;

class Coin extends FlxSprite
{
	override public function new()
	{
		super();
		loadGraphic('assets/images/coin.png');
		scale.x = scale.y = FlxG.random.float(1.0, 3.0);
		antialiasing = true;
		updateHitbox();
		velocity.y = FlxG.random.float(-400, -200);
		velocity.x = FlxG.random.float(-800, -600);
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
		angle += elapsed * 200;
	}
}
