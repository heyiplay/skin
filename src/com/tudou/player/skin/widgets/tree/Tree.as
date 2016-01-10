package com.tudou.player.skin.widgets.tree 
{
	import com.tudou.player.skin.assets.AssetsManager;
	import com.tudou.player.skin.configuration.ListType;
	import flash.display.*;
	import flash.geom.*;
	import flash.text.*;
	import flash.net.*;
	import flash.events.*;
	import flash.system.LoaderContext;
	import flash.utils.*;
	
	public class Tree extends Sprite
	{
		protected var next_tree:Tree;
		protected var up_tree:Tree;
		protected var _config:Object;
		protected var _id:String;
		protected var _index:int;
		protected var _level:int;
		protected var _end:Boolean;
		protected var txt:TextField;
		protected var txt_btn:Sprite;
		protected var ic_w:int = 16;
		protected var ic_h:int = 18;
		private var link:TextFormat;
		private var over:TextFormat;
		
		protected static const _h:int = 18;
		protected static const _w:int = 18;
		protected static const _x:int = 5;
		
		protected var _assetsManager:AssetsManager;
		protected var line_shape:Shape;
		
		public function Tree(config:Object, i:int, l:int, end:Boolean, assetsManager:AssetsManager)
		{
			_config = config;
			_index = i;
			_level = l;
			_end = end;
			_assetsManager = assetsManager;
			initTree();
		}
		
		public function initTree():void {
			
			line_shape = new Shape();
			line_shape.x = _x;
			addChild(line_shape);
			
			creatTxt();
			drawLine();
			showIcon();
			
		}
		
		private function drawLine():void {
			line_shape.graphics.clear();
			
			var line_style:Bitmap = _assetsManager.getDisplayObject("TreeviewDefaultLine") as Bitmap;
			line_shape.graphics.beginBitmapFill(line_style.bitmapData);
			if (_end) {
				line_shape.graphics.drawRect(_w * level, 0, _w, 10);
			}else {
				line_shape.graphics.drawRect(_w * level, 0, _w, _h);
				if (height > _h) {
					this.graphics.moveTo(_w * level, _h);
					var bmd:BitmapData = new BitmapData(_w, 2);
					bmd.copyPixels(line_style.bitmapData, new Rectangle(0, 0, _w, 2), new Point());
					line_shape.graphics.beginBitmapFill(bmd);
					line_shape.graphics.beginBitmapFill(bmd);
					if (height % 2 == 0) {
						line_shape.graphics.drawRect(_w * level, _h, _w, height - _h);
					}else {
						line_shape.graphics.drawRect(_w * level, _h, _w, height - _h+1);
					}
				}
			}
			
			line_shape.graphics.endFill();
		}
		
		protected var file_icon:Bitmap;
		private function showIcon():void {
			//需要画多文件ICON和单文件（图片、文字、视频、音频）ICON
			/*switch(data.listType)
			{
				case ListType.LIST_SINGLE:
					file_icon = _assetsManager.getDisplayObject("TreeviewIconText") as Bitmap;
					break;
				case ListType.LIST_LISTITEM:
					file_icon = _assetsManager.getDisplayObject("TreeviewIconFolder") as Bitmap;
					break;
					
			}
			
			if (file_icon)
			{
				file_icon.smoothing = true;
				file_icon.width = ic_w;
				file_icon.height = ic_h;
				file_icon.x = _w * (level + 1);
				addChild(file_icon);
			}*/
		}
		
		//
		protected function creatTxt():void {
			txt = new TextField();
			txt.height = _h;
			txt.defaultTextFormat = new TextFormat("Verdana");
			if (!file_icon) ic_w = 0;
			txt.x = _x + _w * (level + 1) + ic_w;
			txt.autoSize = TextFieldAutoSize.LEFT;
			txt.selectable = false;
			txt.textColor = 0x999999;
			txt.mouseEnabled = false;
            txt.htmlText = "<a href='#' class='txt'>" + config.title +"</a>";
			addChild(txt);
			
			txt_btn = new Sprite();
			txt_btn.buttonMode = true;
			txt_btn.graphics.beginFill(0, 0);
			//txt_btn.graphics.drawRect(txt.x, txt.y, txt.width, txt.height);
			txt_btn.graphics.drawRect(0, 0, 296, 18);
			txt_btn.graphics.endFill();
			addChild(txt_btn);
		}
		
		override public function set y(_y:Number):void {
			super.y = _y;
			if (next){
				next.y = this.y + this.height;
			}
		}
		
		override public function set height(_h:Number):void {
			super.height = _h;
			drawLine();
			if (next) {
				next.y = this.y + this.height;
			}
			if (up) {
				up.height = up.height;
			}
		}
		
		//API
		public function set up(_up_tree:Tree):void {
			if (_up_tree!=null) {
				this.up_tree = _up_tree;
			}
		}
		
		public function get up():Tree {
			return this.up_tree;
		}
		
		public function set next(_next_tree:Tree):void {
			if (_next_tree!=null) {
				this.next_tree = _next_tree;
			}
		}
		
		public function get next():Tree {
			return this.next_tree;
		}
		
		public function set id(_id:String):void {
			this._id = _id;
		}
		
		public function get id():String {
			return this._id;
		}
		
		public function set index(_i:int):void {
			this._index = _i;
		}
		
		public function get index():int {
			return this._index;
		}
		
		public function set level(_l:int):void {
			this._level = _l;
		}
		
		public function get level():int {
			return this._level;
		}
		
		public function set config(_c:Object):void {
			this._config = _c;
		}
		
		public function get config():Object {
			return this._config;
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
		}
		
		private var _enabled:Boolean;
		//OVER
	}
	
}