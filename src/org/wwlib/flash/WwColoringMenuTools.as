package org.wwlib.flash 
{
	import flash.display.MovieClip;
	import flash.utils.Dictionary;
	
	/**
	 * ...
	 * @author Andrew Rapo (andrew@worthwhilegames.org)
	 * @license MIT
	 */
	public class WwColoringMenuTools extends WwWrapperTouchList
	{

		private var __controller:WwColoringMenuController;
		private var __brushes:Dictionary;
		
		public function WwColoringMenuTools(controller:WwColoringMenuController, container_mc:MovieClip, item_prefix:String, item_count:int) 
		{
			super(container_mc, item_prefix, item_count);
			__controller = controller;

			
			__brushes = new Dictionary();
			__brushes[3] = "assets/brushes/brush_calligraphy.png";
			__brushes[4] = "assets/brushes/brush_circleSoft.png,rotate_random";
			__brushes[5] = "assets/brushes/brush_crayon.png";
			__brushes[6] = "assets/brushes/brush_circle.png,expand";
			__brushes[7] = "assets/brushes/brush_spiral.png,rotate_normal20x";
			__brushes[8] = "assets/brushes/brush_circle.png,pulse";
			__brushes[9] = "assets/brushes/brush_star.png,interval_dash";
			
		}
		
		override public function handleItemSelected(item:WwWrapperTouchListItem):void
		{
			super.handleItemSelected(item);
			
			if (item.index > 2 && item.index <= item_count)
			{
				__controller.coloringScene.brushesMenuOption(__brushes[item.index]);
				__controller.showColors();
			}
			else if (item.index == 2)
			{
				__controller.showPages();
			}
			else if (item.index == 1)
			{
				__controller.onControlShare(null);
			}
			
		}
		
		public override function dispose():void
		{

		}
	}

}