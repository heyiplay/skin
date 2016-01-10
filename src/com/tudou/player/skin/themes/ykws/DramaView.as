package com.tudou.player.skin.themes.ykws 
{
	import com.tudou.player.skin.assets.AssetsManager;
	import com.tudou.player.skin.configuration.ListType;
	import com.tudou.player.skin.events.SkinNetStatusEventCode;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.NetStatusEvent;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	/**
	 * ...
	 * @author 8088
	 */
	public class DramaView extends Sprite
	{
		
		public function DramaView(manager:AssetsManager)
		{
			_assetsManager = manager;
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(evt:Event = null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			//..
			changeHandler();
		}
		
		private function changeHandler(evt:Event=null):void
		{
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		private var li_w:int = 50;
		private var li_h:int = 20;
		private var _r:int = -1; //行数
		private var _c:int = 0; //列数
		private var _t:int = 0; //标题数
		private function creatList():void
		{
			while (count < ln) {
				
				if (count % 25 == 0)
				{
					var m:int = int(count / 25);
					var num_ttl:TextField = new TextField();
					num_ttl.width = li_w;
					num_ttl.height = li_h;
					num_ttl.x = 5;
					num_ttl.y = li_h * (_r + 1);
					num_ttl.defaultTextFormat = new TextFormat("Arial", 10);
					num_ttl.textColor = 0x666666;
					num_ttl.mouseEnabled = false;
					var end:int = 25 * (m + 1);
					if (end > ln) end = ln;
					num_ttl.text = (count + 1) + "-" + end;
					addChild(num_ttl);
					_t++;
				}
				_c = count % 5;
				_r = int(count / 5) + _t;
				var li:Drama = new Drama( _data[count]
									, type
									, count
									, _assetsManager
									);
				li.addEventListener(NetStatusEvent.NET_STATUS, statusHandler);
				li.enabled = true;
				
				li.x = li_w * _c + 15;
				li.y = li_h * _r;
				
				addChild(li);
				
				count++;
				if(count%10==0&&count!= ln - 1){
					sleep(50, creatList);
					return;
				}
			}
			//结束
			changeHandler();
		}
		
		private function statusHandler(evt:NetStatusEvent):void
		{
			dispatchEvent(evt);
		}
		
		private function sleep(t:int, f:Function):void{
			var timer:Timer = new Timer(t,1);
			timer.addEventListener(TimerEvent.TIMER, function():void{
								   timer.stop();
								   timer = null;
								   f();
								   });
			timer.start();
		}
		
		//API
		public function set data(ary:Array):void {
			//从新设置更新列表、设置为null清空列表
			//
			_data = ary;
			ln = _data.length;
			creatList();
		}
		
		public function set type(t:String):void
		{
			list_type = t;
		}
		
		public function get type():String
		{
			return list_type;
		}
		
		
		private var list_type:String = ListType.LIST_TVDRAMA;
		private var _data:Array;
		private var _assetsManager:AssetsManager;
		
		private var ln:int;
		private var count:int;
	}

}