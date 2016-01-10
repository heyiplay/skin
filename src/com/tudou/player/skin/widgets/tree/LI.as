package com.tudou.player.skin.widgets.tree 
{
	import com.tudou.player.skin.assets.AssetsManager;
	import com.tudou.player.events.NetStatusCommandCode;
	import com.tudou.player.skin.events.SkinNetStatusEventCode;
	import com.tudou.player.skin.themes.tdws.PlayList;
	import flash.display.DisplayObject;
	import flash.events.*;
	import flash.net.*;
	import flash.external.ExternalInterface;
	
	public class LI extends Tree implements IList
	{
		
		public function LI(config:Object, i:int, l:int, end:Boolean, assetsManager:AssetsManager)
		{
			super(config, i, l, end, assetsManager);
			
			cur_icon = assetsManager.getDisplayObject("TreeviewIconPlay") as DisplayObject;
			
			if (_config.iid)
			{
				_id = _config.iid;
				//PlayList.lists.put(_id, this);
			}
			
			initLI();
		}
		public function initLI():void {
			txt_btn.addEventListener(MouseEvent.CLICK, liDownHandler);
			txt_btn.addEventListener(MouseEvent.ROLL_OVER, liOverHandler);
			txt_btn.addEventListener(MouseEvent.ROLL_OUT, liOutHandler);
		}
		private function liDownHandler(evt:MouseEvent):void {
			var info:Object = { };
			info.code = NetStatusCommandCode.PLAY_LIST;
			info.level = "status";
			info.li = this;
			dispatchEvent( new NetStatusEvent
							( NetStatusEvent.NET_STATUS
							, false
							, false
							, info
							)
						 );
		}
		
		private function liOverHandler(evt:MouseEvent):void
		{
			this.graphics.clear();
			this.graphics.beginFill(0xFFFFFF, .1);
			this.graphics.drawRect(0, 0, 296, 18);
			this.graphics.endFill();
			
			txt.textColor = 0xFFFFFF;
		}
		
		private function liOutHandler(evt:MouseEvent):void
		{
			this.graphics.clear();
			txt.textColor = 0x999999;
		}
		
		private function setCur():void
		{
			txt_btn.mouseEnabled = !_cur;
			txt_btn.buttonMode = !_cur;
			
			if (_cur)
			{
				txt_btn.removeEventListener(MouseEvent.CLICK, liDownHandler);
				txt_btn.removeEventListener(MouseEvent.ROLL_OVER, liOverHandler);
				txt_btn.removeEventListener(MouseEvent.ROLL_OUT, liOutHandler);
				
				this.graphics.clear();
				this.graphics.beginFill(0xFF8800, .2);
				this.graphics.drawRect(0, 0, 296, 18);
				this.graphics.endFill();
				
				if (cur_icon)
				{
					cur_icon.x = _x + _w * (level + 1) + ic_w;
					addChild(cur_icon);
					txt.x = cur_icon.x + cur_icon.width;
				}
				txt.textColor = 0xFFFFFF;
			}
			else {
				txt_btn.addEventListener(MouseEvent.CLICK, liDownHandler);
				txt_btn.addEventListener(MouseEvent.ROLL_OVER, liOverHandler);
				txt_btn.addEventListener(MouseEvent.ROLL_OUT, liOutHandler);
				liOutHandler(null);
				
				if (cur_icon)
				{
					if (contains(cur_icon)) removeChild(cur_icon);
					txt.x = _x + _w * (level + 1) + ic_w;
				}
			}
		}
		
		public function set cur(c:Boolean):void
		{
			//if (!enabled) return;
			_cur = c;
			setCur();
		}
		
		public function get cur():Boolean
		{
			return _cur;
		}
		
		private var _cur:Boolean;
		private var cur_icon:DisplayObject;
		//OVER
	}
	
}