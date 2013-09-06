package
{
    import flash.display.BitmapData;
    import flash.display.BlendMode;
    import flash.geom.Vector3D;
    import flash.text.TextField;
    import flash.utils.ByteArray;
    
    import away3d.animators.ParticleAnimationSet;
    import away3d.animators.ParticleAnimator;
    import away3d.animators.data.ParticleProperties;
    import away3d.animators.data.ParticlePropertiesMode;
    import away3d.animators.nodes.ParticleBillboardNode;
    import away3d.animators.nodes.ParticleVelocityNode;
    import away3d.core.base.Geometry;
    import away3d.entities.Mesh;
    import away3d.entities.Sprite3D;
    import away3d.materials.TextureMaterial;
    import away3d.primitives.PlaneGeometry;
    import away3d.tools.helpers.ParticleGeometryHelper;
    import away3d.utils.Cast;
    
    import durian.actSpr.structs.CACT;
    import durian.actTpc.ActTpcView;
    import durian.interfaces.ITickable;
    import durian.robotlegs.DurianBundle;
    
    import morn.core.handlers.Handler;
    import morn.core.managers.ResLoader;
    
    import robotlegs.bender.bundles.mvcs.MVCSBundle;
    import robotlegs.bender.extensions.contextView.ContextView;
    import robotlegs.bender.framework.impl.Context;
    
    import starling.animation.IAnimatable;
    import starling.display.DisplayObject;
    import starling.textures.TextureAtlas;
    
    [SWF(width="960",height="640",frameRate="60",backgroundColor="#ffffff")]
    public class DurianDemo extends DurianMainSprite
    {
        protected var _viewList:Vector.<DisplayObject>;
        
        protected var _particleAnimationSet:ParticleAnimationSet;
        
        protected var _particleAnimator:ParticleAnimator;
        
        protected var _particleMesh:Mesh;
        
        [Embed(source="blue.png")]
        protected var ParticleImg:Class;
        
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
            _viewList = new Vector.<DisplayObject>();
            
            var actBytes:ByteArray = App.loader.getResLoaded( ResTable.ACT_ZIP );
            zipMgr.addZip( ResTable.ACT_ZIP , actBytes );
            
            var cact:CACT = new CACT( zipMgr.getFileFromZip( ResTable.ACT_ZIP , ResTable.MONSTER_PORING_ACT ));
            
            var count:int = 0;
            while( count < 200 )
            {
                newActTpcView( cact , ResTable.MONSTER_TEXTURE_001 , textureAtlas );
                count++;
            }
            
            //            var posList:Vector.<Point> = new Vector.<Point>();
            //            posList.push( new Point( 0 , 0 ) );
            //            posList.push( new Point( 20 , 0 ) );
            //            posList.push( new Point( 0 , 20 ) );
            //            posList.push( new Point( 20 , 20 ) );
            //            var aniDisplay:MultiAnimation = new MultiAnimation( Vector.<String>( ["poring_" , "poporing_" , "goldporing_" , "em_deviling_"] ) , posList );
            //            aniDisplay.updateAnimation( textureAtlas );
            //            _starlingMain.addChild( aniDisplay );
            //            _viewList.push( aniDisplay );
            
            //            initGround();
            //            initParticles();
        }
        
        private function initGround():void
        {
            var text:TextField = new TextField();  
            text.text = "怪物名字";  
            var textBmpData:BitmapData = new BitmapData(64,16);  
            textBmpData.draw(text);  
            var textMaterial:TextureMaterial = new TextureMaterial(Cast.bitmapTexture(textBmpData));  
            var sprite3D:Sprite3D = new Sprite3D(textMaterial,64,16);  
            sprite3D.y = 150;  
            sprite3D.scale(10);  
            _away3dView.scene.addChild(sprite3D);  
        }
        
        protected function initParticles():void
        {
            var plane:Geometry = new PlaneGeometry(10, 10, 1, 1, false);
            var geometrySet:Vector.<Geometry> = new Vector.<Geometry>();
            for (var i:int = 0; i < 20000; i++)
                geometrySet.push(plane);
            
            //setup the particle animation set
            _particleAnimationSet = new ParticleAnimationSet(true, true);
            _particleAnimationSet.addAnimation(new ParticleBillboardNode());
            _particleAnimationSet.addAnimation(new ParticleVelocityNode(ParticlePropertiesMode.LOCAL_STATIC));
            _particleAnimationSet.initParticleFunc = initParticleFunc;
            
            //setup the particle material
            var material:TextureMaterial = new TextureMaterial(Cast.bitmapTexture(ParticleImg));
            material.blendMode = BlendMode.ADD;
            
            //setup the particle animator and mesh
            _particleAnimator = new ParticleAnimator(_particleAnimationSet);
            _particleMesh = new Mesh(ParticleGeometryHelper.generateGeometry(geometrySet), material);
            _particleMesh.animator = _particleAnimator;
            _away3dView.scene.addChild(_particleMesh);
            
            //start the animation
            _particleAnimator.start();
        }
        
        protected function initParticleFunc(prop:ParticleProperties):void
        {
            prop.startTime = Math.random()*5 - 5;
            prop.duration = 5;
            var degree1:Number = Math.random() * Math.PI ;
            var degree2:Number = Math.random() * Math.PI * 2;
            var r:Number = Math.random() * 50 + 400;
            prop[ParticleVelocityNode.VELOCITY_VECTOR3D] = new Vector3D(r * Math.sin(degree1) * Math.cos(degree2), r * Math.cos(degree1) * Math.cos(degree2), r * Math.sin(degree2));
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
            viewObj.stateIndex = Math.random() * 60;
            _starlingMain.addChild( viewObj );
            _viewList.push( viewObj );
            return viewObj;
        }
        
        override public function tick(delta:Number):void
        {
            if( _viewList )
            {
                var i:int = 0;
                while( i < _viewList.length )
                {
                    _viewList[i].x = 50 + ( i % 20 ) * 40;
                    _viewList[i].y = 150 + int( i / 20 ) * 40;
                    
                    if( _viewList[i] as ITickable )
                    {
                        ( _viewList[i] as ITickable ).tick( delta );
                    }
                    else if( _viewList[i] as IAnimatable )
                    {
                        ( _viewList[i] as IAnimatable ).advanceTime( delta );
                    }
                    i++;
                }
            }
        }
    }
}