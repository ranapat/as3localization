package org.ranapat.localization {
	import flash.text.TextField;
	
	internal final class Settings {
		public static const EMBED_MODE:Boolean = true;
		
		public static const PATH:String = "./";
		public static const EXTENSION:String = ".json";
		
		public static const BUNDLE_BUNDLE_DELIMITER:String = "#";
		public static const KEY_BUNDLE_DELIMITER:String = "@";
		
		public static const MISSING_TRANSLATION_STRING:String = "!!MISSING!!";
		
		public static const DISPLAY_OBJECT_TYPES_TO_TRANSLATE:Vector.<Class> = Vector.<Class>([
			TextField
		]);
		public static const DISPLAY_OBJECT_NAMES_TO_TRANSLATE:Vector.<RegExp> = Vector.<RegExp>([
			/^_.*[t|T][x|X][t|T]$/, /^__TRANSLATE__.*$/
		]);
		
	}

}