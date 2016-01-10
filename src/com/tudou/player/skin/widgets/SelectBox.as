package com.tudou.player.skin.widgets 
{
	import com.tudou.player.events.NetStatusCommandCode;
	import com.tudou.player.skin.events.SkinNetStatusEventCode;
	import com.tudou.layout.LayoutSprite;
	import com.tudou.player.skin.MediaPlayerSkin;
	import com.tudou.utils.Check;
	import flash.events.NetStatusEvent;
	import flash.utils.getDefinitionByName;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.utils.getQualifiedClassName;
	/**
	 * SelectBox
	 * 
	 * @author 8088
	 */
	public class SelectBox extends LayoutSprite
	{
		
		public function SelectBox( normal:DisplayObject, focused:DisplayObject=null, pressed:DisplayObject=null, disabled:DisplayObject=null):void
		{
			super();
			
			this.normal = normal;
			this.focused = focused;
			this.pressed = pressed;
			this.disabled = disabled;
			
			this.mouseChildren = false;
			
			var format:TextFormat = new TextFormat();
			format.size = 12;
			format.font = "Verdana";
			format.color = 0xFFFFFF;
			
			label_txt = new TextField();
			label_txt.height = 18;
			label_txt.width = 20;
			label_txt.multiline = false;
			label_txt.defaultTextFormat = format;
			label = _label;
			addChild(label_txt);
			
			updateFace(this.normal);
		}
		
		override protected function onStage(evt:Event=null):void
		{
			super.onStage(null);
			//
			
			buildOptionList();
		}
		
		override protected function reSetWidth():void
		{
			normal.width = this.width;
			focused.width = this.width;
			pressed.width = this.width;
			disabled.width = this.width;
			label_txt.width = this.width;
		}
		
		override protected function reSetHeight():void
		{
			normal.height = this.height;
			focused.height = this.height;
			pressed.height = this.height;
			disabled.height = this.height;
			label_txt.y = int((this.height -label_txt.height) * .5);
		}
		
		override protected function reSetX():void
		{
			if (!option_list || !stage) return;
			var point:Point =  localToGlobal(new Point(0, 0));
			option_list.x = point.x;
		}
		
		override protected function reSetY():void
		{
			if (!option_list || !stage) return;
			var point:Point =  localToGlobal(new Point(0, 0));
			
			if (_global.stageHeight - point.y < option_list_h+ this.height) 
			{
				option_list_v = -1;
				rectangle = new Rectangle(0, this.height, this.width, -this.height);
			}
			else {
				option_list_v = 1;
				rectangle = new Rectangle(0, 0, this.width, option_list_h + this.height);
			}
			option_list.y = point.y + this.height * option_list_v + option_list_v;
		}
		
		protected function updateFace(face:DisplayObject):void
		{
			if (face == null) return;
			if (currentFace != face)
			{
				if (currentFace)
				{
					removeChild(currentFace);
				}
				
				currentFace = face;
				
				if (currentFace)
				{
					addChildAt(currentFace, 0);
				}
			}
			
		}
		
		protected function onMouseLeave(evt:Event):void
		{
			select = false;
		}
		
		protected function onStageMouseDown(evt:MouseEvent):void
		{
			var point:Point = new Point(this.mouseX, this.mouseY);
			if (Check.Out(point, rectangle)) select = false;
		}
		
		protected function onMouseDown(evt:MouseEvent):void
		{
			select = !select;
		}
		
		protected function onRollOver(evt:MouseEvent):void
		{
			if(!_select) updateFace(this.focused);
		}
		
		protected function onRollOut(evt:MouseEvent):void
		{
			if(!_select) updateFace(this.normal);
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
			updateFace(enabled ? normal : disabled);
			
			if (enabled)
			{
				label_txt.textColor = 0xFFFFFF;
				addEventListener(MouseEvent.ROLL_OVER, onRollOver);
				addEventListener(MouseEvent.ROLL_OUT, onRollOut);
				addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
				
				if (stage)
				{
					stage.addEventListener(MouseEvent.MOUSE_DOWN, onStageMouseDown);
					stage.addEventListener(Event.MOUSE_LEAVE, onMouseLeave);
				}
			}
			else {
				label_txt.textColor = 0x666666;
				removeEventListener(MouseEvent.ROLL_OVER, onRollOver);
				removeEventListener(MouseEvent.ROLL_OUT, onRollOut);
				removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
				
				if (stage)
				{
					stage.removeEventListener(MouseEvent.MOUSE_DOWN, onStageMouseDown);
					stage.removeEventListener(Event.MOUSE_LEAVE, onMouseLeave);
				}
			}
		}
		
		public function get option():Array
		{
			return _option;
		}
		
		public function set option(ary:Array):void
		{
			_option = ary;
			
			if(stage) buildOptionList();
		}
		
		private function buildOptionList():void
		{
			if (option_list)
			{
				if (stage && stage.contains(option_list)) stage.removeChild(option_list);
				option_list = null;
			}
			
			option_list = new Sprite();
			var ln:int = option.length;
			
			option_list_h = normal.height * ln;
			
			var point:Point =  localToGlobal(new Point(0, 0));
			option_list.x = point.x;
			
			if (_global.stageHeight - point.y < option_list_h+ this.height) 
			{
				option_list_v = -1;
				rectangle = new Rectangle(0, this.height, this.width, -this.height);
			}
			else {
				option_list_v = 1;
				rectangle = new Rectangle(0, 0, this.width, option_list_h + this.height);
			}
			option_list.y = point.y + this.height * option_list_v + option_list_v;
			
			
			
			var format:TextFormat = new TextFormat();
			format.align = TextFormatAlign.LEFT;
			btns = { };
			for (var i:int = 0; i != ln; i++)
			{
				var li:SelectBoxList = new SelectBoxList
									( option[i]
									, copyView(option_btn_normal) 
									, copyView(option_btn_focused)
									, copyView(option_btn_pressed)
									);
				li.style = "width:" + this.width 
								+ "; height:" + normal.height 
								+ "; y:" + this.height * i * option_list_v
								+ ";";
				li.enabled = true;
				li.textField.autoSize = TextFieldAutoSize.LEFT;
				li.id = option[i];
				if (li.id == label)
				{
					li.cur = true;
					_cur = li;
				}
				btns[li.id] = li;
				option_list.addChild(li);
				
				li.addEventListener(MouseEvent.MOUSE_UP, listUpHandler);
				option_list.addEventListener(MouseEvent.MOUSE_OVER, listOverHandler);
			}
			
		}
		
		//private
		
		private function listOverHandler(evt:MouseEvent):void
		{
			option_list.removeEventListener(MouseEvent.MOUSE_OVER, listOverHandler);
			if (_cur) _cur.cur = false;
		}
		
		private function listUpHandler(evt:MouseEvent):void
		{
			var btn:SelectBoxList = evt.target as SelectBoxList;
			
			
			btn.cur = true;
			_cur = btn;
			label = btn.id;
			
			select = false;
			
			dispatch(btn.id);
		}
		
		private function dispatch(id:String):void
		{
			dispatchEvent( new NetStatusEvent
							( NetStatusEvent.NET_STATUS
							, false
							, false
							, { code:"selectChange", level:"status", data:{value:id} }
							)
						 );
		}
		
		private function copyView(view:DisplayObject):DisplayObject
		{
			var v:DisplayObject
			var C:Class = getDefinitionByName(getQualifiedClassName(view)) as Class;
			v = new C() as DisplayObject;
			return v;
		}
		
		private function createList():void
		{
			buildOptionList();
			stage.addChild(option_list);
		}
		
		private function destroyList():void
		{
			if (option_list)
			{
				if (stage && stage.contains(option_list)) stage.removeChild(option_list);
				option_list = null;
			}
		}
		
		public function setOptionBtnStyle(normal:DisplayObject, focused:DisplayObject = null, pressed:DisplayObject = null, disabled:DisplayObject = null):void
		{
			if(normal) this.option_btn_normal = normal;
			if(focused) this.option_btn_focused = focused;
			if(pressed) this.option_btn_pressed = pressed;
			if(disabled) this.option_btn_disabled = disabled;
		}
		
		public function get select():Boolean
		{
			return _select;
		}
		
		public function set select(s:Boolean):void
		{
			if (!stage) return;
			
			_select = s;
			updateFace(_select? this.pressed:this.normal);
			
			if (_select) createList();
			else destroyList();
		}
		
		public function set label(l:String):void
		{
			_label = l;
			if (label_txt) label_txt.text = _label;
			if (btns && btns[_label]) btns[_label].cur = true;
		}
		
		public function get label():String
		{
			return _label;
		}
		
		protected var normal:DisplayObject;
		protected var focused:DisplayObject;
		protected var pressed:DisplayObject;
		protected var disabled:DisplayObject;
		protected var _label:String = "请选择";
		protected var label_txt:TextField;
		
		private var currentFace:DisplayObject;
		private var _enabled:Boolean;
		private var _select:Boolean;
		
		private var _option:Array;
		private var option_list_h:Number;
		private var option_list_v:int;
		private var rectangle:Rectangle;
		private var _cur:SelectBoxList
		private var btns:Object;
		
		private var option_list:Sprite;
		private var option_btn_normal:DisplayObject;
		private var option_btn_focused:DisplayObject;
		private var option_btn_pressed:DisplayObject;
		private var option_btn_disabled:DisplayObject;
		
	}

}