package durian.robotlegs.extensions.zipMgrExtension
{
    import flash.utils.ByteArray;
    
    import durian.interfaces.IZipMgr;
    
    import nochump.util.zip.ZipEntry;
    import nochump.util.zip.ZipFile;
    
    /**
     * 显示管理器 （层管理 )
     * @author inoah
     */    
    public class ZipMgr implements IZipMgr
    {
        protected var _zipIndexList:Vector.<String>;
        protected var _zipList:Vector.<ZipFile>;
        
        public function ZipMgr()
        {
            _zipIndexList = new Vector.<String>();
            _zipList = new Vector.<ZipFile>();
        }
        
        public function addZip( resId:String , data:ByteArray ):void
        {
            if( getZip( resId ) == null )
            {
                _zipIndexList.push( resId );
                var zipFile:ZipFile = new ZipFile( data );
                _zipList.push( zipFile );
            }
        }
        
        public function getZip( resId:String ):ZipFile
        {
            var index:int = _zipIndexList.indexOf( resId );
            if( index != -1 )
            {
                return _zipList[index];
            }
            return null;
        }
        
        public  function getFileFromZip( resId:String , fileResId:String ):ByteArray
        {
            var zipFile:ZipFile = getZip( resId );
            if( zipFile != null )
            {
                for ( var i:int = 0; i < zipFile.entries.length ;  i++) 
                {
                    var entry:ZipEntry = zipFile.entries[i];
                    if( entry.name == fileResId )
                    {
                        return zipFile.getInput(entry);
                    }
                }
            }
            return null;
        }
    }
}