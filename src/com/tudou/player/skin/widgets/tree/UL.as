package com.tudou.player.skin.widgets.tree 
{
	import com.tudou.player.skin.assets.AssetsManager;
	import com.tudou.player.skin.configuration.ListType;
	import flash.display.*;
	import flash.geom.*;
	import flash.text.*;
	import flash.net.*;
	import flash.events.*;
	import flash.utils.Timer;
	
	public class UL extends Tree
	{
		private var fold_icon:Sprite;
		private var unfold_icon:Sprite;
		private var cur_icon:Sprite;
		private var _open:Boolean;
		
		private var ul_leng:int;
		private var li_leng:int;
		private var count:int;
		private var pre_ul:Tree;
		private var pre_li:Tree;
		private var tree_end:Boolean;
		private var list:Sprite;
		private var ul:Array;
		private var li:Array;
		public function UL(config:Array, i:int, l:int, end:Boolean, assetsManager:AssetsManager)
		{
			super(config, i, l, end, assetsManager);
			
			ul = [];
			li = [];
			var ln:int = config.length;
			for (var i:int = 0; i != ln; i++)
			{
				if (config[i] as Array)
				{
					ul.push(config[i]);
					ul_leng++;
				}
				if (config[i] as Object)
				{
					li.push(config[i]);
					li_leng++;
				}
				
			}
			initUL();
		}
		
		override protected function creatTxt():void {
			super.creatTxt();
			
            txt.htmlText = "<a href='#' class='txt'>" + "多文件标题" +"</a>";
		}
		
		private function updateIcon(icon:Sprite):void
		{
			if (icon == null) return;
			if (cur_icon != icon)
			{
				if (cur_icon)
				{
					cur_icon.removeEventListener(MouseEvent.MOUSE_DOWN, ulDownHandler);
					removeChild(cur_icon);
				}
				
				cur_icon = icon;
				cur_icon.x = _x+2+_w * level;
				cur_icon.y = 4;
				cur_icon.buttonMode = true;
				cur_icon.addEventListener(MouseEvent.MOUSE_DOWN, ulDownHandler);
				
				if (cur_icon)
				{
					addChild(cur_icon);
				}
			}
		}
		
		public function initUL():void {
			fold_icon = _assetsManager.getDisplayObject("TreeviewIconFold") as Sprite;
			fold_icon.mouseChildren = false;
			unfold_icon = _assetsManager.getDisplayObject("TreeviewIconUnfold") as Sprite;
			unfold_icon.mouseChildren = false;
			updateIcon(unfold_icon);
			//Open 是同步的
			txt_btn.addEventListener(MouseEvent.CLICK, ulDownHandler);
			txt_btn.addEventListener(MouseEvent.ROLL_OVER, liOverHandler);
			txt_btn.addEventListener(MouseEvent.ROLL_OUT, liOutHandler);
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
		
		private function ulDownHandler(evt:MouseEvent):void {
			_open = !_open;
			if (_open)
			{
				updateIcon(fold_icon);
				Open();
			}
			else {
				updateIcon(unfold_icon);
				Close();
			}
			changeHandler();
		}
		//API
		public function Close():void {
			removeChild(list);
			drawLine()
			height = _h;
		}
		private function drawLine():void {
			line_shape.graphics.clear();
			
			var line_style:Bitmap = _assetsManager.getDisplayObject("TreeviewDefaultLine") as Bitmap;
			line_shape.graphics.beginBitmapFill(line_style.bitmapData);
			if (_end) {
				line_shape.graphics.drawRect(_w * level, 0, _w, 10);
			}else {
				line_shape.graphics.drawRect(_w * level, 0, _w, _h);
			}
			
			line_shape.graphics.endFill();
		}
		public function Open():void {
			if (list) {
				addChild(list);
				height = this.height;
			}else {
				list = new Sprite();
				list.y = _h;
				
				if (ul_leng > 0) {
					creatUL();
				}else {
					creatLI();
				}
			}
			
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
				var ul:Tree = new UL(ul[count], count, (level+1), tree_end, _assetsManager);
				ul.addEventListener(NetStatusEvent.NET_STATUS, statusHandler);
				ul.addEventListener(Event.CHANGE, changeHandler);
				ul.up = this;
				if (pre_ul) {
					pre_ul.next = ul;
					ul.y = pre_ul.y + pre_ul.height;
				}
				list.addChild(ul);
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
				addChild(list);
				height = this.height;
			}
		}
		private function creatLI():void {
			while (count < li_leng) {
				if (count == li_leng - 1) {
					tree_end = true;
				}
				var li:Tree = new LI(li[count], count, (level + 1), tree_end, _assetsManager);
				li.addEventListener(NetStatusEvent.NET_STATUS, statusHandler);
				li.up = this;
				if (pre_li) {
					pre_li.next = li;
					li.y = pre_li.y + pre_li.height;
				}else if(pre_ul){
					pre_ul.next = li;
					li.y = pre_ul.y + pre_ul.height;
				}
				list.addChild(li);
				
				pre_li = li;
				count++;
				if(count%10==0&&count!= li_leng - 1){
					sleep(50, creatLI);
					return;
				}
			}
			//结束
			addChild(list);
			height = this.height;
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
		//OVER
	}
	
}