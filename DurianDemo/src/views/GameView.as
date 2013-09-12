package views
{
    import flash.events.IEventDispatcher;
    import flash.events.MouseEvent;
    
    import durian.events.GameEvent;
    import durian.events.UserInfoEvent;
    import durian.interfaces.IUserInfo;
    
    import game.ui.gameViewUI;
    
    public class GameView extends gameViewUI
    {
        [Inject]
        public var eventDispatcher:IEventDispatcher;
        
        [Inject]
        public var userInfo:IUserInfo;
        
        public function GameView()
        {
            super();
            this.addEventListener( MouseEvent.MOUSE_DOWN , onDown );
            this.speedBtn.toggle = true;
            this.speedBtn.addEventListener( MouseEvent.CLICK , onSpeed );
            this.menuBtn.addEventListener( MouseEvent.CLICK , onMenu );
        }
        
        private function onChangeUserInfo( e:UserInfoEvent ):void
        {
            this.txtCoin.text = userInfo.zeny.toString();
        }
        
        protected function onDown( e:MouseEvent):void
        {
            e.stopImmediatePropagation();
        }
        
        private function onRestart( e:GameEvent ):void
        {
            this.txtCoin.text = userInfo.zeny.toString();
            this.speedBtn.selected = false;
        }
        
        protected function onSpeed( e:MouseEvent):void
        {
            dispatchEvent( new GameEvent( GameEvent.SPEED , [] ));
            e.stopImmediatePropagation();
        }
        
        public function initialize():void
        {
            this.txtCoin.text = userInfo.zeny.toString();
            userInfo.addEventListener( UserInfoEvent.USER_INFO_CHANGE , onChangeUserInfo );
            eventDispatcher.addEventListener( GameEvent.RESTART , onRestart );
        }
        
        protected function onMenu( e:MouseEvent):void
        {
            eventDispatcher.dispatchEvent( new GameEvent( GameEvent.MENU , [] ) );
            e.stopImmediatePropagation();
        }
    }
}