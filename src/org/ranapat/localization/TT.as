package org.ranapat.localization {
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	
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
	}

}