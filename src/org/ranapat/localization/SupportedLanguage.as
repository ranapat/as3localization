package org.ranapat.localization {
	import com.adobe.serialization.json.JSON;
	
	internal class SupportedLanguage {
		
		private var _latestGetSuccess:Boolean;
		
		public var data:Object;
		
		public function SupportedLanguage(data:String) {
			try { this.data = JSON.decode(data); } catch (e:Error) { /**/ }
		}
		
		public function get latestGetSuccess():Boolean {
			return this._latestGetSuccess;
		}
		
		public function get(key:String, bundle:String = null):String {
			this._latestGetSuccess = false;
			
			if (this.data) {
				if (bundle) {
					var items:Array = bundle.split(Settings.BUNDLE_BUNDLE_DELIMITER);
					var tmp:Object = this.data;
					
					try {
						var length:uint = items.length;
						for (var i:uint = 0; i < length; ++i) {
							tmp = tmp[items[i]];
						}
						
						if (tmp[key]) {
							this._latestGetSuccess = true;
						}
						
						return tmp[key]? tmp[key] : ("!!" + bundle + "." + key + "!!");
					} catch (e:Error) {
						return "!!" + bundle + "." + key + "!!";
					}
				} else {
					try {
						if (this.data[key]) {
							this._latestGetSuccess = true;
						}
						
						return this.data[key]? this.data[key] : ("!!" + key + "!!");
					} catch (e:Error) { return "!!" + key + "!!"; }
				}
			} else {
				return "!!" + key + "!!";
			}
			return "";
		}
		
	}

}