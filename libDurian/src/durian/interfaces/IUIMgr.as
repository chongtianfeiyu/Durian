package durian.interfaces
{
    import robotlegs.bender.extensions.mediatorMap.api.IMediator;

    public interface IUIMgr extends IMediator
    {
        function show( name:String ):void;
        function hide( name:String ):void;
    }
}