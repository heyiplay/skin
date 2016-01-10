package com.tudou.player.skin.themes.ykws 
{
	import com.tudou.player.skin.assets.AssetsManager;
	import com.tudou.player.skin.configuration.ListType;
	import com.tudou.player.skin.events.SkinNetStatusEventCode;
	import com.tudou.utils.Check;
	import com.tudou.player.skin.utils.TimeUtil;
	import com.tudou.player.skin.widgets.tree.IList;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.NetStatusEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	/**
	 * ...
	 * @author 8088
	 */
	public class List extends Sprite implements IList
	{
		
		private static const _h:int = 20;
		
		public function List(config:Object, type:String, index:int, assetsManager:AssetsManager)
		{
			_config = config;
			_type = type;
			_index = index;
			_assetsManager = assetsManager;
			
			this.mouseChildren = false;
			this.tabChildren = false;
			
			if (_config.iid)
			{
				_id = _config.iid;
				PlayList.lists.put(_id, this);
			}
			
			cur_icon = assetsManager.getDisplayObject("TreeviewIconPlay") as DisplayObject;
			
			init();
		}
		
		private function init():void
		{
			date_txt = new TextField();
			date_txt.height = _h;
			date_txt.x = 20;
			date_txt.y = 1;
			date_txt.defaultTextFormat = new TextFormat("Arial", 11);
			date_txt.autoSize = TextFieldAutoSize.LEFT;
			date_txt.textColor = 0x999999;
			date_txt.mouseEnabled = false;
			date_txt.multiline = true;
			date_txt.wordWrap = true;
			addChild(date_txt);
			
			ttl_txt = new TextField();
			ttl_txt.height = _h;
			ttl_txt.x = date_txt.x + date_txt.width;
			ttl_txt.defaultTextFormat = new TextFormat("Verdana");
			ttl_txt.autoSize = TextFieldAutoSize.LEFT;
			ttl_txt.textColor = 0x999999;
			ttl_txt.mouseEnabled = false;
			ttl_txt.multiline = true;
			ttl_txt.wordWrap = true;
			addChild(ttl_txt);
			
			time_txt = new TextField();
			time_txt.height = _h;
			time_txt.x = ttl_txt.x + ttl_txt.width;
			time_txt.y = 1;
			time_txt.defaultTextFormat = new TextFormat("Arial");
			time_txt.autoSize = TextFieldAutoSize.LEFT;
			time_txt.selectable = false;
			time_txt.textColor = 0x999999;
			time_txt.mouseEnabled = false;
			time_txt.multiline = true;
			time_txt.wordWrap = true;
			addChild(time_txt);
			
			switch(_type)
			{
				case ListType.LIST_SINGLE:
				case ListType.LIST_LISTITEM:
				case ListType.LIST_MOVIE:
				case ListType.LIST_LIVETV:
				case ListType.LIST_HOBBY:
					date_txt.width = 30;
					date_txt.text = (_index + 1) + ".";
					
					ttl_txt.x = date_txt.x + date_txt.width;
					ttl_txt.width = 190;
					ttl_txt.text = Check.View(_config.title, ttl_txt.width);
					
					time_txt.x = ttl_txt.x + ttl_txt.width;
					time_txt.width = 50;
					time_txt.text = TimeUtil.formatAsTimeCode(Number(_config.totalTime));
					break;
				case ListType.LIST_VARIETYSHOW:
					date_txt.text = String(_config.publishTime).slice(0, 10);
					date_txt.width = 80;
					
					ttl_txt.x = date_txt.x + date_txt.width;
					ttl_txt.width = 200;
					ttl_txt.text = Check.View(_config.title, ttl_txt.width);
					break;
				
			}
			
			var btn:Sprite =  new Sprite();
			btn.graphics.beginFill(0, 0);
			btn.graphics.drawRect(0, 0, 296, _h);
			btn.graphics.endFill();
			addChild(btn);
			
			
		}
		
		
		private function setCur():void
		{
			this.mouseEnabled = !_cur;
			this.buttonMode = !_cur;
			
			if (_cur)
			{
				this.removeEventListener(MouseEvent.CLICK, liDownHandler);
				this.removeEventListener(MouseEvent.ROLL_OVER, liOverHandler);
				this.removeEventListener(MouseEvent.ROLL_OUT, liOutHandler);
				
				this.graphics.clear();
				this.graphics.beginFill(0xFF8800, .2);
				this.graphics.drawRect(0, 0, 296, _h);
				this.graphics.endFill();
				
				if (cur_icon)
				{
					cur_icon.x = 5;
					addChild(cur_icon);
				}
				date_txt.textColor = 0xFFFFFF;
				ttl_txt.textColor = 0xFFFFFF;
				time_txt.textColor = 0xFFFFFF;
			}
			else {
				this.addEventListener(MouseEvent.CLICK, liDownHandler);
				this.addEventListener(MouseEvent.ROLL_OVER, liOverHandler);
				this.addEventListener(MouseEvent.ROLL_OUT, liOutHandler);
				liOutHandler(null);
				
				if (cur_icon)
				{
					if (contains(cur_icon)) removeChild(cur_icon);
				}
			}
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
			this.graphics.drawRect(0, 0, 296, _h);
			this.graphics.endFill();
			
			date_txt.textColor = 0xFFFFFF;
			ttl_txt.textColor = 0xFFFFFF;
			time_txt.textColor = 0xFFFFFF;
		}
		
		private function liOutHandler(evt:MouseEvent):void
		{
			this.graphics.clear();
			
			date_txt.textColor = 0x999999;
			ttl_txt.textColor = 0x999999;
			time_txt.textColor = 0x999999;
		}
		
		
		public function set id(_id:String):void {
			this._id = _id;
		}
		
		public function get id():String {
			return this._id;
		}
		
		public function set cur(c:Boolean):void
		{
			if (!enabled) return;
			_cur = c;
			setCur();
		}
		
		public function get cur():Boolean
		{
			return _cur;
		}
		public function set enabled(value:Boolean):void
		{
			_enabled = value;
			processEnabledChange();
		}
		
		public function get enabled():Boolean
		{
			return _enabled;
		}
		
		protected function processEnabledChange():void 
		{
			mouseEnabled = enabled;
			buttonMode = enabled;
			
			if (enabled&&!cur)
			{
				this.addEventListener(MouseEvent.CLICK, liDownHandler);
				this.addEventListener(MouseEvent.ROLL_OVER, liOverHandler);
				this.addEventListener(MouseEvent.ROLL_OUT, liOutHandler);
			}
			else {
				this.removeEventListener(MouseEvent.CLICK, liDownHandler);
				this.removeEventListener(MouseEvent.ROLL_OVER, liOverHandler);
				this.removeEventListener(MouseEvent.ROLL_OUT, liOutHandler);
			}
		}
		
		private var _cur:Boolean;
		private var cur_icon:DisplayObject;
		
		private var _config:Object;
		private var _type:String;
		private var _id:String;
		private var _index:int;
		private var _assetsManager:AssetsManager;
		
		private var date_txt:TextField;
		private var ttl_txt:TextField;
		private var time_txt:TextField;
		
		private var _enabled:Boolean;
	}

}