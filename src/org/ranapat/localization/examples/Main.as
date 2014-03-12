package org.ranapat.localization.examples
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import org.ranapat.localization.embedded.LanguageFactory;
	import org.ranapat.localization.embedded.Languages;
	import org.ranapat.localization.LanguageChangedEvent;
	import org.ranapat.localization.Localization;
	import org.ranapat.localization.TT;
	
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
			Localization.construct(new Languages(), new LanguageFactory());
			
			Localization.instance.collectMode = true;
			//TT.language = "english";
			
			/*
			var r:String = "My name is %s and I live in %f and now I think the time is %d";
			var regexp:RegExp = /%([d|f|s])/
			
			while (regexp.test(r)) {
				var type:String = r.match(regexp)[1];
				r = r.replace(regexp, "__SHIT__");
				trace("............... " + r + " .. " + type)
			}
			*/
			
			trace("+++++++ " + TT.spritf("key1", "Ivo", 123.3, "Another One"));
			
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
			
			/*
			var textField1:TextField = new TextField();
			textField1.text = "имало едно време три";
			textField1.width = 200;
			textField1.height = 200;
			var textFormat1:TextFormat = textField1.getTextFormat();
			textFormat1.size = 65;
			textFormat1.color = 0xff00ff;
			textField1.setTextFormat(textFormat1);
			addChild(textField1);
			
			
			var textField:TextField = new TextField();
			textField.text = "имало едно време три"
			textField.width = 200;
			textField.height = 200;
			var textFormat:TextFormat = textField.getTextFormat();
			textFormat.size = 65;
			textFormat.color = 0x00ff00;
			textField.setTextFormat(textFormat);
			addChild(textField);
			
			TT.supportedCharactersRegExp = /^[èéóöñíışáäàçğüÈÉÓÖÑÍİŞÁÄÀÇĞÜa-zA-Z0-9\s\+\-\\\[\]\(\)\{\}\|\/\!¡<>@#\$%\^&\=\*\?\.,`~_"':;]*$/g;
			trace(TT.charactersSupported(textField.text))
			
			TT.adjustTextFieldFont(textField, "Verdana");
			TT.fitTextWithinTextField(textField);
			*/
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			Localization.instance.addEventListener(LanguageChangedEvent.CHANGED, handleChanged);
			Localization.instance.addEventListener(LanguageChangedEvent.FAILED, handleFailed);
			Localization.instance.addEventListener(LanguageChangedEvent.INITIALIZED, handleInitialized);
			Localization.instance.addEventListener(LanguageChangedEvent.REQUESTED, handleRequested);
			Localization.instance.addEventListener(LanguageChangedEvent.SKIPPED, handleSkipped);
			
			//Localization.instance.language = "english";
			TT.language = "english";
			trace("?????? " + TT.get("key1@bundle1@bundle2"))
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
			trace("try to get key1? " + Localization.instance.get("key1", "i"))
			trace("try to get key1? " + Localization.instance.get("key1@bundle1@bundle2"))
			//trace("try to get key1? " + Localization.instance.get("key1", "bundle2#bundle3"))
			
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
			bbb.name = "_justSomeTestNotWorkingTxt"
			bbb.width = 500;
			bbb.y = 200;
			addChild(bbb);
			
			addChild(new ExampleClass());
			
			Localization.instance.supportedCharactersRegExp = /a-zа-яА-Я/gi;
			Localization.instance.triggers.adjustTextFieldFont = true;
			Localization.instance.triggers.fitTextWithinTextField = true;
			Localization.instance.triggers.replacementFont = "Verdana";
			
			Localization.instance.applyToDisplayObjectContainer(this);
			trace(Localization.instance.collected)
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