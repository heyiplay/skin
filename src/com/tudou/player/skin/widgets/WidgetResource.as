package com.tudou.player.skin.widgets
{
	public class WidgetResource
	{
		public function WidgetResource(config:XML)
		{
			_config = config;
			_id = config.@id;
			_url = config.@url;
			if (String(config.@url).indexOf(".swf")!=-1 || String(config.@url).indexOf(".swz")!=-1 )
			{
				_local = false;
			}
			else {
				_local = true;
			}
			_load = (config.@preload == "false")?false:true;
			_symbol = config.@symbol;
		}

		public function get config():XML
		{
			return _config;
		}
		
		public function get id():String
		{
			return _id;
		}
		
		public function get url():String
		{
			return _url;
		}
		
		public function set url(u:String):void
		{
			_url = u;
		}
		
		public function get local():Boolean
		{
			return _local;
		}
		
		public function get load():Boolean
		{
			return _load;
		}
		
		public function set load(l:Boolean):void
		{
			_load = l;
		}
		
		public function get symbol():String
		{
			return _symbol;
		}
		
		private var _config:XML;
		private var _id:String;
		private var _url:String;
		private var _local:Boolean;
		private var _load:Boolean;
		private var _symbol:String;
	}
}