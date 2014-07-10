package
{
	import flash.display.MovieClip;

	public final class CellWorker
	{
		// :: 생성자
		public function CellWorker() {}
		
		
		// :: Cell 찾기
		public static function get_cell(cellDic:Object, hn:uint, vn:uint):MovieClip
		{
			var t_rv:MovieClip = cellDic['cell_' + hn + '_' + vn];
			return t_rv;
		}
		
		// :: Cell 상태가 변경할수 있는 상태인지 여부
		//		@Param(cellDic: CellDictionaryObject, hn: HorizontalNum, vn: VerticalNum)
		public static function get_isState(cellDic:Object, hn:uint, vn:uint):Boolean
		{
			var t_rv:Boolean = false;
			
			var t_cell:MovieClip = get_cell(cellDic, hn, vn);
			if (t_cell != null)
			{
				if (t_cell.d_sn == 0)
				{
					t_rv = true;
				}
			}
			
			return t_rv;
		}		
		
		// :: Cell 상태 변경 (CellPoint 사용)
		//		@Param(cellDic: CellDictionaryObject, hn: HorizontalNum, vn: VerticalNum, sn: StateNum)
		public static function stateChange(cellDic:Object, hn:uint, vn:uint, sn:int):void
		{
			var t_cell:MovieClip = get_cell(cellDic, hn, vn);
			if (t_cell != null)
			{
				t_cell.d_sn = sn;
				var t_fn:int = sn + 1;
				t_cell.gotoAndStop(t_fn);
			}
		}		
	}
}
