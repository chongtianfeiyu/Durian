Durian Engine
================================================

Durian Engine is a AS3 Game Engine supporting 2D GPU accelerated rendering and 3rd party library integration.

Fast build games:

* Tower defense [TD online demo](http://dly2005.com/roWeb/tdDemo/)

* ARPG ( working )

* RPG ( working )

* AVG ( working )

* SLG ( working )

Dependencies: 
-------------

* [Starling](https://github.com/PrimaryFeather/Starling-Framework)

* [Roboglegs](https://github.com/robotlegs/robotlegs-framework)

* [Feathers](https://github.com/joshtynjala/feathers)

* [MornUI](https://github.com/yungzhu/morn)

Durian(core)
------------

Supported res structs:

* actSpr ( RO act/spr bitmap animations )

* actTpc ( RO act/tpc texture animations )

Robotlegs extensions:

* DurianBundle:

  * DisplayMgrExtension

  * KeyMgrExtension

  * TextureMgrExtension
  
Durian Engine Struct

* Model View Controller

* Map Camera

Json configure
 
config.json

```javascript
{"config":[
    
]}
```
 
perload.json

```javascript
{"perload":[
    {"resId":"data/cursors.act"},
    {"resId":"data/cursors.tpc"}
]}
``` 

resource

```javascript
{"resource":[
    {"resId":"" , "path":""}
]}
```

ui.json

```javascript
{"ui":[
    { "defaultView":"" },
    { "loadingView":"" }
]}
```

character.json

job.json

skill.json

item.json

weapon.json

equip.json

monster.json

monsterGroup.json

buff.json

event.json

map.json

scene.json

npc.json

dialog.json

Durian Game Run:
----------------

new main sprite -> addToStage 

-> App.init , starling , enterFrame 

-> robotlegs context 
 
-> inject main sprite , load asset 

-> show defaultView

-> you game logic

extends main sprite:

`DurianDemo extends DurianMainSprite`

setup game fps rate:

```javascript
public function DurianDemo()
{
    Config.GAME_FPS = 60;
    super();
}
```

setup robotlegs extensions:

```javascript
override protected function onStarlingInitialized():void
{
    _context = new Context()
        .install( MVCSBundle )
        .install( DurianBundle )
        .configure( new ContextView( this ) );
    _context.initialize( onContextInitialized );
}
```

load ui assets:

```javascript
override protected function onContextInitialized():void
{
    super.onContextInitialized();
    App.loader.loadAssets( ["assets/component.swf"] , new Handler( onLoadComplete ) );
}
```

show default ui:

```javascript
protected function onLoadComplete():void
{
    var defaultView:defaultViewUI = new defaultViewUI();
    addChild( defaultView );
}
```

##Contact

Email: 234082230@qq.com

MSN: noahwang@live.cn

QQ: 234082230
