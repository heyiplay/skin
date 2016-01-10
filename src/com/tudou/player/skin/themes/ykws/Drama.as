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
	public class Drama extends Sprite implements IList
	{
		
		private static const _h:int = 20;
		private static const _w:int = 50;
		
		public function Drama(config:Object, type:String, index:int, assetsManager:AssetsManager)
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
			ttl_txt = new TextField();
			ttl_txt.height = _h;
			ttl_txt.width = _w-10;
			ttl_txt.defaultTextFormat = new TextFormat("Arial");
			ttl_txt.autoSize = TextFieldAutoSize.RIGHT;
			ttl_txt.textColor = 0x999999;
			ttl_txt.mouseEnabled = false;
			ttl_txt.text = String(_index + 1)+"集";
			addChild(ttl_txt);
			
			var btn:Sprite =  new Sprite();
			btn.graphics.beginFill(0, 0);
			btn.graphics.drawRect(0, 0, _w, _h);
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
				this.graphics.drawRect(0, 0, _w, _h);
				this.graphics.endFill();
				
				ttl_txt.textColor = 0xFFFFFF;
			}
			else {
				this.addEventListener(MouseEvent.CLICK, liDownHandler);
				this.addEventListener(MouseEvent.ROLL_OVER, liOverHandler);
				this.addEventListener(MouseEvent.ROLL_OUT, liOutHandler);
				liOutHandler(null);
				
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
			this.graphics.drawRect(0, 0, _w, _h);
			this.graphics.endFill();
			
			ttl_txt.textColor = 0xFFFFFF;
		}
		
		private function liOutHandler(evt:MouseEvent):void
		{
			this.graphics.clear();
			
			ttl_txt.textColor = 0x999999;
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