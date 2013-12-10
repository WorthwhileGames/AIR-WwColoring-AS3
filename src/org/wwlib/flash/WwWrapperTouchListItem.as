package org.wwlib.flash
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author Andrew Rapo (andrew@worthwhilegames.org)
	 * @license MIT
	 */
	public class WwWrapperTouchListItem implements WwWrapperITouchListItem
	{
		private var __touchList:WwWrapperTouchList;
		private var __mc:MovieClip;
		private var __itemWidth:Number;
		private var __index:Number;
		private var __itemHeight:Number;
		private var __data:Object;
		
		
		public function WwWrapperTouchListItem(touch_list:WwWrapperTouchList, mc:MovieClip)
		{
			__touchList = touch_list;
			__mc = mc;
			if (__mc)
			{
				__mc.addEventListener(flash.events.MouseEvent.MOUSE_DOWN, pressHandler);
			}
		}
		
		// ----- properites --------
		
		
		public function set mc(mc:MovieClip):void
		{
			__mc = mc;
		}
		
		public function get mc():MovieClip
		{
			return __mc;
		}
		
		public function get itemWidth():Number
		{
			return __itemWidth;
		}
		public function set itemWidth(value:Number):void
		{
			__itemWidth = value;
			//draw();
		}
		
		public function get itemHeight():Number
		{
			return __itemHeight;
		}
		public function set itemHeight(value:Number):void
		{
			__itemHeight = value;
			//draw();
		}
		
		public function get data():Object
		{
			return __data;
		}
		public function set data(value:Object):void
		{
			__data = value;
			//draw();
		}
		
		public function get index():Number
		{
			return __index;
		}
		public function set index(value:Number):void
		{
			__index = value;
		}
		
		public function selectItem():void
		{
			__mc.addEventListener(MouseEvent.MOUSE_UP, selectHandler);
			__mc.alpha =  .5;

		}
		
		public function unselectItem():void
		{
			__mc.removeEventListener(MouseEvent.MOUSE_UP, selectHandler);
			//draw();
			__mc.alpha =  1.0;
		}
		
		protected function draw():void
		{
			
		}
		
		// ----- event handlers --------
		
		/**
		 * Dispatched when item is first pressed on tap or MOUSE_DOWN.
		 * */
		protected function pressHandler(e:Event):void
		{
			WwAudioManager.playMouseDown();
			__touchList.handleItemPress(this);
		}
		
		/**
		 * Dispatched when item is selected, usually on touch end or MOUSE_UP.
		 * */
		protected function selectHandler(e:Event):void
		{
			WwAudioManager.playMouseUp();
			__touchList.handleItemSelected(this);
		}
		
		// ----- Clean Up --------
		
		/**
		 * Clean up item when removed from stage.
		 * */
		public function dispose():void
		{
			__mc.removeEventListener(MouseEvent.MOUSE_UP, selectHandler);
			__mc = null;
		}
		
	}
}