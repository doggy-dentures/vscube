package;

// import webm.WebmPlayer;
import flixel.FlxGame;
import openfl.display.FPS;
import openfl.display.Sprite;

class Main extends Sprite
{
	public static var fpsDisplay:FPS;

	// #if web
	// 	var vHandler:VideoHandler;
	// #elseif desktop
	// 	var webmHandle:WebmHandler;
	// #end
	// public static var video:Bool = !Sys.args().contains("-novid");
	public static var preload:Bool = !Sys.args().contains("-nopreload");
	public static var modelView:ModelView;

	// public static var modelViewBF:ModelView;
	public static var characters:Array<String> = [];
	public static var characterNames:Array<String> = [];
	public static var characterSpecials:Array<String> = [];
	public static var characterCredits:Array<String> = [];

	public function new()
	{
		super();

		if (preload)
			addChild(new FlxGame(0, 0, Startup, 1, 144, 144, true));
		else
			addChild(new FlxGame(0, 0, TitleVidState, 1, 144, 144, true));

		#if !mobile
		fpsDisplay = new FPS(10, 3, 0xFFFFFF);
		fpsDisplay.visible = false;
		addChild(fpsDisplay);
		#end

		modelView = new ModelView();
		// modelViewBF = new ModelView();

		addCharacter("bf", "Boyfriend", "Health regen for 15 seconds");
		addCharacter("dad", "Daddy Dearest", "Role reversal for 13 seconds");
		addCharacter("spooky", "Skid & Pump", "Trick-or-treat: turn all projectiles into candy");
		addCharacter("pico", "Pico", "Destroy all hazards on-screen");
		addCharacter("mom", "Mommy Mearest", "Invincibility for 15 seconds");
		addCharacter("senpai", "Senpai", "Summon a random powerup");
		addCharacter("anders", "Anders", "Larger crosshair and bomb projectile immunity for 20 seconds", "Typic");
		addCharacter("salesman", "Door-to-Door Door Salesman", "Make it rain for 15 seconds", "Aurazona & Pizzapancakess_");
		addCharacter("minesweeper", "Minesweeper", "Summon a helping crosshair for 20 seconds", "TheMaurii");
		addCharacter("atlanta", "Atlanta", "Auto-hit notes for 20 seconds", "Ket_Overkill");
		addCharacter("cat", "Cat", "Slow down the song and projectiles for 25 seconds", "Sonivv");

		// if(video){
		// var ourSource:String = "assets/videos/DO NOT DELETE OR GAME WILL CRASH/dontDelete.webm";

		// #if web
		// var str1:String = "HTML CRAP";
		// vHandler = new VideoHandler();
		// vHandler.init1();
		// vHandler.video.name = str1;
		// addChild(vHandler.video);
		// vHandler.init2();
		// GlobalVideo.setVid(vHandler);
		// vHandler.source(ourSource);
		// #elseif desktop
		// WebmPlayer.SKIP_STEP_LIMIT = 90;
		// var str1:String = "WEBM SHIT";
		// webmHandle = new WebmHandler();
		// webmHandle.source(ourSource);
		// webmHandle.makePlayer();
		// webmHandle.webm.name = str1;
		// addChild(webmHandle.webm);
		// GlobalVideo.setWebm(webmHandle);
		// #end
		// }
	}

	public static function addCharacter(who:String, name:String, special:String, credit:String = "")
	{
		characters.push(who);
		characterNames.push(name);
		characterSpecials.push(special);
		characterCredits.push(credit);
	}
}
