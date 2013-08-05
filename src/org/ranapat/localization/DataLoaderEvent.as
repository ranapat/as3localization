package org.ranapat.localization {
	import flash.events.Event;
	
	internal class DataLoaderEvent extends Event {
		public static const COMPLETE:String = "complete";
		public static const FAILED:String = "failed";
		
		public var result:String;
		
		public function DataLoaderEvent(type:String, result:String = null) {
			super(type);
			
			this.result = result;
		}
	}

}