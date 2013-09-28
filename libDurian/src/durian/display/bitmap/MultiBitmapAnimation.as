package durian.display.bitmap
{
    import flash.display.Sprite;
    import flash.geom.Point;
    
    import durian.display.IAnimation;
    
    import starling.textures.TextureAtlas;
    
    /**
     * player multi textureList animation
     * @author inoah
     */    
    public class MultiBitmapAnimation extends Sprite implements IAnimation
    {
        protected var _nameList:Vector.<String>;
        protected var _posList:Vector.<Point>;
        
        protected var _animationList:Vector.<BitmapAnimation>;
        
        protected var _couldTick:Boolean;
        
        public function MultiBitmapAnimation( nameList:Vector.<String> , posList:Vector.<Point> = null )
        {
            _nameList = nameList;
            _posList = posList;
            _animationList = new Vector.<BitmapAnimation>();
        }
        
        public function updateAnimation( textureAtlas:TextureAtlas = null , bitmapDataAtlas:BitmapDataAtlas = null ):void
        {
            _couldTick = false;
            
            var len:int = _nameList.length;
            for( var i:int = 0;i<len;i++ )
            {
                _animationList[i] = new BitmapAnimation( _nameList[i] );
                _animationList[i].loop = true;
                _animationList[i].updateAnimation( null , bitmapDataAtlas );
                if( _posList.length > i )
                {
                    _animationList[i].x = _posList[i].x
                    _animationList[i].y = _posList[i].y
                }
                addChild( _animationList[i] );
            }
        }
        
        public function tick( delta:Number ):void
        {
            var len:int = _animationList.length;
            for( var i:int = 0;i<len;i++ )
            {
                _animationList[i].tick( delta );
            }
        }
                              
        public function get counterTargetRate():Number
        {
            return 0;
        }
        
        public function get currentFrame():uint
        {
            return 0;
        }
        
        public function set currentFrame( value:uint ):void
        {
            
        }
        
        public function set loop( value:Boolean ):void
        {
            
        }
        
        public function set counterTargetRate( value:Number ):void
        {
            
        }
        public function updateFrame():void
        {
            
        }
        
        public function dispose():void
        {
            super.dispose();
            distruct();
        }
        
        protected function distruct():void
        {
            while(_animationList.length)
            {
                _animationList.splice( 0 , 1 );
            }
            super.dispose();
        }
        
        public function get couldTick():Boolean
        {
            return _couldTick;
        }
    }
}