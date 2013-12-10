package org.wwlib.starling 
{
	import org.wwlib.WwColoring.anim.UI_Logos;
	
	import flash.display.MovieClip;
	import flash.events.AccelerometerEvent;

	/**
	 * ...
	 * @author Andrew Rapo (andrew@worthwhilegames.org)
	 * @license MIT
	 */
	public class WwLogosScene extends WwScene
	{
		private var __currentAnim:MovieClip;
		
		private var __UI_Logos:UI_Logos;
		
		private var __animVector:Vector.<MovieClip>;
				
		private var __lableList:Array;
		private var __currentLabel:String;
		private var __defaultLabel:String = "a";
		private var __currentLabelIndex:int;
		
		public function WwLogosScene(scene_manager:WwSceneManager)
		{
			super(scene_manager);
		}
		
		/********** START Setup Code ***/
		
		public override function initWithXML(xml:XML):void
		{
			startAnimation();
		}
	
		/********** END Setup Code ***/

				
		private function startAnimation():void
		{
			__debug.msg("startAnimation: ", "2");
			__UI_Logos = new UI_Logos(); __UI_Logos.gotoAndPlay(1);
						
			__animVector = new Vector.<MovieClip>;
			
			__animVector.push(__UI_Logos);
			
			var scene_mc:MovieClip;
			for each (scene_mc in __animVector)
			{
				scene_mc.label_callback = labelCallback;
				scene_mc.anim_callback = animCallback;
				scene_mc.face_callback = faceCallback;
				scene_mc.skin_callback = skinCallback;
			}
			
			playNextAnim();			
		}
		

		
		public function labelCallback(label_list:Array):void
		{
			__currentLabelIndex = 0;
			__currentLabel = "";
			if ((label_list != null) && (label_list.length > 0))
			{
				__lableList = label_list;
				__currentLabel = __lableList[__currentLabelIndex];
			}
			else
			{
				__lableList = [];
			}
		}
		
		public function getNextLabel():Boolean
		{
			__currentLabelIndex++;
			if (__currentLabelIndex < __lableList.length)
			{
				__currentLabel = __lableList[__currentLabelIndex];
				if ((__currentLabel == null) || (__currentLabel == ""))
				{
					__currentLabel = __defaultLabel;
				}
				return true;
			}
			else
			{
				__currentLabelIndex = 0;
				__currentLabel = __lableList[__currentLabelIndex];
				return false;
			}
			
		}
		
		public function animCallback(anim_state:String):void
		{
			switch (anim_state)
			{
				case "EOL": //End Of Label
					__debug.msg("animCallback: EOL", "2");
					break;
				case "EOS": //End Of Scene
					__debug.msg("animCallback: EOS", "2");
					__sceneManager.gotoScene("Main"); // ("Coloring");
					break;
				default:
					break;
			}
		}
	
		public function faceCallback(face:MovieClip):void
		{
		}
		
		public function skinCallback(skin_list:Array):void
		{
			
		}
		
		public function playNextAnim(back:Boolean=false):void
		{
			__debug.msg("playNextAnim: ", "2");
			if (__currentAnim != null)
			{
				WwSprite.FLASH_STAGE.removeChild(__currentAnim);
				__currentAnim = null;
			}
			
			if (back)
			{
				__currentAnim = __animVector.pop();
				__animVector.unshift(__currentAnim);
			}
			else
			{
				__currentAnim = __animVector.shift();
				__animVector.push(__currentAnim);
			}
			
			__currentAnim.x = 0;
			__currentAnim.y = 0;
			WwSprite.FLASH_STAGE.addChild(__currentAnim);
			__currentAnim.gotoAndPlay(__defaultLabel);
		}
		
        public override function dispose():void
        {
			__debug.msg("WwLogosScene: Dispose: " + __currentAnim, "2");
			__currentAnim.stop();
            WwSprite.FLASH_STAGE.removeChild(__currentAnim);
			__currentAnim = null;
            super.dispose();
        }
		
		public override function enterframeEvent(frame_time:int, total_seconds:Number):void
		{	

		}
		
		public override function acceleromterEvent(event:AccelerometerEvent):void
		{	
			
		}
	}
}