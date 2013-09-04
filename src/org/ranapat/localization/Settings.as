package org.ranapat.localization {
	import flash.display.SimpleButton;
	import flash.text.TextField;
	
	internal final class Settings {
		public static const EMBED_MODE:Boolean = true;
		
		public static const PATH:String = "./";
		public static const EXTENSION:String = ".json";
		
		public static const BUNDLE_BUNDLE_DELIMITER:String = "#";
		public static const KEY_BUNDLE_DELIMITER:String = "@";
		
		public static const SUPER_BUNDLE_KEY_NAME:String = "__super";
		
		public static const MISSING_TRANSLATION_STRING:String = "!!MISSING!!";
		
		public static const DISPLAY_OBJECT_TYPES_TO_TRANSLATE:Vector.<Class> = Vector.<Class>([
			TextField, SimpleButton
		]);
		public static const DISPLAY_OBJECT_NAMES_TO_TRANSLATE:Vector.<RegExp> = Vector.<RegExp>([
			/^_.*[t|T][x|X][t|T]$/, /^__TRANSLATE__.*$/, /^_.*Btn$/
		]);
		
		public static const SEARCH_NAMED_GROUP_PATTERNS:Vector.<RegExp> = Vector.<RegExp>([
			/(.*)\|([a-zA-Z]+)\|(.*)$/
		]);
		public static const SEARCH_NAMED_GROUP_INDEXES:Vector.<uint> = Vector.<uint>([
			2
		]);
		public static const REPLACE_NAMED_GROUP_PATTERNS:Vector.<String> = Vector.<String>([
			"$1($0)$3"
		]);
	}

}