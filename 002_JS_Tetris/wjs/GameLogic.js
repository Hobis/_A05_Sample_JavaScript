// # GameLogic Class
(function() {

	// #
	HB_Class.create_i('GameLogic', {

		// :: 초기화
		p_initOnce: function(owner) {
			this._owner = owner;
			this._cc = new CellCanvas(this._owner);
			this._downSpeed = 1000;

			jQuery(document).keydown(HB_Adapter.wrap(this, this.p_keyDown));
			this._timer = new HB_Timer(this._downSpeed);
			this._timer.onCallBack = HB_Adapter.wrap(this, this.p_timer_onCallBack);

			this.p_newShapeStart();
		}

		,
		keyGo: function(keyCode) {
			this.p_keyDown({keyCode: keyCode});
		}

		,
		p_keyDown: function(eObj) {

			switch (eObj.keyCode) {
				// Key_Left
				case 37: {
					this._cc.shapeMove(ShapeWorker.MOVE_DIR_LEFT);
					break;
				}

				// Key_Right
				case 39: {
					this._cc.shapeMove(ShapeWorker.MOVE_DIR_RIGHT);
					break;
				}

				// Key_Up
				case 38: {
					//this._cc.shapeMove(ShapeWorker.MOVE_DIR_UP);
					this._cc.shapeRotate(ShapeWorker.ROTATE_DIR_RIGHT);
					break;
				}

				// Key_Down
				case 40: {
					this.p_intelDown();
					//this._cc.shapeMove(ShapeWorker.MOVE_DIR_DOWN);
					break;
				}

				// Key_Z
				case 90: {
					this._cc.shapeRotate(ShapeWorker.ROTATE_DIR_LEFT);
					break;
				}

				// Key_X
				case 88: {
					this.p_endDown();
					break;
				}

				// Key_C
				case 67: {
					this._cc.shapeRotate(ShapeWorker.ROTATE_DIR_RIGHT);
					break;
				}
			}
		}

		,
		p_timer_onCallBack: function(eObj) {
			switch (eObj.type) {
				case HB_Timer.EVENT_TYPE_UPDATE: {
					this.p_intelDown();

					break;
				}

				case HB_Timer.EVENT_TYPE_UPDATE_END: {

					break;
				}
			}
		}

		,
		// ::
		p_intelDown: function() {
			if (this._cc.shapeMove(ShapeWorker.MOVE_DIR_DOWN)) {
				this._timer.stop();
				this._timer.start();
			}
			else {
				this.p_newShapeStart();
			}
		}

		,
		// ::
		p_endDown: function() {
			this._timer.stop();
			this._timer.start();

			while (true) {
				if (this._cc.shapeMove(ShapeWorker.MOVE_DIR_DOWN)) {
				}
				else {
					this.p_newShapeStart();
					break;
				}
			}
		}

		,
		// ::
		p_newShapeStart: function() {
			this._cc.clearLineCheck();
			this._cc.shapeCreate();
			this._timer.reset();
			this._timer.start();
		}

	});

})();


// # CellCanvas Class
(function() {

	// #
	HB_Class.create_i('CellCanvas', {

		// :: 초기화
		p_initOnce: function(owner) {
			// - Canvas 참조
			this._owner = owner;

			// - Cell Dictionary
			this._cellDic = null;

			// - Canvas 넓이
			this._canvasWidth = parseInt(this._owner.css('width'));
			// - Canvas 높이
			this._canvasHeight = parseInt(this._owner.css('height'));

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

			this.p_cellsCreate();
		}

		,
		// :: Cell 생성
		p_cellCreate: function() {
			var t_cell = new Cell(this._cdw, this._cdh);
			return t_cell;
		}

		,
		// :: Cells 생성
		p_cellsCreate: function() {

			this._cellDic = {};
			for (var i = 0; i < this._tl; i++) {
				var t_cell = this.p_cellCreate();
				var t_cx = i % this._hl;
				var t_cy = Math.floor(i / this._hl);
				var t_tx = Math.round((this._cdw + this._cmr) * t_cx);
				var t_ty = Math.round((this._cdh + this._cmb) * t_cy);
				var t_rx = this._cbx + t_tx;
				var t_ry = this._cby + t_ty;
				t_cell.set_x(t_rx);
				t_cell.set_y(t_ry);
				this._owner.append(t_cell.get_rect());

				t_cell.num = i + 1;//ThisNum
				t_cell.set_state(0);//StateNum

				var t_hn = t_cx + 1;
				var t_vn = t_cy + 1;
				var t_cName = 'cell_' + t_hn + '_' + t_vn;
				this._cellDic[t_cName] = t_cell;
			}
		}

		,
		// :: Shape 제거
		shapeClear: function() {
			if (this._nso != null) {
				this._nso = null;
			}
		}

		,
		// :: Shape 랜덤하기 생성
		shapeCreate: function() {
			var t_ri = HB_Number.randRange(1, ShapeData.TYPES.length);
			var t_so = new ShapeObj(t_ri, 4, 1);

			var t_rv = ShapeWorker.draw(this._cellDic, t_so);

			if (t_rv) {
				this.shapeClear();
				this._nso = t_so;
			}

			return t_rv;
		}

		,
		// :: Shape 이동
		shapeMove: function(dir) {
			var t_rv = false;

			if (this._nso != null) {
				var t_so = ShapeWorker.move(dir, this._cellDic, this._nso);
				if (t_so != this._nso) {
					this._nso = t_so;
					t_rv = true;
				}
			}

			return t_rv;
		}

		,
		// :: Shape 회전
		shapeRotate: function(dir) {
			var t_rv = false;

			if (this._nso != null) {
				var t_so = ShapeWorker.rotate(dir, this._cellDic, this._nso);
				if (t_so != this._nso) {
					this._nso = t_so;
					t_rv = true;
				}
			}

			return t_rv;
		}

		,
		// ::
		p_clearAfterDown: function(ej) {
			if (ej > -1) {
				for (var i = ej; i > 0; i--) {
					//var t_hn = i + 1;
					//var t_vn = j + 1;
					//var t_cName = 'cell_' + t_hn + '_' + t_vn;
					//t_cell = this._cellDic[t_cName];
					//t_cell.moveDown();
				}
			}
		}

		,
		// ::
		p_clearLine: function(j) {
			for (var i = 0; i < this._hl; i++) {
				var t_hn = i + 1;
				var t_vn = j + 1;
				var t_cName = 'cell_' + t_hn + '_' + t_vn;
				t_cell = this._cellDic[t_cName];
				t_cell.set_state(0);
			}
		}

		,
		// ::
		clearLineCheck: function() {
			var t_ej = -1;
			for (var j = 0; j < this._vl; j++) {
				var t_b = false;
				for (var i = 0; i < this._hl; i++) {
					var t_hn = i + 1;
					var t_vn = j + 1;
					var t_cName = 'cell_' + t_hn + '_' + t_vn;
					t_cell = this._cellDic[t_cName];
					if (t_cell.get_state() > 0) {
						t_b = true;
					}
					else {
						t_b = false;
						break;
					}
				}

				if (t_b) {
					this.p_clearLine(j);
					t_ej = j;
				}
			}

			this.p_clearAfterDown(t_ej);
		}

	});

})();

// # Cell Class
(function() {

	// #
	var t_class = HB_Class.create_i('Cell', {

		// :: 초기화
		p_initOnce: function(w, h) {
			//
			var t_DIV_STR =
				'<div style="position: absolute; left: 0px; top: 0px; ' +
					'overflow: hidden;"></div>';

			this._rect = jQuery(t_DIV_STR);
			this._rect.css('background-color', Cell._RECT_COLORS[0]);
			this._rect.css('width', (w - 2) + 'px');
			this._rect.css('height', (h - 2) + 'px');

			this._stateNum = 0;
		}

		,
		// ::
		get_rect: function() {
			return this._rect;
		}

		,
		// ::
		get_state: function() {
			return this._stateNum;
		}
		,
		// ::
		set_state: function(v) {
			this._stateNum = v;
			this._rect.css('background-color', Cell._RECT_COLORS[this._stateNum]);
		}


		,
		// ::
		get_x: function() {
			var t_v = parseInt(this._rect.css('left'));
			return t_v;
		}
		,
		// ::
		set_x: function(v) {
			this._rect.css('left', v + 'px');
		}

		,
		// ::
		get_y: function() {
			var t_v = parseInt(this._rect.css('top'));
			return t_v;
		}
		,
		// ::
		set_y: function(v) {
			this._rect.css('top', v + 'px');
		}

	});

	// -
	t_class._RECT_COLORS = [
		'#b4b4b4', '#ff0000', '#33ff00', '#00FF99', '#3300ff', '#ff00cc', '#ffcc00', '#0099ff'
	];

})();


// # CellObj Class
(function() {

	// #
	var t_class = HB_Class.create_i('CellObj', {

		// :: 초기화
		p_initOnce: function(hn, vn, sn) {
			this.hn = hn;
			this.vn = vn;
			this.sn = sn;
		}

		,
		// :: 출력
		toString: function() {
			var t_str =
				'hn=' + this.hn + ', ' +
				'vn=' + this.vn + ', ' +
				'sn=' + this.sn;
			return t_str;
		}

		,
		// :: 복제
		clone: function() {
			var t_rv = new CellObj(this.hn, this.vn, this.sn);
			return t_rv;
		}

	});

})();


// # CellWorker Class
(function() {

	// #
	var t_class = HB_Class.create_s('CellWorker', {

		// :: Cell 찾기
		get_cell: function(cellDic, hn, vn) {
			var t_rv = cellDic['cell_' + hn + '_' + vn];
			return t_rv;
		}

		,
		// :: Cell 상태가 변경할수 있는 상태인지 여부
		//		@Param(cellDic: CellDictionaryObject, hn: HorizontalNum, vn: VerticalNum)
		get_isState: function(cellDic, hn, vn) {
			var t_rv = false;

			var t_cell = this.get_cell(cellDic, hn, vn);
			if (t_cell != null) {
				if (t_cell.get_state() == 0) {
					t_rv = true;
				}
			}

			return t_rv;
		}

		,
		// :: Cell 상태 변경 (CellPoint 사용)
		//		@Param(cellDic: CellDictionaryObject, hn: HorizontalNum, vn: VerticalNum, sn: StateNum)
		stateChange: function(cellDic, hn, vn, sn) {
			var t_cell = this.get_cell(cellDic, hn, vn);
			if (t_cell != null) {
				t_cell.set_state(sn);
			}
		}

	});

})();


// # ShapeData Class
(function() {

	// #
	var t_class = HB_Class.create_s('ShapeData', {

		// ::
		p_get_sweetData: function(source, sn) {
			var t_rv = null;

			for (
				var
					t_sps = source.split('-'),
					t_la = t_sps.length,
					i = 0;
				i < t_la; i++
			) {
				var t_sp = t_sps[i];
				var t_lb = t_sp.length;
				for (var j = 0; j < t_lb; j++) {
					var t_ab = t_sp.charAt(j);
					if (t_ab == 'o') {
						var t_hn = j + 1;
						var t_vn = i + 1;
						var t_co = new CellObj(j + 1, i + 1, sn);

						if (t_rv == null) {
							t_rv = [];
						}
						t_rv.push(t_co);
					}
				}
			}

			return t_rv;
		}

		,
		// ::
		p_get_sweetData_all: function() {
			var t_rv = null;

			for (var t_la = this.TYPE_SOURCES.length,
					i = 0;
					i < t_la; i++) {
				var t_rvs = null;

				var t_ts = this.TYPE_SOURCES[i];
				for (var t_lb = t_ts.length,
					j = 0;
					j < t_lb; j++) {
					var t_ti = t_ts[j];

					if (t_rvs == null) {
						t_rvs = [];
					}
					t_rvs.push(this.p_get_sweetData(t_ti, i + 1));
				}

				if (t_rv == null) {
					t_rv = [];
				}
				t_rv.push(t_rvs);
			}

			return t_rv;
		}

		,
		// - 데이터 소스 이거만 수정하면 됨 (3차원 행렬)
		TYPE_SOURCES: [
		 	// Type 1
			[
				'xxxx-' +
				'oooo-' +
				'xxxx-' +
				'xxxx-'

				,
				'xoxx-' +
				'xoxx-' +
				'xoxx-' +
				'xoxx-'
			]

			,
			// Type 2
			[
				'xxx-' +
				'ooo-' +
				'xox-'

				,
				'xox-' +
				'oox-' +
				'xox-'

				,
				'xxx-' +
				'xox-' +
				'ooo-'

				,
				'xox-' +
				'xoo-' +
				'xox-'
			]

			,
			// Type 3
			[
				'xxx-' +
				'ooo-' +
				'oxx-'

				,
				'oox-' +
				'xox-' +
				'xox-'

				,
				'xxx-' +
				'xxo-' +
				'ooo-'

				,
				'xox-' +
				'xox-' +
				'xoo-'
			]

			,
			// Type 4
			[
				'xxx-' +
				'ooo-' +
				'xxo-'

				,
				'xox-' +
				'xox-' +
				'oox-'

				,
				'xxx-' +
				'oxx-' +
				'ooo-'

				,
				'xoo-' +
				'xox-' +
				'xox-'
			]

			,
			// Type 5
			[
				'xxx-' +
				'xoo-' +
				'oox-'

				,
				'oxx-' +
				'oox-' +
				'xox-'
			]

			,
			// Type 6
			[
				'xxx-' +
				'oox-' +
				'xoo-'

				,
				'xxo-' +
				'xoo-' +
				'xox-'
			]

			,
			// Type 7
			[
				'oo-' +
				'oo-'
			]
		]

	});

	t_class.TYPES = t_class.p_get_sweetData_all();

})();


// # ShapeObj Class
(function() {

	// #
	var t_class = HB_Class.create_i('ShapeObj', {

		// :: 초기화
		p_initOnce: function(typeNum, hn, vn, ri) {
			// - TypeNum
			this._typeNum = typeNum;

			// - BaseHorizontalNum
			this._hn = hn;

			// - BaseVerticlaNum
			this._vn = vn;

			// - RotateIndex
			this._ri = (ri != undefined) ? ri : 0;

			// - CellObjs 참조
			this._cellObjs = ShapeData.TYPES[this._typeNum - 1][this._ri];
		}

		,
		get_hn: function() {
			return this._hn;
		}
		,
		set_hn: function(n) {
			this._hn = n;
		}

		,
		get_vn: function() {
			return this._vn;
		}
		,
		set_vn: function(n) {
			this._vn = n;
		}

		,
		get_cellObjs: function() {
			return this._cellObjs;
		}

		,
		// :: Real Horizontal Num
		get_rhn: function(hn) {
			return (this._hn - 1) + hn;
		}

		,
		// :: Real Vertical Num
		get_rvn: function(vn) {
			return (this._vn - 1) + vn;
		}

		,
		// :: 출력
		toString: function() {
			var t_str =
				'typeNum=' + this._typeNum + ', ' +
				'hn=' + this._hn + ', ' +
				'vn=' + this._vn + ', ' +
				'ri=' + this._ri + '\n';
			for (var
				 	i = 0,
				 	t_la = this._cellObjs.length;
				 i < t_la; i++) {
				var t_co = this._cellObjs[i];
				t_str += '	co_' + i + ': ' + t_co.toString() + '\n';
			}

			return t_str;
		}

		,
		// :: 복제
		clone: function() {
			var t_rv = new ShapeObj(
							this._typeNum,
							this._hn, this._vn, this._ri);
			return t_rv;
		}

		,
		// ::
		get_moveClone: function(dir) {
			var t_so = this.clone();

			switch (dir) {
				case ShapeWorker.MOVE_DIR_LEFT: {
					t_so._hn -= 1;
					break;
				}

				case ShapeWorker.MOVE_DIR_RIGHT: {
					t_so._hn += 1;
					break;
				}

				case ShapeWorker.MOVE_DIR_UP: {
					t_so._vn -= 1;
					break;
				}

				case ShapeWorker.MOVE_DIR_DOWN: {
					t_so._vn += 1;
					break;
				}
			}

			return t_so;
		}

		,
		// ::
		get_rotateClone: function(dir) {
			var t_so = this.clone();

			var t_typeArr = ShapeData.TYPES[this._typeNum - 1];
			switch (dir) {
				case ShapeWorker.ROTATE_DIR_LEFT: {
					if (t_so._ri > 0) {
						t_so._ri--;
					}
					else {
						t_so._ri = t_typeArr.length - 1;
					}
					t_so._cellObjs = t_typeArr[t_so._ri];

					break;
				}

				case ShapeWorker.ROTATE_DIR_RIGHT: {
					if (t_so._ri < (t_typeArr.length - 1)) {
						t_so._ri++;
					}
					else {
						t_so._ri = 0;
					}
					t_so._cellObjs = t_typeArr[t_so._ri];

					break;
				}
			}

			return t_so;
		}

	});

})();


// # ShapeWorker Class
(function() {

	// #
	var t_class = HB_Class.create_s('ShapeWorker', {

		// :: ShapeObj 표시된거 클리어
		drawClear: function(cellDic, so) {
			var t_cos = so.get_cellObjs();
			for (var i = 0, t_la = t_cos.length;
					i < t_la; i++)
			{
				var t_co = t_cos[i];
				var t_hn = so.get_rhn(t_co.hn);
				var t_vn = so.get_rvn(t_co.vn);
				var t_sn = 0;
				CellWorker.stateChange(cellDic, t_hn, t_vn, t_sn);
			}
		}

		,
		// :: ShapeObj가 표시가 가능한지 여부
		get_isDraw: function(cellDic, so) {
			var t_rv = false;

			var t_cos = so.get_cellObjs();
			for (var i = 0, t_la = t_cos.length;
					i < t_la; i++) {

				var t_co = t_cos[i];
				var t_hn = so.get_rhn(t_co.hn);
				var t_vn = so.get_rvn(t_co.vn);
				if (CellWorker.get_isState(cellDic, t_hn, t_vn)) {
					t_rv = true;
				}
				else {
					t_rv = false;
					break;
				}
			}

			return t_rv;
		}

		,
		// :: ShapeObj 표시하기
		draw: function(cellDic, so) {
			var t_rv = false;

			if (ShapeWorker.get_isDraw(cellDic, so)) {
				var t_cos = so.get_cellObjs();
				for (var i = 0, t_la = t_cos.length;
						i < t_la; i++) {

					var t_co = t_cos[i];
					var t_hn = so.get_rhn(t_co.hn);
					var t_vn = so.get_rvn(t_co.vn);
					var t_sn = t_co.sn;
					CellWorker.stateChange(cellDic, t_hn, t_vn, t_sn);
				}

				t_rv = true;
			}

			return t_rv;
		}

		,
		// :: ShapeObj 이동 성공적으로 이동하면 성공된 so반환
		//		@Param(cellDic: CellDictionary, so: ShapeObj)
		move: function(dir, cellDic, so) {
			var t_rv = null;

			// - Original Shape Obj
			var t_oso = so;
			// - New Shape Obj
			var t_nso = t_oso.get_moveClone(dir);

			this.drawClear(cellDic, t_oso);
			if (this.get_isDraw(cellDic, t_nso)) {
				this.draw(cellDic, t_nso);
				t_rv = t_nso;
			}
			else {
				this.draw(cellDic, t_oso);
				t_rv = t_oso;
			}

			return t_rv;
		}

		,
		// :: ShapeObj 회전 성공적으로 이동하면 성공된 so반환
		//		@Param(cellDic: CellDictionary, so: ShapeObj)
		rotate: function(dir, cellDic, so) {
			var t_rv = null;

			// - Original Shape Obj
			var t_oso = so;
			// - New Shape Obj
			var t_nso = t_oso.get_rotateClone(dir);

			this.drawClear(cellDic, t_oso);
			if (this.get_isDraw(cellDic, t_nso)) {
				this.draw(cellDic, t_nso);
				t_rv = t_nso;
			}
			else {
				this.draw(cellDic, t_oso);
				t_rv = t_oso;
			}

			return t_rv;
		}

	});

	// -
	t_class.MOVE_DIR_LEFT = 'md_left';
	// -
	t_class.MOVE_DIR_RIGHT = 'md_right';
	// -
	t_class.MOVE_DIR_UP = 'md_up';
	// -
	t_class.MOVE_DIR_DOWN = 'md_down';

	// -
	t_class.ROTATE_DIR_LEFT = 'rd_left';
	// -
	t_class.ROTATE_DIR_RIGHT = 'rd_right';

})();
