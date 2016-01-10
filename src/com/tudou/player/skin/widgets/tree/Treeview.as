package com.tudou.player.skin.widgets.tree
{
	import com.tudou.player.skin.assets.AssetsManager;
	import com.tudou.player.skin.configuration.ListType;
	import com.tudou.player.skin.events.SkinNetStatusEventCode;
	import flash.display.*;
	import flash.events.*;
	import flash.filters.*;
	import flash.net.*;
	import flash.geom.*;
	import flash.media.*;
	import flash.system.*;
	import flash.utils.Timer;
	
	
	public class Treeview extends Sprite
	{
		private var ul_leng:int;
		private var li_leng:int;
		private var count:int;
		private var pre_ul:Tree;
		private var pre_li:Tree;
		private var tree_end:Boolean;
		
		private var _data:Array;
		private var ul:Array;
		private var li:Array;
		private var _assetsManager:AssetsManager;
		
		
		public function Treeview(manager:AssetsManager)
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
		
		private function InitTree():void {
			if (ul_leng > 0) {
				creatUL();
			}else {
				creatLI();
			}
			changeHandler();
		}
		
		private function changeHandler(evt:Event=null):void
		{
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		private function creatUL():void {
			while (count < ul_leng) {
				if (count == ul_leng - 1 && li_leng == 0) {
					tree_end = true;
				}
				var ul:Tree = new UL( ul[count]
									, count
									, 0
									, tree_end
									, _assetsManager
									);
				ul.addEventListener(NetStatusEvent.NET_STATUS, statusHandler);
				ul.addEventListener(Event.CHANGE, changeHandler);
				if (pre_ul)
				{
					pre_ul.next = ul;
					ul.y = pre_ul.y + pre_ul.height;
				}
				addChild(ul);
				pre_ul = ul;
				count++;
				if(count%10==0&&count!= ul_leng - 1){
					sleep(50, creatUL);
					return;
				}
			}
			count = 0;
			if (li_leng > 0) {
				sleep(100, creatLI);
			}else {
				//结束
			}
		}
		
		private function creatLI():void {
			while (count < li_leng) {
				if (count == li_leng - 1) {
					tree_end = true;
				}
				var li:Tree = new LI( li[count]
									, count
									, 0
									, tree_end
									, _assetsManager
									);
				li.addEventListener(NetStatusEvent.NET_STATUS, statusHandler);
				if (pre_li)
				{
					pre_li.next = li;
					li.y = pre_li.y + pre_li.height;
				}
				else {
					if (pre_ul)
					{
						pre_ul.next = li;
						li.y = pre_ul.y + pre_ul.height;
					}
				}
				addChild(li);
				
				pre_li = li;
				count++;
				if(count%10==0&&count!= li_leng - 1){
					sleep(50, creatLI);
					return;
				}
			}
			//结束
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
			ul = [];
			li = [];
			var ln:int = ary.length;
			for (var i:int = 0; i != ln; i++)
			{
				if (ary[i] as Array)
				{
					ul.push(ary[i]);
					ul_leng++;
				}
				else if (ary[i] as Object) {
					li.push(ary[i]);
					li_leng++;
				}
				
			}
			
			InitTree();
		}
		
		//OVER
	}
	
}