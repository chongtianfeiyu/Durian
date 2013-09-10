package durian.robotlegs.extensions.uiMgrExtension
{
    import durian.interfaces.IUIMgr;
    import durian.interfaces.IViewFactory;
    
    import morn.core.components.View;
    
    import robotlegs.bender.bundles.mvcs.Mediator;
    import robotlegs.bender.extensions.contextView.ContextView;
    
    public class UIMgr extends Mediator implements IUIMgr
    {
        [Inject]
        public var contextView:ContextView;
        
        [Inject]
        public var viewFactory:IViewFactory;
        
        protected var _viewIndexList:Vector.<String>;
        protected var _viewList:Vector.<View>;
        
        protected var _isDisposed:Boolean;
        
        public function UIMgr()
        {
            _viewIndexList = new Vector.<String>();
            _viewList= new Vector.<View>();
        }
        
        public function show( name:String ):void
        {
            var view:View;
            var index:int = _viewIndexList.indexOf( name );
            if( index != -1 )
            {
                view = _viewList[index];
                contextView.view.addChild( view ); 
            }
            else
            {
                view = viewFactory.getView( name ) as View;
                if( view )
                {
                    _viewIndexList.push( name );
                    _viewList.push( view );
                    contextView.view.addChild( view ); 
                }
            }
        }
        
        public function hide( name:String ):void
        {
            var index:int = _viewIndexList.indexOf( name );
            if( index != -1 )
            {
                var view:View = _viewList[index];
                view.parent.removeChild( view );
            }
        }
        
        public function dispose():void 
        {
            if (_isDisposed == false)
            {
                _isDisposed = true;
                distruct();
            }
        }
        
        protected function distruct():void 
        {
        }
        
        public function get isDisposed():Boolean 
        {
            return _isDisposed;
        }
    }
}

