package durian.display
{
    import durian.display.bitmap.BitmapDataAtlas;
    import durian.interfaces.ITickable;
    
    import starling.textures.TextureAtlas;

    public interface IAnimation extends ITickable
    {
        function updateAnimation( textureAtlas:TextureAtlas = null , bitmapDataAtlas:BitmapDataAtlas = null ):void
        function get counterTargetRate():Number;
        function get currentFrame():uint;
        function set currentFrame( value:uint ):void;
        function set loop( value:Boolean ):void;
        function set counterTargetRate( value:Number ):void;
        function updateFrame():void;
    }
}