package durian.network
{
    import flash.events.Event;
    import flash.events.EventDispatcher;
    import flash.net.URLLoader;
    import flash.net.URLLoaderDataFormat;
    import flash.net.URLRequest;
    import flash.net.URLRequestMethod;
    import flash.net.URLVariables;
    import flash.utils.ByteArray;
    import flash.utils.Dictionary;
    
    import durian.events.GameEvent;
    
    public class DurianHttp extends EventDispatcher
    {
        protected static var _instance:DurianHttp;
        
        protected var _cookie:String;
        protected var _host:String = "http://localhost/";
        protected var _port:int = 80;
        
        protected var _csrf:String;
        protected var _urlLoader:URLLoader;  
        protected var _phpUrl:URLRequest;  
        
        public static function get instance():DurianHttp
        {
            if( !_instance )
            {
                _instance = new DurianHttp();
            }
            return _instance;
        }
        
        public function DurianHttp()
        {
            super();
        }
        
        public function connect( host:String = null , port:int = 0 ):void
        {
            if( host != null )
            {
                _host = host;
            }
            if( port != 0 )
            {
                _port = port;
            }
            _phpUrl = new URLRequest( _host + "?flash=1" );
            _phpUrl.method = URLRequestMethod.GET;
            
            _urlLoader = new URLLoader();  
            _urlLoader.dataFormat = URLLoaderDataFormat.BINARY;
            _urlLoader.addEventListener(Event.COMPLETE, onConnect );  
            trace( "[DurianHttp] >>>>>> connect " + _host );
            _urlLoader.load(_phpUrl);  
        }
        
        protected function onConnect( e:Event):void
        {
            _urlLoader.removeEventListener(Event.COMPLETE, onConnect );  
            
            var data:ByteArray = e.currentTarget.data as ByteArray;
            var resultStr:String = data.readUTFBytes( data.length );
            
            trace( "[DurianHttp] <<<<<< " + _host + " DATA : " + resultStr );
            
            try
            {
                var resultObj:Object = JSON.parse( resultStr );
                _csrf = resultObj.csrf;
                _cookie = resultObj.cookie;
                dispatchEvent( new Event( Event.CONNECT ) );
                _urlLoader.addEventListener( Event.COMPLETE , onData );
            }
            catch( e:Error)
            {
                trace( "[DurianHttp] error " + e.getStackTrace() );
            }
        }
        
        public function send( cmdStr:String , data:Dictionary ):void
        {
            _phpUrl = new URLRequest( _host + cmdStr );
            _phpUrl.method = URLRequestMethod.POST;  
            
            var dataStr:String = "";
            var vars:URLVariables = new URLVariables();
            for ( var key:String in data )
            {
                vars[key] = data[key];
                dataStr += key + "=" + data[key] + ";";
            }
            vars.csrf = _csrf;
            _phpUrl.data = vars;  
            trace( "[DurianHttp] >>>>>> " + _host + cmdStr + " DATA : " + dataStr );
            _urlLoader.load(_phpUrl);  
        }
        
        protected function onData( e:Event ):void
        {
            var data:ByteArray = e.currentTarget.data as ByteArray;
            var resultStr:String = data.readUTFBytes( data.length );
            
            trace( "[DurianHttp] <<<<<< " + _host + " DATA : " + resultStr );
            
            try
            {
                var resultObj:Object = JSON.parse( resultStr );
                _csrf = resultObj.csrf;
                _cookie = resultObj.cookie;
                
                dispatchEvent( new GameEvent( resultObj.cmd, resultObj ) );
            }
            catch( e:Error)
            {
                trace( "[DurianHttp] error " + e.getStackTrace() );
            }
        }
        
        public function register( username:String , email:String , password:String , callBack:Function ):void
        {
            _phpUrl = new URLRequest( _host + "user/register" );
            
            _phpUrl.method = URLRequestMethod.POST;  
            var vars:URLVariables = new URLVariables();  
            vars.username = username;  
            vars.email = email;  
            vars.password = password;  
            vars.csrf = _csrf;
            _phpUrl.data = vars;  
            
            _urlLoader = new URLLoader();  
            _urlLoader.dataFormat = URLLoaderDataFormat.BINARY;
            
            _urlLoader.load(_phpUrl);  
            _urlLoader.addEventListener(Event.COMPLETE, onRegister);  
        }
        
        protected function onRegister( e:Event):void
        {
            var data:ByteArray = e.currentTarget.data as ByteArray;
            var resultStr:String = data.readUTFBytes( data.length );
            trace( resultStr );
            var resultObj:Object = JSON.parse( resultStr );
            _csrf = resultObj.csrf;
            _cookie = resultObj.cookie;
        }
        
        protected function onLogin( e:Event ):void
        {
            var data:ByteArray = e.currentTarget.data as ByteArray;
            var resultStr:String = data.readUTFBytes( data.length );
            trace( resultStr );
            var resultObj:Object = JSON.parse( resultStr );
            _csrf = resultObj.csrf;
            _cookie = resultObj.cookie;
        }
    }
}