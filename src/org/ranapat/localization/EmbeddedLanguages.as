package org.ranapat.localization {
	import flash.utils.ByteArray;
	import org.ranapat.localization.embedded.EmbeddedLanguageFactory;
	import org.ranapat.localization.embedded.EnglishLanguage;
	
	internal class EmbeddedLanguages {
		
		public function getJSONString(language:String):String {
			var languageByteArray:ByteArray = EmbeddedLanguageFactory.get(language)
			return languageByteArray? languageByteArray.toString() : null;
		}
	}
	
}