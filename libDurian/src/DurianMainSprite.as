package
{
    import flash.display.BlendMode;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.geom.Vector3D;
    
    import away3d.animators.ParticleAnimationSet;
    import away3d.animators.ParticleAnimator;
    import away3d.animators.data.ParticleProperties;
    import away3d.animators.data.ParticlePropertiesMode;
    import away3d.animators.nodes.ParticleBillboardNode;
    import away3d.animators.nodes.ParticleVelocityNode;
    import away3d.containers.View3D;
    import away3d.controllers.HoverController;
    import away3d.core.base.Geometry;
    import away3d.core.managers.Stage3DManager;
    import away3d.core.managers.Stage3DProxy;
    import away3d.debug.AwayStats;
    import away3d.entities.Mesh;
    import away3d.events.Stage3DEvent;
    import away3d.materials.TextureMaterial;
    import away3d.primitives.PlaneGeometry;
    import away3d.tools.helpers.ParticleGeometryHelper;
    import away3d.utils.Cast;
    
    import durian.interfaces.IDisplayMgr;
    import durian.interfaces.ITextureMgr;
    import durian.interfaces.IZipMgr;
    import durian.starling.StarlingMain;
    
    import robotlegs.bender.framework.api.IContext;
    import robotlegs.bender.framework.api.ILogger;
    
    import starling.core.Starling;
    import starling.utils.HAlign;
    import starling.utils.VAlign;
    
    public class DurianMainSprite extends Sprite
    {
        [Inject]
        public var logger:ILogger;
        
        [Inject]
        public var displayMgr:IDisplayMgr;
        
        [Inject]
        public var zipMgr:IZipMgr; 
        
        [Inject]
        public var textureMgr:ITextureMgr;
        
        /**
         * robotlegs context 
         */        
        protected var _context:IContext;
        /**
         * starling
         */        
        protected var _starling:Starling;
        /**
         * starlingMain sprite
         */        
        protected var _starlingMain:StarlingMain;
        /**
         *  tick time stamp
         */        
        protected var _lastTimeStamp:Number;
        /**
         *  
         */        
        protected var _stage3DManager:Stage3DManager;
        /**
         * 
         */        
        protected var _stage3DProxy:Stage3DProxy;
        /**
         * 
         */        
        protected var _away3dView:View3D;
        private var _particleAnimationSet:ParticleAnimationSet;
        private var _particleAnimator:ParticleAnimator;
        private var _particleMesh:Mesh;
        
        /**
         * construct
         */        
        public function DurianMainSprite()
        {
            addEventListener( Event.ADDED_TO_STAGE , onAddedToStage );
        }
        
        /**
         * added to stage
         * initialize starling
         * @param e
         */        
        protected function onAddedToStage( e:Event = null ):void
        {   
            removeEventListener( Event.ADDED_TO_STAGE , onAddedToStage );
            
            _stage3DManager = Stage3DManager.getInstance(stage);
            _stage3DProxy = _stage3DManager.getFreeStage3DProxy();
            _stage3DProxy.addEventListener(Stage3DEvent.CONTEXT3D_CREATED, onContextCreated);
            _stage3DProxy.antiAlias = 8;
            _stage3DProxy.color = 0x0;
        }
        
        protected function onContextCreated( e:Event):void
        {
            initAway3D();
            initStarling();
//            initMaterials();
//            initObjects();
//            initButton();
            initListeners();
            initParticles();
        }

        [Embed(source="blue.png")]
        private var ParticleImg:Class;
        
        private function initParticles():void
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
        
        private function initParticleFunc(prop:ParticleProperties):void
        {
            prop.startTime = Math.random()*5 - 5;
            prop.duration = 5;
            var degree1:Number = Math.random() * Math.PI ;
            var degree2:Number = Math.random() * Math.PI * 2;
            var r:Number = Math.random() * 50 + 400;
            prop[ParticleVelocityNode.VELOCITY_VECTOR3D] = new Vector3D(r * Math.sin(degree1) * Math.cos(degree2), r * Math.cos(degree1) * Math.cos(degree2), r * Math.sin(degree2));
        }
        
        private function initAway3D():void
        {
            _away3dView = new View3D();
            _away3dView.stage3DProxy = _stage3DProxy;
            _away3dView.shareContext = true;
            var hoverController:HoverController = new HoverController(_away3dView.camera, null, 45, 30, 1200, 5, 89.999);
            addChild(_away3dView);
            addChild(new AwayStats(_away3dView));
        }
        
        private function initStarling():void
        {
            App.init( this );
            
            Starling.handleLostContext = true;
            Starling.multitouchEnabled = true;
            _starling = new Starling( StarlingMain, stage , _stage3DProxy.viewPort , _stage3DProxy.stage3D);
            _starling.enableErrorChecking = false;
            _starling.showStats = true;
            _starling.showStatsAt(HAlign.RIGHT, VAlign.CENTER);
//            _starling.start();
        }
        
        private function initListeners():void
        {
            _lastTimeStamp = new Date().time;
            _stage3DProxy.addEventListener(Event.ENTER_FRAME, onEnterFrame);
        }
        
        /**
         * starlingMain initialized
         * initialize robotlegs
         */        
        protected function onStarlingInitialized():void
        {
            /* example:
            _context = new Context()
            .install( MVCSBundle )
            .configure( new ContextView( this ) );
            _context.initialize( onContextInitialized );
            */
        }
        
        /**
         * rebotlegs initialized
         */        
        protected function onContextInitialized():void
        {
            //inject root sprite
            _context.injector.injectInto(this);
            logger.debug( "onContextInitialized" );
            displayMgr.initStarlingLevels( _starlingMain );
        }
        
        /**
         * enterFrame
         * @param e
         */        
        protected function onEnterFrame( e:Event):Number
        {
            var currentTimeStamp:Number = new Date().time;
            var delta:Number = (currentTimeStamp - _lastTimeStamp)/1000;
            _lastTimeStamp = currentTimeStamp;
            
            if( _starlingMain )
            {
                _starlingMain.tick( delta );
            }
            else if( Starling.current && Starling.current.root )
            {
                _starlingMain = Starling.current.root as StarlingMain;
                onStarlingInitialized();
            }
            
            _starling.nextFrame();
            _away3dView.render();
            
            return delta;
        }
    }
}