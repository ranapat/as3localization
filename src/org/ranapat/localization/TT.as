package org.ranapat.localization {
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.text.TextField;
	
	public final class TT {
		public static function initialize(supportedLanguages:SupportedLanguages, factory:EmbeddedLanguageFactory, language:String = null):void {
			Localization.construct(supportedLanguages, factory);
			TT.language = language;
		}
		
		public static function set language(value:String):void {
			if (Localization.instance) {
				Localization.instance.language = value;
			}
		}
		
		public static function get language():String {
			return Localization.instance? Localization.instance.language : "";
		}
		
		public static function get supportedCharactersRegExp():RegExp {
			return Localization.instance? Localization.instance.supportedCharactersRegExp : null;
		}
		
		public static function set supportedCharactersRegExp(value:RegExp):void {
			if (Localization.instance) {
				Localization.instance.supportedCharactersRegExp = value;
			}
		}
		
		public static function get triggers():Triggers {
			return Localization.instance? Localization.instance.triggers : null;
		}
		
		public static function set triggers(value:Triggers):void {
			if (Localization.instance) {
				Localization.instance.triggers = value;
			}
		}
		
		public static function hash(hash:String, bundle:* = null):String {
			return Localization.instance? Localization.instance.hash(hash, bundle) : "";
		}
		
		public static function get(hash:String, _default:String = null):String {
			return Localization.instance? Localization.instance.get(hash, _default) : "";
		}
		
		public static function spritf(hash:String, ...args):String {
			args.splice(0, 0, hash);
			return Localization.instance? Localization.instance.spritf.apply(Localization.instance, args) : "";
		}
		
		public static function string(hash:String, replacements:* = null):String {
			return Localization.instance? Localization.instance.string(hash, replacements) : "";
		}
		
		public static function apply(target:DisplayObject, replacements:* = null):void {
			if (Localization.instance) {
				Localization.instance.apply(target, replacements);
			}
		}
		
		public static function supply(hash:String, bundle:* = null, replacements:* = null):String {
			return Localization.instance? Localization.instance.supply(hash, bundle, replacements) : "";
		}
		
		public static function applyToDisplayObject(object:DisplayObject, text:String):void {
			if (Localization.instance) {
				Localization.instance.applyToDisplayObject(object, text);
			}
		}
		
		public static function translateDisplayObjectContainer(object:DisplayObjectContainer):void {
			if (Localization.instance) {
				Localization.instance.applyToDisplayObjectContainer(object);
			}
		}
		
		public static function autoTranslateDisplayObjectContainer(object:DisplayObjectContainer, callback:Function = null):void {
			if (Localization.instance) {
				Localization.instance.autoApplyToDisplayObjectContainer(object, callback);
			}
		}
		
		public static function fitTextWithinTextField(object:TextField):void {
			if (Localization.instance) {
				Localization.instance.fitTextWithinTextField(object);
			}
		}
		
		public static function charactersSupported(string:String):Boolean {
			return Localization.instance? Localization.instance.charactersSupported(string) : false;
		}
		
		public static function adjustTextFieldFont(object:TextField, replacementFont:String = "Arial", defaultFont:String = null):void {
			if (Localization.instance) {
				Localization.instance.adjustTextFieldFont(object, replacementFont, defaultFont);
			}
		}
	}

}