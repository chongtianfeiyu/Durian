package views
{
    import flash.events.Event;
    import flash.events.IEventDispatcher;
    import flash.events.MouseEvent;
    
    import durian.events.GameEvent;
    import durian.interfaces.IUIMgr;
    
    import game.ui.defaultViewUI;
    
    public class DefaultView extends defaultViewUI
    {
        [Inject]
        public var eventDispatcher:IEventDispatcher;
        
        [Inject]
        public var uiMgr:IUIMgr;
        
        public function DefaultView()
        {
            loginBtn.addEventListener( MouseEvent.CLICK , onLogin );
        }
        
        protected function onLogin( e:MouseEvent):void
        {
            uiMgr.hide( UIConsts.DEFAULT_VIEW );
            dispatch( new GameEvent( GameEvent.LOGIN , [] ) );
        }
        
        protected function dispatch(event:Event):void
        {
            if (eventDispatcher.hasEventListener(event.type))
                eventDispatcher.dispatchEvent(event);
        }
    }
}