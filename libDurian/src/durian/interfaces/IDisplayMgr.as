package durian.interfaces
{
    import durian.starling.StarlingMain;
    
    import starling.display.DisplayObjectContainer;
    
    public interface IDisplayMgr
    {
        /**
         * 
         * @param starlingRoot
         */        
        function initStarlingLevels( starlingRoot:StarlingMain ):void;
        
        function removeFromParent( displayObj:* ):void;
        
        function get topLevel():DisplayObjectContainer;
        
        function get joyStickLevel():DisplayObjectContainer;
        
        function get uiLevel():DisplayObjectContainer;
        
        function get effectLevel():DisplayObjectContainer;
        
        function get unitLevel():DisplayObjectContainer;
        
        function get mapLevel():DisplayObjectContainer;
        
        function get bgLevel():DisplayObjectContainer;
    }
}