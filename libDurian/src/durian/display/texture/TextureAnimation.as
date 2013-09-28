package durian.display.texture
{
    import flash.display.BitmapData;
    
    import durian.display.IAnimation;
    import durian.display.bitmap.BitmapDataAtlas;
    import durian.events.ActTpcEvent;
    import durian.utils.Counter;
    
    import starling.display.Image;
    import starling.display.Sprite;
    import starling.textures.Texture;
    import starling.textures.TextureAtlas;
    import starling.textures.TextureSmoothing;
    
    /**
     * player textureList animation
     * @author inoah
     */    
    public class TextureAnimation extends Sprite implements IAnimation
    {
        protected static const NULL_TEXTURE:Texture = Texture.fromBitmapData(new BitmapData(1,1,true,0));
        
        protected var _animationDisplay:Image;
        
        protected var _textureList:Vector.<Texture>;
        
        protected var _currentFrame:uint;
        
        protected var _counterTargetRate:Number;
        
        protected var _loop:Boolean;
        
        protected var _baseCounterTarget:Number;
        
        protected var _counterTarget:Number;
        
        protected var _animationCounter:Counter;
        
        protected var _couldTick:Boolean;
        
        protected var _counter:Counter;
        
        protected var _name:String;
        
        public function TextureAnimation( name:String )
        {
            _name = name;
            _counter = new Counter();
            _baseCounterTarget = 0.075 ;
            _counterTarget = _baseCounterTarget;
        }
        
        public function updateAnimation( textureAtlas:TextureAtlas = null , bitmapDataAtlas:BitmapDataAtlas = null  ):void
        {
            _couldTick = false;
            
            _textureList = new Vector.<Texture>();
            var textureTmp:Texture;
            
            for( var i:int = 0;i<int.MAX_VALUE;i++)
            {
                textureTmp = textureAtlas.getTexture( _name + ( i >= 10 ? "":"0") + i );
                if( textureTmp )
                {
                    _textureList[i] = textureTmp;
                }
                else 
                {
                    break;
                }
            }
            
            onInited();
        }
        
        
        
        protected function onInited():void
        {
            if( !_animationDisplay )
            {
                _animationDisplay = new Image(NULL_TEXTURE);
                _animationDisplay.smoothing = TextureSmoothing.TRILINEAR;
                _animationDisplay.touchable = true;
                addChildAt(_animationDisplay, 0);
            }
            currentFrame = 0;
            _counter.initialize();
            _counter.reset( _counterTarget );
            updateFrame();
            _couldTick = true;
        }
        
        public function tick(delta:Number):void
        {
            if( !_couldTick )
            {
                return;
            }
            
            _counter.tick( delta );
            
            var couldRender:Boolean;
            
            while( _counter.expired == true )
            {
                if( _currentFrame >= _textureList.length - 1 )
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
        
        public function updateFrame():void
        {
            var mTexture:Texture = _textureList[ _currentFrame ];
            if( mTexture && _animationDisplay.texture != mTexture )
            {
                _animationDisplay.texture = mTexture ;
                _animationDisplay.x = int( -_animationDisplay.texture.width / 2 );
                _animationDisplay.y = int( -_animationDisplay.texture.height / 2 );
                _animationDisplay.readjustSize();
            }
        }
        
        
        
        override public function dispose():void
        {
            super.dispose();
            distruct();
        }
        
        protected function distruct():void
        {
            while(_textureList.length)
            {
                _textureList.splice( 0 , 1 );
            }
            _animationDisplay.removeFromParent(true);
            _animationDisplay = null;
            _couldTick = false;
            super.dispose();
        }
        
        public function get couldTick():Boolean
        {
            return _couldTick;
        }
        
        public function get counterTargetRate():Number
        {
            return _counterTargetRate;
        }
        
        public function get currentFrame():uint
        {
            return _currentFrame;
        }
        
        public function set currentFrame( value:uint ):void
        {
            if( _currentFrame != value )
            {
                _currentFrame = value;
                updateFrame();
            }
        }
        
        public function set loop( value:Boolean ):void
        {
            _loop = value;
        }
        
        public function set counterTargetRate( value:Number ):void
        {
            _counterTargetRate = value;
            if( _counterTargetRate >= 1 )
            {
                _counterTargetRate = 0.8;
            }
            _counterTarget = _baseCounterTarget * ( 1 - _counterTargetRate );
        }
    }
}