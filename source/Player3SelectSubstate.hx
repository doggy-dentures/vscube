package;

import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup;
import flixel.text.FlxText;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSubState;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;

class Player3SelectSubstate extends FlxSubState
{
	private var controls(get, never):Controls;

	inline function get_controls():Controls
		return PlayerSettings.player1.controls;

	public var finishThing:Void->Void;
	public var playerSelected:String = "boyfriend";

	var ui_tex:FlxAtlasFrames;

	var difficultySelectors:FlxGroup;
	// var sprDifficulty:FlxSprite;
	var leftArrow:FlxSprite;
	var rightArrow:FlxSprite;

	var selectedChar:Int = 0;

	var iconArray:Array<HealthIcon> = [];

	var charName:FlxText;
	// var charAbility:FlxText;
	var charCredit:FlxText;

	var eligibleCharacters = Main.characters.copy();
	var eligibleCharacterNames = Main.characterNames.copy();
	var eligibleCharacterSpecials = Main.characterSpecials.copy();
	var eligibleCharacterCredits = Main.characterCredits.copy();	

	var curBoyfriend:String;

	override public function new(boyfriend:String)
	{
		super();
		curBoyfriend = boyfriend;
	}

	override function create()
	{
		cameras = [FlxG.cameras.list[FlxG.cameras.list.length - 1]];
		var removeIndex = eligibleCharacters.indexOf(curBoyfriend);
		eligibleCharacters.remove(eligibleCharacters[removeIndex]);
		eligibleCharacterNames.remove(eligibleCharacterNames[removeIndex]);
		eligibleCharacterSpecials.remove(eligibleCharacterSpecials[removeIndex]);
		eligibleCharacterCredits.remove(eligibleCharacterCredits[removeIndex]);
		super.create();
		ui_tex = FlxAtlasFrames.fromSparrow('assets/images/campaign_menu_UI_assets.png', 'assets/images/campaign_menu_UI_assets.xml');
		var yellowBG:FlxSprite = new FlxSprite(0, 56).makeGraphic(FlxG.width, 400, 0xFFF9CF51);
		var blackBarThingie:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, 56, FlxColor.BLACK);
		add(blackBarThingie);
		difficultySelectors = new FlxGroup();
		leftArrow = new FlxSprite();
		leftArrow.frames = ui_tex;
		leftArrow.updateHitbox();
		leftArrow.y = (yellowBG.y + yellowBG.height / 2) - leftArrow.height / 2;
		leftArrow.animation.addByPrefix('idle', "arrow left");
		leftArrow.animation.addByPrefix('press', "arrow push left");
		leftArrow.animation.play('idle');
		difficultySelectors.add(leftArrow);
		rightArrow = new FlxSprite();
		rightArrow.frames = ui_tex;
		rightArrow.updateHitbox();
		rightArrow.y = (yellowBG.y + yellowBG.height / 2) - rightArrow.height / 2;
		rightArrow.x = FlxG.width - rightArrow.width * 0.25;
		rightArrow.animation.addByPrefix('idle', 'arrow right');
		rightArrow.animation.addByPrefix('press', "arrow push right", 24, false);
		rightArrow.animation.play('idle');
		difficultySelectors.add(rightArrow);
		add(yellowBG);
		add(difficultySelectors);

		var selectSomeone:FlxText = new FlxText(0, 0, 0, "Select a companion");
		selectSomeone.setFormat('VCR OSD Mono', 48);
		selectSomeone.screenCenter(X);
		selectSomeone.y = FlxG.height - selectSomeone.height - 10;
		add(selectSomeone);

		charName = new FlxText();
		charName.setFormat('VCR OSD Mono', 60, FlxColor.BLACK);
		charName.screenCenter(X);
		charName.y = yellowBG.y + 20;
		add(charName);

		// charAbility = new FlxText();
		// charAbility.setFormat(charAbility.font, 24, FlxColor.WHITE, CENTER);
		// charAbility.screenCenter(X);
		// charAbility.y = yellowBG.y + yellowBG.height + 20;
		// add(charAbility);

		charCredit = new FlxText();
		charCredit.setFormat('VCR OSD Mono', 22, FlxColor.BLACK);
		charCredit.y = yellowBG.y + yellowBG.height - charCredit.size - 5;
		charCredit.x = 5;
		add(charCredit);

		for (i in eligibleCharacters)
		{
			var icon:HealthIcon = new HealthIcon(i);
			iconArray.push(icon);
			icon.updateHitbox();
			icon.screenCenter(X);
			icon.y = (yellowBG.y + yellowBG.height / 2) - icon.height / 2;
			icon.visible = false;
			add(icon);
		}

		changeCharacter();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (!movedBack)
		{
			if (!selectedWeek)
			{
				// if (controls.UP_P)
				// {
				// 	changeWeek(-1);
				// }

				// if (controls.DOWN_P)
				// {
				// 	changeWeek(1);
				// }

				if (controls.RIGHT)
					rightArrow.animation.play('press')
				else
					rightArrow.animation.play('idle');

				if (controls.LEFT)
					leftArrow.animation.play('press');
				else
					leftArrow.animation.play('idle');

				if (controls.RIGHT_P)
					changeCharacter(1);
				if (controls.LEFT_P)
					changeCharacter(-1);
			}

			if (controls.ACCEPT)
			{
				selectWeek();
			}
		}
	}

	var movedBack:Bool = false;
	var selectedWeek:Bool = false;
	var stopspamming:Bool = false;

	function changeCharacter(dir:Int = 0)
	{
		FlxG.sound.play('assets/sounds/scrollMenu' + TitleState.soundExt);
		iconArray[selectedChar].visible = false;
		selectedChar += dir;
		if (selectedChar < 0)
			selectedChar = eligibleCharacters.length - 1;
		if (selectedChar >= eligibleCharacters.length)
			selectedChar = 0;
		iconArray[selectedChar].visible = true;
		charName.text = eligibleCharacterNames[selectedChar];
		charName.updateHitbox();
		charName.screenCenter(X);
		// charAbility.text = "Special Ability:\n";
		// charAbility.text += eligibleCharacterSpecials[selectedChar];
		// charAbility.updateHitbox();
		// charAbility.screenCenter(X);
		if (eligibleCharacterCredits[selectedChar] == "")
			charCredit.text = "";
		else
			charCredit.text = "ft. " + eligibleCharacterCredits[selectedChar];
	}

	function selectWeek()
	{
		if (stopspamming == false)
		{
			FlxG.sound.play('assets/sounds/confirmMenu' + TitleState.soundExt);
			cameras[0].flash();
			playerSelected = eligibleCharacters[selectedChar];

			// grpWeekText.members[curWeek].week.animation.resume();
			// grpWeekCharacters.members[1].animation.play('bfConfirm');
			stopspamming = true;

			selectedWeek = true;
			new FlxTimer().start(1, function(tmr:FlxTimer)
			{
				if (FlxG.sound.music != null)
					FlxG.sound.music.stop();
				if (finishThing != null)
					finishThing();
				close();
			});
		}
	}
}
