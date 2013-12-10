package org.wwlib.flash 
{
	import flash.display.MovieClip;
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	import flash.geom.ColorTransform;
	import flash.utils.Dictionary;
	
	import org.wwlib.utils.WwDebug;

	/**
	 * ...
	 * @author Andrew Rapo (andrew@worthwhilegames.org)
	 * @license MIT
	 */
	public class WwColoringMenuColors extends WwWrapperTouchList
	{

		private var __controller:WwColoringMenuController;
		private var __colors:Dictionary;
		
		public function WwColoringMenuColors(controller:WwColoringMenuController, container_mc:MovieClip, item_prefix:String, item_count:int) 
		{
			super(container_mc, item_prefix, item_count);
			__controller = controller;
			
			__colors = new Dictionary();
			__colors[1] = "erase";
			__colors[2] = "rainbow";
			__colors[3] = "random_rainbow";
			
			reapplyColorTransforms();

		}
		
		public function reapplyColorTransforms():void
		{
			//WwDebug.instance.msg("reapplyColorTransforms: __items: " + __items, "2");
			for each (var item:WwWrapperTouchListItem in __items) 
			{
				
				var item_tx:ColorTransform = item.mc.transform.colorTransform;
				item.mc.transform.colorTransform = new ColorTransform();
				var crayon:MovieClip = item.mc["crayon"];
				WwDebug.instance.msg("reapplyColorTransforms: crayon: " + crayon, "2");
				if (crayon)
				{
					crayon.transform.colorTransform = item_tx;
				}
				item.mc.filters = __itemFiltersShadow;
				item.mc.cacheAsBitmap = true;
			}
			
		}
		
		override public function handleItemPress(item:WwWrapperTouchListItem):void
		{
			super.handleItemPress(item);
		}

		override public function handleItemSelected(item:WwWrapperTouchListItem):void
		{
			super.handleItemSelected(item);
			
			var crayon:MovieClip = item.mc["crayon"];
			var color_tx:ColorTransform = crayon.transform.colorTransform;
			var color_uint:uint = color_tx.color;
			if (item.index > 3)
			{
				var color_hex:String = "#" + color_uint.toString(16);
				WwDebug.instance.msg("ColorMenu: handleItemSelected: color: " + color_uint.toString() + ", " + color_uint + ", " + color_hex, "2");
				__controller.coloringScene.brushColorFromString = color_uint.toString();
			}
			else if (item.index >= 1 && item.index <= 3)
			{
				__controller.coloringScene.brushColorFromString = __colors[item.index];
			}
			
		}
	
		public override function dispose():void
		{
			super.dispose();
			__controller = null;
		}
	}

}