package durian.actTpc
{
    public class ActTpcPlayerView extends ActTpcBodyView
    {
        public function ActTpcPlayerView( name:String )
        {
            super( name );
        }
        
        override public function tick(delta:Number):void
        {
            super.tick( delta );
            //only stand
            if( _stateIndex < 8 || (_stateIndex >=16) && (_stateIndex < 24)  )
            {
                currentFrame = 2;
            }
        }
        
        override public function updateFrame():void
        {
            super.updateFrame();
        }
    }
}