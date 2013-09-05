package durian.interfaces
{
    import flash.utils.ByteArray;
    
    import robotlegs.bender.extensions.mediatorMap.api.IMediator;
    
    import starling.textures.Texture;
    import starling.textures.TextureAtlas;

    public interface ITextureMgr extends IMediator
    {
        function getTextureById( resId:String ):Texture;
        function getTexture( resId:String , atfByte:ByteArray, loadAsync:Function=null):Texture;
        function getTextureAtlasById( resId:String ):TextureAtlas;
        function getTextureAtlas( resId:String , atfByte:ByteArray, atlasXml:XML , loadAsync:Function = null ):TextureAtlas;
    }
}