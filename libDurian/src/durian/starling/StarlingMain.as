package durian.starling
{
    import starling.display.Sprite;
    import starling.events.Event;
    import durian.interfaces.ITickable;
    
    public class StarlingMain extends Sprite implements ITickable
    {
        public function StarlingMain()
        {
            super();
            addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler)
        }
        
        protected function addedToStageHandler( e:Event ):void
        {
            
        }
        
        public function tick( delta:Number ):void
        {
            
        }
        
        public function get couldTick():Boolean
        {
            return true;
        }
    }
}