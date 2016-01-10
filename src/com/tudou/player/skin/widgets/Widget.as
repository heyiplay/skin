package com.tudou.player.skin.widgets 
{
	import com.tudou.utils.Debug;
	import com.tudou.layout.LayoutSprite;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.system.ApplicationDomain;
	import flash.ui.Mouse;
	import flash.utils.Dictionary;
	
	import com.tudou.player.skin.assets.AssetsManager;
	import com.tudou.player.skin.interfaces.IWidget;
	import com.tudou.player.skin.themes.ElementsProvider;
	
	/**
	 * 媒体播放器内小功能控件的抽象类
	 */
	public class Widget extends LayoutSprite implements IWidget
	{
		
		public function Widget()
		{
			super();
			this.mouseEnabled = true;
			_assetsManager = ElementsProvider.getInstance().assetsManager;
			_widgetsManager = ElementsProvider.getInstance().widgetsManager;
			
		}
		
		override protected function onStage(evt:Event = null):void
		{
			super.onStage(evt);
			
			if (configuration && String(configuration.@alt).length>0)
			{
				Hint.register(this, configuration.@alt);
			}
		}
		
		public function configure(xml:XML):void
		{
			configuration = xml;
		}
		
		public function set configuration(xml:XML):void
		{
			_configuration = xml;
			//关联样式
			style = xml.@style;
			id = xml.@id;
		}
		
		public function get configuration():XML
		{
			return _configuration;
		}
		
		public function get url():String
		{
			return _url;
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
		
		override protected function getDefinitionByName(url:String):Object
		{
			return ApplicationDomain.currentDomain.getDefinition(url);
		}
		
		protected function processEnabledChange():void
		{
			mouseEnabled = enabled;
		}
		
		private var _configuration:XML;
		protected var _assetsManager:AssetsManager;
		protected var _widgetsManager:WidgetsManager;
		private var _enabled:Boolean = true;
		private var _hint:String = null;
		private var _url:String;
		
		/**
		 * 控制提示字体颜色
		 */
		public function get hintColor():uint
		{
			return hint_color;
		}
		
		public function set hintColor(color:uint):void
		{
			hint_color = color;
		}
		
		/**
		 * 控制提示
		 */
		public function get hintHasV():Boolean
		{
			return hint_has_v;
		}
		
		public function set hintHasV(has:Boolean):void
		{
			hint_has_v = has;
		}
		
		/**
		 * 控制提示x轴固定为某值
		 */
		public function get hintX():Number
		{
			return hint_x;
		}
		
		public function set hintX(num:Number):void
		{
			hint_x = num;
		}
		
		/**
		 * 控制提示y轴固定为某值
		 */
		public function get hintY():Number
		{
			return hint_y;
		}
		
		public function set hintY(num:Number):void
		{
			hint_y = num;
		}
		
		/**
		 * 控制提示
		 */
		public function get hintV():Number
		{
			return hint_v;
		}
		
		public function set hintV(num:Number):void
		{
			hint_v = num;
		}
		
		/**
		 * 控制提示
		 */
		public function get hintT():Number
		{
			return hint_t;
		}
		
		public function set hintT(num:Number):void
		{
			hint_t = num;
		}
		
		/**
		 * 控制提示可以鼠标划过交互
		 */
		public function get hintHover():Boolean
		{
			return hint_hover;
		}
		
		public function set hintHover(m:Boolean):void
		{
			hint_hover = m;
		}
		
		
		protected function isMouseon():Boolean
		{
			var _is_mouseon:Boolean;
			
			if (this.mouseX > 0 && this.mouseX < this.width && this.mouseY > 0 && this.mouseY < this.height)
			{
				_is_mouseon = true;
			}
			
			return _is_mouseon;
		}
		
		private var hint_color:uint;
		private var hint_has_v:Boolean = true;
		private var hint_x:Number;
		private var hint_y:Number;
		private var hint_v:Number;
		private var hint_t:Number;
		private var hint_hover:Boolean;
		
	}

}