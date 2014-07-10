package
{
	import hb.utils.DebugUtil;

	public class CellObj
	{
		// :: 생성자 @Param(hn: HorizontalNum, vn: VerticalNum, sn: StateNum)
		public function CellObj(hn:uint, vn:uint, sn:uint)
		{
			this.hn = hn;
			this.vn = vn;
			this.sn = sn;
		}
		
		// - HorizontalNum
		public var hn:uint;
		// - VerticalNum
		public var vn:uint;
		// - StateNum
		public var sn:uint;
		
		
		
		// :: 출력
		public function toString():String
		{
			var t_str:String =
				'hn=' + this.hn + ', ' +
				'vn=' + this.vn + ', ' +
				'sn=' + this.sn;
			return t_str;
		}
		
		// :: 복제
		public function clone():CellObj
		{
			var t_rv:CellObj = new CellObj(
								this.hn, this.vn, this.sn);
			return t_rv;
		}
	}
}
