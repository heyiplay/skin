package com.tudou.player.skin.assets
{
	import mx.core.FontAsset; FontAsset;
	import mx.core.ByteArrayAsset; ByteArrayAsset;
	import flash.text.Font;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	public class FontAsset extends SymbolAsset
	{
		public function FontAsset(font:Class, resource:FontResource)
		{
			super(font);
			
			_font = new font();
			Font.registerFont(font);
			
			_resource = resource;
		}
		
		public function get font():Font
		{
			return _font;
		}
		
		public function get format():TextFormat
		{
			var result:TextFormat
				= new TextFormat
					( _font.fontName
					, _resource.size
					, _resource.color
					, _resource.bold
					);
					
			//result.align = TextFormatAlign.LEFT;
			
			return result;
		}
		
		public function get resource():FontResource{
			return _resource;
		}
		
		public function set resource(value:FontResource):void{
			_resource = value;
		}
		
		private var _font:Font;
		private var _resource:FontResource;
	}
}