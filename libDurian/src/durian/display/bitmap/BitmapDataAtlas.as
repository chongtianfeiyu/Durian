package durian.display.bitmap
{
    import flash.display.BitmapData;
    import flash.geom.Point;
    import flash.geom.Rectangle;
    import flash.utils.Dictionary;
    
    public class BitmapDataAtlas
    {
        private var mAtlasBitmapData:BitmapData;
        
        private var mTextureRegions:Dictionary;
        
        private var mTextureFrames:Dictionary;
        
        /** helper objects */
        private static var sNames:Vector.<String> = new <String>[];
        
        public function BitmapDataAtlas( bitmapData:BitmapData, atlasXml:XML=null)
        {
            mTextureRegions = new Dictionary();
            mTextureFrames  = new Dictionary();
            mAtlasBitmapData   = bitmapData;
            
            if (atlasXml)
                parseAtlasXml(atlasXml);
        }
        
        /** Disposes the atlas texture. */
        public function dispose():void
        {
            mAtlasBitmapData.dispose();
        }
        
        /** This function is called by the constructor and will parse an XML in Starling's 
         *  default atlas file format. Override this method to create custom parsing logic
         *  (e.g. to support a different file format). */
        protected function parseAtlasXml(atlasXml:XML):void
        {
//            var scale:Number = mAtlasBitmapData.scale;
            var scale:Number = 1;
            
            for each (var subTexture:XML in atlasXml.SubTexture)
            {
                var name:String        = subTexture.attribute("name");
                var x:Number           = parseFloat(subTexture.attribute("x")) / scale;
                var y:Number           = parseFloat(subTexture.attribute("y")) / scale;
                var width:Number       = parseFloat(subTexture.attribute("width")) / scale;
                var height:Number      = parseFloat(subTexture.attribute("height")) / scale;
                var frameX:Number      = parseFloat(subTexture.attribute("frameX")) / scale;
                var frameY:Number      = parseFloat(subTexture.attribute("frameY")) / scale;
                var frameWidth:Number  = parseFloat(subTexture.attribute("frameWidth")) / scale;
                var frameHeight:Number = parseFloat(subTexture.attribute("frameHeight")) / scale;
                
                var region:Rectangle = new Rectangle(x, y, width, height);
                var frame:Rectangle  = frameWidth > 0 && frameHeight > 0 ?
                    new Rectangle(frameX, frameY, frameWidth, frameHeight) : null;
                
                addRegion(name, region, frame);
            }
        }
        
        /** Retrieves a subtexture by name. Returns <code>null</code> if it is not found. */
        public function getBitmapData(name:String):BitmapData
        {
            var region:Rectangle = mTextureRegions[name];
            
            if (region == null)
            {
                return null;
            }
            else
            {
                var bmpd:BitmapData = new BitmapData( region.width , region.height );
                bmpd.copyPixels( mAtlasBitmapData , region , new Point( 0 , 0 ) );
                return bmpd;  
            }
        }
        
        /** Returns all textures that start with a certain string, sorted alphabetically
         *  (especially useful for "MovieClip"). */
        public function getBitmapDatas(prefix:String="", result:Vector.<BitmapData>=null):Vector.<BitmapData>
        {
            if (result == null) result = new <BitmapData>[];
            
            for each (var name:String in getNames(prefix, sNames)) 
            result.push(getBitmapData(name)); 
            
            sNames.length = 0;
            return result;
        }
        
        /** Returns all texture names that start with a certain string, sorted alphabetically. */
        public function getNames(prefix:String="", result:Vector.<String>=null):Vector.<String>
        {
            if (result == null) result = new <String>[];
            
            for (var name:String in mTextureRegions)
                if (name.indexOf(prefix) == 0)
                    result.push(name);
            
            result.sort(Array.CASEINSENSITIVE);
            return result;
        }
        
        /** Returns the region rectangle associated with a specific name. */
        public function getRegion(name:String):Rectangle
        {
            return mTextureRegions[name];
        }
        
        /** Returns the frame rectangle of a specific region, or <code>null</code> if that region 
         *  has no frame. */
        public function getFrame(name:String):Rectangle
        {
            return mTextureFrames[name];
        }
        
        /** Adds a named region for a subtexture (described by rectangle with coordinates in 
         *  pixels) with an optional frame. */
        public function addRegion(name:String, region:Rectangle, frame:Rectangle=null):void
        {
            mTextureRegions[name] = region;
            mTextureFrames[name]  = frame;
        }
        
        /** Removes a region with a certain name. */
        public function removeRegion(name:String):void
        {
            delete mTextureRegions[name];
            delete mTextureFrames[name];
        }
        
        /** The base texture that makes up the atlas. */
        public function get bitmapData():BitmapData { return mAtlasBitmapData; }
    }
}