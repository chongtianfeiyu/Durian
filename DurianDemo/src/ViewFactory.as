package
{
    import durian.interfaces.IViewFactory;
    
    import morn.core.components.View;
    
    import robotlegs.bender.framework.api.IInjector;
    
    import views.ChooseView;
    import views.DefaultView;
    import views.GameView;
    import views.MenuDialog;
    
    public class ViewFactory implements IViewFactory
    {
        [Inject]
        public var injector:IInjector;
        
        public function ViewFactory()
        {
        }
        
        public function getView( name:String ):View
        {
            var view:View;
            switch( name )
            {
                case UIConsts.DEFAULT_VIEW:
                {
                    view = new DefaultView();
                    break;
                }
                case UIConsts.CHOOSE_VIEW:
                {
                    view = new ChooseView();
                    break;
                }
                case UIConsts.GAME_VIEW:
                {
                    view = new GameView();
                    break;
                }
                case UIConsts.MENU_VIEW:
                {
                    view = new MenuDialog();
                    view.x = view.width / 2;
                    view.y = view.height / 2
                    break;
                }
            }
            if( view )
            {
                injector.injectInto( view );
            }
            return view;
        }
    }
}