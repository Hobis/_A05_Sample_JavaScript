package
{
	import flash.display.MovieClip;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;

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



		// :: 한번만 초기화
		private function p_initOnce():void
		{
			this._hl = uint(Math.floor(this._canvasWidth / this._cdw));
			this._vl = uint(Math.floor(this._canvasHeight / this._cdh));
			this._tl = this._hl * this._vl;
			this.p_cellsCreate();
			
			
			this._nso = new ShapeObj(1, 2, 1);
			ShapeWorker.draw(this._cellDic, this._nso);
			
			
			
			//			
			this._owner.stage.addEventListener(KeyboardEvent.KEY_DOWN,
				function(event:KeyboardEvent):void
				{
					switch (event.keyCode)
					{
						case Keyboard.LEFT:
						{
							p_shapeMove(ShapeWorker.MOVE_DIR_LEFT);
							break;
						}
		
						case Keyboard.RIGHT:
						{
							p_shapeMove(ShapeWorker.MOVE_DIR_RIGHT);
							break;
						}
		
						case Keyboard.UP:
						{
							p_shapeMove(ShapeWorker.MOVE_DIR_UP);
							break;
						}
		
						case Keyboard.DOWN:
						{
							p_shapeMove(ShapeWorker.MOVE_DIR_DOWN);
							break;
						}
		
						case Keyboard.Z:
						{
							p_shapeRotate(ShapeWorker.ROTATE_DIR_LEFT);
							break;
						}
		
						case Keyboard.X:
						{
							break;
						}
		
						case Keyboard.C:
						{
							p_shapeRotate(ShapeWorker.ROTATE_DIR_RIGHT);
							break;
						}
					}
				}
			);		
		}
		
		// ::
		private function p_shapeMove(dir:String):void
		{
			this._nso = ShapeWorker.move(dir, this._cellDic, this._nso);
		}
		
		// ::
		private function p_shapeRotate(dir:String):void
		{
			this._nso = ShapeWorker.rotate(dir, this._cellDic, this._nso);
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
