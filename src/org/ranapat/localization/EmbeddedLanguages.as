package org.ranapat.localization {
	import flash.utils.ByteArray;
	import org.ranapat.localization.EmbeddedLanguageFactory;
	
	internal class EmbeddedLanguages {
		
		private var _factory:EmbeddedLanguageFactory;
		
		public function EmbeddedLanguages(factory:EmbeddedLanguageFactory) {
			this._factory = factory;
		}
		
		public function getJSONString(language:String):String {
			var languageByteArray:ByteArray = this._factory.get(language)
			return languageByteArray? languageByteArray.toString() : null;
		}
	}
	
}