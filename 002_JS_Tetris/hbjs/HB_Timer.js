/**
@Name: JavaScript Timer
@Author: HobisJung
@Date: 2014-07-15
@Ver: 1.0
========================================================================================== */
(function() {
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
