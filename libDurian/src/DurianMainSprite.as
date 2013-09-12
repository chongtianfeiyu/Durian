package
{
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.IEventDispatcher;
    
    import away3d.containers.View3D;
    import away3d.controllers.HoverController;
    import away3d.core.managers.Stage3DManager;
    import away3d.core.managers.Stage3DProxy;
    import away3d.debug.AwayStats;
    import away3d.events.Stage3DEvent;
    
    import durian.interfaces.IDisplayMgr;
    import durian.interfaces.ITextureMgr;
    import durian.interfaces.IUIMgr;
    import durian.interfaces.IUserInfo;
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
        public var uiMgr:IUIMgr;
        
        [Inject]
        public var zipMgr:IZipMgr; 
        
        [Inject]
        public var textureMgr:ITextureMgr;
        
        [Inject]
        public var eventDispatcher:IEventDispatcher;
        
        [Inject]
        public var userInfo:IUserInfo;
        
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
         * away3d
         */        
        protected var _away3dView:View3D;
        /**
         *  
         */        
        protected var _awar3DStats:AwayStats;
        
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
        }
        
        protected function initAway3D():void
        {
            _away3dView = new View3D();
            _away3dView.stage3DProxy = _stage3DProxy;
            _away3dView.shareContext = true;
            var hoverController:HoverController = new HoverController(_away3dView.camera, null, 45, 30, 1200, 5, 89.999);
            addChild(_away3dView);
            _awar3DStats = new AwayStats( _away3dView );
            addChild( _awar3DStats );
        }
        
        protected function initStarling():void
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
        
        protected function initListeners():void
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
        protected function onEnterFrame( e:Event ):void
        {
            var currentTimeStamp:Number = new Date().time;
            var delta:Number = (currentTimeStamp - _lastTimeStamp)/1000;
            _lastTimeStamp = currentTimeStamp;
            
            if( delta <= 0.0 )
            {
                return;
            }
            if( _starlingMain )
            {
                tick( delta );
            }
            else if( Starling.current && Starling.current.root )
            {
                _starlingMain = Starling.current.root as StarlingMain;
                onStarlingInitialized();
            }
            
            _starling.nextFrame();
            _away3dView.render();
        }
        
        public function tick(delta:Number):void
        {
            
        }
    }
}