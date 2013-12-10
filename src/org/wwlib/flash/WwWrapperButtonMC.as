package org.wwlib.flash 
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author Andrew Rapo (andrew@worthwhilegames.org)
	 * @license MIT
	 */
	public class WwWrapperButtonMC extends WwWrapperActiveMC
	{
		private var __buttonMC:MovieClip;  // TODO should be using __mc, protected?, setter?
		private var __handlerFunction:Function;
		
		public function WwWrapperButtonMC(button_mc:MovieClip, handler_function:Function) 
		{
			super(button_mc);
			__buttonMC = button_mc;
			__handlerFunction = handler_function;
			if (__buttonMC)
			{
			__buttonMC.addEventListener(MouseEvent.MOUSE_DOWN, __handlerFunction);
			__buttonMC.addEventListener(MouseEvent.MOUSE_UP, __handlerFunction);
			//__buttonMC.addEventListener(MouseEvent.MOUSE_OUT, __handlerFunction);
			}
		}
		
		override public function dispose():void 
		{
			__buttonMC.removeEventListener(MouseEvent.MOUSE_DOWN, __handlerFunction);
			__buttonMC.removeEventListener(MouseEvent.MOUSE_UP, __handlerFunction);
			//__buttonMC.removeEventListener(MouseEvent.MOUSE_OUT, __handlerFunction);
			__buttonMC = null;
			super.dispose();
		}
	}

}