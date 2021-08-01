package;

import lime.utils.Assets;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.text.FlxTypeText;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxSpriteGroup;
import flixel.input.FlxKeyManager;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

using StringTools;

class DialogueBox extends FlxSpriteGroup
{
	var box:FlxSprite;

	var curCharacter:String = '';

	var dialogue:Alphabet;
	var dialogueList:Array<String> = [];

	// SECOND DIALOGUE FOR THE PIXEL SHIT INSTEAD???
	var swagDialogue:FlxTypeText;

	var dropText:FlxText;

	public var finishThing:Void->Void;

	// var portraitLeft:FlxSprite;
	// var portraitRight:FlxSprite;
	var handSelect:FlxSprite;
	var bgFade:FlxSprite;

	var portraits:Map<String, FlxSprite> = new Map<String, FlxSprite>();

	public function new(talkingRight:Bool = true, ?dialogueList:Array<String>)
	{
		super();

		switch (PlayState.SONG.song.toLowerCase())
		{
			case 'senpai':
				FlxG.sound.playMusic('assets/music/Lunchbox' + TitleState.soundExt, 0);
				FlxG.sound.music.fadeIn(1, 0, 0.8);
			case 'thorns':
				FlxG.sound.playMusic('assets/music/LunchboxScary' + TitleState.soundExt, 0);
				FlxG.sound.music.fadeIn(1, 0, 0.8);
		}

		bgFade = new FlxSprite(-200, -200).makeGraphic(Std.int(FlxG.width * 1.3), Std.int(FlxG.height * 1.3), 0xFFB3DFd8);
		bgFade.scrollFactor.set();
		bgFade.alpha = 0;
		add(bgFade);

		new FlxTimer().start(0.83, function(tmr:FlxTimer)
		{
			bgFade.alpha += (1 / 5) * 0.7;
			if (bgFade.alpha > 0.7)
				bgFade.alpha = 0.7;
		}, 5);

		// switch (PlayState.SONG.song.toLowerCase())
		// {
		// 	case 'senpai' | 'roses' | 'thorns':
		// 		portraitLeft = new FlxSprite(-20, 40);
		// 		portraitLeft.frames = FlxAtlasFrames.fromSparrow('assets/images/weeb/senpaiPortrait.png', 'assets/images/weeb/senpaiPortrait.xml');
		// 		portraitLeft.animation.addByPrefix('enter', 'Senpai Portrait Enter', 24, false);
		// 		portraitLeft.setGraphicSize(Std.int(portraitLeft.width * PlayState.daPixelZoom * 0.9));
		// 		portraitLeft.updateHitbox();
		// 		portraitLeft.scrollFactor.set();
		// 		add(portraitLeft);
		// 		portraitLeft.visible = false;

		// 		portraitRight = new FlxSprite(0, 40);
		// 		portraitRight.frames = FlxAtlasFrames.fromSparrow('assets/images/weeb/bfPortrait.png', 'assets/images/weeb/bfPortrait.xml');
		// 		portraitRight.animation.addByPrefix('enter', 'Boyfriend portrait enter', 24, false);
		// 		portraitRight.setGraphicSize(Std.int(portraitRight.width * PlayState.daPixelZoom * 0.9));
		// 		portraitRight.updateHitbox();
		// 		portraitRight.scrollFactor.set();
		// 		add(portraitRight);
		// 		portraitRight.visible = false;
		// 	case 'vertex' | 'mesh':
		// 		portraitLeft = new FlxSprite(0, 0);
		// 		portraitLeft.loadGraphic('assets/images/boxmonkey.png');
		// 		portraitLeft.scrollFactor.set();
		// 		add(portraitLeft);
		// 		portraitLeft.visible = false;

		// 		portraitRight = new FlxSprite(0, 0);
		// 		portraitRight.loadGraphic('assets/images/boxbf.png');
		// 		portraitRight.scrollFactor.set();
		// 		add(portraitRight);
		// 		portraitRight.visible = false;
		// 	case 'polygon':
		// 		portraitLeft = new FlxSprite(0, 0);
		// 		portraitLeft.loadGraphic('assets/images/boxmonkey.png');
		// 		portraitLeft.scrollFactor.set();
		// 		add(portraitLeft);
		// 		portraitLeft.visible = false;

		// 		portraitRight = new FlxSprite(0, 0);
		// 		portraitRight.loadGraphic('assets/images/boxbfpoly.png');
		// 		portraitRight.scrollFactor.set();
		// 		add(portraitRight);
		// 		portraitRight.visible = false;
		// 	default:
		// 		portraitLeft = new FlxSprite(-20, 40);
		// 		portraitLeft.frames = FlxAtlasFrames.fromSparrow('assets/images/weeb/senpaiPortrait.png', 'assets/images/weeb/senpaiPortrait.xml');
		// 		portraitLeft.animation.addByPrefix('enter', 'Senpai Portrait Enter', 24, false);
		// 		portraitLeft.setGraphicSize(Std.int(portraitLeft.width * PlayState.daPixelZoom * 0.9));
		// 		portraitLeft.updateHitbox();
		// 		portraitLeft.scrollFactor.set();
		// 		add(portraitLeft);
		// 		portraitLeft.visible = false;

		// 		portraitRight = new FlxSprite(0, 40);
		// 		portraitRight.frames = FlxAtlasFrames.fromSparrow('assets/images/weeb/bfPortrait.png', 'assets/images/weeb/bfPortrait.xml');
		// 		portraitRight.animation.addByPrefix('enter', 'Boyfriend portrait enter', 24, false);
		// 		portraitRight.setGraphicSize(Std.int(portraitRight.width * PlayState.daPixelZoom * 0.9));
		// 		portraitRight.updateHitbox();
		// 		portraitRight.scrollFactor.set();
		// 		add(portraitRight);
		// 		portraitRight.visible = false;
		// }

		for (name in ["cube", "round", "skid", "pump", "gf", "senpai-angry"])
		{
			var sprite = new FlxSprite();
			if (Assets.exists('assets/images/dialogue/' + name + '.png'))
				sprite.loadGraphic('assets/images/dialogue/' + name + '.png');
			else
				sprite.loadGraphic('assets/images/dialogue/test.png');
			sprite.scrollFactor.set();
			add(sprite);
			sprite.visible = false;
			sprite.antialiasing = true;
			portraits[name] = sprite;
		}

		for (name in Main.characters)
		{
			var sprite = new FlxSprite();
			if (Assets.exists('assets/images/dialogue/' + name + '.png'))
				sprite.loadGraphic('assets/images/dialogue/' + name + '.png');
			else
				sprite.loadGraphic('assets/images/dialogue/test.png');
			sprite.scrollFactor.set();
			add(sprite);
			sprite.visible = false;
			if (name != 'senpai')
				sprite.antialiasing = true;
			portraits[name] = sprite;
		}

		box = new FlxSprite(-20, 45);

		switch (PlayState.SONG.song.toLowerCase())
		{
			// case 'senpai':
			// 	box.frames = FlxAtlasFrames.fromSparrow('assets/images/weeb/pixelUI/dialogueBox-pixel.png',
			// 		'assets/images/weeb/pixelUI/dialogueBox-pixel.xml');
			// 	box.animation.addByPrefix('normalOpen', 'Text Box Appear', 24, false);
			// 	box.animation.addByIndices('normal', 'Text Box Appear', [4], "", 24);
			// 	box.animation.play('normalOpen');
			// 	box.setGraphicSize(Std.int(box.width * PlayState.daPixelZoom * 0.9));
			// 	box.updateHitbox();
			// case 'roses':
			// 	FlxG.sound.play('assets/sounds/ANGRY_TEXT_BOX' + TitleState.soundExt);

			// 	box.frames = FlxAtlasFrames.fromSparrow('assets/images/weeb/pixelUI/dialogueBox-senpaiMad.png',
			// 		'assets/images/weeb/pixelUI/dialogueBox-senpaiMad.xml');
			// 	box.animation.addByPrefix('normalOpen', 'SENPAI ANGRY IMPACT SPEECH', 24, false);
			// 	box.animation.addByIndices('normal', 'SENPAI ANGRY IMPACT SPEECH', [4], "", 24);
			// 	box.animation.play('normalOpen');
			// 	box.setGraphicSize(Std.int(box.width * PlayState.daPixelZoom * 0.9));
			// 	box.updateHitbox();
			// case 'thorns':
			// 	box.frames = FlxAtlasFrames.fromSparrow('assets/images/weeb/pixelUI/dialogueBox-evil.png', 'assets/images/weeb/pixelUI/dialogueBox-evil.xml');
			// 	box.animation.addByPrefix('normalOpen', 'Spirit Textbox spawn', 24, false);
			// 	box.animation.addByIndices('normal', 'Spirit Textbox spawn', [11], "", 24);

			// 	var face:FlxSprite = new FlxSprite(320, 170).loadGraphic('assets/images/weeb/spiritFaceForward.png');
			// 	face.setGraphicSize(Std.int(face.width * 6));
			// 	add(face);
			// 	box.animation.play('normalOpen');
			// 	box.setGraphicSize(Std.int(box.width * PlayState.daPixelZoom * 0.9));
			// 	box.updateHitbox();
			default:
				box.loadGraphic('assets/images/blenderbox.png');
				box.y = FlxG.height - box.height;
		}

		add(box);

		// handSelect = new FlxSprite(FlxG.width * 0.9, FlxG.height * 0.9).loadGraphic('assets/images/weeb/pixelUI/hand_textbox.png');
		// add(handSelect);

		box.screenCenter(X);
		// portraitLeft.screenCenter(X);

		if (!talkingRight)
		{
			// box.flipX = true;
		}

		dropText = new FlxText(242, 502, Std.int(FlxG.width * 0.6), "", 32);
		dropText.font = 'Pixel Arial 11 Bold';
		dropText.color = 0xFFD89494;
		add(dropText);

		swagDialogue = new FlxTypeText(240, 500, Std.int(FlxG.width * 0.6), "", 32);
		swagDialogue.font = 'Pixel Arial 11 Bold';
		swagDialogue.color = 0xFF3F2021;
		swagDialogue.sounds = [FlxG.sound.load('assets/sounds/pixelText' + TitleState.soundExt, 0.6)];
		add(swagDialogue);

		dialogue = new Alphabet(0, 80, "", false, true);
		// dialogue.x = 90;
		// add(dialogue);

		this.dialogueList = dialogueList;
	}

	var dialogueOpened:Bool = false;
	var dialogueStarted:Bool = false;

	override function update(elapsed:Float)
	{
		// HARD CODING CUZ IM STUPDI
		// if (PlayState.SONG.song.toLowerCase() == 'roses')
		// 	portraitLeft.visible = false;
		// if (PlayState.SONG.song.toLowerCase() == 'thorns')
		// {
		// 	portraitLeft.color = FlxColor.BLACK;
		// 	swagDialogue.color = FlxColor.WHITE;
		// 	dropText.color = FlxColor.BLACK;
		// }
		switch (PlayState.SONG.song.toLowerCase())
		{
			// case 'roses':
			// 	portraitLeft.visible = false;
			// case 'thorns':
			// 	portraitLeft.color = FlxColor.BLACK;
			// 	swagDialogue.color = FlxColor.WHITE;
			// 	dropText.color = FlxColor.BLACK;
			default:
				swagDialogue.color = FlxColor.WHITE;
				dropText.color = FlxColor.BLACK;
		}

		dropText.text = swagDialogue.text;

		if (box.animation.curAnim != null)
		{
			if (box.animation.curAnim.name == 'normalOpen' && box.animation.curAnim.finished)
			{
				box.animation.play('normal');
				dialogueOpened = true;
			}
		}
		else
			dialogueOpened = true;

		if (dialogueOpened && !dialogueStarted)
		{
			startDialogue();
			dialogueStarted = true;
		}

		if (FlxG.keys.justPressed.ANY)
		{
			remove(dialogue);

			FlxG.sound.play('assets/sounds/clickText' + TitleState.soundExt, 0.8);

			if (dialogueList[1] == null)
			{
				if (!isEnding)
				{
					isEnding = true;

					if (PlayState.SONG.song.toLowerCase() == 'senpai' || PlayState.SONG.song.toLowerCase() == 'thorns')
						FlxG.sound.music.fadeOut(2.2, 0);

					new FlxTimer().start(0.2, function(tmr:FlxTimer)
					{
						box.alpha -= 1 / 5;
						bgFade.alpha -= 1 / 5 * 0.7;
						// portraitLeft.visible = false;
						// portraitRight.visible = false;
						for (char in portraits)
						{
							char.visible = false;
						}
						swagDialogue.alpha -= 1 / 5;
						dropText.alpha = swagDialogue.alpha;
					}, 5);

					new FlxTimer().start(1.2, function(tmr:FlxTimer)
					{
						finishThing();
						kill();
					});
				}
			}
			else
			{
				dialogueList.remove(dialogueList[0]);
				startDialogue();
			}
		}

		super.update(elapsed);
	}

	var isEnding:Bool = false;

	function startDialogue():Void
	{
		cleanDialog();

		// var theDialog:Alphabet = new Alphabet(0, 70, dialogueList[0], false, true);
		// dialogue = theDialog;
		// add(theDialog);

		// swagDialogue.text = ;
		swagDialogue.resetText(dialogueList[0]);
		swagDialogue.start(0.04, true);

		// switch (curCharacter)
		// {
		// 	case 'dad':
		// 		portraitRight.visible = false;
		// 		if (!portraitLeft.visible)
		// 		{
		// 			portraitLeft.visible = true;
		// 			portraitLeft.animation.play('enter');
		// 		}
		// 	case 'bf':
		// 		portraitLeft.visible = false;
		// 		if (!portraitRight.visible)
		// 		{
		// 			portraitRight.visible = true;
		// 			portraitRight.animation.play('enter');
		// 		}
		// }
		for (char in portraits)
		{
			char.visible = false;
		}
		if (portraits[curCharacter] != null)
		{
			portraits[curCharacter].visible = true;
		}
	}

	function cleanDialog():Void
	{
		var splitName:Array<String> = dialogueList[0].split(":");
		curCharacter = splitName[1];
		dialogueList[0] = dialogueList[0].substr(splitName[1].length + 2).trim();
	}
}
