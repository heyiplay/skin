package com.tudou.player.skin.assets
{
	public class SymbolResource extends AssetResource
	{
		public function SymbolResource(id:String, url:String, local:Boolean, symbol:String)
		{
			_symbol = symbol;
			super(id, url, local);
		}
		
		public function get symbol():String
		{
			return _symbol;
		}
		
		private var _symbol:String;
		
	}
}