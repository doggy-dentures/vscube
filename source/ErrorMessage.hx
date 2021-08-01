package;

import flixel.util.FlxDestroyUtil;
import flixel.tweens.motion.CircularMotion;
import flixel.tweens.FlxTween;
import flixel.math.FlxRandom;
import flixel.math.FlxPoint;
import flixel.math.FlxAngle;
import flixel.FlxG;
import flixel.math.FlxVelocity;
import flixel.FlxSprite;

class ErrorMessage extends FlxSprite
{
	public var button:ErrorMessageButton;

	var tweenMotion:FlxTween;

	override public function new(type:Int = 0, randomY:Bool = false)
	{
		super();
		loadGraphic('assets/images/errormessage.png');
		updateHitbox();
		antialiasing = true;
		button = new ErrorMessageButton(this);
		button.xOffset = FlxG.random.float(0, width - button.width);
		button.yOffset = randomY ? FlxG.random.float(0, height - button.height) : height - button.height - 15;
		switch (type)
		{
			case 1:
				x = 80;
				y = (Config.downscroll ? FlxG.height - height : 0);
			case 2:
				x = FlxG.width - width - 80;
				y = (Config.downscroll ? FlxG.height - height : 0);
			case 3:
				x = 80;
				y = (Config.downscroll ? 0 : FlxG.height - height);
			case 4:
				x = FlxG.width - width - 80;
				y = (Config.downscroll ? 0 : FlxG.height - height);
			case 5:
				screenCenter(XY);
			case 6:
				x = 0;
				y = 0;
				tweenMotion = FlxTween.circularMotion(this, FlxG.width / 2 - width / 2, FlxG.height / 2 - height / 2, width / 2, 0, true, 6, true,
					{type: LOOPING});
			case 7:
				x = FlxG.width - width - 80;
				y = (Config.downscroll ? FlxG.height - height : 0);
				tweenMotion = FlxTween.tween(this, {x: FlxG.width + 5}, 1.5, {type: PINGPONG});
			case 8:
				x = FlxG.width + 5;
				y = (Config.downscroll ? 0 : FlxG.height - height);
				tweenMotion = FlxTween.tween(this, {x: FlxG.width - width - 80}, 1.5, {type: PINGPONG});
		}
	}

	public function disarm()
	{
		this.kill();
		button.kill();
		this.destroy();
	}

	override public function destroy()
	{
		if (tweenMotion != null)
		{
			tweenMotion.active = false;
			FlxDestroyUtil.destroy(tweenMotion);
		}
		FlxDestroyUtil.destroy(button);
		super.destroy();
	}

	public function checkButtonOverlap():Bool
	{
		return button.checkOverlap();
	}
}

class ErrorMessageButton extends FlxSprite
{
	public var parent:ErrorMessage;

	public var xOffset:Float;
	public var yOffset:Float;

	override public function new(_parent:ErrorMessage)
	{
		super();
		parent = _parent;
		loadGraphic('assets/images/errorbutton.png');
		updateHitbox();
		antialiasing = true;
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
		x = parent.x + xOffset;
		y = parent.y + yOffset;
		if (isOnScreen() && FlxG.mouse.justPressed && !FlxG.mouse.justPressedRight && checkOverlap())
		{
			parent.disarm();
		}
	}

	public function checkOverlap():Bool
	{
		var tmpPoint = getScreenPosition(null, FlxG.cameras.list[FlxG.cameras.list.length - 1]);
		var worldX = tmpPoint.x;
		var worldY = tmpPoint.y;
		var tmpPoint2 = FlxG.mouse.getScreenPosition(FlxG.cameras.list[FlxG.cameras.list.length - 1]);
		var mworldX = tmpPoint2.x;
		var mworldY = tmpPoint2.y;
		tmpPoint.put();
		tmpPoint2.put();
		if (PlayState.specialActive > 0 && PlayState.specialType == 'anders')
		{
			return (worldX < mworldX + 128 && worldX + width > mworldX && worldY < mworldY + 128 && worldY + height > mworldY);
		}
		else
			return (worldX < mworldX + 32 && worldX + width > mworldX && worldY < mworldY + 32 && worldY + height > mworldY);
	}
}
