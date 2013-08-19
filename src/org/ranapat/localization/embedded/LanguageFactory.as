package org.ranapat.localization.embedded {
	import flash.utils.ByteArray;
	import org.ranapat.localization.EmbeddedLanguageFactory;
	
	public class LanguageFactory extends EmbeddedLanguageFactory {
		
		override public function get(language:String):ByteArray {
			if (language == Languages.ENGLISH) {
				return new EnglishLanguage();
			} else {
				return null;
			}
		}
	}

}