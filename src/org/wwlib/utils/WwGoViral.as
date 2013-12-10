package org.wwlib.utils
{
	
	import com.milkmangames.nativeextensions.GVFacebookFriend;
	import com.milkmangames.nativeextensions.GVHttpMethod;
	import com.milkmangames.nativeextensions.GVSocialServiceType;
	import com.milkmangames.nativeextensions.GoViral;
	import com.milkmangames.nativeextensions.events.GVFacebookEvent;
	import com.milkmangames.nativeextensions.events.GVMailEvent;
	import com.milkmangames.nativeextensions.events.GVShareEvent;
	import com.milkmangames.nativeextensions.events.GVTwitterEvent;
	
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	
	/**
	 * WwGoViral is a wrapper/interface for com.milkmangames.nativeextensions.GoViral
	 * http://www.milkmangames.com/blog/tools/
	 * http://www.adobe.com/devnet/air/articles/goviral-ane-ios.html
	 * 
	 * @author Andrew Rapo (andrew@worthwhilegames.org)
	 * @license MIT
	 */
	public class WwGoViral
	{
		private static var __instance:WwGoViral;
		/** CHANGE THIS TO YOUR FACEBOOK APP ID! */
		/** REMEMBER to set the -app.xml as well */

		public static const FACEBOOK_APP_ID:String="YOUR_FACEBOOK_APP_ID"; // Replace this with a real facebook app id
		
		/** An embedded image for testing image attachments. */
		[Embed(source="/Default-AppMarketingImage.png")]
		private var testImageClass:Class;
		
		public var photoBitmapData:BitmapData;
		
		public var postTitle:String = "Title";
		public var postCaption:String = "Caption";
		public var postMessage:String = "Message";
		public var postDescription:String = "Description";
		public var postURL:String = "http://url.com";
		public var postImageURL:String = "http://url.com/image.jpg";
		public var postName:String = "Name";
		public var postEmailSubject:String = "Email Subject";
		public var postEmailAddresses:String = "Email Addresses";
		public var postEmailBody:String = "Email Body";
		public var twitterMessage:String = "Twitter Message";
		
		// Buttons
		private var buttonContainer:Sprite;
		
		// CALLBACK
		public var onFacebookEventCallback:Function;

		
		public function WwGoViral(enforcer:SingletonEnforcer)
		{
			if (!(enforcer is SingletonEnforcer))
			{
				throw new ArgumentError("WwGoViral cannot be directly instantiated!");
			}
		}
		
		/**
		 *   Initialize the singleton if it has not already been initialized
		 *   @return The singleton instance
		 */
		public static function init(): WwGoViral
		{
			if (__instance == null)
			{
				__instance = new WwGoViral(new SingletonEnforcer());
			}
			__instance.log("\n");
			__instance.log("GV: Started WwGoViral");
			//ANE REQUIRED __instance.initGoViral();
			

			return __instance;
		}
		
/*	ANE REQUIRED	
		
		// Init
		public function initGoViral():void
		{
			log("  GV: initGoViral");
			// check if GoViral is supported.  note that this just determines platform support- iOS - and not
			// whether the particular version supports it.		
			if (!GoViral.isSupported())
			{
				log("  GV: Extension is not supported on this platform.");
				return;
			}
			
			log("  GV: will create.");
		
			// initialize the extension.
			GoViral.create();
			
			log("  GV: Extension Initialized.");

			// initialize facebook.		
			// this is to make sure you remembered to put in your app ID !
			if (FACEBOOK_APP_ID=="YOUR_FACEBOOK_APP_ID")
			{
				log("  GV: You forgot to put in Facebook ID!");
			}
			else
			{
				log("  GV: Init facebook...");
				// as of April 2013, Facebook is dropping support for iOS devices with a version below 5.  You can check this with isFacebookSupported():
				
				if (GoViral.goViral.isFacebookSupported())
				{
					GoViral.goViral.initFacebook(FACEBOOK_APP_ID, "");
					log("  GV: iniialized.");
				}
				else
				{
					log("  GV: Warning: Facebook not supported on this device.");
				}
				
				
			}

			// set up all the event listeners.
			// you only need the ones for the services you want to use.		
			
			// mail events
			GoViral.goViral.addEventListener(GVMailEvent.MAIL_CANCELED,onMailEvent);
			GoViral.goViral.addEventListener(GVMailEvent.MAIL_FAILED,onMailEvent);
			GoViral.goViral.addEventListener(GVMailEvent.MAIL_SAVED,onMailEvent);
			GoViral.goViral.addEventListener(GVMailEvent.MAIL_SENT,onMailEvent);
			
			// facebook events
			GoViral.goViral.addEventListener(GVFacebookEvent.FB_DIALOG_CANCELED,onFacebookEvent);
			GoViral.goViral.addEventListener(GVFacebookEvent.FB_DIALOG_FAILED,onFacebookEvent);
			GoViral.goViral.addEventListener(GVFacebookEvent.FB_DIALOG_FINISHED,onFacebookEvent);
			GoViral.goViral.addEventListener(GVFacebookEvent.FB_LOGGED_IN,onFacebookEvent);
			GoViral.goViral.addEventListener(GVFacebookEvent.FB_LOGGED_OUT,onFacebookEvent);
			GoViral.goViral.addEventListener(GVFacebookEvent.FB_LOGIN_CANCELED,onFacebookEvent);
			GoViral.goViral.addEventListener(GVFacebookEvent.FB_LOGIN_FAILED,onFacebookEvent);
			GoViral.goViral.addEventListener(GVFacebookEvent.FB_REQUEST_FAILED,onFacebookEvent);
			GoViral.goViral.addEventListener(GVFacebookEvent.FB_REQUEST_RESPONSE,onFacebookEvent);
			
			// twitter events
			GoViral.goViral.addEventListener(GVTwitterEvent.TW_DIALOG_CANCELED,onTwitterEvent);
			GoViral.goViral.addEventListener(GVTwitterEvent.TW_DIALOG_FAILED,onTwitterEvent);
			GoViral.goViral.addEventListener(GVTwitterEvent.TW_DIALOG_FINISHED,onTwitterEvent);

			// Generic sharing events
			GoViral.goViral.addEventListener(GVShareEvent.GENERIC_MESSAGE_SHARED,onShareEvent);
			GoViral.goViral.addEventListener(GVShareEvent.SOCIAL_COMPOSER_CANCELED,onShareEvent);
			GoViral.goViral.addEventListener(GVShareEvent.SOCIAL_COMPOSER_FINISHED,onShareEvent);

			var asBitmap:Bitmap=new testImageClass() as Bitmap;
			photoBitmapData = asBitmap.bitmapData;
		}
		
		// facebook
		
		// Login to facebook
		public function loginFacebook():void
		{
			log("GV: Login facebook...");
			if(!GoViral.goViral.isFacebookAuthenticated())
			{			
				// you must set at least one read permission.  if you don't know what to pick, 'basic_info' is fine.
				// PUBLISH PERMISSIONS are NOT permitted by Facebook here anymore.
				GoViral.goViral.authenticateWithFacebook("user_likes,user_photos"); 
			}
			log("  GV: done.");
		}
		
		// Logout of facebook
		public function logoutFacebook():void
		{
			log("GV: logout fb.");
			GoViral.goViral.logoutFacebook();
			log("  GV: done logout.");
		}
		
		// Post to the facebook wall / feed via dialog
		public function postFeedFacebook():void
		{
			if (!checkLoggedInFacebook())
			{
				loginFacebook();
				return;
			}
			
			log("GV: posting fb feed...");
			GoViral.goViral.showFacebookFeedDialog(
				postTitle,
				postCaption,
				postMessage,
				postDescription,
				postURL,
				postImageURL
			);
			
			log("  GV: done feed post.");
		}
		
		// Get a list of all your facebook friends
		public function getFriendsFacebook():void
		{
			if (!checkLoggedInFacebook()) return;
			
			log("GV: getting friends.(first_name)..");
			GoViral.goViral.requestFacebookFriends({fields:"installed,first_name"});
			log("  GV: sent friend list request.");		
		}
		
		// Get your own facebook profile
		public function getMeFacebook():void
		{
			if (!checkLoggedInFacebook()) return;
			
			log("GV: Getting profile...");
			GoViral.goViral.requestMyFacebookProfile();
			log("  GV: sent profile request.");
		}
		
		// Get Facebook Access Token
		public function getFacebookToken():void
		{
			log("GV: Retrieving access token...");
			var accessToken:String=GoViral.goViral.getFbAccessToken();
			var accessExpiry:Number=GoViral.goViral.getFbAccessExpiry();
			log("  GV: expiry:"+accessExpiry+",Token is:"+accessToken);
		}
		
		
		
		// Make a post graph request
		public function postGraphFacebook():void
		{
			if (!checkLoggedInFacebook()) return;
			
			log("GV: Graph posting...");
			var params:Object={};
			params.name=postName;
			params.caption=postCaption;
			params.link=postURL;
			params.picture=postImageURL;
			params.actions=new Array();
			params.actions.push({name:"Link NOW!",link:postURL});
			
			// notice the "publish_actions", a required publish permission to write to the graph!
			GoViral.goViral.facebookGraphRequest("me/feed",GVHttpMethod.POST,params,"publish_actions");
			log("  GV: post complete.");
		}
		
		// Show a facebook friend invite dialog
		public function inviteFriendsFacebook():void
		{
			if (!checkLoggedInFacebook()) return;
			
			log("GV: inviting friends.");
			GoViral.goViral.showFacebookRequestDialog("This is just a test","My Title","somedata");
			log("  GV: sent friend invite.");
		}
		
		// Post a photo to the facebook stream
		public function postPhotoFacebook():void
		{
			if (!checkLoggedInFacebook())
			{
				loginFacebook();
				return;
			}
			
			log("GV: postPhotoFacebook...");
			GoViral.goViral.facebookPostPhoto(postCaption, photoBitmapData);
			
			log("  GV: completed postPhotoFacebook");
			
		}	
		
		// Check you're logged in to facebook before doing anything else.
		public function checkLoggedInFacebook():Boolean
		{
			// make sure you're logged in first
			if (!GoViral.goViral.isFacebookAuthenticated())
			{
				log("GV: Not logged in!");
				return false;
			}
			return true;
		}
		
		//
		// Email
		//
		
		// Send Test Email
		public function sendEmail():void
		{
			if (GoViral.goViral.isEmailAvailable())
			{
				log("GV: Opening email composer...");
				GoViral.goViral.showEmailComposer(postEmailSubject, postEmailAddresses, postEmailBody,false);
				log("  GV: Composer opened.");
			}
			else
			{
				log("GV: Email is not set up on this device.");
			}
		}
		
		// Send Email with attached image
		public function sendImageEmail():void
		{
			
			if (GoViral.isSupported())
			{
				log("GV: Email composer w/image...");
				if (GoViral.goViral.isEmailAvailable())
				{
					GoViral.goViral.showEmailComposerWithBitmap(postEmailSubject, postEmailAddresses, postEmailBody, false, photoBitmapData);
				}
				else
				{
					log("  GV: Email is not available on this device.");
					return;
				}
				log("  GV: Mail composer opened.");
			}
			else
			{
				log("GV: Extension not supported: " + postEmailSubject + ", " + postEmailAddresses + ", " + postEmailBody);
			}
		}
		
		//
		// Android Generic Sharing
		//
		
		//Send Generic Message
		public function sendGenericMessage():void
		{
			if (!GoViral.goViral.isGenericShareAvailable())
			{
				log("Generic share doesn't work on this platform.");
				return;
			}
			
			log("Sending generic share intent...");
			GoViral.goViral.shareGenericMessage("The Subject","The message!",false);
			log("done send share intent.");
		}
		
		// Send Generic Message
		public function sendGenericMessageWithImage():void
		{
			if (!GoViral.goViral.isGenericShareAvailable())
			{
				log("Generic share doesn't work on this platform.");
				return;
			}
			
			log("Sending generic share img intent...");
			var asBitmap:Bitmap=new testImageClass() as Bitmap;
			GoViral.goViral.shareGenericMessageWithImage("The Subject","The message!",false,asBitmap.bitmapData);
			log("done send share img intent.");
		}
		
		// iOS 6 only sharing
		public function shareSocialComposer():void
		{
			// note that SINA_WEIBO and TWITTER are also available...
			if (GoViral.goViral.isSocialServiceAvailable(GVSocialServiceType.FACEBOOK))
			{
				log("GV: launch ios 6 social composer...");

				GoViral.goViral.displaySocialComposerView(GVSocialServiceType.FACEBOOK, postTitle, photoBitmapData, postURL);
			}
			else
			{
				log("GV: social composer service not available on device.");
			}
		}
		//
		// twitter
		//
		
		// Post a status message to Twitter
		public function postTwitter():void
		{
			log("GV: posting to twitter.");
			
			// You should check GoViral.goViral.isTweetSheetAvailable() to determine
			// if you're able to use the built-in iOS Twitter UI.  If the phone supports it
			// (because its running iOS 5.0+, or an Android device with Twitter) it will return true and you can call
			// 'showTweetSheet'. 
			
			if (GoViral.goViral.isTweetSheetAvailable())
			{
				GoViral.goViral.showTweetSheet(twitterMessage);
			}
			else
			{
				log("  GV: Twitter not available on this device.");
				return;
			}
		}
		
		// Post a picture to twitter
		public function postTwitterPic():void
		{
			log("GV: post twitter pic.");
			
			// You should check GoViral.goViral.isTweetSheetAvailable() to determine
			// if you're able to use the built-in iOS Twitter UI.  If the phone supports it
			// (because its running iOS 5.0+, or an Android device with Twitter) it will return true and you can call
			// 'showTweetSheetWithImage'.
			if (GoViral.goViral.isTweetSheetAvailable())
			{
				GoViral.goViral.showTweetSheetWithImage(twitterMessage, photoBitmapData);
			}
			else
			{
				log("  GV: Twitter not available on this device.");
				return;
			}
			log("  GV: done show tweet.");
		}
		
		
		//
		// Events
		//
		
		// Handle Facebook Event
		private function onFacebookEvent(e:GVFacebookEvent):void
		{
			switch(e.type)
			{
				case GVFacebookEvent.FB_DIALOG_CANCELED:
					log("GV: Facebook dialog '"+e.dialogType+"' canceled.");
					break;
				case GVFacebookEvent.FB_DIALOG_FAILED:
					log("GV: dialog err:"+e.errorMessage);
					break;
				case GVFacebookEvent.FB_DIALOG_FINISHED:
					log("GV: fin dialog '"+e.dialogType+"'="+e.jsonData);
					break;
				case GVFacebookEvent.FB_LOGGED_IN:
					log("GV: Logged in to facebook!");
					break;
				case GVFacebookEvent.FB_LOGGED_OUT:
					log("GV: Logged out of facebook.");
					break;
				case GVFacebookEvent.FB_LOGIN_CANCELED:
					log("GV: Canceled facebook login.");
					break;
				case GVFacebookEvent.FB_LOGIN_FAILED:
					log("GV: Login failed:"+e.errorMessage+"(notify? "+e.shouldNotifyFacebookUser+" "+e.facebookUserErrorMessage+")");
					break;
				case GVFacebookEvent.FB_REQUEST_FAILED:
					log("GV: Facebook '"+e.graphPath+"' failed:"+e.errorMessage);
					break;
				case GVFacebookEvent.FB_REQUEST_RESPONSE:
					// handle a friend list- there will be only 1 item in it if 
					// this was a 'my profile' request.				
					if (e.friends!=null)
					{					
						// 'me' was a request for own profile.
						if (e.graphPath=="me")
						{
							var myProfile:GVFacebookFriend=e.friends[0];
							log("GV: Me: name='"+myProfile.name+"',gender='"+myProfile.gender+"',location='"+myProfile.locationName+"',bio='"+myProfile.bio+"'");
							return;
						}
						
						// 'me/friends' was a friends request.
						if (e.graphPath=="me/friends")
						{					
							var allFriends:String="";
							for each(var friend:GVFacebookFriend in e.friends)
							{
								allFriends+=","+friend.name;
							}
							
							log("GV: " + e.graphPath+": Friends = ("+e.friends.length+")="+allFriends+",json="+e.jsonData);
						}
						else
						{
							log("GV: " + e.graphPath+": Other Friends: res="+e.jsonData);
							
						}
					}
					else
					{
						log("GV: " + e.graphPath+"Non-Friends: res="+e.jsonData);
						
					}
					break;
				
				default:
					break;
			
			}
			
			if (onFacebookEventCallback)
			{
				log("  GV: Calling onFacebookEventCallback");
				onFacebookEventCallback(e);
			}
			else
			{
				log("  GV: onFacebookEventCallback undefined");
			}
		}
	
		// Handle Twitter Event
		private function onTwitterEvent(e:GVTwitterEvent):void
		{
			switch(e.type)
			{
				case GVTwitterEvent.TW_DIALOG_CANCELED:
					log("GV: Twitter canceled.");
					break;
				case GVTwitterEvent.TW_DIALOG_FAILED:
					log("GV: Twitter failed: "+e.errorMessage);
					break;
				case GVTwitterEvent.TW_DIALOG_FINISHED:
					log("GV: Twitter finished.");
					break;
			}
		}
		
		// Handle Mail Event
		private function onMailEvent(e:GVMailEvent):void
		{
			switch(e.type)
			{
				case GVMailEvent.MAIL_CANCELED:
					log("GV: Mail canceled.");
					break;
				case GVMailEvent.MAIL_FAILED:
					log("GV: Mail failed:"+e.errorMessage);
					break;
				case GVMailEvent.MAIL_SAVED:
					log("GV: Mail saved.");
					break;
				case GVMailEvent.MAIL_SENT:
					log("GV: Mail sent!");
					break;
			}
		}
		
		// Handle Generic Share Event
		private function onShareEvent(e:GVShareEvent):void
		{
			log("GV: share finished.");
		}
*/
		/**
		 *   Get the singleton instance
		 *   @return The singleton instance or null if it has not yet been
		 *           initialized
		 */
		public static function get instance(): WwGoViral
		{
			return __instance;
		}
		
		// Log
		private function log(msg:String):void
		{
			WwDebug.instance.msg("[WwGoViral] " + msg);
		}
	}
}

/** A class that is here specifically to stop public instantiation of the
 *   WwDebug singleton. It is inaccessible by classes outside this file. */
class SingletonEnforcer{}