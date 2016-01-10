package com.tudou.player.skin.assets
{
	public class AssetResource
	{
		public function AssetResource(id:String, url:String, local:Boolean)
		{
			_id = id;
			_url = url;
			_local = local;
		}

		public function get id():String
		{
			return _id;
		}
		
		public function get url():String
		{
			return _url;
		}
		
		public function get local():Boolean
		{
			return _local;
		}
		
		private var _id:String;
		private var _url:String;
		private var _local:Boolean;
	}
}