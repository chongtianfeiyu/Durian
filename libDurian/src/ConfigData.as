package
{
    public class ConfigData
    {
        public static var DEFUALT_VIEW:String;
        
        public static function parse( configJson:String ):void
        {
            var configObj:Object = JSON.parse( configJson ).config;
            DEFUALT_VIEW = configObj.defaultView;
        }
    }
}