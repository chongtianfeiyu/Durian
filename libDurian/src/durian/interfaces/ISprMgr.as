package durian.interfaces
{
    import flash.utils.ByteArray;
    
    import durian.actSpr.structs.CSPR;
    
    import robotlegs.bender.extensions.mediatorMap.api.IMediator;

    public interface ISprMgr extends IMediator
    {
        function getCSPR( resId:String , sprByte:ByteArray, loadAsync:Function=null):CSPR;
        function disposeTexture( texture:CSPR ):void;
    }
}