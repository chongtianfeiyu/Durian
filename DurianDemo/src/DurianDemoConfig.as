package
{
    import durian.interfaces.IViewFactory;
    
    import robotlegs.bender.framework.api.IConfig;
    import robotlegs.bender.framework.api.IInjector;
    
    public class DurianDemoConfig implements IConfig
    {
        [Inject]
        public var injector:IInjector;
        
        public function configure():void
        {
            injector.map(IViewFactory).toSingleton(ViewFactory);
        }
    }
}