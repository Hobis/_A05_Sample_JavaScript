package
{
	import flash.display.MovieClip;
	import hb.utils.NumberUtil;


	public class CellCanvas
	{
		// :: 생성자
		public function CellCanvas(owner:MovieClip)
		{
			this._owner = owner;
			this._canvasWidth = this._owner.width;
			this._canvasHeight = this._owner.height;
			this._cellProto = this._owner.cellProto_mc;
			this._cdw = this._cellProto.width;
			this._cdh = this._cellProto.height;

			this.p_initOnce();
		}


		// - Canvas 참조
		private var _owner:MovieClip = null;

		// - Cell 원형
		private var _cellProto:MovieClip = null;

		// - Cell Dictionary
		private var _cellDic:Object = null;

		// - Canvas 넓이
		private var _canvasWidth:Number;
		// - Canvas 높이
		private var _canvasHeight:Number;

		// - CellDefaultWidth
		private var _cdw:Number;
		// - CellDefaultHeight
		private var _cdh:Number;

		// - CellBaseX
		private var _cbx:Number = 0;
		// - CellBaseY
		private var _cby:Number = 0;

		// - CellMarginRight
		private var _cmr:Number = 0;
		// - CellMarginBottom
		private var _cmb:Number = 0;

		// - HorizontalLength
		private var _hl:uint;
		// - VerticalLength
		private var _vl:uint;
		// - TotalLength
		private var _tl:uint;
		
		// - NowShapeObj
		private var _nso:ShapeObj = null;


		// :: Shape 제거
		public function shapeClear():void
		{
			if (this._nso != null)
			{
				this._nso = null;
			}
		}

		// :: Shape 랜덤하기 생성
		public function shapeCreate():Boolean
		{			
			var t_ri:uint = NumberUtil.randRange(1, ShapeData.TYPES.length);
			var t_so:ShapeObj = new ShapeObj(t_ri, 4, 1);
			
			var t_rv:Boolean = ShapeWorker.draw(this._cellDic, t_so);
			
			if (t_rv)
			{
				this.shapeClear();
				this._nso = t_so;
			}			
			
			return t_rv;
		}

		// :: Shape 이동
		public function shapeMove(dir:String):Boolean
		{
			var t_rv:Boolean = false;
			
			if (this._nso != null)
			{
				var t_so:ShapeObj = ShapeWorker.move(dir, this._cellDic, this._nso);
				if (t_so != this._nso)
				{
					this._nso = t_so;
					t_rv = true;
				}
			}
			
			return t_rv;
		}
		
		// :: Shape 회전
		public function shapeRotate(dir:String):Boolean
		{			
			var t_rv:Boolean = false;
			
			if (this._nso != null)
			{
				var t_so:ShapeObj = ShapeWorker.rotate(dir, this._cellDic, this._nso);
				if (t_so != this._nso)
				{
					this._nso = t_so;
					t_rv = true;
				}
			}
			
			return t_rv;			
		}


		// :: 한번만 초기화
		private function p_initOnce():void
		{
			this._hl = uint(Math.floor(this._canvasWidth / this._cdw));
			this._vl = uint(Math.floor(this._canvasHeight / this._cdh));
			this._tl = this._hl * this._vl;
			this.p_cellsCreate();
		}

		// :: Cell 생성
		private function p_cellCreate():MovieClip
		{
			var t_class:Class = this._cellProto.constructor;
			var t_rv:MovieClip = MovieClip(new t_class());
			return t_rv;
		}

		// :: Cells 생성
		private function p_cellsCreate():void
		{
			this._cellDic = {};
			for (var i:uint = 0; i < this._tl; i++)
			{
				var t_cell:MovieClip = p_cellCreate();
				var t_cx:uint = uint(i % this._hl);
				var t_cy:uint = uint(Math.floor(i / this._hl));
				var t_tx:Number = Math.round((this._cdw + this._cmr) * t_cx);
				var t_ty:Number = Math.round((this._cdh + this._cmb) * t_cy);
				var t_rx:Number = this._cbx + t_tx;
				var t_ry:Number = this._cby + t_ty;
				t_cell.x = t_rx;
				t_cell.y = t_ry;
				this._owner.addChild(t_cell);

				t_cell.d_tn = i + 1;//ThisNum
				t_cell.d_sn = 0;//StateNum
				t_cell.gotoAndStop(1);


				var t_hn:uint = t_cx + 1;
				var t_vn:uint = t_cy + 1;
				var t_cName:String = 'cell_' + t_hn + '_' + t_vn;
				this._cellDic[t_cName] = t_cell;
			}
		}
	}
}
