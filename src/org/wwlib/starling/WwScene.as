package org.wwlib.starling
{
	import flash.events.AccelerometerEvent;
	
	import starling.events.Event;
    
	/**
	 * ...
	 * @author Andrew Rapo (andrew@worthwhilegames.org)
	 * @license MIT
	 */
    public class WwScene extends WwSprite
    {

		public static const CLOSING:String = "closing";
		
		protected var __sceneManager:WwSceneManager;
		protected var __menuXMLList:XMLList;
		//protected var __menus:Vector.<WwMenu> = new Vector.<WwMenu>();
		protected var __bg:WwSprite;
		
		/*
		protected var __borderTop:WwSprite;
		protected var __borderBottom:WwSprite;
		protected var __borderLeft:WwSprite;
		protected var __borderRight:WwSprite;
		*/
        
        public function WwScene(scene_manager:WwSceneManager)
        {
			__sceneManager = scene_manager;
			//__debug.msg("WwScene: Constructor");

        }
		
		public function acceleromterEvent(event:AccelerometerEvent):void
		{
			// Override this
		}
		
		public function enterframeEvent(elapsed_time:int, total_seconds:Number):void
		{
			// Override this
		}
		
        private function onSceneClosing():void
        {
            dispatchEvent(new Event(CLOSING, true));
        }
		
		public function initWithXML(xml:XML):void
		{
			//override
		}
        
		
		public function optionGotoScene(value:String):void
		{
			__debug.msg("optionGotoScene: " + value);
			__sceneManager.gotoScene(value);
		}
		
		public function defaultOptionFunction(value:String):void
		{
			__debug.msg("defaultOptionFunction: " + value);
		}
		
		public function debugMenuOption(value:String):void
		{
			__debug.msg("debugMenuOption: " + value);
			switch (value) 
			{
				case "btn1":
					__debug.show = !__debug.show;
				break;
				case "btn2":
					__debug.clear();
				break;
				case "btn3":
					if (__debug.alpha < 1)
					{
						__debug.alpha = 1;
					}
					else
					{
						__debug.alpha = .5;
					}
				break;
				default:
			}
		}
		

		
		public override function dispose():void
		{
			removeChildren();
			removeEventListeners();
			if (__bg)
			{
				__bg.dispose();
				__bg = null;
			}
			super.dispose();
		}
    }
}