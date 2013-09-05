package durian.robotlegs.extensions.textureMgrExtension
{
    import flash.utils.ByteArray;
    
    import durian.interfaces.ITextureMgr;
    
    import robotlegs.bender.bundles.mvcs.Mediator;
    
    import starling.textures.Texture;
    import starling.textures.TextureAtlas;
    
    public class TextureMgr extends Mediator implements ITextureMgr
    {
        private var _resIdList:Vector.<String>;
        private var _atfDataList:Vector.<ByteArray>;
        private var _textureList:Vector.<Texture>;
        
        private var _atlasResidList:Vector.<String>;
        private var _atlasXmlList:Vector.<XML>;
        private var _textureAtlasList:Vector.<TextureAtlas>;
        private var _textureAtlasLoadAsyncList:Vector.<Function>;
        
        private var _usedCountList:Vector.<int>;
        
        private var _isDisposed:Boolean;
        
        public function TextureMgr()
        {
            //index of texture
            _resIdList = new Vector.<String>();
            
            _atfDataList= new Vector.<ByteArray>();
            _textureList = new Vector.<Texture>();
            
            //index of textureAtlas
            _atlasResidList = new Vector.<String>;
            _atlasXmlList = new Vector.<XML>();
            _textureAtlasList = new Vector.<TextureAtlas>();
            _textureAtlasLoadAsyncList = new Vector.<Function>();
            
            _usedCountList = new Vector.<int>();
        }
        
        /**
         * 
         * @param resId
         * @return 
         */        
        public function getTextureById( resId:String ):Texture
        {
            var index:int = _resIdList.indexOf( resId );
            if( index != -1 )
            {
                _usedCountList[index]++;
                if( _textureList.length > index )
                {
                    return _textureList[index];
                }
            }
            return null;
        }
        
        /**
         * 
         * @param resId
         * @param atfByte
         * @param loadAsync
         * @return 
         */
        public function getTexture( resId:String , atfByte:ByteArray, loadAsync:Function=null):Texture
        {
            var index:int = _resIdList.indexOf( resId );
            if( index == -1 )
            {
                index = _atfDataList.indexOf( atfByte );
            }
            if( index == -1 )
            {
                _atfDataList.push( atfByte );
                index = _atfDataList.indexOf( atfByte );
                _resIdList[index] = resId;
                _usedCountList[index] = 0;
                _textureList.push( Texture.fromAtfData( atfByte, 1, false, loadAsync) );
            }
            else
            {
                loadAsync( _textureList[index] );
            }
            _usedCountList[index]++;
            if( _textureList.length > index )
            {
                return _textureList[index];
            }
            return null;
        }
        
        /**
         * 
         * @param resId
         * @return 
         */        
        public function getTextureAtlasById( resId:String ):TextureAtlas
        {
            var index:int = _resIdList.indexOf( resId );
            if( index != -1 )
            {
                _usedCountList[index]++;
                if( _textureAtlasList.length > index )
                {
                    return _textureAtlasList[index];
                }
            }
            return null;
        }
        
        /**
         * 
         * @param resId
         * @param atfByte
         * @param atlasXml
         * @param loadAsync
         * @return 
         */        
        public function getTextureAtlas( resId:String , atfByte:ByteArray, atlasXml:XML , loadAsync:Function = null ):TextureAtlas
        {
            var index:int = _atlasResidList.indexOf( resId );
            if( index == -1 )
            {
                index = _atlasResidList.push( resId );
                _atlasXmlList.push( atlasXml );
                _textureAtlasLoadAsyncList.push( loadAsync );
            }
            if( _textureAtlasList.length > index )
            {
                return _textureAtlasList[index];
            }
            else
            {
                getTexture( resId , atfByte , onGetTexture );
            }
            return null;
        }
        
        private function onGetTexture( texture:Texture ):void
        {
            var index:int = _textureList.indexOf( texture );
            var atlasResIndex:int;
            if( index != -1 )
            {
                atlasResIndex = _atlasResidList.indexOf( _resIdList[index] );
                _textureAtlasList.push( new TextureAtlas( texture , _atlasXmlList[atlasResIndex] ));
                _textureAtlasLoadAsyncList[ atlasResIndex ]( _textureAtlasList[_textureAtlasList.length - 1] );
                _textureAtlasLoadAsyncList.splice( atlasResIndex , 1 );
            }
        }
        
        public function disposeTexture( texture:Texture ):void
        {
            var index:int = _textureList.indexOf( texture );
            if(index != -1 )
            {
                _usedCountList[index]--;
                var usedCount:int = _usedCountList[index];
                if(usedCount == 0)
                {
                    _textureList[index].dispose();
                    _textureList.splice( index ,1 );
                    _atfDataList.splice( index , 1 );
                    _usedCountList.splice( index ,  1 );
                    _resIdList.splice( index ,  1 );
                }
            }
        }
        
        public function disposeTextureAtlas( textureAtlas:TextureAtlas ):void
        {
            var index:int = _textureAtlasList.indexOf( textureAtlas );
            if(index != -1 )
            {
                _usedCountList[index]--;
                _textureAtlasList[index].dispose();
                _textureAtlasList.splice( index ,1 );
                _atlasXmlList.splice( index ,  1 );
                _atlasResidList.splice( index ,  1 );
                disposeTexture( textureAtlas.texture );
            }
        }
        
        public function dispose():void 
        {
            if (_isDisposed == false)
            {
                _isDisposed = true;
                distruct();
            }
        }
        
        protected function distruct():void 
        {
        }
        
        public function get isDisposed():Boolean 
        {
            return _isDisposed;
        }
    }
}

