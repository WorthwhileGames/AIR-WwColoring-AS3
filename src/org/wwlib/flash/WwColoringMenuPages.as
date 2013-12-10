package org.wwlib.flash 
{
	import flash.display.MovieClip;
	
	/**
	 * ...
	 * @author Andrew Rapo (andrew@worthwhilegames.org)
	 * @license MIT
	 */
	public class WwColoringMenuPages extends WwWrapperTouchList
	{
		private var __controller:WwColoringMenuController;
		
		public function WwColoringMenuPages(controller:WwColoringMenuController, container_mc:MovieClip, item_prefix:String, item_count:int) 
		{
			super(container_mc, item_prefix, item_count);
			__controller = controller;
		}
		
		override public function handleItemSelected(item:WwWrapperTouchListItem):void
		{
			super.handleItemSelected(item);
			
			switch (item.index) 
			{
				case 1:
					__controller.coloringScene.page = "assets/coloring_pages/qc_cyril_960.png"
					break;
				case 2:
					__controller.coloringScene.page = "assets/coloring_pages/qc_sascha_960.png"
					break;
				case 3:
					__controller.coloringScene.page = "assets/coloring_pages/qc_lobsters_960.png"
					break;
				case 4:
					__controller.coloringScene.page = "assets/coloring_pages/blank_960.png"
					break;
				default:
			}
		}

		public override function dispose():void
		{
			
		}
	}

}