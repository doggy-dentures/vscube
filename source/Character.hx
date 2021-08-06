package;

import flixel.FlxObject;
import flixel.util.FlxDestroyUtil;
import flixel.system.FlxSound;
import away3d.core.base.data.Face;
import flixel.tweens.FlxTween;
import away3d.errors.AbstractMethodError;
import flixel.FlxSprite;
import flixel.animation.FlxBaseAnimation;
import flixel.graphics.frames.FlxAtlasFrames;

using StringTools;

class Character extends FlxSprite
{
	public var animOffsets:Map<String, Array<Dynamic>>;
	public var debugMode:Bool = false;

	public var isPlayer:Bool = false;
	public var curCharacter:String = 'bf';

	public var holdTimer:Float = 0;

	public var canAutoAnim:Bool = true;

	public var isModel:Bool = false;
	public var beganLoading:Bool = false;
	public var modelName:String;
	public var modelScale:Float;
	public var modelOrigBPM:Int;
	public var model:ModelThing;

	public var spinYaw:Bool = false;
	public var spinYawVal:Int = 0;
	public var spinPitch:Bool = false;
	public var spinPitchVal:Int = 0;
	public var spinRoll:Bool = false;
	public var spinRollVal:Int = 0;
	public var yTween:FlxTween;
	public var xTween:FlxTween;
	public var originalY:Float = -1;
	public var originalX:Float = -1;
	public var circleTween:FlxTween;
	public var initYaw:Float = 0;
	public var initAlpha:Float = 1.0;
	public var shimmer:Bool = false;
	public var healthToAdd:Float = 0;
	public var noPitching:Bool = false;
	public var absoluteLength:Bool = false;
	public var noLooping:Bool = false;
	public var initialSpecial:Int = 0;
	public var noHitIncrement:Bool = false;

	public var isPlayer3 = false;

	var initWidth:Int;
	var initFacing:Int = FlxObject.RIGHT;

	var hitSound:FlxSound;

	public function new(x:Float, y:Float, ?character:String = "bf", ?isPlayer:Bool = false)
	{
		animOffsets = new Map<String, Array<Dynamic>>();
		super(x, y);

		curCharacter = character;
		this.isPlayer = isPlayer;

		var tex:FlxAtlasFrames;
		antialiasing = true;

		if (isPlayer)
			hitSound = new FlxSound().loadEmbedded('assets/sounds/bfhit' + TitleState.soundExt);
		else
			hitSound = new FlxSound().loadEmbedded('assets/sounds/dadhit' + TitleState.soundExt);

		// var loadFrom = (isPlayer ? Main.modelViewBF.sprite : Main.modelView.sprite);
		var loadFrom = Main.modelView.sprite;

		switch (curCharacter)
		{
			// case 'monkey':
			// 	// DD: Okay, don't load models here cuz the engine will crash with more than one model

			// 	// model = new ModelThing("monkey", Main.modelView, 100, 80);
			// 	// model = new ModelThing("boyfriend", Main.modelView, 1.5, 80);
			// 	modelName = "monkey";
			// 	modelScale = 90;
			// 	modelOrigBPM = 75;
			// 	isModel = true;
			// 	loadGraphicFromSprite(loadFrom);
			// 	scale.x = scale.y = 1.4;
			// 	initYaw = 0;
			// 	updateHitbox();

			// case 'bf-poly':
			// 	// model = new ModelThing("boyfriend", Main.modelViewBF, 1.5, 80);
			// 	modelName = "boyfriend";
			// 	modelScale = 1.2;
			// 	modelOrigBPM = 75;
			// 	isModel = true;
			// 	loadGraphicFromSprite(loadFrom);
			// 	scale.x = scale.y = 1.6;
			// 	updateHitbox();
			// 	initYaw = 45;
			// 	flipX = true;

			case 'cube':
				modelName = "cube";
				modelScale = 50;
				modelOrigBPM = 75;
				isModel = true;
				loadGraphicFromSprite(loadFrom);
				scale.x = scale.y = 1.3;
				initYaw = -45;
				updateHitbox();

			case 'round':
				modelName = "round";
				initAlpha = 0.86;
				shimmer = true;
				modelScale = 50;
				modelOrigBPM = 75;
				isModel = true;
				loadGraphicFromSprite(loadFrom);
				scale.x = scale.y = 1.3;
				initYaw = -45;
				updateHitbox();

			case 'cat':
				initialSpecial = 2;
				tex = FlxAtlasFrames.fromSparrow('assets/images/CAT.png', 'assets/images/CAT.xml');
				frames = tex;
				animation.addByPrefix('idle', 'cat idle dance', 24, false);
				animation.addByPrefix('singUP', 'cat Sing Note UP', 24);
				animation.addByPrefix('singRIGHT', 'cat Sing Note RIGHT', 24);
				animation.addByPrefix('singDOWN', 'cat Sing Note DOWN', 24);
				animation.addByPrefix('singLEFT', 'cat Sing Note LEFT', 24);

				addOffset('idle');
				addOffset("singUP", -6, 10);
				addOffset("singRIGHT", -7, -10);
				addOffset("singLEFT", -12, 0);
				addOffset("singDOWN", -6, -7);

				playAnim('idle');

			case 'anders':
				initialSpecial = 3;
				tex = FlxAtlasFrames.fromSparrow('assets/images/anders.png', 'assets/images/anders.xml');
				frames = tex;
				animation.addByPrefix('idle', 'Dad idle dance', 24, false);
				animation.addByPrefix('singUP', 'Dad Sing Note UP', 24);
				animation.addByPrefix('singRIGHT', 'Dad Sing Note RIGHT', 24);
				animation.addByPrefix('singDOWN', 'Dad Sing Note DOWN', 24);
				animation.addByPrefix('singLEFT', 'Dad Sing Note LEFT', 24);

				addOffset('idle');
				addOffset("singUP", 55, 96);
				addOffset("singRIGHT", -4, 33);
				addOffset("singLEFT", 121, 12);
				addOffset("singDOWN", -5, -20);

				playAnim('idle');

			case 'salesman':
				initialSpecial = 2;
				initFacing = FlxObject.LEFT;
				var tex = FlxAtlasFrames.fromSparrow('assets/images/Door.png', 'assets/images/Door.xml');
				frames = tex;
				animation.addByPrefix('idle', 'BF idle dance', 24, false);
				animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);
				animation.addByPrefix('singLEFT', 'BF NOTE LEFT0', 24, false);
				animation.addByPrefix('singRIGHT', 'BF NOTE RIGHT0', 24, false);
				animation.addByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);
				animation.addByPrefix('singUPmiss', 'BF NOTE UP MISS', 24, false);
				animation.addByPrefix('singLEFTmiss', 'BF NOTE LEFT MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BF NOTE RIGHT MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BF NOTE DOWN MISS', 24, false);
				animation.addByPrefix('hey', 'BF HEY', 24, false);

				animation.addByPrefix('firstDeath', "BF dies", 24, false);
				animation.addByPrefix('deathLoop', "BF Dead Loop", 24, true);
				animation.addByPrefix('deathConfirm', "BF Dead confirm", 24, false);

				animation.addByPrefix('scared', 'BF idle shaking', 24);

				addOffset('idle');
				addOffset("hey");
				addOffset("singUP", 2, 5);
				addOffset("singRIGHT", -38, -7);
				addOffset("singLEFT", 12, -6);
				addOffset("singDOWN", -10, -28);
				addOffset("singUPmiss", 2, 5);
				addOffset("singRIGHTmiss", -38, -7);
				addOffset("singLEFTmiss", 12, -6);
				addOffset("singDOWNmiss", -10, -28);
				addOffset('firstDeath', 0, 199);
				addOffset('deathLoop', 0, 199);
				addOffset('deathConfirm', 0, 199);
				addOffset('scared', 0, 1);

				playAnim('idle');

			// flipX = true;

			case 'minesweeper':
				initialSpecial = 3;
				frames = FlxAtlasFrames.fromSparrow('assets/images/minesweeper.png', 'assets/images/minesweeper.xml');

				animation.addByPrefix('idle', 'MS Idle dance', 24, false);
				animation.addByPrefix('singUP', 'MS Up Pose', 24, false);
				animation.addByPrefix('singLEFT', 'MS Left Pose', 24, false);
				animation.addByPrefix('singRIGHT', 'MS Right Pose', 24, false);
				animation.addByPrefix('singDOWN', 'MS Down Pose', 24, false);

				addOffset('idle');
				addOffset("singUP");
				addOffset("singRIGHT");
				addOffset("singLEFT");
				addOffset("singDOWN");

				playAnim('idle');

			case 'atlanta':
				initialSpecial = 2;
				noLooping = true;
				tex = FlxAtlasFrames.fromSparrow('assets/images/atlanta.png', 'assets/images/atlanta.xml');
				frames = tex;
				animation.addByPrefix('idle', 'Atlanta idle dance', 24);
				animation.addByPrefix('singUP', 'Atlanta Sing Note UP', 24);
				animation.addByPrefix('singRIGHT', 'Atlanta Sing Note RIGHT', 24);
				animation.addByPrefix('singDOWN', 'Atlanta Sing Note DOWN', 24);
				animation.addByPrefix('singLEFT', 'Atlanta Sing Note LEFT', 24);
				animation.addByPrefix('idle-alt', 'AtlantaBass idle dance', 24);
				animation.addByPrefix('singUP-alt', 'AtlantaBass Sing Note UP', 24);
				animation.addByPrefix('singRIGHT-alt', 'AtlantaBass Sing Note RIGHT', 24);
				animation.addByPrefix('singDOWN-alt', 'AtlantaBass Sing Note DOWN', 24);
				animation.addByPrefix('singLEFT-alt', 'AtlantaBass Sing Note LEFT', 24);

				addOffset('idle');
				addOffset("singUP", -25, 1);
				addOffset("singRIGHT", -37, -6);
				addOffset("singLEFT", 17, 11);
				addOffset("singDOWN", -130, -65);
				addOffset('idle-alt', -16, -74);
				addOffset("singUP-alt", -39, -76);
				addOffset("singRIGHT-alt", -50, -80);
				addOffset("singLEFT-alt", -2, -81);
				addOffset("singDOWN-alt", -140, -141);

				playAnim('idle');

			case 'dilune':
				initialSpecial = 2;
				initFacing = FlxObject.LEFT;
				tex = FlxAtlasFrames.fromSparrow('assets/images/dilune.png', 'assets/images/dilune.xml');
				frames = tex;
				animation.addByPrefix('idle', "Pico Idle Dance", 24, false);
				animation.addByPrefix('singUP', 'pico Up note0', 24, false);
				animation.addByPrefix('singDOWN', 'Pico Down Note0', 24, false);
				animation.addByPrefix('singLEFT', 'Pico NOTE LEFT0', 24, false);
				animation.addByPrefix('singRIGHT', 'Pico Note Right0', 24, false);

				addOffset('idle');
				addOffset("singUP", 32, 19);
				addOffset("singLEFT", 104, -8);
				addOffset("singRIGHT", -17, 1);
				addOffset("singDOWN", 54, -81);

				playAnim('idle');

			case 'nothing':
				loadGraphic('assets/images/nothing.png');

			case 'gf':
				// GIRLFRIEND CODE
				tex = FlxAtlasFrames.fromSparrow('assets/images/GF_assets.png', 'assets/images/GF_assets.xml');
				frames = tex;
				animation.addByPrefix('cheer', 'GF Cheer', 24, false);
				animation.addByPrefix('singLEFT', 'GF left note', 24, false);
				animation.addByPrefix('singRIGHT', 'GF Right Note', 24, false);
				animation.addByPrefix('singUP', 'GF Up Note', 24, false);
				animation.addByPrefix('singDOWN', 'GF Down Note', 24, false);
				animation.addByIndices('sad', 'gf sad', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], "", 24, false);
				animation.addByIndices('danceLeft', 'GF Dancing Beat', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF Dancing Beat', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
				animation.addByIndices('hairBlow', "GF Dancing Beat Hair blowing", [0, 1, 2, 3], "", 24);
				animation.addByIndices('hairFall', "GF Dancing Beat Hair Landing", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11], "", 24, false);
				animation.addByPrefix('scared', 'GF FEAR', 24);

				addOffset('cheer');
				addOffset('sad', -2, -21);
				addOffset('danceLeft', 0, -9);
				addOffset('danceRight', 0, -9);

				addOffset("singUP", 0, 4);
				addOffset("singRIGHT", 0, -20);
				addOffset("singLEFT", 0, -19);
				addOffset("singDOWN", 0, -20);
				addOffset('hairBlow', 45, -8);
				addOffset('hairFall', 0, -9);

				addOffset('scared', -2, -17);

				playAnim('danceRight');

			// case 'gf-christmas':
			// 	tex = FlxAtlasFrames.fromSparrow('assets/images/christmas/gfChristmas.png', 'assets/images/christmas/gfChristmas.xml');
			// 	frames = tex;
			// 	animation.addByPrefix('cheer', 'GF Cheer', 24, false);
			// 	animation.addByPrefix('singLEFT', 'GF left note', 24, false);
			// 	animation.addByPrefix('singRIGHT', 'GF Right Note', 24, false);
			// 	animation.addByPrefix('singUP', 'GF Up Note', 24, false);
			// 	animation.addByPrefix('singDOWN', 'GF Down Note', 24, false);
			// 	animation.addByIndices('sad', 'gf sad', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], "", 24, false);
			// 	animation.addByIndices('danceLeft', 'GF Dancing Beat', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
			// 	animation.addByIndices('danceRight', 'GF Dancing Beat', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
			// 	animation.addByIndices('hairBlow', "GF Dancing Beat Hair blowing", [0, 1, 2, 3], "", 24);
			// 	animation.addByIndices('hairFall', "GF Dancing Beat Hair Landing", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11], "", 24, false);
			// 	animation.addByPrefix('scared', 'GF FEAR', 24);

			// 	addOffset('cheer');
			// 	addOffset('sad', 0, -21);
			// 	addOffset('danceLeft', 0, -9);
			// 	addOffset('danceRight', 0, -9);

			// 	addOffset("singUP", 0, 4);
			// 	addOffset("singRIGHT", 0, -20);
			// 	addOffset("singLEFT", 0, -19);
			// 	addOffset("singDOWN", 0, -20);
			// 	addOffset('hairBlow', 45, -8);
			// 	addOffset('hairFall', 0, -9);

			// 	addOffset('scared', -2, -17);

			// 	playAnim('danceRight');

			// case 'gf-car':
			// 	tex = FlxAtlasFrames.fromSparrow('assets/images/gfCar.png', 'assets/images/gfCar.xml');
			// 	frames = tex;
			// 	animation.addByIndices('singUP', 'GF Dancing Beat Hair blowing CAR', [0], "", 24, false);
			// 	animation.addByIndices('danceLeft', 'GF Dancing Beat Hair blowing CAR', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
			// 	animation.addByIndices('danceRight', 'GF Dancing Beat Hair blowing CAR', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24,
			// 		false);

			// 	addOffset('danceLeft', 0);
			// 	addOffset('danceRight', 0);

			// 	playAnim('danceRight');

			// case 'gf-pixel':
			// 	tex = FlxAtlasFrames.fromSparrow('assets/images/weeb/gfPixel.png', 'assets/images/weeb/gfPixel.xml');
			// 	frames = tex;
			// 	animation.addByIndices('singUP', 'GF IDLE', [2], "", 24, false);
			// 	animation.addByIndices('danceLeft', 'GF IDLE', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
			// 	animation.addByIndices('danceRight', 'GF IDLE', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);

			// 	addOffset('danceLeft', 0);
			// 	addOffset('danceRight', 0);

			// 	playAnim('danceRight');

			// 	setGraphicSize(Std.int(width * PlayState.daPixelZoom));
			// 	updateHitbox();
			// 	antialiasing = false;

			case 'dad':
				initialSpecial = 2;
				// DAD ANIMATION LOADING CODE
				tex = FlxAtlasFrames.fromSparrow('assets/images/DADDY_DEAREST.png', 'assets/images/DADDY_DEAREST.xml');
				frames = tex;
				animation.addByPrefix('idle', 'Dad idle dance', 24, false);
				animation.addByPrefix('singUP', 'Dad Sing Note UP', 24);
				animation.addByPrefix('singRIGHT', 'Dad Sing Note RIGHT', 24);
				animation.addByPrefix('singDOWN', 'Dad Sing Note DOWN', 24);
				animation.addByPrefix('singLEFT', 'Dad Sing Note LEFT', 24);

				addOffset('idle');
				addOffset("singUP", -9, 50);
				addOffset("singRIGHT", -4, 26);
				addOffset("singLEFT", -11, 10);
				addOffset("singDOWN", 2, -32);

				playAnim('idle');
			case 'spooky':
				initialSpecial = 2;
				tex = FlxAtlasFrames.fromSparrow('assets/images/spooky_kids_assets.png', 'assets/images/spooky_kids_assets.xml');
				frames = tex;
				animation.addByPrefix('singUP', 'spooky UP NOTE', 24, false);
				animation.addByPrefix('singDOWN', 'spooky DOWN note', 24, false);
				animation.addByPrefix('singLEFT', 'note sing left', 24, false);
				animation.addByPrefix('singRIGHT', 'spooky sing right', 24, false);
				animation.addByIndices('danceLeft', 'spooky dance idle', [0, 2, 6], "", 12, false);
				animation.addByIndices('danceRight', 'spooky dance idle', [8, 10, 12, 14], "", 12, false);

				addOffset('danceLeft');
				addOffset('danceRight');

				addOffset("singUP", -18, 25);
				addOffset("singRIGHT", -130, -14);
				addOffset("singLEFT", 124, -13);
				addOffset("singDOWN", -46, -144);

				playAnim('danceRight');
			case 'mom':
				initialSpecial = 3;
				tex = FlxAtlasFrames.fromSparrow('assets/images/Mom_Assets.png', 'assets/images/Mom_Assets.xml');
				frames = tex;

				animation.addByPrefix('idle', "Mom Idle", 24, false);
				animation.addByPrefix('singUP', "Mom Up Pose", 24, false);
				animation.addByPrefix('singDOWN', "MOM DOWN POSE", 24, false);
				animation.addByPrefix('singLEFT', 'Mom Left Pose', 24, false);
				// ANIMATION IS CALLED MOM LEFT POSE BUT ITS FOR THE RIGHT
				// CUZ DAVE IS DUMB!
				animation.addByPrefix('singRIGHT', 'Mom Pose Left', 24, false);

				addOffset('idle');
				addOffset("singUP", -1, 81);
				addOffset("singRIGHT", 21, -54);
				addOffset("singLEFT", 250, -23);
				addOffset("singDOWN", 20, -157);

				playAnim('idle');

			// case 'mom-car':
			// 	tex = FlxAtlasFrames.fromSparrow('assets/images/momCar.png', 'assets/images/momCar.xml');
			// 	frames = tex;

			// 	animation.addByPrefix('idle', "Mom Idle", 24, false);
			// 	animation.addByPrefix('singUP', "Mom Up Pose", 24, false);
			// 	animation.addByPrefix('singDOWN', "MOM DOWN POSE", 24, false);
			// 	animation.addByPrefix('singLEFT', 'Mom Left Pose', 24, false);
			// 	// ANIMATION IS CALLED MOM LEFT POSE BUT ITS FOR THE RIGHT
			// 	// CUZ DAVE IS DUMB!
			// 	animation.addByPrefix('singRIGHT', 'Mom Pose Left', 24, false);

			// 	addOffset('idle');
			// 	addOffset("singUP", -1, 81);
			// 	addOffset("singRIGHT", 21, -54);
			// 	addOffset("singLEFT", 250, -23);
			// 	addOffset("singDOWN", 20, -157);

			// 	playAnim('idle');
			// case 'monster':
			// 	tex = FlxAtlasFrames.fromSparrow('assets/images/Monster_Assets.png', 'assets/images/Monster_Assets.xml');
			// 	frames = tex;
			// 	animation.addByPrefix('idle', 'monster idle', 24, false);
			// 	animation.addByPrefix('singUP', 'monster up note', 24, false);
			// 	animation.addByPrefix('singDOWN', 'monster down', 24, false);
			// 	animation.addByPrefix('singLEFT', 'Monster left note', 24, false);
			// 	animation.addByPrefix('singRIGHT', 'Monster Right note', 24, false);

			// 	addOffset('idle');
			// 	addOffset("singUP", -23, 87);
			// 	addOffset("singRIGHT", -51, 15);
			// 	addOffset("singLEFT", -31, 4);
			// 	addOffset("singDOWN", -63, -86);
			// 	playAnim('idle');
			// case 'monster-christmas':
			// 	tex = FlxAtlasFrames.fromSparrow('assets/images/christmas/monsterChristmas.png', 'assets/images/christmas/monsterChristmas.xml');
			// 	frames = tex;
			// 	animation.addByPrefix('idle', 'monster idle', 24, false);
			// 	animation.addByPrefix('singUP', 'monster up note', 24, false);
			// 	animation.addByPrefix('singDOWN', 'monster down', 24, false);
			// 	animation.addByPrefix('singLEFT', 'Monster left note', 24, false);
			// 	animation.addByPrefix('singRIGHT', 'Monster Right note', 24, false);

			// 	addOffset('idle');
			// 	addOffset("singUP", -21, 53);
			// 	addOffset("singRIGHT", -51, 10);
			// 	addOffset("singLEFT", -30, 7);
			// 	addOffset("singDOWN", -52, -91);
			// 	playAnim('idle');
			case 'pico':
				initialSpecial = 3;
				noPitching = true;
				initFacing = FlxObject.LEFT;
				tex = FlxAtlasFrames.fromSparrow('assets/images/Pico_FNF_assetss.png', 'assets/images/Pico_FNF_assetss.xml');
				frames = tex;
				animation.addByPrefix('idle', "Pico Idle Dance", 24, false);
				animation.addByPrefix('singUP', 'pico Up note0', 24, false);
				animation.addByPrefix('singDOWN', 'Pico Down Note0', 24, false);
				animation.addByPrefix('singLEFT', 'Pico NOTE LEFT0', 24, false);
				animation.addByPrefix('singRIGHT', 'Pico Note Right0', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'Pico Note Right Miss', 24, false);
				animation.addByPrefix('singLEFTmiss', 'Pico NOTE LEFT miss', 24, false);
				animation.addByPrefix('singUPmiss', 'pico Up note miss', 24, false);
				animation.addByPrefix('singDOWNmiss', 'Pico Down Note MISS', 24, false);

				addOffset('idle');
				addOffset("singUP", 26, 29);
				addOffset("singLEFT", 85, -11);
				addOffset("singRIGHT", -45, 2);
				addOffset("singDOWN", 114, -76);
				addOffset("singUPmiss", 32, 67);
				addOffset("singLEFTmiss", 85, 28);
				addOffset("singRIGHTmiss", -30, 50);
				addOffset("singDOWNmiss", 116, -34);

				playAnim('idle');

			// flipX = true;

			case 'bf':
				initialSpecial = 3;
				var tex = FlxAtlasFrames.fromSparrow('assets/images/BOYFRIEND.png', 'assets/images/BOYFRIEND.xml');
				frames = tex;
				initFacing = FlxObject.LEFT;
				animation.addByPrefix('idle', 'BF idle dance', 24, false);
				animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);
				animation.addByPrefix('singLEFT', 'BF NOTE LEFT0', 24, false);
				animation.addByPrefix('singRIGHT', 'BF NOTE RIGHT0', 24, false);
				animation.addByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);
				animation.addByPrefix('singUPmiss', 'BF NOTE UP MISS', 24, false);
				animation.addByPrefix('singLEFTmiss', 'BF NOTE LEFT MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BF NOTE RIGHT MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BF NOTE DOWN MISS', 24, false);
				animation.addByPrefix('hey', 'BF HEY', 24, false);
				animation.addByPrefix('attack', 'boyfriend attack', 24, false);
				animation.addByPrefix('hit', 'BF hit', 24, false);

				animation.addByPrefix('firstDeath', "BF dies", 24, false);
				animation.addByPrefix('deathLoop', "BF Dead Loop", 24, true);
				animation.addByPrefix('deathConfirm', "BF Dead confirm", 24, false);

				animation.addByPrefix('scared', 'BF idle shaking', 24);

				addOffset('idle', -5);
				addOffset("singUP", -29, 27);
				addOffset("singRIGHT", -38, -7);
				addOffset("singLEFT", 12, -6);
				addOffset("singDOWN", -10, -50);
				addOffset("singUPmiss", -29, 27);
				addOffset("singRIGHTmiss", -30, 21);
				addOffset("singLEFTmiss", 12, 24);
				addOffset("singDOWNmiss", -11, -19);
				addOffset("hey", 7, 4);
				addOffset('firstDeath', 37, 11);
				addOffset('deathLoop', 37, 5);
				addOffset('deathConfirm', 37, 69);
				addOffset('scared', -4);

				playAnim('idle');

			// flipX = true;

			// case 'bf-christmas':
			// 	var tex = FlxAtlasFrames.fromSparrow('assets/images/christmas/bfChristmas.png', 'assets/images/christmas/bfChristmas.xml');
			// 	frames = tex;
			// 	animation.addByPrefix('idle', 'BF idle dance', 24, false);
			// 	animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);
			// 	animation.addByPrefix('singLEFT', 'BF NOTE LEFT0', 24, false);
			// 	animation.addByPrefix('singRIGHT', 'BF NOTE RIGHT0', 24, false);
			// 	animation.addByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);
			// 	animation.addByPrefix('singUPmiss', 'BF NOTE UP MISS', 24, false);
			// 	animation.addByPrefix('singLEFTmiss', 'BF NOTE LEFT MISS', 24, false);
			// 	animation.addByPrefix('singRIGHTmiss', 'BF NOTE RIGHT MISS', 24, false);
			// 	animation.addByPrefix('singDOWNmiss', 'BF NOTE DOWN MISS', 24, false);
			// 	animation.addByPrefix('hey', 'BF HEY', 24, false);

			// 	addOffset('idle', -5);
			// 	addOffset("singUP", -29, 27);
			// 	addOffset("singRIGHT", -38, -7);
			// 	addOffset("singLEFT", 12, -6);
			// 	addOffset("singDOWN", -10, -50);
			// 	addOffset("singUPmiss", -29, 27);
			// 	addOffset("singRIGHTmiss", -30, 21);
			// 	addOffset("singLEFTmiss", 12, 24);
			// 	addOffset("singDOWNmiss", -11, -19);
			// 	addOffset("hey", 7, 4);

			// 	playAnim('idle');

			// // flipX = true;
			// case 'bf-car':
			// 	var tex = FlxAtlasFrames.fromSparrow('assets/images/bfCar.png', 'assets/images/bfCar.xml');
			// 	frames = tex;
			// 	animation.addByPrefix('idle', 'BF idle dance', 24, false);
			// 	animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);
			// 	animation.addByPrefix('singLEFT', 'BF NOTE LEFT0', 24, false);
			// 	animation.addByPrefix('singRIGHT', 'BF NOTE RIGHT0', 24, false);
			// 	animation.addByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);
			// 	animation.addByPrefix('singUPmiss', 'BF NOTE UP MISS', 24, false);
			// 	animation.addByPrefix('singLEFTmiss', 'BF NOTE LEFT MISS', 24, false);
			// 	animation.addByPrefix('singRIGHTmiss', 'BF NOTE RIGHT MISS', 24, false);
			// 	animation.addByPrefix('singDOWNmiss', 'BF NOTE DOWN MISS', 24, false);

			// 	addOffset('idle', -5);
			// 	addOffset("singUP", -29, 27);
			// 	addOffset("singRIGHT", -38, -7);
			// 	addOffset("singLEFT", 12, -6);
			// 	addOffset("singDOWN", -10, -50);
			// 	addOffset("singUPmiss", -29, 27);
			// 	addOffset("singRIGHTmiss", -30, 21);
			// 	addOffset("singLEFTmiss", 12, 24);
			// 	addOffset("singDOWNmiss", -11, -19);
			// 	playAnim('idle');

			// // flipX = true;
			// case 'bf-pixel':
			// 	frames = FlxAtlasFrames.fromSparrow('assets/images/weeb/bfPixel.png', 'assets/images/weeb/bfPixel.xml');
			// 	animation.addByPrefix('idle', 'BF IDLE', 24, false);
			// 	animation.addByPrefix('singUP', 'BF UP NOTE', 24, false);
			// 	animation.addByPrefix('singLEFT', 'BF LEFT NOTE', 24, false);
			// 	animation.addByPrefix('singRIGHT', 'BF RIGHT NOTE', 24, false);
			// 	animation.addByPrefix('singDOWN', 'BF DOWN NOTE', 24, false);
			// 	animation.addByPrefix('singUPmiss', 'BF UP MISS', 24, false);
			// 	animation.addByPrefix('singLEFTmiss', 'BF LEFT MISS', 24, false);
			// 	animation.addByPrefix('singRIGHTmiss', 'BF RIGHT MISS', 24, false);
			// 	animation.addByPrefix('singDOWNmiss', 'BF DOWN MISS', 24, false);

			// 	addOffset('idle');
			// 	addOffset("singUP", -6);
			// 	addOffset("singRIGHT");
			// 	addOffset("singLEFT", -12);
			// 	addOffset("singDOWN");
			// 	addOffset("singUPmiss", -6);
			// 	addOffset("singRIGHTmiss");
			// 	addOffset("singLEFTmiss", -12);
			// 	addOffset("singDOWNmiss");

			// 	setGraphicSize(Std.int(width * 6));
			// 	updateHitbox();

			// 	playAnim('idle');

			// 	width -= 100;
			// 	height -= 100;

			// 	antialiasing = false;

			// // flipX = true;
			// case 'bf-pixel-dead':
			// 	frames = FlxAtlasFrames.fromSparrow('assets/images/weeb/bfPixelsDEAD.png', 'assets/images/weeb/bfPixelsDEAD.xml');
			// 	animation.addByPrefix('singUP', "BF Dies pixel", 24, false);
			// 	animation.addByPrefix('firstDeath', "BF Dies pixel", 24, false);
			// 	animation.addByPrefix('deathLoop', "Retry Loop", 24, true);
			// 	animation.addByPrefix('deathConfirm', "RETRY CONFIRM", 24, false);
			// 	animation.play('firstDeath');

			// 	addOffset('firstDeath');
			// 	addOffset('deathLoop', -36);
			// 	addOffset('deathConfirm', -36);
			// 	playAnim('firstDeath');
			// 	// pixel bullshit
			// 	setGraphicSize(Std.int(width * 6));
			// 	updateHitbox();
			// 	antialiasing = false;
			// // flipX = true;

			case 'senpai':
				initialSpecial = 3;
				frames = FlxAtlasFrames.fromSparrow('assets/images/weeb/senpai.png', 'assets/images/weeb/senpai.xml');
				animation.addByPrefix('idle', 'Senpai Idle', 24, false);
				animation.addByPrefix('singUP', 'SENPAI UP NOTE', 24, false);
				animation.addByPrefix('singLEFT', 'SENPAI LEFT NOTE', 24, false);
				animation.addByPrefix('singRIGHT', 'SENPAI RIGHT NOTE', 24, false);
				animation.addByPrefix('singDOWN', 'SENPAI DOWN NOTE', 24, false);
				animation.addByPrefix('singUPmiss', 'Angry Senpai UP NOTE', 24, false);
				animation.addByPrefix('singLEFTmiss', 'Angry Senpai LEFT NOTE', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'Angry Senpai RIGHT NOTE', 24, false);
				animation.addByPrefix('singDOWNmiss', 'Angry Senpai DOWN NOTE', 24, false);
				animation.addByPrefix('hit', 'Angry Senpai Idle', 24, false);

				addOffset('idle');
				addOffset("singUP", 12, 36);
				addOffset("singRIGHT", 6);
				addOffset("singLEFT", 30);
				addOffset("singDOWN", 12);
				addOffset("singUPmiss", 6, 36);
				addOffset("singRIGHTmiss");
				addOffset("singLEFTmiss", 24, 6);
				addOffset("singDOWNmiss", 6, 6);
				addOffset('hit');

				playAnim('idle');

				setGraphicSize(Std.int(width * 6));
				updateHitbox();

				antialiasing = false;
				// case 'senpai-angry':
				// 	frames = FlxAtlasFrames.fromSparrow('assets/images/weeb/senpai.png', 'assets/images/weeb/senpai.xml');
				// 	animation.addByPrefix('idle', 'Angry Senpai Idle', 24, false);
				// 	animation.addByPrefix('singUP', 'Angry Senpai UP NOTE', 24, false);
				// 	animation.addByPrefix('singLEFT', 'Angry Senpai LEFT NOTE', 24, false);
				// 	animation.addByPrefix('singRIGHT', 'Angry Senpai RIGHT NOTE', 24, false);
				// 	animation.addByPrefix('singDOWN', 'Angry Senpai DOWN NOTE', 24, false);

				// 	addOffset('idle');
				// 	addOffset("singUP", 6, 36);
				// 	addOffset("singRIGHT");
				// 	addOffset("singLEFT", 24, 6);
				// 	addOffset("singDOWN", 6, 6);
				// 	playAnim('idle');

				// 	setGraphicSize(Std.int(width * 6));
				// 	updateHitbox();

				// 	antialiasing = false;

				// case 'spirit':
				// 	frames = FlxAtlasFrames.fromSpriteSheetPacker('assets/images/weeb/spirit.png', 'assets/images/weeb/spirit.txt');
				// 	animation.addByPrefix('idle', "idle spirit_", 24, false);
				// 	animation.addByPrefix('singUP', "up_", 24, false);
				// 	animation.addByPrefix('singRIGHT', "right_", 24, false);
				// 	animation.addByPrefix('singLEFT', "left_", 24, false);
				// 	animation.addByPrefix('singDOWN', "spirit down_", 24, false);

				// 	addOffset('idle', -220, -280);
				// 	addOffset('singUP', -220, -238);
				// 	addOffset("singRIGHT", -220, -280);
				// 	addOffset("singLEFT", -202, -280);
				// 	addOffset("singDOWN", 170, 110);

				// 	setGraphicSize(Std.int(width * 6));
				// 	updateHitbox();

				// 	playAnim('idle');

				// 	antialiasing = false;

				// case 'parents-christmas':
				// 	frames = FlxAtlasFrames.fromSparrow('assets/images/christmas/mom_dad_christmas_assets.png',
				// 		'assets/images/christmas/mom_dad_christmas_assets.xml');
				// 	animation.addByPrefix('idle', 'Parent Christmas Idle', 24, false);
				// 	animation.addByPrefix('singUP', 'Parent Up Note Dad', 24, false);
				// 	animation.addByPrefix('singDOWN', 'Parent Down Note Dad', 24, false);
				// 	animation.addByPrefix('singLEFT', 'Parent Left Note Dad', 24, false);
				// 	animation.addByPrefix('singRIGHT', 'Parent Right Note Dad', 24, false);

				// 	animation.addByPrefix('singUP-alt', 'Parent Up Note Mom', 24, false);

				// 	animation.addByPrefix('singDOWN-alt', 'Parent Down Note Mom', 24, false);
				// 	animation.addByPrefix('singLEFT-alt', 'Parent Left Note Mom', 24, false);
				// 	animation.addByPrefix('singRIGHT-alt', 'Parent Right Note Mom', 24, false);

				// 	addOffset('idle');
				// 	addOffset("singUP", -47, 24);
				// 	addOffset("singRIGHT", -1, -23);
				// 	addOffset("singLEFT", -30, 16);
				// 	addOffset("singDOWN", -31, -29);
				// 	addOffset("singUP-alt", -47, 24);
				// 	addOffset("singRIGHT-alt", -1, -24);
				// 	addOffset("singLEFT-alt", -30, 15);
				// 	addOffset("singDOWN-alt", -30, -27);

				// 	playAnim('idle');
		}

		initWidth = frameWidth;
		setFacingFlip((initFacing == FlxObject.LEFT ? FlxObject.RIGHT : FlxObject.LEFT), true, false);

		dance();

		if (isPlayer)
		{
			// flipX = !flipX;
			facing = FlxObject.LEFT;
		}
		else
			facing = FlxObject.RIGHT;

		if (!isModel && initFacing != facing)
		{
			// var animArray
			if (animation.getByName('singRIGHT') != null)
			{
				var oldRight = animation.getByName('singRIGHT').frames;
				var oldOffset = animOffsets['singRIGHT'];
				animation.getByName('singRIGHT').frames = animation.getByName('singLEFT').frames;
				animOffsets['singRIGHT'] = animOffsets['singLEFT'];
				animation.getByName('singLEFT').frames = oldRight;
				animOffsets['singLEFT'] = oldOffset;
			}

			// IF THEY HAVE MISS ANIMATIONS??
			if (animation.getByName('singRIGHTmiss') != null)
			{
				var oldMiss = animation.getByName('singRIGHTmiss').frames;
				var oldOffset = animOffsets['singRIGHTmiss'];
				animation.getByName('singRIGHTmiss').frames = animation.getByName('singLEFTmiss').frames;
				animOffsets['singRIGHTmiss'] = animOffsets['singLEFTmiss'];
				animation.getByName('singLEFTmiss').frames = oldMiss;
				animOffsets['singLEFTmiss'] = oldOffset;
			}

			if (animation.getByName('singRIGHT-alt') != null)
			{
				var oldRight = animation.getByName('singRIGHT-alt').frames;
				var oldOffset = animOffsets['singRIGHT-alt'];
				animation.getByName('singRIGHT-alt').frames = animation.getByName('singLEFT-alt').frames;
				animOffsets['singRIGHT-alt'] = animOffsets['singLEFT-alt'];
				animation.getByName('singLEFT-alt').frames = oldRight;
				animOffsets['singLEFT-alt'] = oldOffset;
			}
		}

		animation.finishCallback = animationEnd;
	}

	override function update(elapsed:Float)
	{
		if (!isPlayer && !isModel && curCharacter != 'nothing')
		{
			if (animation.curAnim.name.startsWith('sing'))
			{
				holdTimer += elapsed;
			}

			var dadVar:Float = 4;

			if (curCharacter == 'dad')
				dadVar = 6.1;
			if (holdTimer >= Conductor.stepCrochet * dadVar * 0.001)
			{
				idleEnd();
				holdTimer = 0;
			}
		}
		else if (!isPlayer && isModel)
		{
			if (model.currentAnim.startsWith('sing'))
			{
				holdTimer += elapsed;
			}

			var dadVar:Float = 4;

			if (curCharacter == 'dad')
				dadVar = 6.1;
			if (holdTimer >= Conductor.stepCrochet * dadVar * 0.001)
			{
				idleEnd();
				holdTimer = 0;
			}
		}

		switch (curCharacter)
		{
			case 'gf':
				if (animation.curAnim.name == 'hairFall' && animation.curAnim.finished)
					playAnim('danceRight');
		}

		super.update(elapsed);

		if (isModel)
		{
			if (spinYaw)
			{
				model.addYaw(elapsed * spinYawVal);
			}

			if (spinPitch)
			{
				model.addPitch(elapsed * spinPitchVal);
			}

			if (spinRoll)
			{
				model.addRoll(elapsed * spinRollVal);
			}
		}
	}

	private var danced:Bool = false;

	/**
	 * FOR GF DANCING SHIT
	 */
	public function dance(?ignoreDebug:Bool = false)
	{
		if (!debugMode || ignoreDebug)
		{
			switch (curCharacter)
			{
				case 'gf' | 'gf-car' | 'gf-christmas' | 'gf-pixel':
					if (!animation.curAnim.name.startsWith('hair'))
					{
						danced = !danced;

						if (danced)
							playAnim('danceRight', true);
						else
							playAnim('danceLeft', true);
					}

				case 'spooky':
					danced = !danced;

					if (danced)
						playAnim('danceRight', true);
					else
						playAnim('danceLeft', true);
				default:
					if (holdTimer == 0 && !isModel)
						playAnim('idle', true);
			}
		}
	}

	public function idleEnd(?ignoreDebug:Bool = false)
	{
		if (!isModel && (!debugMode || ignoreDebug))
		{
			switch (curCharacter)
			{
				case 'gf' | 'gf-car' | 'gf-christmas' | 'gf-pixel' | "spooky":
					playAnim('danceRight', true, false, animation.getByName('danceRight').numFrames - 1);
				default:
					playAnim('idle', true, false, animation.getByName('idle').numFrames - 1);
			}
		}
		else if (isModel && (!debugMode || ignoreDebug))
		{
			playAnim('idle');
		}
	}

	public function playAnim(AnimName:String, Force:Bool = false, Reversed:Bool = false, Frame:Int = 0):Void
	{
		if (curCharacter == 'nothing')
			return;

		if (isModel)
		{
			model.playAnim(AnimName);
		}
		else
		{
			var daAnim:String = AnimName;

			if (AnimName.endsWith('miss') && animation.getByName(AnimName) == null)
			{
				daAnim = AnimName.substring(0, AnimName.length - 4);
				color = 0x5462bf;
			}
			else
				color = 0xffffff;

			animation.play(daAnim, Force, Reversed, Frame);

			var daOffset = animOffsets.get(animation.curAnim.name);
			if (animOffsets.exists(animation.curAnim.name))
			{
				offset.set((facing != initFacing ? -1 : 1) * daOffset[0] + (facing != initFacing ? frameWidth - initWidth : 0), daOffset[1]);
			}
			else
				offset.set(0, 0);

			if (curCharacter == 'gf')
			{
				if (daAnim == 'singLEFT')
				{
					danced = true;
				}
				else if (daAnim == 'singRIGHT')
				{
					danced = false;
				}

				if (daAnim == 'singUP' || daAnim == 'singDOWN')
				{
					danced = !danced;
				}
			}
		}
	}

	public function addOffset(name:String, x:Float = 0, y:Float = 0)
	{
		animOffsets[name] = [x, y];
	}

	function animationEnd(name:String)
	{
		switch (curCharacter)
		{
			case "mom-car":
				switch (name)
				{
					case "idle":
						playAnim(name, false, false, 8);
					case "singUP":
						playAnim(name, false, false, 4);
					case "singDOWN":
						playAnim(name, false, false, 4);
					case "singLEFT":
						playAnim(name, false, false, 2);
					case "singRIGHT":
						playAnim(name, false, false, 2);
				}

			case "bf-car":
				switch (name)
				{
					case "idle":
						playAnim(name, false, false, 8);
					case "singUP":
						playAnim(name, false, false, 3);
					case "singDOWN":
						playAnim(name, false, false, 2);
					case "singLEFT":
						playAnim(name, false, false, 4);
					case "singRIGHT":
						playAnim(name, false, false, 2);
				}

			case "monster-christmas" | "monster":
				switch (name)
				{
					case "idle":
						playAnim(name, false, false, 10);
					case "singUP":
						playAnim(name, false, false, 8);
					case "singDOWN":
						playAnim(name, false, false, 7);
					case "singLEFT":
						playAnim(name, false, false, 5);
					case "singRIGHT":
						playAnim(name, false, false, 6);
				}
		}
	}

	public function getHit(dmg:Float)
	{
		if (isPlayer)
		{
			healthToAdd -= dmg;
			if (!noHitIncrement)
				PlayState.hits++;
		}
		else
			healthToAdd += dmg;
		if (animation.getByName('hit') != null)
			playAnim('hit', true);
		else if (animation.getByName('scared') != null)
			playAnim('scared', true);
		hitSound.play(true);
	}

	override public function destroy()
	{
		FlxDestroyUtil.destroy(hitSound);
		super.destroy();
	}
}
