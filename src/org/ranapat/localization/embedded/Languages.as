package org.ranapat.localization.embedded {
	import org.ranapat.localization.SupportedLanguages;
	
	public class Languages extends SupportedLanguages {
		public static const ENGLISH:String = "english";
		
		override protected function get defaultLanguage():String {
			return Languages.ENGLISH;
		}
		
		override protected function get supported():Vector.<String> {
			return Vector.<String>([
				Languages.ENGLISH
			]);
		}
	}

}