package com.tudou.player.config 
{
	import com.tudou.net.JSONFileLoader;
	import com.tudou.player.events.NetStatusEventCode;
	import com.tudou.player.events.NetStatusEventLevel;
	import com.tudou.utils.Global;
	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.NetStatusEvent;
	/**
	 * 播放器的语种
	 * - 控制播放器 选择什么语种显示提示或错误信息
	 * 
	 * @author 8088 at 2014/6/26 13:31:45
	 */
	public class PlayerLanguage extends EventDispatcher
	{
		
		public function PlayerLanguage(lock:Class = null) 
		{
			if (lock != ConstructorLock)
			{
				throw new IllegalOperationError("单例，禁止直接实例化 ！!");
			}
			
			_strings = _default;
			_langid = _default_langid;
		}
		
		public static function getInstance():PlayerLanguage
		{
			_instance ||= new PlayerLanguage(ConstructorLock);
			return _instance;
		}
		
		/**
		 * 获取字符串
		 */
		public function getString(code:String, type:String=NetStatusEventLevel.STATUS, params:Array=null):String
		{
			var value:String;
			switch(type)
			{
				case NetStatusEventLevel.STATUS:
					value = _strings.status.hasOwnProperty(code) ? String(_strings.status[code]) : null;
					break;
				case NetStatusEventLevel.WARNING:
					value = _strings.warning.hasOwnProperty(code) ? String(_strings.warning[code]) : null;
					break;
				case NetStatusEventLevel.ERROR:
					value = _strings.error.hasOwnProperty(code) ? String(_strings.error[code]) : null;
					break;
				case NetStatusEventLevel.HINT:
					if(_strings.hint) value = _strings.hint.hasOwnProperty(code) ? String(_strings.hint[code]) : null;
					break;
			}
			if (type == NetStatusEventLevel.HINT && value == null) return "";
			if (value == null)
			{
				value = _strings.error["E0000"];
				params = [code];
			}
			
			if (params)
			{
				value = substitute(value, params);
			}
			
			return value;
		}
		
		/**
		 * 语言标识
		 * - 支持 zh-CN(简体中文)、zh-TW(繁体中文)、en(英)、kr(韩)、ja(日)、ru(俄)、fr(法)、de(德)
		 */
		public function get langid():String
		{
			return _langid;
		}
		
		public function set langid(value:String):void
		{
			if (_langid != value)
			{
				_langid = value;
				
				loadString();
			}
		}
		
		public function setbaseUrl():void
		{
			var value:String = Global.getInstance().system.baseDir;
			if (value != null && value != "" && _baseurl != value)
			{
				_baseurl = value;
				
				loadString();
			}
		}
		
		// Internals...
		//
		private function loadString():void
		{
			if ( _baseurl != "" && _langid != "")
			{
				var _url:String = "language/" + _langid + "/strings"
				_url = _baseurl + _url;
				var loader:JSONFileLoader = new JSONFileLoader();
				loader.addEventListener(Event.COMPLETE, onComplete);
				loader.addEventListener(IOErrorEvent.IO_ERROR, onError);
				loader.load(_url);
			}
		}
		private function onComplete(evt:Event):void
		{
			var loader:JSONFileLoader = evt.target as JSONFileLoader;
			if (loader)
			{
				try {
					_strings = loader.json;
				}
				catch (_:Error) {
					// ignore..
				};
			}
			
			dispatchEvent( new NetStatusEvent
							( NetStatusEvent.NET_STATUS
							, false
							, false
							,   { code:NetStatusEventCode.LANGUAGE_STRINGS_LOADED
								, level:NetStatusEventLevel.STATUS
								}
							)
						 );
		}
		
		private function onError(evt:Event):void
		{
			var message:String = NetStatusEventCode.LANGUAGE_CHANGE_FAILED;
			var code:String = NetStatusEventCode.getCodeByMessage(message);
			var desc:String = getString(code, NetStatusEventLevel.WARNING, [_langid]);
			dispatchEvent( new NetStatusEvent
							( NetStatusEvent.NET_STATUS
							, false
							, false
							,   { code:message
								, level:NetStatusEventLevel.WARNING
								, data: { code:code, desc:desc }
								}
							)
						 );
						 
			//回滚到默认设置
			_strings = _default;
			
			_langid = _default_langid;
			
		}
		
		private function substitute(value:String, ... rest):String
		{
			var result:String = "";

			if (value != null)
			{
				result = value;
				
				var len:int = rest.length;
				var args:Array;
				if (len == 1 && rest[0] is Array)
				{
					args = rest[0] as Array;
					len = args.length;
				}
				else {
					args = rest;
				}
				
				for (var i:int = 0; i < len; i++)
				{
					result = result.replace(new RegExp("\\{"+i+"\\}", "g"), args[i]);
				}
			}
			
			return result;
		}
		
		private static var _instance:PlayerLanguage;
		
		private var _default_langid:String = "zh-CN";
		
		private var _langid:String = "";
		private var _baseurl:String = "";
		private var _strings:Object;
		
		private var _default:Object = 
		{
			"error":{
				"E0000":"非常抱歉，检测到未知错误，请尝试刷新或联系客服。",
				"E1000":"非常抱歉，此播放器禁止盗用，如需合作请前往<a href='{0}'><font color='#FF6600'><u>优酷土豆放平台</u></font></a>。",
				"E1001":"缺少参数，如需设置请查看<a href='{0}'><font color='#FF6600'><u>帮助文档</u></font></a>。",
				"Y1000":"由于天气干扰导致“信号”中断^ ^，请刷新页面重新连接",
				"Y1001":"尚未开始，客官稍安勿躁",
				"Y1002":"暂时无法播放T  T\n试着刷一下页面继续“前缘”吧。",
				"Y1003":"呜呜.....暂时无法播放T  T",

				"Y2000":"啊哦！播放失败啦！\n请刷新一下页面重试。",
				"Y2001":"啊哦！播放失败啦！\n请刷新一下页面重试。",
				"Y2002":"啊哦！播放失败啦！\n请刷新一下页面重试。",
				"Y2003":"啊哦！播放失败啦！\n请刷新一下页面重试。",
				"Y2004":"啊哦！播放失败啦！\n请刷新一下页面重试。",
				"Y2006":"啊哦！播放失败啦！\n请刷新一下页面重试。",
				"Y2007":"啊哦！播放失败啦！\n请刷新一下页面重试。",
				"Y2008":"啊哦！播放失败啦！\n请刷新一下页面重试。",
				"Y2100":"啊哦！播放失败啦！\n请刷新一下页面重试。",
				"Y2999":"啊哦！播放失败啦！\n请刷新一下页面重试。",
				"R1000":"啊哦！播放失败啦！\n请刷新一下页面重试。",
				"R1001":"啊哦！播放失败啦！\n请刷新一下页面重试。",
				"R2000":"啊哦！播放失败啦！\n请刷新一下页面重试。",
				"S1000":"啊哦！播放失败啦！\n请刷新一下页面重试。",
				"S1001":"啊哦！播放失败啦！\n请刷新一下页面重试。",
				"S2000":"啊哦！播放失败啦！\n请刷新一下页面重试。",

				"Y3000":"哎呦！需要付费哦~\n购买完就可以看啦~~",
				"Y3001":"哎呦！需要付费哦~\n购买完就可以看啦~~",
				"Y3100":"哎呦！需要付费哦~\n购买完就可以看啦~~",
				"Y3101":"哎呦！需要付费哦~\n购买完就可以看啦~~",

				"Y3002":"观看次数已经用完\n请再次购买观看吧！",
				"Y3003":"购买时限已经过期了\n请再次购买观看吧！",
				
				"Y4000":"该处属于神秘地带\n请告诉我你的口令",
				"Y4001":"该视频只在中国大陆播放\n请您观看其他视频！",
				"Y7000":"仅黄金会员可看\n请登录或开通黄金会员。"
			},
			"warning": {
				"W1000":"非常抱歉，暂不支持 '{0}' 语言，如有需要请联系客服。"
			},
			"hint":{
				"H0000":"播放",
				"H0001":"暂停",
				"H0002":"静音",
				"H0003":"音量：{0}",
				"H0004":"按方向键 ↑ 继续放大音量",
				"H0005":"单曲循环:开",
				"H0006":"单曲循环:关",
				"H0007":"设置成功",
				"H0008":"清晰度切换成功",
				"H0009":"画面旋转",
				"H0010":"停止"
			}
		}

		
	}

}

class ConstructorLock {};