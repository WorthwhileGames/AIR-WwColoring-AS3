package org.wwlib.flash
{
	import flash.display.MovieClip;

	/**
	 * ...
	 * @author Andrew Rapo (andrew@worthwhilegames.org)
	 * @license MIT
	 */
	public interface WwWrapperITouchListItem
	{
		function set mc(mc:MovieClip):void;
		function get mc():MovieClip;
		function set data(value:Object):void;
		function get data():Object;
		function set index(value:Number):void;
		function get index():Number;
		function set itemWidth(value:Number):void;
		function get itemWidth():Number;
		function set itemHeight(value:Number):void;
		function get itemHeight():Number;
		function selectItem():void;
		function unselectItem():void;
	}
}