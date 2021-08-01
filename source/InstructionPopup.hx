package;

import flixel.FlxCamera;
import flixel.tweens.FlxTween;
import flixel.math.FlxRandom;
import flixel.math.FlxPoint;
import flixel.math.FlxAngle;
import flixel.FlxG;
import flixel.math.FlxVelocity;
import flixel.FlxSprite;

class InstructionPopup extends FlxSprite
{
    public var finishThing:Void->Void;
    private var controls(get, never):Controls;

	inline function get_controls():Controls
		return PlayerSettings.player1.controls;

	override public function new(type:Int = 0, ?cam:FlxCamera)
	{
		super();
        if (cam == null)
            cam = FlxG.camera;
        cameras = [cam];
		loadGraphic('assets/images/instruct' + type + '.png');
		antialiasing = true;
		updateHitbox();
	}

    override public function update(elapsed:Float)
    {
        var accepted = controls.ACCEPT;
        super.update(elapsed);
        if (accepted)
        {
            finishThing();
        }
    }

}
