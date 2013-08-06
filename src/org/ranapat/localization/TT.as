package org.ranapat.localization {
	import flash.display.DisplayObjectContainer;
	
	public class TT {
		public static function set language(value:String):void {
			Localization.instance.language = value;
		}
		
		public static function get language():String {
			return Localization.instance.language;
		}
		
		public static function get(hash:String, _default:String = null):String {
			return Localization.instance.get(hash, _default);
		}
		
		public static function string(hash:String, ...args):String {
			args.splice(0, 0, hash);
			return Localization.instance.string.apply(Localization.instance, args);
		}
		
		public static function translateDisplayObjectContainer(object:DisplayObjectContainer):void {
			Localization.instance.applyToDisplayObjectContainer(object);
		}
	}

}