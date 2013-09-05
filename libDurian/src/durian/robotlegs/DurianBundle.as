package durian.robotlegs
{
    import durian.robotlegs.extensions.displayMgrExtension.DisplayMgrExtension;
    import durian.robotlegs.extensions.keyMgrExtension.KeyMgrExtension;
    import durian.robotlegs.extensions.textureMgrExtension.TextureMgrExtension;
    
    import robotlegs.bender.framework.api.IBundle;
    import robotlegs.bender.framework.api.IContext;
    
    public class DurianBundle implements IBundle
    {
        public function extend(context:IContext):void
        {
            context.install(
                DisplayMgrExtension,
                KeyMgrExtension,
                TextureMgrExtension
                );    
            
            context.configure(DurianConfig);
        }
    }
}