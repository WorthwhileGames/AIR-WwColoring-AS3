package org.wwlib.flash 
{
	
	import org.wwlib.WwColoring.anim.UI_ColoringMenu;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import org.wwlib.starling.WwColoringScene;
	import org.wwlib.utils.WwDebug;

	/**
	 * ...
	 * @author Andrew Rapo (andrew@worthwhilegames.org)
	 * @license MIT
	 */
	public class WwColoringMenuController 
	{
		private var __debug:WwDebug;
		private var __coloringScene:WwColoringScene;
		
		private var __menu_mc:UI_ColoringMenu;
		private var __bg_mc:MovieClip;
		
		private var __back_mc:MovieClip;
		private var __home_mc:MovieClip;
		private var __tools_mc:MovieClip;
		private var __colors_mc:MovieClip;
		private var __pages_mc:MovieClip;
		
		private var __btn_home:WwWrapperButtonMC;
		private var __btn_back:WwWrapperButtonMC;
		private var __menu:WwColoringMenu;
		
		private var __toolsTouchList:WwColoringMenuTools;
		private var __colorsTouchList:WwColoringMenuColors;
		private var __pagesTouchList:WwColoringMenuPages;
		private var __activeTouchlist:WwWrapperTouchList
		
		
		public function WwColoringMenuController(coloring_scene:WwColoringScene, menu:UI_ColoringMenu)
		//public function WwColoringMenuController(menu:UI_ColoringMenu) 
		{
			__debug = WwDebug.instance;
			__coloringScene = coloring_scene;
			__menu_mc = menu;
			
			if (__menu_mc)
			{
				__bg_mc			= __menu_mc["bg"];
				
				__back_mc 		= __menu_mc["btn_back"];
				__home_mc		= __menu_mc["btn_home"];
				__tools_mc		= __menu_mc["tools"];
				__colors_mc		= __menu_mc["colors"];
				__pages_mc		= __menu_mc["pages"];
				
				__btn_home = new WwWrapperButtonMC(__home_mc, backHomeHandler);
				__btn_back = new WwWrapperButtonMC(__back_mc, backHomeHandler);
				
				__back_mc.visible = false;
				__tools_mc.visible = false;
				__colors_mc.visible = false;
				__pages_mc.visible = false;
				
				__menu = new WwColoringMenu(this, __menu_mc, "menu");
				__menu.dragRect = new Rectangle(832, 64, 130, 0);
				
				__toolsTouchList = new WwColoringMenuTools(this, __tools_mc,"tool_", 9);
				__colorsTouchList = new WwColoringMenuColors(this, __colors_mc,"color_", 40);
				__pagesTouchList = new WwColoringMenuPages(this, __pages_mc,"page_", 4);
				
				showTools();
			}
		}
		
		public function onGlobalMouseUp(e:Event):void
		{
			if (__menu_mc)
			{
				__menu.stopDrag(e);
				__activeTouchlist.onMouseUp(e);
			}
		}
		
		public function enterFrameUpdateHandler(elapsed_time:int, total_seconds:Number):void
		{
			if (__menu_mc)
			{
				__activeTouchlist.enterFrameUpdateHandler(elapsed_time, total_seconds);
				//__colorsTouchList.enterFrameUpdateHandler(elapsed_time, total_seconds);
				//__pagesTouchList.enterFrameUpdateHandler(elapsed_time, total_seconds);
			}
		}
		
		private function backHomeHandler(e:Event):void
		{
			var mc:MovieClip = e.target as MovieClip;
			
			//__debug.msg("backHomeHandler: " + mc.name, "2");
			
			if (e.type == MouseEvent.MOUSE_UP)
			{
				switch (mc.name) 
				{
					case "btn_home":
						__coloringScene.gotoMainMenu();
						//onControlShare(null);
						break;
					case "btn_back":
						showTools();
						break;
					default:
				}
			}
		}
		
		public function show(flag:Boolean=true):void
		{
			if (__menu_mc)
			{
				__menu_mc.visible = flag;
			}
		}

		public function showTools():void
		{
			if (__menu_mc)
			{
				__activeTouchlist = __toolsTouchList;
				__pages_mc.visible = false;
				__tools_mc.visible = true;
				__colors_mc.visible = false;
				__back_mc.visible = false;
				__home_mc.visible = true;
			}
		}
		
		public function showPages():void
		{
			if (__menu_mc)
			{
				__activeTouchlist = __pagesTouchList;
				__pages_mc.visible = true;
				__tools_mc.visible = false;
				__colors_mc.visible = false;
				__back_mc.visible = true;
				__home_mc.visible = false;
			}
		}
		
		public function showColors():void
		{
			if (__menu_mc)
			{
				__activeTouchlist = __colorsTouchList;
				__pages_mc.visible = false;
				__tools_mc.visible = false;
				__colors_mc.visible = true;
				__back_mc.visible = true;
				__home_mc.visible = false;
			}
		}
		
		public function onControlShare(event:Event):void
		{
			__coloringScene.onControlShare(null);
		}
		
		
		public function get coloringScene():WwColoringScene
		{
			return __coloringScene;
		}
		
		public function dispose():void
		{
			if (__menu_mc)
			{
				__toolsTouchList.dispose();
				__pagesTouchList.dispose();
				__colorsTouchList.dispose();
				__btn_home.dispose();
				__btn_back.dispose();
				__menu.dispose();
				
				__btn_home = null;
				__btn_back = null;
				__menu = null;
				__toolsTouchList = null;
				__pagesTouchList = null;
				__colorsTouchList = null;
			}
		}
	}

}