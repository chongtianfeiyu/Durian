package
{
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.utils.Dictionary;
    
    import durian.events.GameEvent;
    import durian.network.DurianHttp;
    
    import morn.core.handlers.Handler;
    
    [SWF(width="960",height="640",frameRate="60",backgroundColor="#ffffff")]
    public class DurianClient extends Sprite
    {
        private var _defaultView:DefaultView;
        
        public function DurianClient()
        {
            addEventListener( Event.ADDED_TO_STAGE , onAddedToStage );
        }
        
        protected function onAddedToStage( e:Event = null ):void
        {   
            removeEventListener( Event.ADDED_TO_STAGE , onAddedToStage );
            
            App.init( this );
            App.loader.loadAssets( ["assets/component.swf"] , new Handler( onLoadComplete ) );
        }
        
        private function onLoadComplete():void
        {
            _defaultView = new DefaultView();
            addChild( _defaultView );
            
            DurianHttp.instance;
            DurianHttp.instance.addEventListener( Event.CONNECT , onConnect );
            DurianHttp.instance.connect( null, 0 );
        }
        
        private function onConnect( e:Event ):void
        {
            _defaultView.loginBtn.addEventListener( MouseEvent.CLICK , onLogin );
            _defaultView.regBtn.addEventListener( MouseEvent.CLICK , onRegister );
        }
        
        protected function onLogin(event:MouseEvent):void
        {
            var data:Dictionary = new Dictionary();
            if( _defaultView.txtLoginUser.text && _defaultView.txtLoginPass.text )
            {
                data["username"] = _defaultView.txtLoginUser.text;
                data["password"] = _defaultView.txtLoginPass.text;
                data["remember"] = "";
            }
            else
            {
                data["username"] = "durian";
                data["password"] = "durian123";
                data["remember"] = "";
            }
            DurianHttp.instance.addEventListener( "user/login", onLoginComplete );
            DurianHttp.instance.send( "user/login" , data );
        }
        
        protected function onRegister(event:MouseEvent):void
        {
            
            if( _defaultView.txtRegPassConfirm.text == _defaultView.txtRegPass.text )
            {
                var data:Dictionary = new Dictionary();
                data["username"] = _defaultView.txtRegUser.text;
                data["password"] = _defaultView.txtRegPass.text;
                data["password_confirm"] = _defaultView.txtRegPassConfirm.text;
                data["email"] = _defaultView.txtRegEmail.text;
                DurianHttp.instance.addEventListener( "user/register" , onRegisterComplete );
                DurianHttp.instance.send( "user/register" , data );
            }
            else
            {
                
            }
        }
        
        private function onLoginComplete( e:GameEvent ):void
        {
            DurianHttp.instance.removeEventListener( "user/login", onLoginComplete );
            var resultObj:Object = e.params;
            if( resultObj.isLogin == 1 )
            {
                trace( "[DurianClient] resultObj.msg: " + resultObj.msg );
            }
            else
            {
                trace( "[DurianClient] resultObj.error: " + resultObj.error );
            }
        }
        
        private function onRegisterComplete( e:GameEvent ):void
        {
            DurianHttp.instance.removeEventListener( "user/register", onRegisterComplete );
            var resultObj:Object = e.params;
            if( resultObj.isLogin == 1 )
            {
                trace( "[DurianClient] resultObj.msg: " + resultObj.msg );
            }
            else
            {
                var errStr:String = "";
                for ( var str:String in resultObj.error )
                {
                    errStr += resultObj.error[str] + " , ";
                }
                trace( "[DurianClient] resultObj.error: " +  errStr );
            }
        }
    }
}