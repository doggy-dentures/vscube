package;

import flixel.tweens.FlxTween;
import flixel.math.FlxRandom;
import flixel.math.FlxPoint;
import flixel.math.FlxAngle;
import flixel.FlxG;
import flixel.math.FlxVelocity;
import flixel.FlxSprite;

class Candy extends FlxSprite
{
	public var healthBoost:Float;
    public var target:Character;

	public static var maxIndex:Int = 4;

	override public function new(type:Int = 0)
	{
		super();
		loadGraphic('assets/images/candy' + type + '.png');
		scale.x = scale.y = 2.0;
		antialiasing = true;
		updateHitbox();
		switch (type)
		{
			case 0:
                healthBoost = 0.175;
            case 1:
                healthBoost = 0.2;
            case 3:
                healthBoost = 0.225;
            case 4:
                healthBoost = 0.25;
		}
	}

	public function disarm()
	{
		alive = false;
        if (target != null)
        {
            target.healthToAdd = healthBoost;
        }
		FlxTween.tween(this, {alpha: 0}, 0.2, {
			onComplete: function(_)
			{
				this.kill();
			}
		});
	}
}
