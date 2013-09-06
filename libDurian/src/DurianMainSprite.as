package
{
    import flash.display.Sprite;
    import flash.events.Event;
    
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
            
            App.init( this );
            
            Starling.handleLostContext = true;
            Starling.multitouchEnabled = true;
            _starling = new Starling( StarlingMain, stage );
            _starling.enableErrorChecking = false;
            _starling.showStats = true;
            _starling.showStatsAt(HAlign.RIGHT, VAlign.CENTER);
            _starling.start();
            
            _lastTimeStamp = new Date().time;
            stage.addEventListener( Event.ENTER_FRAME, onEnterFrame );
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
            return delta;
        }
    }
}