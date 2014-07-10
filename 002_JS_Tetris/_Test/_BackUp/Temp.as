﻿import flash.display.MovieClip;
import flash.events.KeyboardEvent;
import flash.ui.Keyboard;
import hb.utils.GeomUtil;

/**
	@Name: Tetris 인터페이스 정리
	@Author: HobisJung
	@Date: 2014-07-01
*/
// ::
function p_trace(msg:String):void
{
	var t_do:Object = this._dataObj;

	if (t_do.isLog)
	{
		trace('# [hb] ' + msg);
	}
}

// :: 캔버스 쉐이프오프젝트 회전 (90_Angle_Left)
function p_canvas_shapeObjRotate_left(oso:Object):void
{
}

// :: 캔버스 쉐이프오프젝트 회전 (90_Angle_Right)
function p_canvas_shapeObjRotate_right(oso:Object):void
{
}

// :: 캔버스 쉐이프오프젝트 이동 (Update) @Param(cso: CopyShapeObj, oso: OriginalShapeObj)
function p_canvas_shapeObjCheckUpdate(cso:Object, oso:Object):void
{
	p_canvas_shapeObjDraw_clear(oso);

	// 이동 가능
	if (p_canvas_getIsShapeObjDraw(cso))
	{
		oso.cos = cso.cos;
		p_canvas_shapeObjDraw(oso);
	}

	// 이동 불가
	else
	{
		p_canvas_shapeObjDraw(oso);
	}
}

// :: 캔버스 쉐이프오프젝트 이동 (Left) @Param(oso: OriginalShapeObj)
function p_canvas_shapeObjMove_left(oso:Object):void
{
	var t_cso:Object = p_canvas_shapeObjCopy(oso);
	var t_ccos:Array = t_cso.cos;
	for
	(
	 	var
			t_la:uint = t_ccos.length,
			i:uint = 0;
		i < t_la;
		i++
	)
	{
		var t_co:Object = t_ccos[i];
		t_co.hn -= 1;
		//p_canvas_cellObjPrint(t_co);
	}

	p_canvas_shapeObjCheckUpdate(t_cso, oso);
}

// :: 캔버스 쉐이프오프젝트 이동 (Right)
function p_canvas_shapeObjMove_right(oso:Object):void
{
	var t_cso:Object = p_canvas_shapeObjCopy(oso);
	var t_ccos:Array = t_cso.cos;
	for
	(
	 	var
			t_la:uint = t_ccos.length,
			i:uint = 0;
		i < t_la;
		i++
	)
	{
		var t_co:Object = t_ccos[i];
		t_co.hn += 1;
		//p_canvas_cellObjPrint(t_co);
	}

	p_canvas_shapeObjCheckUpdate(t_cso, oso);
}

// :: 캔버스 쉐이프오프젝트 이동 (Up)
function p_canvas_shapeObjMove_up(oso:Object):void
{
	var t_cso:Object = p_canvas_shapeObjCopy(oso);
	var t_ccos:Array = t_cso.cos;
	for
	(
	 	var
			t_la:uint = t_ccos.length,
			i:uint = 0;
		i < t_la;
		i++
	)
	{
		var t_co:Object = t_ccos[i];
		t_co.vn -= 1;
		//p_canvas_cellObjPrint(t_co);
	}

	p_canvas_shapeObjCheckUpdate(t_cso, oso);
}

// :: 캔버스 쉐이프오프젝트 이동 (Down)
function p_canvas_shapeObjMove_down(oso:Object):void
{
	var t_cso:Object = p_canvas_shapeObjCopy(oso);
	var t_ccos:Array = t_cso.cos;
	for
	(
	 	var
			t_la:uint = t_ccos.length,
			i:uint = 0;
		i < t_la;
		i++
	)
	{
		var t_co:Object = t_ccos[i];
		t_co.vn += 1;
		//p_canvas_cellObjPrint(t_co);
	}

	p_canvas_shapeObjCheckUpdate(t_cso, oso);
}

// :: 캔버스 쉐이프오프젝트 카피 @Param(oso: OriginalShapeObj)
function p_canvas_shapeObjCopy(oso:Object):Object
{
	var t_ocos:Array = oso.cos;
	var t_ccos:Array = [];
	for
	(
	 	var
			t_la:uint = t_ocos.length,
			i:uint = 0;
		i < t_la;
		i++
	)
	{
		var t_oco:Object = t_ocos[i];
		var t_cco:Object = p_canvas_cellObjCopy(t_oco);
		t_ccos.push(t_cco);
	}

	var t_cso:Object =
	{
		tn: oso.tn,
		cos: t_ccos
	};

	return t_cso;
}

// :: 캔버스 쉐이프오프젝트 표시해도 괜잖은지 확인
function p_canvas_getIsShapeObjDraw(so:Object):Boolean
{
	var t_rv:Boolean = false;

	var t_cos:Object = so.cos;
	var t_la:uint = t_cos.length;
	for (var i:uint = 0; i < t_la; i++)
	{
		var t_co:Object = t_cos[i];
		if (p_canvas_getIsCellState(t_co.hn, t_co.vn))
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

// :: 캔버스 쉐이프오브젝트 표시 해제
function p_canvas_shapeObjDraw_clear(so:Object):void
{
	var t_cos:Object = so.cos;
	var t_la:uint = t_cos.length;
	for (var i:uint = 0; i < t_la; i++)
	{
		var t_co:Object = t_cos[i];
		p_canvas_cellStateChange(t_co.hn, t_co.vn, 0);
	}
}

// :: 캔버스 쉐이프오브젝트 표시
function p_canvas_shapeObjDraw(so:Object):void
{
	// 표시할수 있음
	if (p_canvas_getIsShapeObjDraw(so))
	{
		var t_cos:Object = so.cos;
		var t_la:uint = t_cos.length;
		for (var i:uint = 0; i < t_la; i++)
		{
			var t_co:Object = t_cos[i];
			p_canvas_cellStateChange(t_co.hn, t_co.vn, t_co.sn);
		}
	}

	// 표시할수 없음
	else
	{

	}
}

// :: 캔버스 쉐이프오브젝트 생성 @Param(tn: TypeNum[1, 2, 3, 4, 5, 6, 7] 모두 7개 모양의 쉐이프)
function p_canvas_createShapeObj(tn:uint, dp:Object = null):Object
{
	if (dp == null)
	{
		dp = {hn: 3, vn: 0}
	}

	var t_so:Object = null;
	switch (tn)
	{
		case 1:
		{
			t_so =
			{
				tn: tn,
				cos:
				[
					p_canvas_createCellObj(dp.hn + 2, dp.vn + 1, tn),
					p_canvas_createCellObj(dp.hn + 2, dp.vn + 2, tn),
					p_canvas_createCellObj(dp.hn + 1, dp.vn + 3, tn),
					p_canvas_createCellObj(dp.hn + 2, dp.vn + 3, tn)
				],
				rn: 1
			};
			break;
		}
	}
	return t_so;
}

// :: 캔버스 셀오브젝트 보기 좋게 출력
function p_canvas_cellObjPrint(co:Object):void
{
	var t_str:String =
		'hn=' + co.hn + ', ' +
		'vn=' + co.hn + ', ' +
		'sn=' + co.hn;
	p_trace(t_str);
}

// :: 캔버스 셀오브젝트 카피
function p_canvas_cellObjCopy(co:Object):Object
{
	var t_rv:Object =
	{
		hn: co.hn,
		vn: co.vn,
		sn: co.sn
	};
	return t_rv;
}

// :: 캔버스 셀오브젝트 생성 (셀오브젝트는 실제 셀이 아닌 셀의 좌표와 상태정보만 가지고 있는 데이터 객체임)
function p_canvas_createCellObj(hn:uint, vn:uint, sn:uint = 0):Object
{
	var t_rv:Object =
	{
		hn: hn,//HorizontalNum(가로방향번호)
		vn: vn,//VerticalNum(세로방향번호)
		sn: sn
	};
	return t_rv;
}

// :: 캔버스 셀 축회전 (aco를 축으로 tco를 left 회전) @Param(aco: AxisCellObj, tco: TargetCellObj)
function p_canvas_cellObjAxisOfRotate_left(aco:Object, tco:Object):void
{
}

// :: 캔버스 셀 축회전 (aco를 축으로 tco를 left 회전) @Param(aco: AxisCellObj, tco: TargetCellObj)
function p_canvas_cellObjAxisOfRotate_right(aco:Object, tco:Object):void
{
}

// :: 캔버스 셀을 변경해도 괜잖은지 여부
function
(hn:uint, vn:uint):Boolean
{
	var t_rv:Boolean = false;

	var t_do:Object = this._dataObj;
	var t_cell:MovieClip = t_do.cellRefer['cell_' + hn + '_' + vn];
	if (t_cell != null)
	{
		if (t_cell.d_sn == 0)
		{
			t_rv = true;
		}
	}

	return t_rv;
}

// :: 캔버스 셀 상태변경 (CellPoint 사용)
function p_canvas_cellStateChange(hn:uint, vn:uint, sn:int):void
{
	var t_do:Object = this._dataObj;
	var t_cell:MovieClip = t_do.cellRefer['cell_' + hn + '_' + vn];
	if (t_cell != null)
	{
		t_cell.d_sn = sn;
		var t_fn:int = sn + 1;
		t_cell.gotoAndStop(t_fn);
	}
}

// :: 캔버스 셀 생성
function p_canvas_createCell():MovieClip
{
	var t_do:Object = this._dataObj;

	var t_cellProto:MovieClip = t_do.cellProto;
	var t_class:Class = t_cellProto.constructor;

	var t_rv:MovieClip = MovieClip(new t_class());
	return t_rv;
}

// :: 캔버스 셀들 생성
function p_canvas_createCells():void
{
	var t_do:Object = this._dataObj;
	var t_canvasCont:MovieClip = this.canvasCont_mc;
	var t_cellRefer:Object = {};
	t_do.cellRefer = t_cellRefer;

	for (var i:uint = 0; i < t_do.tl; i++)
	{
		var t_cell:MovieClip = p_canvas_createCell();
		var t_cx:uint = uint(i % t_do.hl);
		var t_cy:uint = uint(Math.floor(i / t_do.hl));
		var t_tx:Number = Math.round((t_do.cdw + t_do.cmr) * t_cx);
		var t_ty:Number = Math.round((t_do.cdh + t_do.cmb) * t_cy);
		var t_rx:Number = t_do.cbx + t_tx;
		var t_ry:Number = t_do.cby + t_ty;
		t_cell.x = t_rx;
		t_cell.y = t_ry;
		t_canvasCont.addChild(t_cell);
		t_cell.d_tn = i + 1;//ThisNum
		t_cell.d_sn = 0;//StateNum
		t_cell.gotoAndStop(t_cell.d_sn + 1);

		var t_hn:uint = t_cx + 1;
		var t_vn:uint = t_cy + 1;
		var t_cName:String = 'cell_' + t_hn + '_' + t_vn;
		t_cellRefer[t_cName] = t_cell;
	}
}

// :: 캔버스 초기화 한번
function p_canvas_init():void
{
	this._dataObj = {};

	var t_do:Object = this._dataObj;
	t_do.isLog = true;
	t_do.nowCellObj = null;

	var t_cellProto:MovieClip = this.canvasCont_mc.cellProto_mc;
	t_do.cellProto = t_cellProto;
	t_cellProto.visible = false;

	t_do.canvasWidth = 200;//CanvasWidth
	t_do.canvasHeight = 480;//CanvasHeight

	t_do.cdw = t_cellProto.width;//CellDefaultWidth
	t_do.cdh = t_cellProto.height;//CellDefaultHeight
	t_do.cbx = 0;//CellBaseX
	t_do.cby = 0;//CellBaseY
	t_do.cmr = 0;//CellMarginRight
	t_do.cmb = 0;//CellMarginBottom
	t_do.hl = uint(Math.floor(t_do.canvasWidth / t_do.cdw));//HorizontalLength
	t_do.vl = uint(Math.floor(t_do.canvasHeight / t_do.cdh));//VerticalLength
	t_do.tl = t_do.hl * t_do.vl;//TotalLength


	trace('가로방향 쎌개수(t_do.hl): ' + t_do.hl);
	trace('세로방향 쎌개수(t_do.vl): ' + t_do.vl);
	trace('전체 쎌개수(t_do.tl): ' + t_do.tl);



	p_canvas_createCells();

	//p_canvas_cellStateChange(5, 1, 2);

	t_do.nowCellObj = p_canvas_createShapeObj(1);

	p_canvas_shapeObjDraw(t_do.nowCellObj);

	//
	p_canvas_cellStateChange(5, 10, 2);
	p_canvas_cellStateChange(5, 11, 2);
	p_canvas_cellStateChange(6, 11, 2);


	p_canvas_cellStateChange(5, 23, 4);
	p_canvas_cellStateChange(6, 23, 4);
	p_canvas_cellStateChange(5, 24, 4);
	p_canvas_cellStateChange(6, 24, 4);




	this.stage.addEventListener(KeyboardEvent.KEY_DOWN,
		function(event:KeyboardEvent):void
		{
			switch (event.keyCode)
			{
				case Keyboard.LEFT:
				{
					p_canvas_shapeObjMove_left(t_do.nowCellObj);
					break;
				}

				case Keyboard.RIGHT:
				{
					p_canvas_shapeObjMove_right(t_do.nowCellObj);
					break;
				}

				case Keyboard.UP:
				{
					p_canvas_shapeObjMove_up(t_do.nowCellObj);
					break;
				}

				case Keyboard.DOWN:
				{
					p_canvas_shapeObjMove_down(t_do.nowCellObj);
					break;
				}

				case Keyboard.Z:
				{
					p_canvas_shapeObjRotate_right(t_do.nowCellObj);
					break;
				}

				case Keyboard.X:
				{
					break;
				}

				case Keyboard.C:
				{
					break;
				}
			}
		}
	);
}

var owner:MovieClip = this;
var _dataObj:Object = null;


p_canvas_init();

























































import flash.display.MovieClip;
import flash.events.KeyboardEvent;
import flash.ui.Keyboard;
import hb.utils.GeomUtil;

/**
	@Name: Tetris 인터페이스 정리
	@Author: HobisJung
	@Date: 2014-07-01
*/
// ::
function p_trace(msg:String):void
{
	var t_do:Object = this._dataObj;

	if (t_do.isLog)
	{
		trace('# [hb] ' + msg);
	}
}

// ::
function p_canvas_shapeObjUpdate_check():Boolean
{
	var t_rv:Boolean = false;
	return t_rv;
}

// :: 캔버스 쉐이프오브젝트 업데이트
function p_canvas_shapeObjUpdate(so:Object):void
{
	if (p_canvas_shapeObjUpdate_check())
	{
		var t_cos:Object = so.cos;
		var t_la:uint = t_cos.length;
		for (var i:uint = 0; i < t_la; i++) {
			var t_co:Object = t_cos[i];
			p_canvas_cellStateChange(t_co.hn, t_co.vn, t_co.sn);
		}
	}
	else
	{

	}
}

// :: 캔버스 쉐이프오브젝트 생성 @Param(tn: TypeNum[1, 2, 3, 4, 5, 6, 7] 모두 7개 모양의 쉐이프)
function p_canvas_createShapeObj(tn:uint, dp:Object = null):Object
{
	if (dp == null)
	{
		dp = {hn: 3, vn: 0}
	}

	var t_so:Object = null;
	switch (tn)
	{
		case 1:
		{
			t_so =
			{
				tn: tn,
				cos: [
					p_canvas_createCellObj(dp.hn + 2, dp.vn + 1, tn),
					p_canvas_createCellObj(dp.hn + 2, dp.vn + 2, tn),
					p_canvas_createCellObj(dp.hn + 1, dp.vn + 3, tn),
					p_canvas_createCellObj(dp.hn + 2, dp.vn + 3, tn)
				]
			};
			break;
		}
	}
	return t_so;
}

// :: 캔버스 셀오브젝트 생성 (셀오브젝트는 실제 셀이 아닌 셀의 좌표와 상태정보만 가지고 있는 데이터 객체임)
function p_canvas_createCellObj(hn:uint, vn:uint, sn:uint = 0):Object
{
	var t_co:Object =
	{
		hn: hn,//HorizontalNum(가로방향번호)
		vn: vn,//VerticalNum(세로방향번호)
		sn: sn
	};
	return t_co;
}

// :: 캔버스 셀 축회전 (ac를 축으로 tc를 left 회전) @Param(ac: AxisCell, tc: TargetCell)
function p_canvas_cellObjRotate_left(aco:Object, tco:Object):void
{
	var t_nd:Number = GeomUtil.getDistance(aco.hn, aco.vn, tco.hn, tco.vn);//NowDistance
	var t_nr:Number = GeomUtil.getRadian2(aco.hn, aco.vn, tco.hn, tco.vn);//NowRadian
	t_nr -= GeomUtil.getAToR(90);
	var t_rv:Object =
	{
		hn: uint(Math.ceil(aco.hn + GeomUtil.getX(t_nr, t_nd))),
		vn: uint(Math.ceil(aco.vn + GeomUtil.getY(t_nr, t_nd)))
	}
	//trace(t_rv.hn);
	//trace(t_rv.vn);
	p_canvas_cellMove(tco, t_rv);
}

// :: 캔버스 셀 축회전 (ac를 축으로 tc를 left 회전) @Param(ac: AxisCell, tc: TargetCell)
function p_canvas_cellObjRotate_right(aco:Object, tco:Object):void
{
	var t_nd:Number = GeomUtil.getDistance(aco.hn, aco.vn, tco.hn, tco.vn);//NowDistance
	var t_nr:Number = GeomUtil.getRadian2(aco.hn, aco.vn, tco.hn, tco.vn);//NowRadian
	t_nr += GeomUtil.getAToR(90);
	var t_rv:Object =
	{
		hn: uint(Math.ceil(aco.hn + GeomUtil.getX(t_nr, t_nd))),
		vn: uint(Math.ceil(aco.vn + GeomUtil.getY(t_nr, t_nd)))
	}
	//trace(t_rv.hn);
	//trace(t_rv.vn);
	p_canvas_cellMove(tco, t_rv);
}

// :: 캔버스 좌표값으로 쎌 위치 반환
function p_canvas_getCanvasPosToCellPos(cp:Object):Object
{
	var t_do:Object = this._dataObj;

	cp.x = Math.round(cp.x);
	cp.y = Math.round(cp.y);

	var t_cx:uint = uint(Math.floor(cp.x / t_do.cdw));
	var t_cy:uint = uint(Math.floor(cp.y / t_do.cdh));
	var t_hn:uint = t_cx + 1;
	var t_vn:uint = t_cy + 1;
	//trace('t_hn: ' + t_hn);
	//trace('t_vn: ' + t_vn);

	var t_rv:Object =
	{
		x: t_hn,
		y: t_vn
	};

	return t_rv;
}

// :: 캔버스 셀 이동 (Left)
function p_canvas_cellMove_left(co:Object):void
{
	var t_oco:Object = co;
	var t_mco:Object =
	{
		hn: t_oco.hn - 1,
		vn: t_oco.vn,
		sn: t_oco.sn
	};
	p_canvas_cellMove(t_oco, t_mco);
}

// :: 캔버스 셀 이동 (Right)
function p_canvas_cellMove_right(co:Object):void
{
	var t_oco:Object = co;
	var t_mco:Object =
	{
		hn: t_oco.hn + 1,
		vn: t_oco.vn,
		sn: t_oco.sn
	};
	p_canvas_cellMove(t_oco, t_mco);
}

// :: 캔버스 셀 이동 (Up)
function p_canvas_cellMove_up(co:Object):void
{
	var t_oco:Object = co;
	var t_mco:Object =
	{
		hn: t_oco.hn,
		vn: t_oco.vn - 1,
		sn: t_oco.sn
	};
	p_canvas_cellMove(t_oco, t_mco);
}

// :: 캔버스 셀 이동 (Down)
function p_canvas_cellMove_down(co:Object):void
{
	var t_oco:Object = co;
	var t_mco:Object =
	{
		hn: t_oco.hn,
		vn: t_oco.vn + 1,
		sn: t_oco.sn
	};
	p_canvas_cellMove(t_oco, t_mco);
}

// :: 캔버스 셀 이동 @Param(oco: OriginalCellObj, mco: MoveCellObj)
function p_canvas_cellMove(oco:Object, mco:Object):void
{
	var t_do:Object = this._dataObj;

	var t_cell:MovieClip = t_do.cellRefer['cell_' + mco.hn + '_' + mco.vn];
	if (t_cell != null)
	{
		if (p_canvas_getCellStateCheck(mco.hn, mco.vn))
		{
			p_canvas_cellStateChange(oco.hn, oco.vn, 0);
			oco.hn = mco.hn;
			oco.vn = mco.vn;
			p_canvas_cellStateChange(oco.hn, oco.vn, oco.sn);
		}
	}
}

// :: 캔버스 셀 상태확인
function p_canvas_getCellStateCheck(hn:uint, vn:uint):Boolean
{
	var t_rv:Boolean = false;

	var t_do:Object = this._dataObj;
	var t_cell:MovieClip = t_do.cellRefer['cell_' + hn + '_' + vn];
	if (t_cell != null)
	{
		if (t_cell.d_sn == 0)
		{
			t_rv = true;
		}
	}

	return t_rv;
}

// :: 캔버스 셀 상태변경 (CellPoint 사용)
function p_canvas_cellStateChange(hn:uint, vn:uint, sn:int):void
{
	var t_do:Object = this._dataObj;
	var t_cell:MovieClip = t_do.cellRefer['cell_' + hn + '_' + vn];
	if (t_cell != null)
	{
		t_cell.d_sn = sn;
		var t_fn:int = sn + 1;
		t_cell.gotoAndStop(t_fn);
	}
}

// :: 캔버스 셀 생성
function p_canvas_createCell():MovieClip
{
	var t_do:Object = this._dataObj;

	var t_cellProto:MovieClip = t_do.cellProto;
	var t_class:Class = t_cellProto.constructor;

	var t_rv:MovieClip = MovieClip(new t_class());
	return t_rv;
}

// :: 캔버스 셀들 생성
function p_canvas_createCells():void
{
	var t_do:Object = this._dataObj;
	var t_canvasCont:MovieClip = this.canvasCont_mc;
	var t_cellRefer:Object = {};
	t_do.cellRefer = t_cellRefer;

	for (var i:uint = 0; i < t_do.tl; i++)
	{
		var t_cell:MovieClip = p_canvas_createCell();
		var t_cx:uint = uint(i % t_do.hl);
		var t_cy:uint = uint(Math.floor(i / t_do.hl));
		var t_tx:Number = Math.round((t_do.cdw + t_do.cmr) * t_cx);
		var t_ty:Number = Math.round((t_do.cdh + t_do.cmb) * t_cy);
		var t_rx:Number = t_do.cbx + t_tx;
		var t_ry:Number = t_do.cby + t_ty;
		t_cell.x = t_rx;
		t_cell.y = t_ry;
		t_canvasCont.addChild(t_cell);
		t_cell.d_tn = i + 1;//ThisNum
		t_cell.d_sn = 0;//StateNum
		t_cell.gotoAndStop(t_cell.d_sn + 1);

		var t_hn:uint = t_cx + 1;
		var t_vn:uint = t_cy + 1;
		var t_cName:String = 'cell_' + t_hn + '_' + t_vn;
		t_cellRefer[t_cName] = t_cell;
	}
}

// :: 캔버스 초기화 한번
function p_canvas_init():void
{
	this._dataObj = {};

	var t_do:Object = this._dataObj;

	var t_cellProto:MovieClip = this.canvasCont_mc.cellProto_mc;
	t_do.cellProto = t_cellProto;
	t_cellProto.visible = false;

	t_do.canvasWidth = 200;//CanvasWidth
	t_do.canvasHeight = 400;//CanvasHeight

	t_do.cdw = t_cellProto.width;//CellDefaultWidth
	t_do.cdh = t_cellProto.height;//CellDefaultHeight
	t_do.cbx = 0;//CellBaseX
	t_do.cby = 0;//CellBaseY
	t_do.cmr = 0;//CellMarginRight
	t_do.cmb = 0;//CellMarginBottom
	t_do.hl = int(Math.floor(t_do.canvasWidth / t_do.cdw));//HorizontalLength
	t_do.vl = int(Math.floor(t_do.canvasHeight / t_do.cdh));//VerticalLength
	t_do.tl = t_do.hl * t_do.vl;//TotalLength


	trace('가로방향 쎌개수(t_do.hl): ' + t_do.hl);
	trace('세로방향 쎌개수(t_do.vl): ' + t_do.vl);
	trace('전체 쎌개수(t_do.tl): ' + t_do.tl);

	p_canvas_createCells();




	p_canvas_shapeObjUpdate(p_canvas_createShapeObj(1));



/*
	//
	var t_aco:Object = p_canvas_createCellObj(2, 2);

	var t_co:Object = null;
	t_co = p_canvas_createCellObj(1, 1, 4);
	p_canvas_cellStateChange(t_co.hn, t_co.vn, t_co.sn);
	p_canvas_cellObjRotate_right(t_aco, t_co);
	t_co = p_canvas_createCellObj(1, 2, 4);
	p_canvas_cellStateChange(t_co.hn, t_co.vn, t_co.sn);
	p_canvas_cellObjRotate_right(t_aco, t_co);
	t_co = p_canvas_createCellObj(2, 2, 4);
	p_canvas_cellStateChange(t_co.hn, t_co.vn, t_co.sn);
	p_canvas_cellObjRotate_right(t_aco, t_co);
	t_co = p_canvas_createCellObj(2, 3, 4);
	p_canvas_cellStateChange(t_co.hn, t_co.vn, t_co.sn);
	p_canvas_cellObjRotate_right(t_aco, t_co);*/



	//
	//_dataObj.co = {hn: 1, vn: 1, sn: 7};
	//p_canvas_cellStateChange(_dataObj.co.hn, _dataObj.co.vn, _dataObj.co.sn);
	//p_canvas_getCanvasPosToCellPos({x: canvasCont_mc.t_1.x, y: canvasCont_mc.t_1.y});
	//canvasCont_mc.setChildIndex(canvasCont_mc.t_1, canvasCont_mc.numChildren - 1);
/*
	this.stage.addEventListener(KeyboardEvent.KEY_DOWN,
		function(event:KeyboardEvent):void
		{
			var t_aco:Object = null;

			switch (event.keyCode)
			{
				case Keyboard.LEFT:
				{
					p_canvas_cellMove_left(_dataObj.co);
					break;
				}

				case Keyboard.RIGHT:
				{
					p_canvas_cellMove_right(_dataObj.co);
					break;
				}

				case Keyboard.UP:
				{
					p_canvas_cellMove_up(_dataObj.co);

					break;
				}

				case Keyboard.DOWN:
				{
					p_canvas_cellMove_down(_dataObj.co);
					break;
				}

				case Keyboard.Z:
				{
					t_aco =
					{
						hn: _dataObj.co.hn,
						vn: _dataObj.co.vn + 1
					};
					p_canvas_cellObjRotate_left(t_aco, _dataObj.co);
					break;
				}

				case Keyboard.X:
				{
					t_aco =
					{
						hn: _dataObj.co.hn,
						vn: _dataObj.co.vn + 1
					};
					p_canvas_cellObjRotate_right(t_aco, _dataObj.co);
					break;
				}
			}
		}
	);
	*/
}

var owner:MovieClip = this;
var _dataObj:Object = null;


p_canvas_init();

