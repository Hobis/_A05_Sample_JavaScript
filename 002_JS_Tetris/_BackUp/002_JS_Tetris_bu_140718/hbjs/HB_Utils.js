/**
@Name: JavaScript HB_Utils
@Author: HobisJung
@Date: 2014-07-15
@Ver: 1.20
@Comment: {
	JavaScript에서 자주 사용되는 모듈을 객체 중심으로 정리한 라이브러리 입니다.
}
========================================================================================== */
// #
(function() {
/**
	@Name: JavaScript Object Handler Adapter
	@Comment: {
		JavaScript에서 클래스를 작성할때 이벤트 핸들러를
		자신의 객체 중심으로 설정할수 있게 합니다.
		즉, 객체에서 핸들러를 등록하고 그 핸들러 안에서 this를 사용할수 있게 합니다.
	}
*/
	if (window.HB_Adapter != undefined) {
		return;
	}

	window.HB_Adapter = {
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
	};

})();


// #
(function() {
/**
	@Name: JavaScript Object Util
	@Comment: {
		Object 유틸함수 모음
	}
*/
	if (window.HB_ObjUtil != undefined) {
		return;
	}

	// #
	window.HB_ObjUtil = {
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
	};

})();


// #
(function() {
/**
	@Name: JavaScript Object Util
	@Comment: {
		Object 유틸함수 모음
	}
*/
	if (window.HB_Debug != undefined) {
		return;
	}

	// #
	window.HB_Debug = {
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
	};

})();