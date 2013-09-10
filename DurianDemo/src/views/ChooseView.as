package views
{
    import flash.events.IEventDispatcher;
    import flash.events.MouseEvent;
    
    import durian.events.GameEvent;
    import durian.interfaces.IUIMgr;
    
    import game.ui.chooseViewUI;
    
    public class ChooseView extends chooseViewUI
    {
        [Inject]
        public var eventDispatcher:IEventDispatcher;
        
        [Inject]
        public var uiMgr:IUIMgr;
        
        public function ChooseView()
        {
            super();
//            this.backBtn.addEventListener( MouseEvent.CLICK , onBack );
            addEventListener( MouseEvent.MOUSE_DOWN , onDown );
            startBtn.addEventListener( MouseEvent.CLICK , onStart );
        }
        
        protected function onDown( e:MouseEvent):void
        {
            e.stopImmediatePropagation();
        }
        
        protected function onBack( e:MouseEvent ):void
        {
//            eventDispatcher.dispatchEvent( new GameEvent( GameEvent.BACK ));
            this.remove();
            e.stopImmediatePropagation();
        }
        
        protected function onStart( e:MouseEvent ):void
        {
            eventDispatcher.dispatchEvent( new GameEvent( GameEvent.CHOOSE , [] ));
            this.remove();
            e.stopImmediatePropagation();
        }
    }
}