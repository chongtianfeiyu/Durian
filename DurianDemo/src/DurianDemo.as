package
{
    import flash.events.Event;
    import flash.utils.ByteArray;
    
    import durian.actSpr.structs.CACT;
    import durian.actTpc.ActTpcView;
    import durian.robotlegs.DurianBundle;
    
    import morn.core.handlers.Handler;
    import morn.core.managers.ResLoader;
    
    import nochump.util.zip.ZipEntry;
    import nochump.util.zip.ZipFile;
    
    import robotlegs.bender.bundles.mvcs.MVCSBundle;
    import robotlegs.bender.extensions.contextView.ContextView;
    import robotlegs.bender.framework.impl.Context;
    
    import starling.textures.TextureAtlas;
    
    [SWF(width="960",height="640",frameRate="60",backgroundColor="#ffffff")]
    public class DurianDemo extends DurianMainSprite
    {
        protected var _viewList:Vector.<ActTpcView>;
        
        public function DurianDemo()
        {
            Config.GAME_FPS = 60;
            super();
        }
        
        override protected function onStarlingInitialized():void
        {
            _context = new Context()
                .install( MVCSBundle )
                .install( DurianBundle )
                .configure( new ContextView( this ) );
            _context.initialize( onContextInitialized );
        }
        
        override protected function onContextInitialized():void
        {
            super.onContextInitialized();
            
            App.loader.loadAssets( ["assets/component.swf" ] , new Handler( onLoadComplete ) );
        }
        
        protected function onLoadComplete():void
        {
            //            var defaultView:defaultViewUI = new defaultViewUI();
            //            addChild( defaultView );
            
            //            var testView:testViewUI = new testViewUI();
            //            addChild( testView );
            
            var assetList:Array = [];
            //            assetList.push( {url: ResTable.MONSTER_PORING_ACT, type:ResLoader.BYTE} );
            assetList.push( {url: ResTable.MONSTER_TEXTURE_001, type:ResLoader.BYTE} );
            assetList.push( {url: ResTable.MONSTER_ATLASXML_001, type:ResLoader.TXT} );
            assetList.push( {url: ResTable.ACT_ZIP, type:ResLoader.BYTE} );
            App.loader.loadAssets( assetList , new Handler( onAssetLoaded ) );
        }
        
        protected function onAssetLoaded():void
        {
            var data:ByteArray = App.loader.getResLoaded( ResTable.MONSTER_TEXTURE_001 );
            var atlasXml:XML = XML( App.loader.getResLoaded( ResTable.MONSTER_ATLASXML_001 ) );
            textureMgr.getTextureAtlas( ResTable.MONSTER_TEXTURE_001 , data , atlasXml , onActTpcReady );
        }
        
        private function onActTpcReady( textureAtlas:TextureAtlas ):void
        {
            _viewList = new Vector.<ActTpcView>();

            var cact:CACT;
            
            var actBytes:ByteArray = App.loader.getResLoaded( ResTable.ACT_ZIP );
            var zipFile:ZipFile = new ZipFile( actBytes );
            for ( var i:int = 0; i < zipFile.entries.length ;  i++) 
            {
                var entry:ZipEntry = zipFile.entries[i];
                if( entry.name == ResTable.MONSTER_PORING_ACT )
                {
                    var data:ByteArray = zipFile.getInput(entry);
                    cact = new CACT( data );
                    break;
                }
            }
            
            var count:int = 0;
            while( count < 100 )
            {
                newActTpcView( cact , ResTable.MONSTER_TEXTURE_001 , textureAtlas );
                count++;
            }
        }
        
        private function newActTpcView( cact:CACT , resId:String , textureAtlas:TextureAtlas ):ActTpcView
        {
            var monsterName:String = "poring_";
            monsterName = Math.random() > 0.5 ? "poporing_" : monsterName;
            monsterName = Math.random() > 0.6 ? "goldporing_" : monsterName;
            monsterName = Math.random() > 0.7 ? "em_deviling_" : monsterName;
            monsterName = Math.random() > 0.8 ? "heavy_metaling_" : monsterName;
            monsterName = Math.random() > 0.9 ? "magmaring_" : monsterName;
            monsterName = Math.random() > 0.9 ? "metaling_" : monsterName;
            monsterName = Math.random() > 0.9 ? "pouring_" : monsterName;
            
            var viewObj:ActTpcView = new ActTpcView( monsterName );
            viewObj.initAct( cact );
            viewObj.initTpc( resId , textureAtlas );
            viewObj.counterTargetRate = 0.15;
            viewObj.loop = true;
            viewObj.actionIndex = 8;
            _starlingMain.addChild( viewObj );
            _viewList.push( viewObj );
            return viewObj;
        }
        
        override protected function onEnterFrame(e:Event):Number
        {
            var delta:Number = super.onEnterFrame( e ); 
            
            if( _viewList )
            {
                var i:int = 0;
                while( i < _viewList.length )
                {
                    _viewList[i].x = 50 + ( i % 20 ) * 40;
                    _viewList[i].y = 50 + int( i / 20 ) * 40;
                    _viewList[i].tick( delta );
                    i++;
                }
            }
            
            return delta;
        }
    }
}