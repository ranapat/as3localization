package org.ranapat.localization {
	
	public class SupportedLanguages {
		public function SupportedLanguages() {
			Tools.ensureAbstractClass(this, SupportedLanguages);
		}
		
		public function validate(language:String):String {
			return this.supported.indexOf(language) >= 0? language : this.defaultLanguage;
		}
		
		protected function get defaultLanguage():String {
			return "";
		}
		
		protected function get supported():Vector.<String> {
			return new Vector.<String>();
		}
	}

}