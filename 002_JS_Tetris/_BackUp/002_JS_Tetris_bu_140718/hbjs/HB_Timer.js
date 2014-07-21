/**
@Name: JavaScript Timer
@Author: HobisJung
@Date: 2014-07-16
@Ver: 1.0
========================================================================================== */
(function() {
	if (window.HB_Timer != undefined) {
		return;
	}

	// ::
	window.HB_Timer = function(delay, repeatCount) {
		if (this instanceof arguments.callee) {
			this.p_initOnce.apply(this, arguments);
		}
		else {
			throw new Error('This function is allowed only instances.');
		}
	};

	//
	window.HB_Timer.EVENT_TYPE_UPDATE = 'update';
	//
	window.HB_Timer.EVENT_TYPE_UPDATE_END = 'updateEnd';

	// #
	window.HB_Timer.prototype = {
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
	};

})();
