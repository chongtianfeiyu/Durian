package views
{
    import flash.events.IEventDispatcher;
    import flash.events.MouseEvent;
    
    import durian.events.GameEvent;
    
    import game.ui.menuDialogUI;
    
    public class MenuDialog extends menuDialogUI
    {
        [Inject]
        public var eventDispatcher:IEventDispatcher;
        
        public function MenuDialog()
        {
            super();
            this.addEventListener( MouseEvent.MOUSE_DOWN , onDown );
            this.continueBtn.addEventListener( MouseEvent.MOUSE_DOWN , onContinue );
            this.restartBtn.addEventListener( MouseEvent.MOUSE_DOWN , onRestart );
        }
        
        protected function onDown( e:MouseEvent):void
        {
            e.stopImmediatePropagation();
        }
        
        protected function onRestart( e:MouseEvent):void
        {
            e.stopImmediatePropagation();
            eventDispatcher.dispatchEvent( new GameEvent( GameEvent.RESTART , [] ));
            this.remove();
        }
        
        protected function onContinue( e:MouseEvent):void
        {
            e.stopImmediatePropagation();
            eventDispatcher.dispatchEvent( new GameEvent( GameEvent.CONTINUE , [] ));
        }
    }
}