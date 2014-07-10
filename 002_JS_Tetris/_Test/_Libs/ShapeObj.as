package
{
	public class ShapeObj
	{
		// :: ShapeObj 생성 @Param(tn: TypeNum[1, 2, 3, 4, 5, 6, 7] 모두 7개 모양의 쉐이프, dp: DefaultPosition)
		public function ShapeObj(typeNum:uint, hn:uint, vn:uint, ri:uint = 0)
		{
			this._typeNum = typeNum;
			this._hn = hn;
			this._vn = vn;
			this._ri = ri;
			this._cellObjs = ShapeData['TYPE_' + this._typeNum][this._ri];
		}
		
		// - TypeNum
		private var _typeNum:uint;
		
		// - BaseHorizontalNum
		private var _hn:uint;
		public function get_hn():uint
		{
			return this._hn;
		}
		public function set_hn(n:uint):void
		{
			this._hn = n;
		}
		
		// - BaseVerticlaNum
		private var _vn:uint;
		public function get_vn():uint
		{
			return this._vn;
		}
		public function set_vn(n:uint):void
		{
			this._vn = n;
		}
		
		// - RotateIndex
		private var _ri:uint = 0;
		// - CellObjs 참조
		private var _cellObjs:Array = null;
		public function get_cellObjs():Array
		{
			return this._cellObjs;
		}
		
		// :: Real Horizontal Num
		public function get_rhn(hn:uint):uint
		{
			return (this._hn - 1) + hn;
		}
		
		// :: Real Vertical Num
		public function get_rvn(vn:uint):uint
		{
			return (this._vn - 1) + vn;
		}
		
		
		// :: 출력
		public function toString():String
		{
			var t_str:String =
				'typeNum=' + this._typeNum + ', ' +
				'hn=' + this._hn + ', ' +
				'vn=' + this._vn + ', ' +
				'ri=' + this._ri + '\n';
			for (var
				 	i:uint = 0,
				 	t_la:uint = this._cellObjs.length;
				 i < t_la; i++)
			{
				var t_co:CellObj = this._cellObjs[i];
				t_str += '	co_' + i + ': ' + t_co.toString() + '\n';
			}
			
			return t_str;
		}
		
		// :: 복제
		public function clone():ShapeObj
		{
			var t_rv:ShapeObj = new ShapeObj(
								this._typeNum,
								this._hn, this._vn, this._ri)
			return t_rv;
		}
		
		
		// ::
		public function get_moveClone(dir:String):ShapeObj
		{
			var t_rv:ShapeObj = this.clone();
			
			switch (dir)
			{
				case ShapeWorker.MOVE_DIR_LEFT:
				{
					t_rv._hn -= 1;
					break;
				}
				
				case ShapeWorker.MOVE_DIR_RIGHT:
				{
					t_rv._hn += 1;
					break;
				}
				
				case ShapeWorker.MOVE_DIR_UP:
				{
					t_rv._vn -= 1;
					break;
				}
				
				case ShapeWorker.MOVE_DIR_DOWN:
				{
					t_rv._vn += 1;
					break;
				}				
			}
			
			return t_rv;			
		}
		
		// ::
		public function get_rotateClone(dir:String):ShapeObj
		{
			var t_rv:ShapeObj = this.clone();
			
			var t_typeArr:Array = ShapeData['TYPE_' + this._typeNum];
			switch (dir)
			{
				case ShapeWorker.ROTATE_DIR_LEFT:
				{
					if (this._ri > 0)
						this._ri--;
					else
						this._ri = t_typeArr.length - 1;
					this._cellObjs = t_typeArr[this._ri];
					//trace('this._ri: ' + this._ri);
					break;
				}
				
				case ShapeWorker.ROTATE_DIR_RIGHT:
				{
					if (this._ri < (t_typeArr.length - 1))
						this._ri++;
					else
						this._ri = 0;
					this._cellObjs = t_typeArr[this._ri];
					//trace('this._ri: ' + this._ri);
					break;
				}
			}
			
			return t_rv;			
		}		
	}
}
