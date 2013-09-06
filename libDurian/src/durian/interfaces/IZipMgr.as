package durian.interfaces
{
    import flash.utils.ByteArray;
    
    import nochump.util.zip.ZipFile;

    public interface IZipMgr
    {
        function addZip( resId:String , data:ByteArray ):void;
        function getZip( resId:String ):ZipFile;
        function getFileFromZip( resId:String , fileResId:String ):ByteArray;
    }
}