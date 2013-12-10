package org.wwlib.flash
{
	import org.wwlib.WwColoring.audio.applause;
	import org.wwlib.WwColoring.audio.chime;
	import org.wwlib.WwColoring.audio.click1;
	import org.wwlib.WwColoring.audio.clickFast;
	import org.wwlib.WwColoring.audio.mainMenuTag;
	import org.wwlib.WwColoring.audio.mainMenuSting;
	import org.wwlib.WwColoring.audio.setupLoop;
	
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.utils.Dictionary;

	/**
	 * ...
	 * @author Andrew Rapo (andrew@worthwhilegames.org)
	 * @license MIT
	 */
	public class WwAudioManager
	{
		private static var audioDictionary:Dictionary;
		private static var clickSound:Sound;
		private static var clickFastSound:Sound;
		private static var applauseSound:Sound;
		private static var chimeSound:Sound;
		private static var mainMenuAudioTag:Sound;
		private static var mainMenuAudioSting:Sound;
		private static var setupLoopSound:Sound;
		private static var bassFillSound:Sound;
		private static var soundChannel:SoundChannel;
		
		public function WwAudioManager()
		{

		}
		
		public static function init():void
		{
			clickSound = new click1();
			clickFastSound = new clickFast();
			applauseSound = new applause();
			chimeSound = new chime();
			mainMenuAudioTag = new mainMenuTag();
			mainMenuAudioSting = new mainMenuSting();
			setupLoopSound = new setupLoop();
		}
		
		public static function playSound(id:String):SoundChannel
		{
			//var soundChannel:SoundChannel = null;
			if (soundChannel)
			{
				soundChannel.stop();
			}
			
			switch(id)
			{
				case "click":
				{
					soundChannel = clickSound.play();
					break;
				}
				case "click_fast":
				{
					soundChannel = clickFastSound.play();
					break;
				}
				case "applause":
				{
					soundChannel = applauseSound.play();
					break;
				}
				case "chime":
				{
					soundChannel = chimeSound.play();
					break;
				}
				case "mainMenu":
				{
					soundChannel = mainMenuAudioSting.play();
					var st:SoundTransform = new SoundTransform(.4);
					soundChannel.soundTransform = st;
					break;
				}
				case "setupLoop":
				{
					soundChannel = setupLoopSound.play(0, 3);
					break;
				}
				default:
				{
					break;
				}
			}
			
			return soundChannel;
		}
		
		public static function playMouseDown():void
		{
			clickFastSound.play();
		}
		
		public static function playMouseUp():void
		{
			clickSound.play();
		}
		
		public static function stopCurrentSound():void
		{
			if (soundChannel)
			{
				soundChannel.stop();
			}
		}
	}
}