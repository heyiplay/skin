package com.tudou.player.skin.events
{

	/**
	 * 皮肤消息列表
	 * 监听NetStatusEvent.NET_STATUS， 从event.code中得到下列消息，对应需要的值可以从event.level中得到
	 */
	public class SkinNetStatusEventCode
	{
		
		/*
		 * 皮肤初始化完成
		 *
		 */
		public static const SKIN_IS_READY:String = "Skin.Is.Ready";
		
		/*
		 * 进度条相关事件
		 */
		public static const SCRUBBAR_PREVIEWER_LOAD_COMPLETE:String = "ScrubBar.Previewer.LoadComplete";
		
		public static const SCRUBBAR_PREVIEWER_LOAD_FAILED:String = "ScrubBar.Previewer.LoadFailed";
		
		public static const SCRUBBAR_SLIDER_START:String = "ScrubBar.Slider.Start";
		
		public static const SCRUBBAR_SLIDER_END:String = "ScrubBar.Slider.End";
		/*
		 * 确认密码输入面板
		 *
		 * event.level: 用户输入的密码
		 */
		public static const PRIVACY_SUBMIT_PASSWORD:String="Privacy.Submit.Password";
		/*
		 * 密码输入面板联系用户
		 *
		 * event.level: 联系用户需要的链接
		 */
		public static const PRIVACY_CONTACT_OWNER:String="Privacy.Contact.Owner";
		/*
		 * 密码输入面板搜索相关
		 *
		 * event.level: 联系用户需要的链接
		 */
		public static const PRIVACY_SEARCH_RELATED:String = "Privacy.Search.Related";
		/*
		 * 显示、隐藏设置面板
		 *
		 * event.level: 设置面板显示时跳转到哪个标签页(播放/色彩/画面/其他)
		 */
		public static const SET_PANEL_TWEEN_TO_SHOW:String="SetPanel.TweenTo.Show";

		public static const SET_PANEL_TWEEN_TO_HIDE:String="SetPanel.TweenTo.Hide";

		/*
		 * 搜索Widget 获取和取消焦点
		 *
		 */
		public static const SEARCH_FOCUS_IN:String="Search.Focus.In";

		public static const SEARCH_FOCUS_OUT:String="Search.Focus.Out";

		/*
		 * 控制区域开始隐藏/开始显示
		 *
		 * event.level: 表示是哪个区域
		 */
		public static const CONTROL_AREA_TWEEN_TO_HIDE:String = "ControlArea.TweenTo.Hide";
		
		public static const CONTROL_AREA_TWEEN_TO_SHOW:String = "ControlArea.TweenTo.Show";
		
		public static const CONTROL_AREA_TWEEN_END:String = "ControlArea.Tween.End";
		
        public static const NEED_USER_LOGIN:String = "Need.User.Login";
		
		public static const NEED_USER_REGISTER:String = "Need.User.Register";
		
	}

}

