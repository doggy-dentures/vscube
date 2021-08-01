![](/art/readme/logo.png)

# You'll need this:
`haxelib install away3d`

*Finally, it's open source.*

# Friday Night Funkin' FPS Plus
Friday Night Funkin' FPS Plus is a mod of Friday Night Funkin' that aims to improve gameplay and add quality of life features.

*You can find the original game here:* **[Newgrounds](https://www.newgrounds.com/portal/view/770371) - [itch.io](https://ninja-muffin24.itch.io/funkin) - [GitHub](https://github.com/ninjamuffin99/Funkin)**

## Features

### Increased FPS
The orignal purpose of FPS Plus. The game has an increased framerate over the base game and even an option for a completely uncapped framerate.

### Better Input
Adjusts how the game handles input allowing you to hit notes more consistently.

This also changes held notes so that they disappear if released to early.

### Fully Rebindable Keys
So that you can use whatever wacky control scheme you come up with. Or you could just be boring and use DFJK. That works too...

### Improved Chart Editor
FPS Plus contains a modified chart editor that has more utility features and is way more user friendly.

### Improved Animation Debug
The animation debug has been adjusted to make editing offsets way easier and faster while requiring less guess work.

### Downscroll
Notes appear from the top of the screen instead of the bottom. This make help some people read patterns more easily.

### Improved Health Icons
Adjusted some of the health icons and adds winning icons.

## Building
- For build intructions, follow the guide on the Funkin github page [here](https://github.com/ninjamuffin99/Funkin#build-instructions).

    - You do not need to install polymod since FPS Plus doesn't use it.
    
    - You can ignore is the part about ignored files since FPS Plus removes them.

- You'll also want to follow the instructions for haxeflixel video [here](https://github.com/GrowtopiaFli/openfl-haxeflixel-video-code).

    - But instead, install my fork of the webm extension with this: 

    - `haxelib git extension-webm https://github.com/ThatRozebudDude/extension-webm`

    - \(All my fork does is allow you to changing the max amount of frameskip.\)

    - Alternatively if the fork isn't working, you can just delete this line in Main.hx

        - `WebmPlayer.SKIP_STEP_LIMIT = 90;`

## Credits
### Friday Night Funkin'
- [ninjamuffin99](https://twitter.com/ninja_muffin99) - Programmer
- [PhantomArcade3K](https://twitter.com/phantomarcade3k) and [Evilsk8r](https://twitter.com/evilsk8r) - Art
- [Kawaisprite](https://twitter.com/kawaisprite) - Musician

### FPS Plus
- [Rozebud](https://twitter.com/helpme_thebigt) - *Everything*

### Shoutouts
- [KadeDev](https://twitter.com/KadeDeveloper) - Occasional code advice. (Sometime I don't listen though...)
- [GWebDev](https://twitter.com/GFlipaclip) - Haxeflixel Video
- [Ethab Taxi](https://twitter.com/EthabTaxi) - He's just sorta chillin'.