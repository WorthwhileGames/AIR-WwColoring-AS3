/**
	 * ...
	 * @author Andrew Rapo (andrew@worthwhilegames.org)
	 * @license MIT
	 * @blog
	 * @twitter
	 * Copyright (c) 2013
	 * 
	 * Based on Touchlist by Michael Ritchie, http://www.thanksmister.com. 
	 * 
	 * Per Michael Ritchie: TouchList is an ActionScript 3 scrolling list for iOS and Android mobile devices. It uses code from other Flex/Flash examples for scrolling lists by the following people or location:
	 * 
	 *   Dan Florio ( polyGeek )
	 *   polygeek.com/2846_flex_adding-physics-to-your-gestures
	 * 
	 *   James Ward
	 *   www.jamesward.com/2010/02/19/flex-4-list-scrolling-on-android-with-flash-player-10-1/
	 * 
	 *   FlepStudio
	 *   www.flepstudio.org/forum/flepstudio-utilities/4973-tipper-vertical-scroller-iphone-effect.html
	 * 
	 *   You may use this code for your personal or professional projects, just be sure to give credit where credit is due.
	 * 
	 * Per Andrew Rapo: WwWrapperTouchList expects a structured MovieClip to be provided - authored in Flash Professional and made available via a SWC.  
	 *   WwWrapperTouchList 'wraps' this clip and adds the touch list functionality.
 **/


package org.wwlib.flash
{
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;

	public class WwWrapperTouchList
	{
		private var __container_mc:MovieClip;
		private var __list_mc:MovieClip;
		private var __listHitArea:MovieClip;
		private var __listMask:Shape;
		
		private var __listWidth:Number;
		private var __listHeight:Number;
		private var __scrollAreaHeight:Number;
		private var __scrollListHeight:Number;
		
		//------ Scrolling ---------------
		
		private var __scrollBar:MovieClip;
		private var __lastY:Number = 0; // last touch position
		private var __firstY:Number = 0; // first touch position
		private var __listY:Number = 0; // initial list position on touch 
		private var __diffY:Number = 0;;
		private var __inertiaY:Number = 0;
		private var __minY:Number = 0;
		private var __maxY:Number = 0;
		private var __totalY:Number;
		private var __scrollRatio:Number = 3; // how many pixels constitutes a touch
		
		//------- Touch Events --------
		
		private var __isTouching:Boolean = false;
		private var __tapDelayTime:Number = 0;
		private var __maxTapDelayTime:Number = 1; // change this to increase or descrease tap sensitivity
		private var __tapItem:WwWrapperTouchListItem;
		private var __tapEnabled:Boolean = false;
		
		// ----- Items
		
		protected var __items:Vector.<WwWrapperITouchListItem>;
		private var __itemPrefix:String;
		private var __item_count:int;
		protected var __activeItem:WwWrapperTouchListItem;
		protected var __itemFiltersShadow:Array;
		protected var __itemFiltersShadowGlow:Array;
		
		public function WwWrapperTouchList(container_mc:MovieClip, item_prefix:String, _item_count:int)
		{
			__container_mc = container_mc;
			__container_mc.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			
			__itemPrefix = item_prefix;
			__item_count = _item_count;
			
			__list_mc = __container_mc["list"]
				
			__listHitArea = __container_mc["bg"];
			__listMask = new Shape();
			__listMask.x = __listHitArea.x;
			__listMask.y = __listHitArea.y;
			__listMask.graphics.clear();
			__listMask.graphics.beginFill(0x0000FF, 1);
			__listMask.graphics.drawRect(0, 0, __listHitArea.width, __listHitArea.height)
			__listMask.graphics.endFill();
			__container_mc.addChild(__listMask);
			__list_mc.mask = __listMask;
			__container_mc.swapChildren(__listMask, __list_mc);
			
			__listWidth = __listHitArea.width; 
			__listHeight = __listHitArea.height;

			__scrollAreaHeight = __listHeight;
			__scrollListHeight = __list_mc.height;
				
			//__container_mc.addEventListener(Event.REMOVED_FROM_STAGE, dispose);
			
			__itemFiltersShadow = [ new DropShadowFilter(4,45,0,1,10,10, .4)];
			__itemFiltersShadowGlow = [ new DropShadowFilter(4,45,0,1,10,10, .4), new GlowFilter(0xFFFFFF,1,10,10)];
			
			createScrollBar();
			initializeItems();
		}
		
		public function initializeItems():void
		{
			__items = new Vector.<WwWrapperITouchListItem>;
			
			for (var i:int = 1; i <= __item_count; i++) 
			{
				var item_mc:MovieClip = __list_mc[__itemPrefix + i];
				var item:WwWrapperTouchListItem = new WwWrapperTouchListItem(this, item_mc);
				item.index = i;
				__items.push(item);
			}
		}
		
		
		/**
		 * Create our scroll bar based on the height of the scrollable list.
		 * */
		private function createScrollBar():void
		{
			if(!__scrollBar) {
				__scrollBar = new MovieClip();
				__container_mc.addChild(__scrollBar);
			}
			
			__scrollBar.x = __listWidth - 5;
			__scrollBar.graphics.clear();
			
			if(__scrollAreaHeight < __scrollListHeight) {
				__scrollBar.graphics.beginFill(0x505050, .8);
				__scrollBar.graphics.lineStyle(1, 0x5C5C5C, .8);
				__scrollBar.graphics.drawRoundRect(0, 0, 4, (__scrollAreaHeight/__scrollListHeight*__scrollAreaHeight), 6, 6);
				__scrollBar.graphics.endFill();
				__scrollBar.alpha = 0;
			}
		}
		
		/**
		 * Detects frist mouse or touch down position.
		 * */

		public function onMouseDown(e:Event):void
		{
			__container_mc.addEventListener( MouseEvent.MOUSE_MOVE, onMouseMove );
			__container_mc.addEventListener( MouseEvent.MOUSE_UP, onMouseUp );
			__container_mc.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			//__container_mc.addEventListener( MouseEvent.MOUSE_OUT, onMouseUp );

			//__list_mc.cacheAsBitmap = true;
			
			__inertiaY = 0;
			__firstY = __container_mc.mouseY;
			__listY = __list_mc.y;
			__minY = Math.min(-__list_mc.y, -__scrollListHeight + __listHeight - __list_mc.y);
			__maxY = -__list_mc.y;
		}
		
		/**
		 * List moves with mouse or finger when mouse down or touch activated. 
		 * If we move the list moves more than the scroll ratio then we 
		 * clear the selected list item. 
		 * */
		protected function onMouseMove( e:Event ):void 
		{
			__totalY = __container_mc.mouseY - __firstY;
			
			if(Math.abs(__totalY) > __scrollRatio) __isTouching = true;
			
			if(__isTouching) {
				
				__diffY = __container_mc.mouseY - __lastY;	
				__lastY = __container_mc.mouseY;
				
				if(__totalY < __minY)
					__totalY = __minY - Math.sqrt(__minY - __totalY);
				
				if(__totalY > __maxY)
					__totalY = __maxY + Math.sqrt(__totalY - __maxY);
				
				__list_mc.y = __listY + __totalY;
				
				onTapDisabled();
			}
		}
		
		/**
		 * Handles mouse up and begins animation. This also deslects
		 * any currently selected list items. 
		 * */
		public function onMouseUp( e:Event ):void 
		{
			__container_mc.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown );
			__container_mc.removeEventListener( MouseEvent.MOUSE_MOVE, onMouseMove );
			__container_mc.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			//__container_mc.removeEventListener(MouseEvent.MOUSE_OUT, onMouseUp);
			
			//__list_mc.cacheAsBitmap = false;
			
			if(__isTouching) {
				__isTouching = false;
				__inertiaY = __diffY;
			}
			
			onTapDisabled();
		}
		
		/**
		 * The ability to tab is disabled if the list scrolls.
		 * */
		protected function onTapDisabled():void
		{
			if(__tapItem){
				__tapItem.unselectItem();
				__tapEnabled = false;
				__tapDelayTime = 0;
			}
		}
		
		/**
		 * We set up a tap delay timer that only selectes a list
		 * item if the tap occurs for a set amount of time.
		 * */
		protected function onTapDelay():void
		{
			__tapDelayTime++;
			
			if(__tapDelayTime > __maxTapDelayTime ) {
				__tapItem.selectItem();
				__tapDelayTime = 0;
				__tapEnabled = false;
			}
		}
		
		/**
		 * On item press we clear any previously selected item. We only
		 * allow an item to be pressed if the list is not scrolling.
		 * */
		public function handleItemPress(item:WwWrapperTouchListItem):void
		{
			//WwDebug.instance.msg("handleItemPress: " + item, "2");
			if(__tapItem) __tapItem.unselectItem();
			
			__tapItem = item;
			
			if(__scrollBar.alpha == 0) {
				__tapDelayTime = 0;
				__tapEnabled = true;
			}
		}
		
		/**
		 * Item selection event fired from a item press.  This event does
		 * not fire if list is scrolling or scrolled after press.
		 * */
		public function handleItemSelected(item:WwWrapperTouchListItem):void
		{
			if (__activeItem)
			{
				deactivateItem(__activeItem);
			}
			__activeItem = item;
			__activeItem.mc.filters = __itemFiltersShadowGlow;
			
			//WwDebug.instance.msg("handleItemSelected: " + item, "2");
			__tapItem = item;
			
			if (__scrollBar.alpha == 0) {
				__tapDelayTime = 0;
				__tapEnabled = false;
				__tapItem.unselectItem();
			}
		}
		
		public function deactivateItem(item:WwWrapperTouchListItem):void
		{
			if (item)
			{
				item.mc.filters = __itemFiltersShadow;
			}
		}
		
		/**
		 * Enter Frame handler.  This is always running keeping track
		 * of the mouse movements and updating any scrolling or
		 * detecting any tap events.
		 * 
		 * Mouse x,y coords come through as negative integers when this out-of-window tracking happens. 
		 * The numbers usually appear as -107374182, -107374182. To avoid having this problem we can 
		 * test for the mouse maximum coordinates.
		 * */
		public function enterFrameUpdateHandler(elapsed_time:int, total_seconds:Number):void
		{
			// test for touch or tap event
			if(__tapEnabled) {
				onTapDelay();
			}
			
			// scroll the list on mouse up
			if(!__isTouching) {
				
				if(__list_mc.y > 0) {
					__inertiaY = 0;
					__list_mc.y *= 0.3;
					
					if(__list_mc.y < 1) {
						__list_mc.y = 0;
					}
				} else if(__scrollListHeight >= __listHeight && __list_mc.y < __listHeight - __scrollListHeight) {
					__inertiaY = 0;
					
					var diff:Number = (__listHeight - __scrollListHeight) - __list_mc.y;
					
					if(diff > 1)
						diff *= 0.1;
					
					__list_mc.y += diff;
				} else if(__scrollListHeight < __listHeight && __list_mc.y < 0) {
					__inertiaY = 0;
					__list_mc.y *= 0.8;
					
					if(__list_mc.y > -1) {
						__list_mc.y = 0;
					}
				}
				
				if( Math.abs(__inertiaY) > 1) {
					__list_mc.y += __inertiaY;
					__inertiaY *= 0.9;
				} else {
					__inertiaY = 0;
				}
				
				if(__inertiaY != 0) {
					if(__scrollBar.alpha < 1 )
						__scrollBar.alpha = Math.min(1, __scrollBar.alpha + 0.1);
					
					__scrollBar.y = __listHeight * Math.min( 1, (-__list_mc.y/__scrollListHeight) );
				} else {
					if(__scrollBar.alpha > 0 )
						__scrollBar.alpha = Math.max(0, __scrollBar.alpha - 0.1);
				}
				
			} else {
				if(__scrollBar.alpha < 1)
					__scrollBar.alpha = Math.min(1, __scrollBar.alpha + 0.1);
				
				__scrollBar.y = __listHeight * Math.min(1, (-__list_mc.y/__scrollListHeight) );
			}
		}
		
		public function dispose():void
		{
			__container_mc.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			__container_mc.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseUp);
			__container_mc.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseMove);
			for each (var item:WwWrapperTouchListItem in __items) 
			{
				item.dispose();
			}
		}

		public function get item_count():int
		{
			return __item_count;
		}

		public function set item_count(value:int):void
		{
			__item_count = value;
		}

	}
}