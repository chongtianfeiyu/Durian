package durian.robotlegs.extensions.displayMgrExtension
{
    import flash.display.DisplayObject;
    
    import durian.interfaces.IDisplayMgr;
    import durian.starling.StarlingMain;
    
    import starling.display.DisplayObjectContainer;
    import starling.display.Sprite;
    
    /**
     * 显示管理器 （层管理 )
     * @author inoah
     */    
    public class DisplayMgr implements IDisplayMgr
    {
        /**
         *  
         */        
        protected var _displayList:Vector.<DisplayObjectContainer>;
        
        public function DisplayMgr()
        {
            
        }
        
        /**
         * 
         * @param starlingRoot
         */        
        public function initStarlingLevels( starlingRoot:StarlingMain ):void
        {
            _displayList = new Vector.<DisplayObjectContainer>();
            for( var i:int = 0;i< 7; i++)
            {
                _displayList[i] = new starling.display.Sprite();
                starlingRoot.addChild( _displayList[i] );
            }
        }
        
        /**
         * 
         * @param displayObj
         */        
        public function removeFromParent( displayObj:* ):void
        {
            if( displayObj as flash.display.DisplayObject )
            {
                if( displayObj.parent )
                {
                    displayObj.parent.removeChild( displayObj );
                }
            }
        }
        
        /**
         * 
         * @return 
         */        
        public function get topLevel():DisplayObjectContainer
        {
            return _displayList[6];
        }
        
        /**
         * 
         * @return 
         */        
        public function get joyStickLevel():DisplayObjectContainer
        {
            return _displayList[5];
        }
        
        /**
         * 
         * @return 
         */        
        public function get uiLevel():DisplayObjectContainer
        {
            return _displayList[4];
        }
        
        /**
         * 
         * @return 
         */        
        public function get effectLevel():DisplayObjectContainer
        {
            return _displayList[3];
        }
        
        /**
         * 
         * @return 
         */        
        public function get unitLevel():DisplayObjectContainer
        {
            return _displayList[2];
        }
        
        /**
         * 
         * @return 
         */        
        public function get mapLevel():DisplayObjectContainer
        {
            return _displayList[1];
        }
        
        /**
         * 
         * @return 
         */        
        public function get bgLevel():DisplayObjectContainer
        {
            return _displayList[0];
        }
    }
}