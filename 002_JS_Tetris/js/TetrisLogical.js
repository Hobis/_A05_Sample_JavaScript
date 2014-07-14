if (window.$Adapter == undefined)
{
	window.$Adapter =
	{
		wrap: function(target, routine)
		{
			var t_func = function()
			{
				var t_target = arguments.callee.target;
				var t_routine = arguments.callee.routine;
				var t_param =  arguments.concat(
					window.$Adapter.p_getParam(arguments.callee.param, 0));

				return t_routine.apply(t_target, t_param);
			};

			t_func.target = target;
			t_func.routine = routine;
			t_func.param = this.p_getParam(arguments, 2);

			return t_func;
		},

		p_getParam: function(array, count)
		{
			var t_rv = [];

			if (array.length < count + 1)
				return t_rv;

			var t_la = array.length;
			var i;

			for (i = count; i < t_la; i ++)
			{
				t_rv.push(array[i]);
			}

			return t_rv;
		},

		remove: function(func)
		{
			var t_rv = (func instanceof Function) ? func : null;

			if (t_rv != null)
			{
				t_rv.target = null;
				t_rv.routine = null;
				t_rv.param = null;
				t_rv = null;
			}

			return t_rv;
		}
	};
};

// #
var Cell = function(w, h) {
	//
	var t_DIV_STR =
		'<div style="position: absolute; left: 0px; top: 0px; ' +
			'overflow: hidden; width: 18px; height: 18px; ' +
			'background-color: #ffffff; ' +
			'border: 1px solid #000066"></div>';
	// -
	this._rect = jQuery(t_DIV_STR);

	// -
	this.num = 0;

	// -
	this._stateNum = 0;
	// ::
	this.get_state = function() {
		return this._stateNum;
	};
	// ::
	this.set_state = function(v) {
		this._stateNum = v;
		this._rect.css('background-color', Cell._RECT_COLORS[this._stateNum]);
	};


	// ::
	this.get_x = function() {
		return parseInt(this._rect.css('left'));
	};
	// ::
	this.set_x = function(v) {
		this._rect.css('left', v + 'px');
	};

	// ::
	this.get_y = function() {
		return parseInt(this._rect.css('top'));
	};
	// ::
	this.set_y = function(v) {
		this._rect.css('top', v + 'px');
	};
};
Cell._RECT_COLORS = [
	0xffffff, 0xff0000, 0x33ff00, 0x00FF99, 0x3300ff, 0xff00cc, 0xffcc00, 0x0099ff
];

// #
var CellCanvas = function(owner) {

	// - Canvas 참조 jQuery객체
	this._owner = owner;

	// - Cell Dictionary
	this._cellDic = null;

	// - Canvas 넓이
	this._canvasWidth = this._owner.width();
	// - Canvas 높이
	this._canvasHeight = this._owner.height();

	// - CellDefaultWidth
	this._cdw = 20;
	// - CellDefaultHeight
	this._cdh = 20;

	// - CellBaseX
	this._cbx = 0;
	// - CellBaseY
	this._cby = 0;

	// - CellMarginRight
	this._cmr = 0;
	// - CellMarginBottom
	this._cmb = 0;

	// - HorizontalLength
	this._hl = Math.floor(this._canvasWidth / this._cdw);
	// - VerticalLength
	this._vl = Math.floor(this._canvasHeight / this._cdh);
	// - TotalLength
	this._tl = this._hl * this._vl;

	// - NowShapeObj
	this._nso = null;


	// :: Shape 제거
	this.shapeClear = function() {
	};

	// :: Shape 랜덤하기 생성
	this.shapeCreate = function() {
	};

	// :: Shape 이동
	this.shapeMove = function(dir) {
	};

	// :: Shape 회전
	this.shapeRotate = function(dir) {
	};

	// :: Cell들 생성
	this.p_cellsCreate = function() {
		//
		for (var i = 0; i < this._tl; i++) {
			var t_cell = new Cell(this._cdw, this._cdh);
			var t_cx = Math.floor(i % this._hl);
			var t_cy = Math.floor(i / this._hl);
			var t_tx = Math.round((this._cdw + this._cmr) * t_cx);
			var t_ty = Math.round((this._cdh + this._cmb) * t_cy);
			var t_rx = this._cbx + t_tx;
			var t_ry = this._cby + t_ty;
			t_cell.set_x(t_rx);
			t_cell.set_y(t_ry);
			this._owner.append(t_cell);

			t_cell.num = i + 1;//ThisNum
			t_cell.set_state(0);//StateNum

			if (this._cellDic == null) {
				this._cellDic = {};
			}
			var t_hn = t_cx + 1;
			var t_vn = t_cy + 1;
			var t_cName = 'cell_' + t_hn + '_' + t_vn;
			this._cellDic[t_cName] = t_cell;
		}
	};

	this.p_cellsCreate();
};


// #
var GameLogic = function(owner) {
	this._owner = owner;
	this._cc = new CellCanvas(this._owner);

	// ::
	this.p_intelDown = function() {
	};

	// ::
	this.p_newShapeStart = function() {
	};


	// ::
	this.p_keyDown = function(eObj) {
		//var t_to = window.GameLogic;
		alert(eObj.currentTarget);
		/*
		switch (eObj.keyCode) {
			case 37: {
				break;
			}

			case 39: {
				break;
			}
		}*/
	};

	//
	var t_keyDown = function(eObj) {
		var t_to = arguments.callee.d_to;

		switch (eObj.keyCode) {
			case 37: {
				break;
			}

			case 39: {
				break;
			}
		}
	};
	t_keyDown.d_to = this;
	jQuery(document).keydown(t_keyDown);





/*
	this._owner.stage.addEventListener(KeyboardEvent.KEY_DOWN, this.p_stage_keyDown);
	this._fpsTimer = new FPSTimer(40);
	this._fpsTimer.onCallBack = this.p_fpsTimer_onCallBack;

	this.p_newShapeStart();*/
};
