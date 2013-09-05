package
{
    import flash.events.Event;
    import flash.utils.ByteArray;
    
    import durian.actSpr.structs.CACT;
    import durian.actTpc.ActTpcView;
    import durian.robotlegs.DurianBundle;
    
    import morn.core.handlers.Handler;
    import morn.core.managers.ResLoader;
    
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
            
            App.loader.loadAssets( ["assets/component.swf"] , new Handler( onLoadComplete ) );
        }
        
        protected function onLoadComplete():void
        {
            //            var defaultView:defaultViewUI = new defaultViewUI();
            //            addChild( defaultView );
            
            //            var testView:testViewUI = new testViewUI();
            //            addChild( testView );
            
            var assetList:Array = [];
            assetList.push( {url: ResTable.MONSTER_PORING_ACT, type:ResLoader.BYTE} );
            assetList.push( {url: ResTable.MONSTER_PORING_TPC, type:ResLoader.BYTE} );
            App.loader.loadAssets( assetList , new Handler( onAssetLoaded ) );
        }
        
        protected function onAssetLoaded():void
        {
            var data:ByteArray = App.loader.getResLoaded( ResTable.MONSTER_PORING_TPC );
            data.inflate();
            var len:int = data.readByte();
            len = data.readUnsignedInt();
            var textureData:ByteArray = new ByteArray();
            data.readBytes( textureData , 0,  len );
            len = data.readUnsignedInt();
            var atlasXml:XML = XML( decodeURI( data.readUTFBytes( len ) ) );
            textureMgr.getTextureAtlas( ResTable.MONSTER_PORING_TPC , textureData , atlasXml , onActTpcReady );
        }
        
        private function onActTpcReady( textureAtlas:TextureAtlas ):void
        {
            _viewList = new Vector.<ActTpcView>();
            
            var cact:CACT = new CACT( App.loader.getResLoaded( ResTable.MONSTER_PORING_ACT ) );
            
            var count:int = 0;
            while( count<250)
            {
                newActTpcView( cact , ResTable.MONSTER_PORING_TPC , textureAtlas );
                count++;
            }
        }
        
        private function newActTpcView( cact:CACT , resId:String , textureAtlas:TextureAtlas ):ActTpcView
        {
            var viewObj:ActTpcView = new ActTpcView();
            viewObj.initAct( cact );
            viewObj.initTpc( resId , textureAtlas );
            viewObj.counterTargetRate = 0.075;
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
                    _viewList[i].x = 50 + ( i % 25 ) * 35;
                    _viewList[i].y = 50 + int( i / 25 ) * 55;
                    _viewList[i].tick( delta );
                    i++;
                }
            }
            
            return delta;
        }
    }
}