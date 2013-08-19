package org.ranapat.localization {
	import flash.events.Event;
	
	public final class LanguageChangedEvent extends Event {
		public static const INITIALIZED:String = "initialized";
		public static const REQUESTED:String = "requested";
		public static const CHANGED:String = "changed";
		public static const SKIPPED:String = "skipped";
		public static const FAILED:String = "failed";
		
		public var language:String;
		
		public function LanguageChangedEvent(type:String, language:String) {
			super(type);
			
			this.language = language;
		}
		
	}

}