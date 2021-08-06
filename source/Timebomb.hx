package;

import flixel.util.FlxDestroyUtil;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.tweens.FlxTween;
import flixel.math.FlxRandom;
import flixel.math.FlxPoint;
import flixel.math.FlxAngle;
import flixel.FlxG;
import flixel.math.FlxVelocity;
import flixel.FlxSprite;

class Timebomb extends FlxSprite
{
	public var target:Character;

	var damage:Float = 0.66;

	public var cursorHeld:Float = 0;
	public var cursorMax:Float = 3;
	public var beingHeld:Bool = false;
	public var helperHeld:Bool = false;

	public var timeMax:Float = 20;
	public var timeAlive:Float = 0;

	var secLeft:Int;

	public var countdown:FlxText;

	override public function new(_target:Character)
	{
		super();
		if (PlayState.easyMode)
			timeMax = 30;
		target = _target;
		scale.x = scale.y = 2.0;
		updateHitbox();
		antialiasing = true;
		loadGraphic('assets/images/timebomb.png');
		FlxG.sound.play('assets/sounds/timebomb' + TitleState.soundExt);
		secLeft = Math.ceil(timeMax);
		countdown = new FlxText(0, 0, 0, ""+secLeft, 72);
		countdown.setFormat(countdown.font, countdown.size, FlxColor.WHITE, CENTER, OUTLINE, FlxColor.BLACK);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (target == null)
		{
			this.kill();
			return;
		}

		timeAlive += FlxG.elapsed;

		secLeft = Math.ceil(timeMax - timeAlive);
		countdown.text = "" + secLeft;
		countdown.x = this.x + this.width / 2 - countdown.width / 2;
		countdown.y = this.y + this.height / 2 - countdown.height / 2;

		if (beingHeld || helperHeld)
		{
			cursorHeld += FlxG.elapsed;
			angle += FlxG.elapsed * 250;
		}

		if (cursorHeld >= cursorMax)
			disarm();

		if (timeAlive >= timeMax)
			explode();

		alpha = 1 - 0.8 * (cursorHeld / cursorMax);
		color = FlxColor.fromRGBFloat(1, 1 - timeAlive / timeMax, 1 - timeAlive / timeMax);

		if (!alive)
			return;
	}

	public function explode()
	{
		alive = false;
		target.getHit(damage);
		FlxG.sound.play('assets/sounds/explosion' + TitleState.soundExt);
		FlxG.camera.shake(0.07);
		this.kill();
	}

	public function disarm(silent:Bool = false)
	{
		alive = false;
		if (!silent)
			FlxG.sound.play('assets/sounds/timebombdisarm' + TitleState.soundExt);
		this.kill();
	}

	override public function kill()
	{
		if (countdown != null)
			countdown.kill();
		super.kill();
	}
}
