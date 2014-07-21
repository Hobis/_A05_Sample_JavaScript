(function() {
	if (window.GameLogic != undefined) {
		return;
	}

	//
	var t_gl = window.GameLogic = function(owner) {
		if (this instanceof arguments.callee) {
			this.p_initOnce.apply(this, arguments);
		}
		else {
			throw new Error('This function is allowed only instances.');
		}
	};
	window.GameLogic = t_gl;

	t_gl.prototype = {
		p_initOnce: function(owner) {
			this._owner = owner;
			this._cc = null;
			this._downSpeed = 1000;

			jQuery(document).keydown(HB_Adapter.wrap(this, this.p_keyDown));

			this._timer = new HB_Timer(this._downSpeed);
			this._timer.onCallBack = HB_Adapter.wrap(this, this.p_timer_onCallBack);
			//this._timer.start();
		}

		,
		p_keyDown: function(eObj) {
			//alert(eObj.keyCode);
		}

		,
		p_timer_onCallBack: function(eObj) {
			switch (eObj.type) {
				case HB_Timer.EVENT_TYPE_UPDATE: {
					alert('1');

					break;
				}

				case HB_Timer.EVENT_TYPE_UPDATE_END: {
					alert('2');

					break;
				}
			}
		}
	};
})();
