package durian.display.bitmap
{
    import flash.display.BitmapData;
    
    import durian.display.IMultiStateAnimation;

    public class MultiStateBitmapAnimaiton extends BitmapAnimation implements IMultiStateAnimation
    {
        protected var _stateIndex:uint;
        
        protected var _animationConfig:Vector.<Vector.<String>>;
        
        public function MultiStateBitmapAnimaiton( name:String )
        {
            super(name);
            _animationConfig = new Vector.<Vector.<String>>();
        }
        
        public function updateAnimationConfig( animationConfig:Vector.<Vector.<String>> ):void
        {
            _couldTick = false;
            _animationConfig = animationConfig;
            _stateIndex = 0;
            currentFrame = 0;
        }
        
        override public function tick(delta:Number):void
        {
            if( !_couldTick )
            {
                return;
            }
            
            _counter.tick( delta );
            
            var couldRender:Boolean;
            
            while( _counter.expired == true )
            {
                if( _currentFrame >= _animationConfig[_stateIndex].length - 1 )
                {
                    if( _loop )
                    {
                        _currentFrame = 0;
                    }
                    //                    dispatchEvent(new ActTpcEvent( ActTpcEvent.MOTION_FINISHED, true ));
                }
                else
                {
                    _currentFrame++;
                }
                couldRender = true;
                _counter.reset( _counterTarget );
            }
            
            if(couldRender == true)
            {
                updateFrame();
            }
        }
        
        override public function updateFrame():void
        {
            var mBitmapData:BitmapData = _bitmapList[ _stateIndex + currentFrame ];
            if( mBitmapData && _animationDisplay.bitmapData != mBitmapData )
            {
                _animationDisplay.bitmapData = mBitmapData ;
                _animationDisplay.x = int( -_animationDisplay.bitmapData.width / 2 );
                _animationDisplay.y = int( -_animationDisplay.bitmapData.height / 2 );
            }
        }
        
        public function set stateIndex( value:uint ):void 
        {
            if( _stateIndex != value )
            {
                _stateIndex = value;
                currentFrame = 0;
            }
        }
        
        public function get stateIndex():uint
        {
            return   _stateIndex;
        }
        
        override public function get currentFrame():uint
        {
            return _currentFrame;
        }
        
        override public function set currentFrame( value:uint ):void
        {
            _currentFrame = value;
        }
    }
}