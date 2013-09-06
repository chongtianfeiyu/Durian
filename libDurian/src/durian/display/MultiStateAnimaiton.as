package durian.display
{
    import durian.events.ActTpcEvent;
    
    import starling.textures.Texture;

    public class MultiStateAnimaiton extends Animation implements IMultiStateAnimation
    {
        protected var _stateIndex:uint;
        
        protected var _animationConfig:Vector.<Vector.<String>>;
        
        public function MultiStateAnimaiton( name:String )
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
                    dispatchEvent(new ActTpcEvent( ActTpcEvent.MOTION_FINISHED, true ));
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
            var mTexture:Texture = _textureList[ _stateIndex + currentFrame ];
            if( mTexture && _animationDisplay.texture != mTexture )
            {
                _animationDisplay.texture = mTexture ;
                _animationDisplay.x = int( -_animationDisplay.texture.width / 2 );
                _animationDisplay.y = int( -_animationDisplay.texture.height / 2 );
                _animationDisplay.readjustSize();
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