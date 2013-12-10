package org.wwlib.flash 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author Andrew Rapo (andrew@worthwhilegames.org)
	 * @license MIT
	 */
	public class WwColoringMenu
	{
		private var __controller:WwColoringMenuController;
		private var __mc:MovieClip;
		private var __handle_mc:MovieClip;
		private var __dragRect:Rectangle;
		private var __id:String;
		
		public function WwColoringMenu(_controller:WwColoringMenuController, mc:MovieClip, id:String) 
		{
			__controller = _controller;
			__mc = mc;
			__mc.addEventListener(MouseEvent.MOUSE_DOWN, onPropagationHandler);
			__handle_mc	= __mc["handle"];
			__handle_mc.addEventListener(MouseEvent.MOUSE_DOWN, startDrag);
			__id = id;
		}
		
		protected function onPropagationHandler(event:MouseEvent):void
		{
			// stop propagation works for MOUSE events
			// event.stopImmediatePropagation();
			// the uiActive flag is necessary to handle device TOUCH events
			__controller.coloringScene.uiActive = true;
			WwAudioManager.playMouseDown();
			
		}
		
		public function set dragRect(r:Rectangle):void
		{
			__dragRect = r;
		}
		
		private function startDrag(e:Event):void
		{
			__handle_mc.removeEventListener(MouseEvent.MOUSE_DOWN, startDrag);
			__handle_mc.addEventListener(MouseEvent.MOUSE_UP, stopDrag);
			//__handle_mc.addEventListener(MouseEvent.MOUSE_OUT, stopDrag);
			__mc.startDrag(false, __dragRect);
		}
		
		public function stopDrag(e:Event):void
		{
			__handle_mc.removeEventListener(MouseEvent.MOUSE_UP, stopDrag);
			//__handle_mc.removeEventListener(MouseEvent.MOUSE_OUT, stopDrag);
			__handle_mc.addEventListener(MouseEvent.MOUSE_DOWN, startDrag);
			__mc.stopDrag();
		}
		
		public function dispose():void
		{
			__handle_mc = null;
		}
		
	}

}