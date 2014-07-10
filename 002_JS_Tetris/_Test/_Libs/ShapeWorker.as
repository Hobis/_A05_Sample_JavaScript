package
{
	import flash.display.MovieClip;

	public final class ShapeWorker
	{
		// :: 생성자
		public function ShapeWorker() {}

		
		// :: ShapeObj 표시된거 클리어
		public static function drawClear(cellDic:Object, so:ShapeObj):void
		{
			var t_cos:Array = so.get_cellObjs();
			for (var i:uint = 0, t_la:uint = t_cos.length;
					i < t_la; i++)
			{
				var t_co:CellObj = t_cos[i];				
				var t_hn:uint = so.get_rhn(t_co.hn);
				var t_vn:uint = so.get_rvn(t_co.vn);
				var t_sn:uint = 0;
				CellWorker.stateChange(cellDic, t_hn, t_vn, t_sn);				
			}
		}
		
		// :: ShapeObj가 표시가 가능한지 여부
		public static function get_isDraw(cellDic:Object, so:ShapeObj):Boolean
		{
			var t_rv:Boolean = false;
			
			var t_cos:Array = so.get_cellObjs();
			for (var i:uint = 0, t_la:uint = t_cos.length;
					i < t_la; i++)
			{
				var t_co:CellObj = t_cos[i];
				var t_hn:uint = so.get_rhn(t_co.hn);
				var t_vn:uint = so.get_rvn(t_co.vn);				
				if (CellWorker.get_isState(cellDic, t_hn, t_vn))
				{
					t_rv = true;
				}
				else
				{
					t_rv = false;
					break;
				}
			}
			
			return t_rv;
		}
		
		// :: ShapeObj 표시하기
		public static function draw(cellDic:Object, so:ShapeObj):void
		{
			if (get_isDraw(cellDic, so))
			{
				var t_cos:Array = so.get_cellObjs();
				for (var i:uint = 0, t_la:uint = t_cos.length;
						i < t_la; i++)
				{
					var t_co:CellObj = t_cos[i];
					var t_hn:uint = so.get_rhn(t_co.hn);
					var t_vn:uint = so.get_rvn(t_co.vn);
					var t_sn:uint = t_co.sn;
					CellWorker.stateChange(cellDic, t_hn, t_vn, t_sn);
				}
			}
		}
		

		// -
		public static const MOVE_DIR_LEFT:String = 'md_left';
		// -
		public static const MOVE_DIR_RIGHT:String = 'md_right';
		// -
		public static const MOVE_DIR_UP:String = 'md_up';
		// -
		public static const MOVE_DIR_DOWN:String = 'md_down';
		
		// -
		public static const ROTATE_DIR_LEFT:String = 'rd_left';
		// -
		public static const ROTATE_DIR_RIGHT:String = 'rd_right';
		
		
		
		
		// :: ShapeObj 이동 성공적으로 이동하면 성공된 so반환
		//		@Param(cellDic: CellDictionary, so: ShapeObj)
		public static function move(dir:String, cellDic:Object, so:ShapeObj):ShapeObj
		{
			var t_rv:ShapeObj = null;
			
			// - Original Shape Obj
			var t_oso:ShapeObj = so;
			// - New Shape Obj
			var t_nso:ShapeObj = t_oso.get_moveClone(dir);
			
			drawClear(cellDic, t_oso);
			if (get_isDraw(cellDic, t_nso))
			{
				draw(cellDic, t_nso);
				t_rv = t_nso;
			}
			else
			{
				draw(cellDic, t_oso);
				t_rv = t_oso;
			}		
			
			return t_rv;
		}
		

		// :: ShapeObj 회전 성공적으로 이동하면 성공된 so반환
		//		@Param(cellDic: CellDictionary, so: ShapeObj)
		public static function rotate(dir:String, cellDic:Object, so:ShapeObj):ShapeObj
		{
			var t_rv:ShapeObj = null;
			
			// - Original Shape Obj
			var t_oso:ShapeObj = so;
			// - New Shape Obj
			var t_nso:ShapeObj = t_oso.get_rotateClone(dir);

			drawClear(cellDic, t_oso);
			if (get_isDraw(cellDic, t_nso))
			{
				draw(cellDic, t_nso);
				t_rv = t_nso;
			}
			else
			{
				draw(cellDic, t_oso);
				t_rv = t_oso;
			}		
			
			return t_rv;
		}
	}
}
