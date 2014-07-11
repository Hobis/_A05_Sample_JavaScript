package
{
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.KeyboardEvent;
	import flash.events.Event;
	import flash.ui.Keyboard;	
	import hb.frame.FPSTimer;
	

	public class GameLogic
	{
		// :: 생성자
		public function GameLogic(owner:MovieClip)
		{
			this._owner = owner;
			this._cc = new CellCanvas(this._owner);			
			
			
			this._owner.stage.addEventListener(KeyboardEvent.KEY_DOWN, this.p_stage_keyDown);
			this._fpsTimer = new FPSTimer(40);
			this._fpsTimer.onCallBack = this.p_fpsTimer_onCallBack;
			
			this.p_newShapeStart();
		}
		
		// - 컨테이너 참조
		private var _owner:MovieClip = null;
		
		// -
		private var _cc:CellCanvas = null;
		
		// -
		private var _fpsTimer:FPSTimer = null;
		
		
		// ::
		private function p_stage_keyDown(event:KeyboardEvent):void
		{
			switch (event.keyCode)
			{
				case Keyboard.LEFT:
				{
					this._cc.shapeMove(ShapeWorker.MOVE_DIR_LEFT);
					break;
				}

				case Keyboard.RIGHT:
				{
					this._cc.shapeMove(ShapeWorker.MOVE_DIR_RIGHT);
					break;
				}

				case Keyboard.UP:
				{
					//this._cc.shapeMove(ShapeWorker.MOVE_DIR_UP);
					this._cc.shapeRotate(ShapeWorker.ROTATE_DIR_RIGHT);
					break;
				}

				case Keyboard.DOWN:
				{
					this.p_intelDown();
					//this._cc.shapeMove(ShapeWorker.MOVE_DIR_DOWN);
					break;
				}

				case Keyboard.Z:
				{
					this._cc.shapeRotate(ShapeWorker.ROTATE_DIR_LEFT);
					break;
				}

				case Keyboard.X:
				{
					//
					break;
				}

				case Keyboard.C:
				{
					this._cc.shapeRotate(ShapeWorker.ROTATE_DIR_RIGHT);
					break;
				}
			}
		}
		
		// ::
		private function p_intelDown():void
		{
			if (this._cc.shapeMove(ShapeWorker.MOVE_DIR_DOWN))
			{
				this._fpsTimer.stop(true);
				this._fpsTimer.start();
			}
			else
			{
				this.p_newShapeStart();
			}
		}
		
		// ::
		private function p_fpsTimer_onCallBack(eObj:Object):void
		{
			this.p_intelDown();
		}
		
		
		// ::
		private function p_newShapeStart():void
		{
			this._cc.shapeCreate();
			this._fpsTimer.reset();
			this._fpsTimer.start();
		}
	}
}
