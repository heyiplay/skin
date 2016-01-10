package com.tudou.player.skin.themes.tdtv 
{
	import com.tudou.player.skin.assets.AssetsManager;
	import com.tudou.player.skin.configuration.ListType;
	import com.tudou.player.skin.events.SkinNetStatusEventCode;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.NetStatusEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	/**
	 * ...
	 * @author 8088
	 */
	public class ListView extends Sprite
	{
		
		public function ListView(manager:AssetsManager)
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
		
		private var pre_li:List;
		private function creatList():void
		{
			while (count < ln) {
				
				var li:List = new List( _data[count]
									, type
									, count
									, _assetsManager
									);
				li.addEventListener(NetStatusEvent.NET_STATUS, statusHandler);
				li.enabled = true;
				if (pre_li)
				{
					li.y = pre_li.y + pre_li.height;
				}
				addChild(li);
				
				pre_li = li;
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
		
		
		private var list_type:String = ListType.LIST_LISTITEM;
		private var _data:Array;
		private var _assetsManager:AssetsManager;
		
		private var ln:int;
		private var count:int;
	}

}