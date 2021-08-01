package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.util.FlxTimer;

using StringTools;

class Boyfriend extends Character
{
	public var stunned:Bool = false;
	public var invuln:Bool = false;

	public function new(x:Float, y:Float, ?char:String = 'bf')
	{
		super(x, y, char, true);
	}

	override function update(elapsed:Float)
	{
		if (!isModel && !debugMode)
		{
			if (animation.curAnim.name.startsWith('sing'))
			{
				holdTimer += elapsed;
			}
			else
				holdTimer = 0;

			if (animation.curAnim.name.endsWith('miss') && animation.curAnim.finished && !debugMode)
			{
				idleEnd();
			}

			if (animation.curAnim.name == 'firstDeath' && animation.curAnim.finished)
			{
				playAnim('deathLoop');
			}
		}
		else if (isModel && !debugMode)
		{
			if (model.currentAnim.startsWith('sing'))
			{
				holdTimer += elapsed;
			}
			else
				holdTimer = 0;
		}

		super.update(elapsed);
	}

	override public function idleEnd(?ignoreDebug:Bool = false)
	{
		if (!isModel && (!debugMode || ignoreDebug))
		{
			switch (curCharacter)
			{
				case 'spooky':
					danced = !danced;
					if (danced)
						playAnim('danceRight', true);
					else
						playAnim('danceLeft', true);
				case 'atlanta':
					var altString = "";
					if (PlayState.specialActive > 0 && PlayState.specialType == 'atlanta')
					{
						altString = "-alt";
					}
					if (animation.getByName('idle' + altString) != null)
						playAnim('idle' + altString, true, false, animation.getByName('idle').numFrames - 1);
					else
						playAnim('idle' + altString, true, false);
				default:
					if (animation.getByName('idle') != null)
						playAnim('idle', true, false, animation.getByName('idle').numFrames - 1);
					else
						playAnim('idle', true, false);
			}
		}
		else if (isModel && (!debugMode || ignoreDebug))
		{
			playAnim('idle');
		}
	}

	override public function dance(?ignoreDebug:Bool = false)
	{
		if (!isModel && (!debugMode || ignoreDebug))
		{
			switch (curCharacter)
			{
				case 'spooky':
					if (!animation.curAnim.name.startsWith('sing'))
						danced = !danced;
					if (danced && !animation.curAnim.name.startsWith('sing'))
						playAnim('danceRight', true);
					else if (!animation.curAnim.name.startsWith('sing'))
						playAnim('danceLeft', true);
				case 'atlanta':
					var altString = "";
					if (PlayState.specialActive > 0 && PlayState.specialType == 'atlanta')
					{
						altString = "-alt";
					}
					if (!animation.curAnim.name.startsWith('sing'))
					{
						playAnim('idle'+altString, true);
					}
				default:
					if (!animation.curAnim.name.startsWith('sing'))
					{
						playAnim('idle', true);
					}
			}
		}
	}
}
