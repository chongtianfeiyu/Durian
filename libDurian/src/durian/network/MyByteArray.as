package durian.network
{
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	
	public class MyByteArray extends ByteArray
	{
		/**
		 * 传递参数
		 * @default 
		 */
		public var Params:Object;
		
		/**
		 * 读取64位整数
		 * @return 2进制内容数组
		 */
		public function readInt64ToBit():Array
		{
			var t1:String = this.readUnsignedInt().toString( 2 );
			var t2:String = this.readUnsignedInt().toString( 2 );
			
			t1 = StringUtils.FillString(t1, 32, "0");
			t2 = StringUtils.FillString(t2, 32, "0");
			
			var bit:String;
			if ( this.endian==Endian.LITTLE_ENDIAN )
			{
				bit = t2+t1;
			}
			else
			{
				bit = t1+t2;
			}
			return bit.split("");
		}
		
		/**
		 * 读取64位整数
		 * @return BitInt
		 */
		public function readInt64():BigInt
		{
			var t1:String = this.readUnsignedInt().toString( 16 );
			var t2:String = this.readUnsignedInt().toString( 16 );
			t1 = StringUtils.FillString(t1, 8, "0");
			t2 = StringUtils.FillString(t2, 8, "0");
			
			if ( this.endian==Endian.LITTLE_ENDIAN )
			{
				return new BigInt( "0x"+t2+t1 );
			}
			else
			{
				return new BigInt( "0x"+t1+t2 );
			}
		}
		
		/**
		 * 读取服务端字符
		 */
		public function readString( len:int=-1, isAsc2:Boolean=false ):String
		{
			var strLen:int = this.readShort();

			if( !isAsc2 ) {
				len = len*3;
			}
			if( strLen>len && len>0) {
				strLen = len;
			}
			var rs:String = this.readUTFBytes(strLen);
			
			//偏移空白字符
			len = len - strLen;
			if( len>0 ) {
				this.position += len;
			}
//			this.readBytes(new ByteArray(),0, len*3-charCnt);
			
			return rs;
		}
		
		/**
		 * 写64位整数
		 * @param val
		 */
		public function writeInt64( val:BigInt ):void
		{
			var str:String = val.toString( 16 );
			var cnt:int = 16-str.length;
			
			for ( var i:int=0; i<cnt; i++ )
			{
				str = '0' + str;
			}
			var t1:uint = uint( '0x'+str.substr( 0, 8 ));
			var t2:uint = uint( '0x'+str.substr( 8 ));
			
			if ( this.endian==Endian.LITTLE_ENDIAN )
			{
				writeInt( t2 );
				writeInt( t1 );
			}
			else
			{
				writeInt( t1 );
				writeInt( t2 );
			}
		}
		
		/**
		 * 填充unicode字符串
		 * @str 内容
		 * @len 长度,内容不足时将填充空字符到指定长度,超过时切掉多余字符
		 */
		public function writeString( str:String, len:int, isAsc2:Boolean=false, writeLen:Boolean=true ):void
		{
			var checkLen:int = len;
			if(!isAsc2) {
				len*=3;
				checkLen *= 2;
			}
			var cnt: int;
			var paddingCnt: int;
			var idx: int;
			var bytes:ByteArray = new ByteArray();
			bytes.writeUTFBytes( str );
			if( bytes.length>len ) {
				str = StringUtils.CutString( str, checkLen );
			}
			var pos:int = this.position;
			if( writeLen ) {
				this.writeUTF( str );
			} else {
				this.writeUTFBytes(str);
			}
			var charCnt:int = this.position - pos - 2;
			for ( idx = charCnt; idx < len; idx++ )
			{
				writeByte(0);
			}
		}
	}
}