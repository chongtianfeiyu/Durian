package durian.interfaces
{
    import morn.core.components.View;

    public interface IViewFactory
    {
        function getView( name:String ):View;
    }
}