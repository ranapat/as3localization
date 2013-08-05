package org.ranapat.localization {
	
	public class SupportedLanguages {
		public static const ENGLISH:String = "english";
		public static const GERMAN:String = "german";
		public static const DEFAULT:String = SupportedLanguages.ENGLISH;
		private static const LANGUAGES:Vector.<String> = Vector.<String>([
			SupportedLanguages.ENGLISH, SupportedLanguages.GERMAN
		]);
		
		public static function validate(language:String):String {
			return SupportedLanguages.LANGUAGES.indexOf(language) >= 0? language : SupportedLanguages.DEFAULT;
		}
	}

}