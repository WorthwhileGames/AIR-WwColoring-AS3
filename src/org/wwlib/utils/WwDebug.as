package org.wwlib.utils 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import org.wwlib.utils.debugPanel;
	
	/**
	 * ...
	 * @author Andrew Rapo (andrew@worthwhilegames.org)
	 * @license MIT
	 */
	public class WwDebug 
	{
		private static const APP_VESRION_NUM:String = "1.0.0";
		private static var __instance:WwDebug;
		private var __stage:MovieClip;
		private var __SHOW_DEBUG_MESSAGES:Boolean;
		private var __debugPanel_mc:debugPanel;
		private var __activeLevel:String;
		private var __frameRateText:TextField;
		private var __frameRate:Number;
		private var __statusText:TextField;
		
		private var __tab_move:MovieClip;
		private var __tab_lvl1:MovieClip;
		private var __tab_lvl2:MovieClip;
		private var __tab_lvl3:MovieClip;
		private var __tab_clear:MovieClip;
		private var __tab_close:MovieClip;
		private var __btn_login:MovieClip;
		private var __btn_logout:MovieClip;
		
		/**
		*   Construct the WwDebug instance. This class is a Singleton, so it should not
		*   be directly instantiated. Instead, call the static "instance" getter
		*   to get an instance of it.
		*   @param enforcer A SingletonEnforcer specifically designed to be
		*                   impossible to pass by outside classes.
		*/
		public function WwDebug(enforcer:SingletonEnforcer)
		{
			if (!(enforcer is SingletonEnforcer))
			{
				throw new ArgumentError("WwDebug cannot be directly instantiated!");
			}
		}
		
		/**
		*   Initialize the singleton if it has not already been initialized
		*   @return The singleton instance
		*/
		public static function init(_stage:MovieClip): WwDebug
		{
			if (__instance == null)
			{
				__instance = new WwDebug(new SingletonEnforcer());
			}
			
			__instance.stage = _stage;
			__instance.setupUI();
			return __instance;
		}
		
		/**
		*   Get the singleton instance
		*   @return The singleton instance or null if it has not yet been
		*           initialized
		*/
		public static function get instance(): WwDebug
		{
			return __instance;
		}

		public function set stage(_stage:MovieClip):void
		{
			__stage = _stage;
		}
		
		public function setupUI():void
		{
			__SHOW_DEBUG_MESSAGES = true;
			
			__debugPanel_mc = new debugPanel();
			__debugPanel_mc.x = WwDeviceInfo.instance.debuggerX;  
			__debugPanel_mc.y = WwDeviceInfo.instance.debuggerY;
			__tab_move = __debugPanel_mc["tab_move"];
			__tab_lvl1 = __debugPanel_mc["tab_lvl1"];
			__tab_lvl2 = __debugPanel_mc["tab_lvl2"];
			__tab_lvl3 = __debugPanel_mc["tab_lvl3"];
			__tab_clear = __debugPanel_mc["tab_clear"];
			__tab_close = __debugPanel_mc["tab_close"];
			__btn_login = __debugPanel_mc["btn_login"];
			__btn_logout = __debugPanel_mc["btn_logout"];
			
			__frameRateText = __debugPanel_mc["debug_field_fps"];
			__statusText = __debugPanel_mc["debug_field_status"];
			
			setMouseUpHandler(__tab_move, onTab_Move);
			setMouseUpHandler(__tab_clear, onTab_Clear);
			
			__tab_move.alpha = 0;
			
			__tab_lvl1.level_num = "1";
			__tab_lvl2.level_num = "2";
			__tab_lvl3.level_num = "3";
			
			setMouseUpHandler(__tab_lvl1, onTab_Lvl);
			setMouseUpHandler(__tab_lvl2, onTab_Lvl);
			setMouseUpHandler(__tab_lvl3, onTab_Lvl);
			
			setMouseUpHandler(__tab_close, onTab_Close);
			
			setMouseUpHandler(__btn_login, onBtn_Login);
			setMouseUpHandler(__btn_logout, onBtn_Logout);
			
            __stage.addChild(__debugPanel_mc);
			activeLevel = "1";
			show = false;
			msg("App Version: " + APP_VESRION_NUM, "1");

		}
		
		public function resetUI():void
		{
			__stage.removeChild(__debugPanel_mc);
			__debugPanel_mc = null;
			setupUI();
		}
		
		/* *** MOUSE HANDLERS *** */
		
		private function setMouseUpHandler(mc:MovieClip, func:Function):void
		{
			if (mc != null)
			{
				mc.addEventListener(MouseEvent.MOUSE_DOWN, func);
			}
		}
		
		public function onTab_Move(event:Event):void
		{
			var btn:MovieClip = event.target as MovieClip;
			var btn_parent:MovieClip = MovieClip(btn.parent);
			var btn_name:String = btn_parent.name;
			
			//msg("onTab_Move: " + btn_name);
			
			btn_parent.startDrag();
			__tab_move.addEventListener(MouseEvent.MOUSE_UP, onTab_Move_UP);
		}
		
		public function onTab_Move_UP(event:Event):void
		{
			var btn:MovieClip = event.target as MovieClip;
			var btn_parent:MovieClip = MovieClip(btn.parent);
			var btn_name:String = btn_parent.name;
			
			btn_parent.stopDrag();
			
			__tab_move.removeEventListener(MouseEvent.MOUSE_UP, onTab_Move_UP);
		}
		
		public function onTab_Clear(event:Event):void
		{
			var btn:MovieClip = event.target as MovieClip;
			var btn_parent:MovieClip = MovieClip(btn.parent);
			var btn_name:String = btn_parent.name;
			
			//msg("onTab_Clear: " + btn_name);
			
			clear();
		}
		
		public function onTab_Lvl(event:Event):void
		{
			var btn:MovieClip = event.target as MovieClip;
			var btn_parent:MovieClip = MovieClip(btn.parent);
			var btn_name:String = btn_parent.name;
			
			//msg("onTab_Lvl: " + btn.level_num);
			activeLevel = btn.level_num;
		}
		
		public function onTab_Close(event:Event):void
		{
			var btn:MovieClip = event.target as MovieClip;
			var btn_parent:MovieClip = MovieClip(btn.parent);
			var btn_name:String = btn_parent.name;
			
			__debugPanel_mc.x = WwDeviceInfo.instance.debuggerX;
			__debugPanel_mc.y = WwDeviceInfo.instance.debuggerY;
		}
		
		public function onBtn_Login(event:Event):void
		{
			//DECOUPLED WwGoViral.instance.loginFacebook();
		}
		
		public function onBtn_Logout(event:Event):void
		{
			//DECOUPLED WwGoViral.instance.logoutFacebook();
		}

		
		/* *** END MOUSE HANDLERS *** */
		
		public function set showDebugMessages(flag:Boolean):void
		{
			__SHOW_DEBUG_MESSAGES = flag;
		}
		
		public function clear():void
		{
			__debugPanel_mc["debug_field_lvl" + __activeLevel].text = "CLEARED:\n";
		}
		
		public function set activeLevel(level:String):void
		{
			__activeLevel = level;
			
			var txt:TextField;
			for (var i:int = 1; i < 4; i++)
			{
				txt = __debugPanel_mc["debug_field_lvl" + i];
				txt.visible = false;
			}
			
			txt = __debugPanel_mc["debug_field_lvl" + level];
			txt.visible = true;
		}
		
		public function set show(flag:Boolean):void
		{
			__debugPanel_mc.visible = flag;
		}
		
		public function get show():Boolean
		{
			return __debugPanel_mc.visible;
		}
		
		public function msg(_msg:String, level:String = "1"):void
		{
			if (__SHOW_DEBUG_MESSAGES)
			{
				__debugPanel_mc["debug_field_lvl" + level].appendText(level + ": " + _msg + "\n");
			}
		}
		
		public function set alpha(a:Number):void
		{
			__debugPanel_mc.alpha = a;
		}
		
		public function get alpha():Number
		{
			return __debugPanel_mc.alpha;
		}
		
		public static function set fps(rate:Number):void
		{
			__instance.__frameRate = rate;
			var fps_text:String = "" + int(__instance.__frameRate*10)/10;
			__instance.__frameRateText.text = fps_text;
		}
		
		public function set status(text:String):void
		{
			__instance.__statusText.text = text;
		}
	}

}

/** A class that is here specifically to stop public instantiation of the
*   WwDebug singleton. It is inaccessible by classes outside this file. */
class SingletonEnforcer{}