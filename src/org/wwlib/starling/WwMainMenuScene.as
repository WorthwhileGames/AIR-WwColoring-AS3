package org.wwlib.starling 
{
	import org.wwlib.WwColoring.anim.UI_MainMenu;
	
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.events.AccelerometerEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.geom.Point;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	import org.wwlib.flash.WwAlertsManager;
	import org.wwlib.flash.WwAudioManager;
	import org.wwlib.flash.WwWrapperButtonMC;
	import org.wwlib.utils.WwGoViral;

	/**
	 * ...
	 * @author Andrew Rapo (andrew@worthwhilegames.org)
	 * @license MIT
	 */
	public class WwMainMenuScene extends WwScene
	{
		private var __currentAnim:MovieClip;
		
		private var __UI_MainMenu:UI_MainMenu;
		
		private var __animVector:Vector.<MovieClip>;
						
		private var __lableList:Array;
		private var __currentLabel:String;
		private var __defaultLabel:String = "a";
		private var __currentLabelIndex:int;
		
		private var __logo_mc:MovieClip;
		private var __logo_mc_start:Point;
		private var __logo_mc_target:Point;
		private var __accelX:Number;
		private var __accelY:Number;
		private var __accelZ:Number;
		private var __accelXStart:Number;
		private var __accelYStart:Number;
		private var __accelZStart:Number;
		private var __accelStarted:Boolean;
		private var __amplitudeY:Number;
		private var __accelX_factor:Number;
		
		private var __buttonVector:Vector.<WwWrapperButtonMC>;
		
		/** An embedded default image for general posting. */
		[Embed(source="/Default-AppMarketingImage.png")]
		private var defaultImageClass:Class;
		
		
		public function WwMainMenuScene(scene_manager:WwSceneManager)
		{
			super(scene_manager);
			__accelStarted = false;
			__accelXStart = 0;
			__accelYStart = 0;
			__accelZStart = 0;
		}
		
		/********** START Setup Code ***/
		
		public override function initWithXML(xml:XML):void
		{
			
			//super.initWithXML(xml);
			
			var xml_xtra:XML = xml.xtra[0];
			if (xml_xtra != null)
			{				
				//nothing
			}
			startAnimation();
			
		}
	
		/********** END Setup Code ***/

				
		private function startAnimation():void
		{
			__UI_MainMenu = new UI_MainMenu();
			__UI_MainMenu.gotoAndPlay(1);
			
			__logo_mc = __UI_MainMenu["logo"];
			__logo_mc.cacheAsBitmap = true;
			__logo_mc_start = new Point(__logo_mc.x, __logo_mc.y);
			__logo_mc_target = new Point(__logo_mc.x, __logo_mc.y);
			__accelY = 0;
			__accelX = 0;
			__accelZ = 0;
			__amplitudeY = 0;
			__accelX_factor = 1.0;
			
			/* BUTTON SETUP */
			__buttonVector = new Vector.<WwWrapperButtonMC>;
			var temp_button:WwWrapperButtonMC;
			__buttonVector.push(newButtonWrapper("btn_coloring", buttonHandler));
			__buttonVector.push(newButtonWrapper("btn_share", buttonHandler));
			__buttonVector.push(newButtonWrapper("btn_wwlib", buttonHandler));
			
			var logo_filter:DropShadowFilter = new DropShadowFilter(20, 70, 0, .5, 10, 10);
			__logo_mc.filters = new Array(logo_filter);
						
			__animVector = new Vector.<MovieClip>;
			
			__animVector.push(__UI_MainMenu);
			
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
		
		private function newButtonWrapper(id:String, handler:Function):WwWrapperButtonMC
		{
			var mc:MovieClip = __UI_MainMenu[id];
			var wrapper:WwWrapperButtonMC = new WwWrapperButtonMC(mc, handler);
			wrapper.id = id;
			if (mc)
			{
				mc.wrapper = wrapper;
				var temp_filter:DropShadowFilter = new DropShadowFilter(20, 70, 0, .5, 10, 10);
				mc.filters = new Array(temp_filter);
				mc.cacheAsBitmap = true;
			}
			return (wrapper);
		}
		
		public function buttonHandler(event:Event):void 
		{
			var target:MovieClip = MovieClip(event.target);
			var wrapper:WwWrapperButtonMC = target.wrapper;
			__debug.msg("buttonHandler: " + target.name + ", " + wrapper, "1");
			
			if (event.type == MouseEvent.MOUSE_UP)
			{
				switch (target.name) 
				{
					case "btn_wwlib":
						navigateToURL(new URLRequest("https://github.com/WorthwhileGames"));
						break;
					case "btn_coloring":
						__sceneManager.gotoScene("Coloring");
						break;
					case "btn_share":
						var asBitmap:Bitmap=new defaultImageClass() as Bitmap;
						
						WwGoViral.instance.photoBitmapData = asBitmap.bitmapData;
						WwGoViral.instance.postTitle = "Title";
						WwGoViral.instance.postCaption = "Caption";
						WwGoViral.instance.postMessage = "Message";
						WwGoViral.instance.postDescription = "Description";
						WwGoViral.instance.postURL = "URL";
						WwGoViral.instance.postImageURL = "ImageURL";
						//WwGoViral.instance.postName = "Name";
						WwGoViral.instance.postEmailSubject = "Subject";
						WwGoViral.instance.postEmailAddresses = "";
						WwGoViral.instance.postEmailBody = "Body";
						//WwGoViral.instance.twitterMessage = "Twitter Message";
						WwAlertsManager.instance.MM_Share();
						
						break;					
					default:
						break;
				}
			}
			else if (wrapper)
			{
				wrapper.springAmplitude = new Point(20, 20);
				WwAudioManager.playMouseDown();
			}
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
					break;
				case "EOS": //End Of Scene
					//WwAudioManager.playSound("mainMenu");
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
				
		public override function enterframeEvent(frame_time:int, total_seconds:Number):void
		{	
			if (__logo_mc)
			{
				updateAmplitude();
				var cos_y:Number = Math.cos(total_seconds * 3.14 * 9) * __amplitudeY;
				var new_x:Number = __logo_mc.x + (__logo_mc_target.x - __logo_mc.x) * .1;
				var new_y:Number = __logo_mc.y + ((__logo_mc_target.y + cos_y) - __logo_mc.y) * .1;
				
				__logo_mc.x = new_x;
				__logo_mc.y = new_y;
				
				__debug.status = __accelX + ", " + __accelY + ", " + __accelZ;
				
				var temp_button:WwWrapperButtonMC;
				for each (temp_button in __buttonVector)
				{
					if (temp_button)
					{
						temp_button.update(frame_time, total_seconds);
					}
				}
			}
			
		}
		
		public override function acceleromterEvent(event:AccelerometerEvent):void
		{	
			__accelX = int(event.accelerationX * 1000)/1000;
			__accelY = int(event.accelerationY * 1000)/1000;
			__accelZ = int(event.accelerationZ * 1000)/1000;
			
			if (!__accelStarted)
			{
				__accelStarted = true;
				__accelXStart = __accelX;
				__accelYStart = __accelY;
				__accelZStart = __accelZ;
			}
						
			__logo_mc_target.x = __logo_mc_start.x + (__accelX - __accelXStart) * 50 * __accelX_factor;
			__logo_mc_target.y = __logo_mc_start.y + (__accelY - __accelYStart) * -50;
			
			
			var temp_button:WwWrapperButtonMC;
			for each (temp_button in __buttonVector)
			{
				if (temp_button)
				{
					temp_button.targetXY.x = temp_button.startXY.x + (__accelX - __accelXStart) * 50 * __accelX_factor;
					temp_button.targetXY.y = temp_button.startXY.y + (__accelY - __accelYStart) * -50;
				}
			}
		}
		
		private function updateAmplitude():void
		{
			__amplitudeY = __amplitudeY * .95;
		}
		
		public override function dispose():void
		{
			__currentAnim.stop();
			WwSprite.FLASH_STAGE.removeChild(__currentAnim);
			__currentAnim = null;
			super.dispose();
		}

	}
}