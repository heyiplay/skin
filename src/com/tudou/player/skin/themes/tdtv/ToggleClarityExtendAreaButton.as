package com.tudou.player.skin.themes.tdtv 
{
	import com.tudou.player.skin.widgets.Button;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	/**
	 * 扩展区域切换按钮
	 * @author 8088
	 */
	public class ToggleClarityExtendAreaButton extends ClarityButton
	{
		
		public function ToggleClarityExtendAreaButton(up:DisplayObject, over:DisplayObject=null, down:DisplayObject=null, disabled:DisplayObject=null)
		{
			super(up, over, down, disabled);
		}
		
		override protected function onRollOut(evt:MouseEvent):void
		{
			if (!cur)
			{
				super.onRollOut(evt);
			}
		}
		
		public function set cur(c:Boolean):void
		{
			if (!enabled) return;
			_cur = c;
			setState(_cur ? PRESSED : NORMAL);
			updateFace(_cur ? pressed : normal);
			mouseEnabled = !_cur;
			buttonMode = !_cur;
		}
		
		public function get cur():Boolean
		{
			return _cur;
		}
		
		private var _cur:Boolean;
		
	}

}