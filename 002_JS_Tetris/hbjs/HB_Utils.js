/** ####################################################################################################
	@Name: JavaScript HB_Utils
	@Author: HobisJung
	@Date: 2014-07-15
	@Ver: 1.20
	@Comment: {
		JavaScript에서 자주 사용되는 모듈을 객체 중심으로 정리한 라이브러리 입니다.
	}
####################################################################################################**/


/**
	@Name: JavaScript Class Util
	@Comment: {
	}
========================================================================================== */
(function() {

	if (window.HB_Class != undefined) {
		return;
	}

	// #
	window.HB_Class = {

		// :: Class원형 생성하기 (인스턴스 클래스)
		//	선언이 되어 있으면 null, 안되어 있으면 클래스 반환
		create: function(className, implObj, type) {
			if (type == 1) {
				return this.create_i();
			}
			else if (type == 2) {
				return this.create_s();
			}
		}

		,
		// :: Class원형 생성하기 (인스턴스 클래스)
		create_i: function(className, implObj) {
			// 선언이 되어 있음
			if (window[className] != undefined) {
				return null;
			}

			// 선언이 안되어 있음
			else {

				var t_class = null;

				// #
				t_class = window[className] = function() {
					if (this instanceof arguments.callee) {
						this.p_initOnce.apply(this, arguments);
					}
					else {
						throw new Error('This function is allowed only instances.');
					}
				};

				if (implObj != undefined) {
					t_class.prototype = implObj;
				}

				return t_class;
			}
		}

		,
		// :: Class원형 생성하기 (스태틱 클래스)
		create_s: function(className, implObj) {

			// 선언이 되어 있음
			if (window[className] != undefined) {
				return null;
			}

			// 선언이 안되어 있음
			else {

				var t_class = null;

				if (implObj != undefined) {
					t_class = window[className] = implObj;
				}

				return t_class;
			}
		}

	};

})();


/**
	@Name: JavaScript Object Handler Adapter
	@Comment: {
		JavaScript에서 클래스를 작성할때 이벤트 핸들러를
		자신의 객체 중심으로 설정할수 있게 합니다.
		즉, 객체에서 핸들러를 등록하고 그 핸들러 안에서 this를 사용할수 있게 합니다.
	}
========================================================================================== */
(function() {

	HB_Class.create_s('HB_Adapter', {

		wrap: function(target, routine) {
			var t_func = function() {
				var t_target = arguments.callee.target;
				var t_routine = arguments.callee.routine;

				var t_params = [];
				for (var i = 0, t_la = arguments.length;
						i < t_la; i++) {
					t_params.push(arguments[i]);
				}
				t_params = t_params.concat(
					window.HB_Adapter.p_getParam(arguments.callee.param, 0));

				return t_routine.apply(t_target, t_params);
			};

			t_func.target = target;
			t_func.routine = routine;
			t_func.param = this.p_getParam(arguments, 2);

			return t_func;
		}

		,
		p_getParam: function(array, count) {
			var t_rv = [];

			if (array.length < count + 1)
				return t_rv;

			var t_la = array.length;
			var i;
			for (i = count; i < t_la; i ++) {
				t_rv.push(array[i]);
			}

			return t_rv;
		}

		,
		remove: function(func) {
			var t_rv = (func instanceof Function) ? func : null;

			if (t_rv != null) {
				t_rv.target = null;
				t_rv.routine = null;
				t_rv.param = null;
				t_rv = null;
			}

			return t_rv;
		}

	});

})();


/**
	@Name: JavaScript Object Util
	@Comment: {
		Object 유틸함수 모음
	}
========================================================================================== */
(function() {

	HB_Class.create_s('HB_ObjUtil', {

		// :: Obj에서 콜백 이벤트 날리기
		dispatchCallBack: function(tObj, eObj) {
			if (tObj.onCallBack != undefined) {
				tObj.onCallBack(eObj);
			}
		}

		,
		// :: Obj에서 동적 함수 호출하기
		methodCall: function(tObj, name, args) {
			var t_func = tObj[name];
			if (t_func != undefined) {
				t_func.apply(null, args);
			}
		}

		,
		// :: Obj에서 모든 속성 열거하기
		get_toString: function(tObj) {
			var t_rv = '';

			for (var t_p in tObj) {
				t_rv += t_p + ': ' + tObj[t_p] + ', ';
			}
			t_rv = t_rv.substr(0, t_rv.length - 2);

			return t_rv;
		}

	});

})();


/**
	@Name: JavaScript Object Util
	@Comment: {
		Object 유틸함수 모음
	}
========================================================================================== */
(function() {

	HB_Class.create_s('HB_Debug', {

		prefix: '[hb] '

		,
		// ::
		log: function(ota, msg) {
			var t_str = this.prefix + msg;
			ota.val(ota.val() + t_str + '\n');
		}

		,
		// ::
		clear: function(ota) {
			ota.val('');
		}

	});

})();


/**
	@Name: JavaScript Number Util
	@Comment: {
	}
========================================================================================== */
(function() {

	HB_Class.create_s('HB_Number', {

		// :: 실수인지 여부
		get_isFloat: function(v) {
			return ((v % 1) != 0);
		}

		,
		// :: 음수인지 여부
		get_isMinus: function(v) {
			return (v < 0);
		}

		,
		// :: 0부터 v-1까지의 난수를 반환
		random: function(v) {
			return Math.round(Math.random() * (v - 1));
		}

		,
		// :: min에서 max사이의 난수를 발생
		randRange: function(min, max) {
			return min + Math.round(Math.random() * (max - min));
		}

		,
		// :: 홀수인지 여부
		get_isOddEven: function(v) {
			return ((v % 2) > 0);
		}

	});

})();



/**
	@Name: JavaScript Timer
	@Author: HobisJung
	@Date: 2014-07-16
	@Ver: 1.2
========================================================================================== */
(function() {
	var t_class = HB_Class.create_i('HB_Timer', {

		// :: Initialize Once
		p_initOnce: function(delay, repeatCount) {
			this._running = false;
			this._delay = 0;
			this._repeatCount = 0;
			this._currentCount = 0;
			this._iid = 0;

			this.set_delay(delay);
			this.set_repeatCount(
				(repeatCount == undefined) ? 0 : repeatCount);
		}

		,
		// :: Delay Return
		get_delay: function() {
			return this._delay;
		}
		,
		// :: Set Delay
		set_delay: function(v) {
			v = isNaN(v) ? 1000 : v;
			this._delay = (v < 1) ? 1 : v;
		}

		,
		// :: RepeatCount Return
		get_repeatCount: function() {
			return this._repeatCount;
		}
		,
		// :: Set RepeatCount
		set_repeatCount: function(v) {
			v = isNaN(v) ? 0 : v;
			this._repeatCount = (v < 0) ? 0 : v;
		}

		,
		// :: CurrentCount Return
		get_currentCount: function() {
			return this._currentCount;
		}

		,
		// ::
		get_running: function() {
			return this._running;
		}


		,
		// ::
		p_looping: function() {
			if (
				(this._repeatCount == 0) ||
				(this._currentCount < this._repeatCount)
			) {
				this._currentCount++;

				HB_ObjUtil.dispatchCallBack(this, {type: window.HB_Timer.EVENT_TYPE_UPDATE});

				if (
					(this._repeatCount > 0) &&
					(this._currentCount >= this._repeatCount)
				) {
					this.stop();

					HB_ObjUtil.dispatchCallBack(this, {type: window.HB_Timer.EVENT_TYPE_UPDATE_END});
				}
			}
			else {
			}
		}

		,
		// ::
		reset: function() {
			this.stop();
			this._currentCount = 0;
		}

		,
		// ::
		stop: function() {
			if (this._running) {
				clearInterval(this._iid);
				this._running = false;
			}
		}

		,
		// ::
		start: function() {
			if (this._running) {
			}
			else {
				if (
					(this._repeatCount == 0) ||
					(this._currentCount < this._repeatCount)
				) {
					this._iid = setInterval(HB_Adapter.wrap(this, this.p_looping), this._delay);
					this._running = true;
				}
			}
		}

	});

})();
