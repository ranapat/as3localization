package org.ranapat.localization.embedded {
	import flash.utils.ByteArray;
	import org.ranapat.localization.SupportedLanguages;
	
	public final class EmbeddedLanguageFactory {
		public static function get(language:String):ByteArray {
			if (language == SupportedLanguages.ENGLISH) {
				return new EnglishLanguage();
			} else {
				return null;
			}
		}
	}

}