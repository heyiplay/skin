package com.tudou.player.skin.assets
{
	public class FontResource extends SymbolResource
	{
		public function FontResource
							( id:String
							, url:String
							, local:Boolean
							, symbol:String
							, size:Number
							, color:uint
							, bold:Boolean=false
							)
		{
			super(id, url, local, symbol);
			
			_size = size;
			_color = color;
			_bold = bold;
		}
	
		public function get size():Number
		{
			return _size;	
		}
		
		public function set size(value:Number):void
		{
			_size = value;
		}
		
		public function get color():uint
		{
			return _color;
		}
		
		public function get bold():Boolean
		{
			return _bold;
		}
		
		// Internals
		//
		
		private var _size:Number;
		private var _color:uint;
		private var _bold:Boolean;
	}
}