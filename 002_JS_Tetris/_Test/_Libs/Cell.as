package  
{
	import flash.display.Shape;
	import hb.utils.DisplayObjectUtil;
	/**
	 * ...
	 * @author HobisJung
	 */
	public class Cell 
	{
		// ::
		public function Cell(w:Number, h:Number)
		{	
			this._rect = new Shape();
			this._rect.graphics.beginFill(0xffffff, 1);
			this._rect.graphics.drawRect(0, 0, w, h);
			this._rect.graphics.endFill();
		}
	
		// -
		private var _rect:Shape = null;
		public function get_rect():Shape
		{
			return this._rect;
		}
		
		// -
		public var num:uint;
		
		// -
		private var _stateNum:uint;
		public function get_state():uint
		{
			return this._stateNum;
		}
		public function set_state(v:uint):void
		{
			this._stateNum = v;
			
			DisplayObjectUtil.setColor(this._rect, _RECT_COLORS[this._stateNum]);
		}
		
		// -
		private static const _RECT_COLORS:Array =
		[
			0xffffff, 0xff0000, 0x33ff00, 0x00FF99, 0x3300ff, 0xff00cc, 0xffcc00, 0x0099ff
		];
		
		// ::
		public function get_x():Number
		{
			return this._rect.x;
		}
		public function set_x(v:uint):void
		{
			this._rect.x = v;
		}		
		
		// ::
		public function get_y():Number
		{
			return this._rect.y;
		}
		public function set_y(v:uint):void
		{
			this._rect.y = v;
		}
	}
}
