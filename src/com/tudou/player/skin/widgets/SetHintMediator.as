package com.tudou.player.skin.widgets {
	import com.tudou.player.events.NetStatusCommandCode;
	import com.tudou.player.skin.utils.TimeUtil;
	import com.tudou.player.skin.widgets.Widget;
	import flash.events.MouseEvent;
	import flash.events.NetStatusEvent;
    
    /**
     * ...
     * @author 
     */
    public class SetHintMediator {
       
        private var _hintInfo:Widget;
		private var _text:String;
		private var skin_theme:String;
		private static var instance:SetHintMediator;
		
        public function SetHintMediator() {
          
        }
		public function init(hintInfo:Widget):void
		{
			_hintInfo = hintInfo;
		}
        public static function getInstance():SetHintMediator
		{
			if (null === instance) instance = new SetHintMediator();
			return instance;
		}
        
        public function onCommand(evt:NetStatusEvent):void {
           if (!_hintInfo) return;
		  /* if (!skin_theme) skin_theme = _hintInfo.parent.parent["info"].theme;
		   if (skin_theme == "TDTV" || skin_theme == "TDWS" )
			{
				if (evt.info.data.action && evt.info.data.action.indexOf("key")  == -1) return;
			}
		   if (evt.info.data.action && evt.info.data.action.indexOf("mouse") && evt.info.data.action != MouseEvent.CLICK ) return;*/
		   var code:String = "";
		   var status:int = 1;
		   var data:Array = [];
			switch (evt.info.code) 
			{
				case NetStatusCommandCode.SET_QUALITY:
					if (evt.info.data.action)
					{
						if (evt.info.data.action.indexOf("mouse") != -1 || evt.info.data.action == MouseEvent.CLICK )
						code = "H0008";
					}
					break;
				case NetStatusCommandCode.PAUSE:
					code = "H0001";
					break;
				case NetStatusCommandCode.STOP:
					code = "H0010";
					break;
				case NetStatusCommandCode.PLAY:
				case NetStatusCommandCode.RESUME:
					code = "H0000";
					break;
				case NetStatusCommandCode.SET_PANEL_RARAMS_CHANGED:
					if (evt.info.data.value && evt.info.data.value == NetStatusCommandCode.SET_ROTATION_ANGLE) code = "H0009";
					else code = "H0007";
					break;
				case NetStatusCommandCode.SEEK:
					code = TimeUtil.formatAsTimeCode(Number(evt.info.data.time));
					status = 0;
					break;
				case NetStatusCommandCode.SET_VOLUME:
				case NetStatusCommandCode.VOLUME_UP:
				case NetStatusCommandCode.VOLUME_DOWN:
					var num:int = Math.round(evt.info.data.value * 100);
					if (num == 0)
					{
						code = "H0002";
					}else {
						code = "H0003";
						data = [ num + "%" ];
					}
					break;
				/*case NetStatusCommandCode.RECONNECT:
				case NetStatusCommandCode.SET_PLAYER_SIZE_NORMAL:
				case NetStatusCommandCode.SET_PLAYER_SIZE_FULLSCREEN:
				case NetStatusCommandCode.REPLAY:
				case NetStatusCommandCode.SEARCH:
				case NetStatusCommandCode.HIDE_PLAY_LIST:
				case NetStatusCommandCode.SHOW_PLAY_LIST:
				case NetStatusCommandCode.TOGGLE_HIDE_SHOW_SET_PANEL:
				case NetStatusCommandCode.SHOW_SET_PANEL:
				case NetStatusCommandCode.OPEN_DANMU:
				case NetStatusCommandCode.CLOSE_DANMU:
				case NetStatusCommandCode.SET_ALLOW_FULL_SCREEN_INTERACTIVE:
				case NetStatusCommandCode.SET_HARDWARE_ACCELERATE:
				case NetStatusCommandCode.SET_COLOR_MODE:
				case NetStatusCommandCode.SET_COLOR_BRIGHTNESS:
				case NetStatusCommandCode.SET_COLOR_CONTRAST:
				case NetStatusCommandCode.SET_COLOR_SATURATION:
				case NetStatusCommandCode.SET_PROPORTION_MODE:
				case NetStatusCommandCode.SET_SCALE:
				break;*/
			}
			if (code && code != "" && _hintInfo.hasOwnProperty("showInfo")) _hintInfo["showInfo"](code, status, data);
        }
        
    }
}