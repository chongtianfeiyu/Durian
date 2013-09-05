package durian.actTpc
{
    import durian.events.ActTpcEvent;

    public class ActTpcBodyView extends ActTpcView
    {
        public function ActTpcBodyView()
        {
            super();
        }
        
        override public function updateFrame():void
        {
            super.updateFrame();
            dispatchEvent( new ActTpcEvent( ActTpcEvent.MOTION_NEXT_FRAME ) );
        }
    }
}