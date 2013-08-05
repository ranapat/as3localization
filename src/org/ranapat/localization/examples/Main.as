package org.ranapat.localization.examples
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import org.ranapat.localization.LanguageChangedEvent;
	import org.ranapat.localization.Localization;
	
	/**
	 * ...
	 * @author ranapat
	 */
	public class Main extends Sprite 
	{
		public var tt:String = "123";
		public var ooo:TextField;
		public var aaa:TextField;
		public var bbb:TextField;
		
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			addChild(new Sprite());
			addChild(new MovieClip());
			ooo = new TextField();
			ooo.text = "1111";
			ooo.name = "__TRANSLATE__justSomeTest"
			ooo.width = 500;
			addChild(ooo);
			aaa = new TextField();
			aaa.text = "1111";
			aaa.name = "_justSomeTestTxt"
			aaa.width = 500;
			aaa.y = 100;
			addChild(aaa);
			bbb = new TextField();
			bbb.text = "1111";
			bbb.name = "_justSomeTestNotWorkingTx"
			bbb.width = 500;
			bbb.y = 200;
			addChild(bbb);
			
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			Localization.instance.addEventListener(LanguageChangedEvent.CHANGED, handleChanged);
			Localization.instance.addEventListener(LanguageChangedEvent.FAILED, handleFailed);
			Localization.instance.addEventListener(LanguageChangedEvent.INITIALIZED, handleInitialized);
			Localization.instance.addEventListener(LanguageChangedEvent.REQUESTED, handleRequested);
			Localization.instance.addEventListener(LanguageChangedEvent.SKIPPED, handleSkipped);
			
			Localization.instance.language = "english";
		}
		
		private function handleSkipped(e:LanguageChangedEvent):void 
		{
			trace(e.type + " .. " + e.language)
			trace("try to get key1? " + Localization.instance.get("key1"))
		}
		
		private function handleRequested(e:LanguageChangedEvent):void 
		{
			trace(e.type + " .. " + e.language)
			trace("try to get key1? " + Localization.instance.get("key1"))
		}
		
		private function handleInitialized(e:LanguageChangedEvent):void 
		{
			trace(e.type + " .. " + e.language)
			//trace("try to get key1? " + Localization.instance.get("key1"))
			//trace("try to get key1? " + Localization.instance.get("key1", "bundle1"))
			//trace("try to get key1? " + Localization.instance.get("key1", "bundle2#bundle3"))
			
			Localization.instance.applyToDisplayObjectContainer(this);
			
			//Localization.instance.language = "german";
		}
		
		private function handleFailed(e:LanguageChangedEvent):void 
		{
			trace(e.type + " .. " + e.language)
			trace("try to get key1? " + Localization.instance.get("key1"))
		}
		
		private function handleChanged(e:LanguageChangedEvent):void 
		{
			trace(e.type + " .. " + e.language)
			trace("try to get key1? " + Localization.instance.get("key1"))
			
			Localization.instance.language = "german";
		}
		
	}
	
}