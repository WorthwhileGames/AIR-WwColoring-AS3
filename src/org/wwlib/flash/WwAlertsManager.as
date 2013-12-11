package org.wwlib.flash
{
	import com.milkmangames.nativeextensions.events.GVFacebookEvent;
	
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.utils.Dictionary;
	
	import org.wwlib.WwColoring.anim.UI_Alerts;
	import org.wwlib.utils.WwDebug;
	import org.wwlib.utils.WwGoViral;
	
	/**
	 * ...
	 * @author Andrew Rapo (andrew@worthwhilegames.org)
	 * @license MIT
	 */
	public class WwAlertsManager
	{
		
		/** Singleton instance */
		private static var __instance:WwAlertsManager;
		public static var FLASH_ALERTS_STAGE:flash.display.MovieClip;
		
		public static const STATE_POST_PHOTO:String = "POST_PHOTO";
		public static const STATE_POSTING:String = "POSTING";
		public static const STATE_LOGIN_OK:String = "LOGIN_OK";
		public static const STATE_POST_OK:String = "POST_OK";
		public static const STATE_LOGIN_NOK:String = "LOGIN_NOK";
		public static const STATE_POST_NOK:String = "POST_NOK";
		public static const STATE_SHARE_METHOD:String = "SHARE_METHOD";
		
		private var __debug:WwDebug;
		private var __ui:MovieClip;
		private var __photoHolder:MovieClip;
		private var __say_somethingTxt:TextField;
		
		private var __controls_OK:MovieClip;
		private var __controls_Cancel:MovieClip;
		
		private var __onUICompleteHandler:Function;
		private var __alertsUIState:String;	
		
		private var __curLabel:String = "a";
		private var __prevLabel:String = "a";
		private var __context:String = "postPhoto";
		
		private var __alertActive:Boolean = false;
		
		private var __Current_StateSet:WwUIStateSet;
		private var __METHOD_StateSet:WwUIStateSet;
		private var __METHOD_MM_StateSet:WwUIStateSet;
		private var __MM_StateSet:WwUIStateSet;
		private var __FB_StateSet:WwUIStateSet;
		
		private var __onShareCompleteCallback:Function;
		
		
		public function WwAlertsManager(enforcer:SingletonEnforcer)
		{
			super();
			
			if (!(enforcer is SingletonEnforcer))
			{
				throw new ArgumentError("WwAvatarManager cannot be directly instantiated!");
			}
			
			__debug = WwDebug.instance;
		}
			
		public static function init(_stage:MovieClip):WwAlertsManager
		{
			if (__instance == null)
			{
				__instance = new WwAlertsManager(new SingletonEnforcer());
				FLASH_ALERTS_STAGE = _stage;
			
				__instance.__ui = new UI_Alerts();
				__instance.__ui.gotoAndPlay(1);
				__instance.__ui.alerts_callback = __instance.UICallback;
				__instance.__ui.x = 0;
				__instance.__ui.y = 0;
				
				__instance.__controls_OK = __instance.__ui["btn_OK"];
				__instance.__controls_Cancel = __instance.__ui["btn_Cancel"];
			
				__instance.__ui.addEventListener(MouseEvent.MOUSE_DOWN, __instance.onMouseDown);
				__instance.setupUIStates();
				//ANE REQUIRED WwGoViral.instance.onFacebookEventCallback = __instance.onFacebookEvent;

			}
			
			return __instance;
		}
		
		public static function get instance(): WwAlertsManager
		{
			return __instance;
		}
		
		public function setupUIStates():void
		{
			var new_state:WwUIState;
			
			
			// METHOD Set - Avater Setup, Scene
			
			__METHOD_StateSet = new WwUIStateSet("METHOD");
			
			new_state = new WwUIState(STATE_SHARE_METHOD);
			new_state.frameLabel = "g";
			new_state.addText("txt_1", "Would you like to share with Facebook or Email?");
			new_state.addButton("btn_Cancel", onCancel);
			new_state.addButton("btn_FB", onPostPhoto);
			new_state.addButton("btn_Email", onEmailPhoto);
			
			__METHOD_StateSet.addState(new_state);
			
			// METHOD Set - Main Menu
			
			__METHOD_MM_StateSet = new WwUIStateSet("METHOD_MM");
			
			new_state = new WwUIState(STATE_SHARE_METHOD);
			new_state.frameLabel = "g";
			new_state.addText("txt_1", "Would you like to share with Facebook or Email?");
			new_state.addButton("btn_Cancel", onCancel);
			new_state.addButton("btn_FB", onPostPhoto);
			new_state.addButton("btn_Email", onEmailPhoto);
			__METHOD_MM_StateSet.addState(new_state);
			
			new_state = new WwUIState(STATE_LOGIN_OK);
			new_state.frameLabel = "b";
			new_state.addText("txt_1", "Successfully logged in to Facebook!\n\nYou can now post your photo");
			new_state.addButton("btn_OK", onPostFeed);
			new_state.addButton("btn_Cancel", onCancel);
			__METHOD_MM_StateSet.addState(new_state);
			
			new_state = new WwUIState(STATE_LOGIN_NOK);
			new_state.frameLabel = "f";
			new_state.addText("txt_1", "Oops. Posting to Facebook failed.\n\nWould you like to try again?");
			new_state.addButton("btn_OK", onPostFeed);
			new_state.addButton("btn_Cancel", onCancel);
			__METHOD_MM_StateSet.addState(new_state);
			
			// FB Set - Facebook
			
			__FB_StateSet = new WwUIStateSet("FB");
			
			new_state = new WwUIState(STATE_POST_PHOTO);
			new_state.frameLabel = "a";
			new_state.addText("txt_1", "Post this photo to Facebook!");
			new_state.addText("txt_say_something", "Say something about this photo...");
			new_state.addButton("btn_Cancel", onCancel);
			new_state.addButton("btn_OK", onPostPhotoOK);
			new_state.addImage("photo_holder", null);
			new_state.setupFunction = setupUI_postPhoto;
			__FB_StateSet.addState(new_state);
			
			new_state = new WwUIState(STATE_POSTING);
			new_state.frameLabel = "d";
			new_state.addText("txt_1", "Posting to Facebook");
			new_state.addButton("btn_OK", onCancel);
			__FB_StateSet.addState(new_state);
			
			new_state = new WwUIState(STATE_POST_OK);
			new_state.frameLabel = "c";
			new_state.addText("txt_1", "Successfully posted to Facebook.");
			new_state.addButton("btn_OK", onCancel);
			__FB_StateSet.addState(new_state);
			
			new_state = new WwUIState(STATE_POST_NOK);
			new_state.frameLabel = "f";
			new_state.addText("txt_1", "Oops. Posting to Facebook failed.\n\nWould you like to try again?");
			new_state.addButton("btn_OK", onPostPhotoOK);
			new_state.addButton("btn_Cancel", onCancel);
			__FB_StateSet.addState(new_state);
			
			new_state = new WwUIState(STATE_LOGIN_OK);
			new_state.frameLabel = "b";
			new_state.addText("txt_1", "Successfully logged in to Facebook!\n\nYou can now post your photo");
			new_state.addButton("btn_OK", onPostPhotoOK);
			new_state.addButton("btn_Cancel", onCancel);
			__FB_StateSet.addState(new_state);
			
			new_state = new WwUIState(STATE_LOGIN_NOK);
			new_state.frameLabel = "e";
			new_state.addText("txt_1", "Oops. Posting to Facebook failed.\n\nWould you like to try again?");
			new_state.addButton("btn_OK", onPostPhotoOK);
			new_state.addButton("btn_Cancel", onCancel);
			__FB_StateSet.addState(new_state);
			
			__Current_StateSet = __METHOD_StateSet;
		}

		public function MM_Share():void
		{
			__Current_StateSet = __METHOD_MM_StateSet;
			gotoState(WwAlertsManager.STATE_SHARE_METHOD);
		}
		
		public function AV_Share(onShareCompleteCallback:Function=null):void
		{
			__onShareCompleteCallback = onShareCompleteCallback;
			__Current_StateSet = __METHOD_StateSet;
			gotoState(WwAlertsManager.STATE_SHARE_METHOD);
		}
		
		public function AV_PostFB():void
		{
			__Current_StateSet = __FB_StateSet;
			gotoState(WwAlertsManager.STATE_POST_PHOTO);
		}
		
		public function gotoState(state:String="na"):void
		{
			WwDebug.instance.msg( "AM:gotoState: " + state, "1");
			
			__alertActive = true;
			
			var ui_state:WwUIState = __Current_StateSet.getState(state);
			var next_label:String = __Current_StateSet.getFrameLabel();
			
			if (next_label != "na")
			{
				WwDebug.instance.msg( "  AM:gotoState: going to frame label: " + next_label, "1");
				__prevLabel = next_label;
				__curLabel = next_label;
				__ui.gotoAndPlay(__curLabel);
			}
			else
			{
				WwDebug.instance.msg( "  AM:gotoState: valid state not found. next_label:" + next_label, "1");
				__alertActive = false;
				return;
			}
		}
		
		public function show():void
		{
			WwDebug.instance.msg( "AM:show: active: " + __alertActive, "1");
			if (__alertActive)
			{
				try
				{
					FLASH_ALERTS_STAGE.addChild(__ui);
				}
				catch (e:Error)
				{
					WwDebug.instance.msg( "  AM:show: error: ", "1");
				}
			}
		}
		
		public function hide():void
		{
			WwDebug.instance.msg( "AM:hide + reset ", "1");
			try
			{
				FLASH_ALERTS_STAGE.removeChild(__ui);
			}
			catch (e:Error)
			{
				WwDebug.instance.msg( "  AM:hide: error: ", "1");
			}
			__alertActive = false;
			__ui.gotoAndPlay("reset");
			
			if (__onShareCompleteCallback)
			{
				__onShareCompleteCallback();
			}
		}
		
		protected function onMouseDown(event:MouseEvent):void
		{
			WwAudioManager.playMouseDown();
		}

		public function UICallback(_context:String, _state:String, _mc:MovieClip = null):void
		{
			WwDebug.instance.msg( "AM: UICallback: " +  _context + ", " + _state + ", " + _mc + ", " + __alertActive, "1");
			
			if (__alertActive)
			{
				__alertsUIState = _state;
				setupStateUI(__alertsUIState);
				show();
			}
			else
			{
				WwDebug.instance.msg( "  AM: UICallback: Alert not active.", "1");
			}
		}
		
		private function setupStateUI(state_id:String):void
		{
			WwDebug.instance.msg( "AM: setupStateUI: state_id: " + state_id, "1");
			
			var state:WwUIState = __Current_StateSet.getState(state_id);
			var dict:Dictionary = state.elementDictionary;
			//set up text fields
			for ( var key: Object in dict)
			{
				var element:WwUIStateElement = dict[key] as WwUIStateElement;
				if (element is WwUIStateText)
				{
					var text_element:WwUIStateText = element as WwUIStateText;
					WwDebug.instance.msg( "  AM: Text: " + text_element.name + ": " + text_element.text, "1");
					var text_field:TextField = __ui[text_element.name] as TextField;
					text_field.text = text_element.text;
				}
				else if (element is WwUIStateButton)
				{
					var button_element:WwUIStateButton = element as WwUIStateButton;
					WwDebug.instance.msg( "  AM: Button: " + button_element.name + ": " + button_element.handler, "1");
					if (button_element.handler)
					{
						var button_mc:MovieClip = __ui[button_element.name] as MovieClip;
						button_mc.addEventListener(MouseEvent.MOUSE_UP, button_element.handler);
					}
				}
			}

			if (state.setupFunction)
			{
				state.setupFunction(state);
			}
			
		}
		
		// BUTTON HANDLERS
		
		public function onCancel(e:Event):void
		{
			WwDebug.instance.msg( "AM: onCancel", "1");
			//Remove event listener
			var btn:MovieClip = e.target as MovieClip;
			btn.removeEventListener(MouseEvent.MOUSE_UP, onCancel);
			hide();
		}
		
		public function onPostPhoto(e:Event):void
		{
			WwDebug.instance.msg( "AM: onPostPhoto", "1");
			//Remove event listener
			var btn:MovieClip = e.target as MovieClip;
			btn.removeEventListener(MouseEvent.MOUSE_UP, onPostPhoto);
			
			__Current_StateSet = __FB_StateSet;
			gotoState(STATE_POST_PHOTO);
		}
		
		public function onPostPhotoOK(e:Event):void
		{
			WwDebug.instance.msg( "AM: onPostPhotoOK", "1");
			//Remove event listener
			var btn:MovieClip = e.target as MovieClip;
			btn.removeEventListener(MouseEvent.MOUSE_UP, onPostPhotoOK);
			
			__Current_StateSet = __FB_StateSet;
			//ANE REQUIRED WwGoViral.instance.postPhotoFacebook();
			gotoState(STATE_POSTING);
		}
		
		public function onEmailPhoto(e:Event):void
		{
			WwDebug.instance.msg( "AM: onEmailPhoto", "1");
			//Remove event listener
			var btn:MovieClip = e.target as MovieClip;
			btn.removeEventListener(MouseEvent.MOUSE_UP, onEmailPhoto);
			
			//ANE REQUIRED WwGoViral.instance.sendImageEmail();
			hide();
		}
		
		public function onPostFeed(e:Event):void
		{
			WwDebug.instance.msg( "AM: onPostFeed", "1");
			//Remove event listener
			var btn:MovieClip = e.target as MovieClip;
			btn.removeEventListener(MouseEvent.MOUSE_UP, onPostFeed);
			
			//ANE REQUIRED WwGoViral.instance.postFeedFacebook();
			hide();
		}

		public function setupUI_postPhoto(state:WwUIState):void
		{
			__debug.msg("AM: setupUI_postPhoto: state: " + state.id, "1");

			var txt_say_something_field:TextField = __ui["txt_say_something"] as TextField;
			txt_say_something_field.text = WwGoViral.instance.postCaption;
			
			var image:WwUIStateImage = state.elementDictionary["photo_holder"] as WwUIStateImage;
			var image_mc:MovieClip = __ui[image.name] as MovieClip;
			__debug.msg("  AM: image.name: " + image.name + ", " + image_mc, "1");
			var bm:Bitmap = new Bitmap(WwGoViral.instance.photoBitmapData);
			bm.width = 512;
			bm.height = 384;
			bm.x = 0;
			bm.y = 0;
			image_mc.addChild(bm);			
		}

/* ANE REQUIRED
		// Handle Facebook Event
		private function onFacebookEvent(e:GVFacebookEvent):void
		{
			switch(e.type)
			{
				case GVFacebookEvent.FB_DIALOG_CANCELED:
					break;
				case GVFacebookEvent.FB_DIALOG_FAILED:
					break;
				case GVFacebookEvent.FB_DIALOG_FINISHED:
					break;
				case GVFacebookEvent.FB_LOGGED_IN:
					// STATE_LOGIN_OK
					gotoState(STATE_LOGIN_OK);
					break;
				case GVFacebookEvent.FB_LOGGED_OUT:
					break;
				case GVFacebookEvent.FB_LOGIN_CANCELED:
					break;
				case GVFacebookEvent.FB_LOGIN_FAILED:
					// STATE_LOGIN_NOK
					gotoState(STATE_LOGIN_NOK);
					break;
				case GVFacebookEvent.FB_REQUEST_FAILED:
					// STATE_POST_NOK
					gotoState(STATE_POST_NOK);
					break;
				case GVFacebookEvent.FB_REQUEST_RESPONSE:
					// handle a friend list- there will be only 1 item in it if 
					// this was a 'my profile' request.				
					if (e.friends!=null)
					{					
						// 'me' was a request for own profile.
						if (e.graphPath=="me")
						{
							//todo
							return;
						}
						
						// 'me/friends' was a friends request.
						if (e.graphPath=="me/friends")
						{					
							// todo
						}
						else
						{
							// STATE_POST_OK
							gotoState(STATE_POST_OK);
						}
					}
					else
					{
						// STATE_POST_OK
						gotoState(STATE_POST_OK);
					}
					break;
			}
		}
*/
		
		public function get alertActive():Boolean
		{
			return __alertActive;
		}
	}
}

/** A class that is here specifically to stop public instantiation of the
 *   WwSceneManager singleton. It is inaccessible by classes outside this file. */
class SingletonEnforcer{}