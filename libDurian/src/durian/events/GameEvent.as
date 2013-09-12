package durian.events
{
    import flash.events.Event;
    
    public class GameEvent extends Event
    {
        public static const LOGIN:String = "GameEvent.LOGIN";
        public static const CHOOSE:String = "GameEvent.CHOOSE";
        public static const MENU:String = "GameEvent.MENU";
        public static const SPEED:String = "GameEvent.SPEED";
        public static const RESTART:String = "GameEvent.RESTART";
        /**
         * menu 
         */        
        public static const CONTINUE:String = "GameEvent.CONTINUE";
        
        public var params:*;
        
        public function GameEvent(type:String, params:* )
        {
            this.params = params;
            super(type);
        }
    }
}