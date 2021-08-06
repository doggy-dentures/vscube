package;

import away3d.errors.AbstractMethodError;
import flixel.tweens.FlxTween;
import flixel.math.FlxRandom;
import flixel.math.FlxPoint;
import flixel.math.FlxAngle;
import flixel.FlxG;
import flixel.math.FlxVelocity;
import flixel.FlxSprite;

class Projectile extends FlxSprite
{
	public var target:Character;

	var damage:Float = 0.1;
	var dest:FlxPoint;
	var speed:Float;
	var projectileType:Int;

	public var isEnemyProj:Bool = false;
	public var isBomb:Bool = false;
	public var gracePeriod:Float = 0;
	public var maxGracePeriod:Float = 0;

	var xOffset:Float;
	var yOffset:Float;

	override public function new(_target:Character, noteData:Int, _isEnemyProj:Bool, noBomb:Bool = false)
	{
		super();
		target = _target;
		projectileType = noteData % 4;
		if (!noBomb && Std.random(100) < PlayState.bombChance)
			projectileType = 4;
		isEnemyProj = _isEnemyProj;
		switch (projectileType)
		{
			case 0:
				loadGraphic('assets/images/projectile0.png');
				speed = PlayState.projSpeed * FlxG.random.float(0.65, 1.05);
			case 1:
				loadGraphic('assets/images/projectile1.png');
				speed = PlayState.projSpeed * FlxG.random.float(0.7, 1.1);
			case 2:
				loadGraphic('assets/images/projectile2.png');
				speed = PlayState.projSpeed * FlxG.random.float(0.75, 1.15);
			case 3:
				loadGraphic('assets/images/projectile3.png');
				speed = PlayState.projSpeed * FlxG.random.float(0.8, 1.2);
			case 4:
				loadGraphic('assets/images/projectile4.png');
				speed = PlayState.projSpeed * FlxG.random.float(0.65, 1.15);
				damage = 0.25;
				isBomb = true;
		}
		speed *= (isEnemyProj ? 1.0 : 2.0);
		scale.x = scale.y = 2.0;
		updateHitbox();
		antialiasing = true;
		dest = FlxPoint.get();
		newDest();
	}

	public function newDest()
	{
		if (isEnemyProj)
		{
			xOffset = target.frameWidth / 2;
			yOffset = target.frameHeight / 2;
		}
		else
		{
			xOffset = target.frameWidth / 2;
			yOffset = FlxG.random.float(target.frameHeight * 0.1, target.frameHeight * 0.9);
		}
	}

	function refreshDest()
	{
		dest.x = target.x + xOffset;
		dest.y = target.y + yOffset;
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (target == null)
		{
			trace("no target?");
			this.kill();
			return;
		}

		if (!alive)
			return;

		refreshDest();

		FlxVelocity.moveTowardsPoint(this, dest,
			speed * ((isEnemyProj && PlayState.freezeProj > 0) ? 0 : 1.0) * Conductor.playbackSpeed * (PlayState.easyMode ? 0.6 : 1));
		angle = FlxAngle.angleBetween(this, target, true);

		// if (FlxG.pixelPerfectOverlap(this, target, 128))
		// {
		// 	if (isBomb)
		// 		explode();
		// 	else
		// 		fire();
		// }
		if (isEnemyProj && target.pixelsOverlapPoint(FlxPoint.weak(x + width / 2, y + height / 2), 0x22))
		{
			if (isBomb)
				explode();
			else
				fire();
		}
		else if (!isEnemyProj && overlaps(target))
		{
			if (isBomb)
				explode();
			else
				fire();
		}

		if (gracePeriod > 0)
		{
			if (isOnScreen())
			{
				gracePeriod = Math.max(0, gracePeriod - FlxG.elapsed);
				alpha = 0.5;
			}
		}
		else
			alpha = 1.0;
	}

	public function fire()
	{
		alive = false;
		target.getHit(damage);
		velocity.x = velocity.y = 0;
		FlxTween.tween(this, {alpha: 0, color: 0xff0000}, 0.2, {
			onComplete: function(_)
			{
				this.kill();
			}
		});
	}

	public function explode()
	{
		fire();
		if (isEnemyProj)
		{
			FlxG.sound.play('assets/sounds/explosion' + TitleState.soundExt);
			FlxG.camera.shake(0.07);
		}
		this.kill();
	}

	public function disarm()
	{
		alive = false;
		velocity.x = velocity.y = 0;
		FlxTween.tween(this, {alpha: 0}, 0.2, {
			onComplete: function(_)
			{
				this.kill();
			}
		});
	}

	override public function kill()
	{
		dest.put();
		velocity.x = velocity.y = 0;
		super.kill();
	}
}
